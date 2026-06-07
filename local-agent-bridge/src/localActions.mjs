import { spawn } from "node:child_process";
import fs from "node:fs";
import path from "node:path";

const POSTCHECK_ACTION_ID = "local.action.prepare_local_validation";
const CANVAS_LANE_REVIEW_ACTION_ID = "local.action.inspect_canvas_lane";
const TASK_QUEUE_REVIEW_ACTION_ID = "local.action.review_task_queue";
const LIVE_GATE_PACKET_REVIEW_ACTION_ID = "local.action.review_live_gate_packets";
const TASK_QUEUE_PATH = ".agents/codex/matrices/VSCODE_INSIDERS_AGENT_TASK_QUEUE_20260606.csv";
const CANVAS_ARTIFACT_PATHS = [
  ".agileagentcanvas-context/vision.json",
  ".agileagentcanvas-context/discovery/product-brief.json",
  ".agileagentcanvas-context/planning/prd.json",
  ".agileagentcanvas-context/planning/epics.json"
];
const LIVE_GATE_PACKET_PATHS = [
  ".agents/codex/orders/ORDER_VSI_JIRA_READ_20260606.md",
  ".agents/codex/orders/ORDER_VSI_OPENAI_LIVE_20260606.md",
  ".agents/codex/orders/ORDER_VSI_MICROSOFT_LIVE_20260606.md",
  ".agents/codex/orders/ORDER_VSI_POWER_PLATFORM_DRY_RUN_20260607.md"
];

function commandSpec(label, command, args) {
  return { label, command, args };
}

function resolveSpawnSpec(spec) {
  if (process.platform !== "win32") {
    return { command: spec.command, args: spec.args };
  }
  if (spec.command === "npm") {
    return { command: "cmd.exe", args: ["/d", "/s", "/c", "npm", ...spec.args] };
  }
  if (spec.command === "powershell") {
    return { command: "powershell.exe", args: spec.args };
  }
  return { command: spec.command, args: spec.args };
}

function getPostcheckCommands() {
  return [
    commandSpec("npm test", "npm", ["test", "--prefix", "local-agent-bridge"]),
    commandSpec("bridge validator", "python", ["scripts/validators/local_agent_bridge_validator.py"]),
    commandSpec("parallel governance", "powershell", [
      "-NoProfile",
      "-ExecutionPolicy",
      "Bypass",
      "-File",
      ".agents/codex/tools/local_validate_parallel_order_governance.ps1"
    ]),
    commandSpec("capability hardening", "powershell", [
      "-NoProfile",
      "-ExecutionPolicy",
      "Bypass",
      "-File",
      ".agents/codex/tools/local_validate_capability_use_hardening.ps1"
    ]),
    commandSpec("diff whitespace", "git", ["diff", "--check"])
  ];
}

function parseCsv(text) {
  const rows = [];
  let row = [];
  let value = "";
  let quoted = false;

  for (let index = 0; index < text.length; index += 1) {
    const char = text[index];
    const next = text[index + 1];

    if (quoted) {
      if (char === '"' && next === '"') {
        value += '"';
        index += 1;
      } else if (char === '"') {
        quoted = false;
      } else {
        value += char;
      }
      continue;
    }

    if (char === '"') {
      quoted = true;
    } else if (char === ",") {
      row.push(value);
      value = "";
    } else if (char === "\n") {
      row.push(value);
      rows.push(row);
      row = [];
      value = "";
    } else if (char !== "\r") {
      value += char;
    }
  }

  if (value.length > 0 || row.length > 0) {
    row.push(value);
    rows.push(row);
  }

  const [headers, ...records] = rows.filter((line) => line.some((cell) => cell.trim() !== ""));
  if (!headers) return [];

  return records.map((record) => Object.fromEntries(
    headers.map((header, index) => [header, record[index] ?? ""])
  ));
}

function findDuplicates(values) {
  const seen = new Set();
  const duplicates = new Set();
  for (const value of values) {
    if (!value) continue;
    if (seen.has(value)) duplicates.add(value);
    seen.add(value);
  }
  return [...duplicates].sort();
}

function readJsonArtifact(repoRoot, artifactPath) {
  const fullPath = path.join(repoRoot, artifactPath);
  if (!fs.existsSync(fullPath)) {
    return {
      path: artifactPath,
      exists: false,
      parsed: false,
      project_name: "NO_ENCONTRADO"
    };
  }

  try {
    const parsed = JSON.parse(fs.readFileSync(fullPath, "utf8"));
    return {
      path: artifactPath,
      exists: true,
      parsed: true,
      project_name: parsed?.metadata?.projectName || parsed?.content?.productOverview?.productName || "NO_DECLARADO"
    };
  } catch (error) {
    return {
      path: artifactPath,
      exists: true,
      parsed: false,
      project_name: "JSON_INVALID",
      error: error.message
    };
  }
}

function reviewCanvasLane(repoRoot) {
  const prd = readJsonArtifact(repoRoot, ".agileagentcanvas-context/planning/prd.json");
  let activeLane = {};
  if (prd.parsed) {
    const prdJson = JSON.parse(fs.readFileSync(path.join(repoRoot, ".agileagentcanvas-context/planning/prd.json"), "utf8"));
    activeLane = prdJson?.content?.activeGovernedLane || {};
  }

  const artifacts = CANVAS_ARTIFACT_PATHS.map((artifactPath) => readJsonArtifact(repoRoot, artifactPath));
  const writeAllowlist = Array.isArray(activeLane.writeAllowlist) ? activeLane.writeAllowlist : [];
  const validators = Array.isArray(activeLane.validators) ? activeLane.validators : [];
  const missingAllowlistEntries = writeAllowlist
    .filter((relativePath) => !fs.existsSync(path.join(repoRoot, relativePath)))
    .sort();
  const missingLaneFields = [
    ["laneId", activeLane.laneId],
    ["status", activeLane.status],
    ["ownerAgent", activeLane.ownerAgent],
    ["reviewerAgent", activeLane.reviewerAgent],
    ["lockKey", activeLane.lockKey],
    ["writeAllowlist", writeAllowlist.length > 0],
    ["validators", validators.length > 0]
  ]
    .filter(([, value]) => !value)
    .map(([field]) => field);

  const liveExecuted = activeLane.liveExecuted === true;
  const externalSync = activeLane.externalSync === true;
  const passed = artifacts.every((artifact) => artifact.exists && artifact.parsed)
    && missingAllowlistEntries.length === 0
    && missingLaneFields.length === 0
    && !liveExecuted
    && !externalSync;

  return {
    status: passed ? "PASS" : "FAIL",
    lane_id: activeLane.laneId || "NO_DECLARADO",
    lane_status: activeLane.status || "NO_DECLARADO",
    owner_agent: activeLane.ownerAgent || "NO_DECLARADO",
    reviewer_agent: activeLane.reviewerAgent || "NO_DECLARADO",
    lock_key: activeLane.lockKey || "NO_DECLARADO",
    artifact_count: artifacts.length,
    parsed_artifact_count: artifacts.filter((artifact) => artifact.parsed).length,
    allowlist_count: writeAllowlist.length,
    missing_allowlist_entries: missingAllowlistEntries,
    validator_count: validators.length,
    missing_lane_fields: missingLaneFields,
    live_executed: liveExecuted,
    external_sync: externalSync,
    artifacts
  };
}

function reviewTaskQueue(repoRoot) {
  const taskQueuePath = path.join(repoRoot, TASK_QUEUE_PATH);
  const rows = parseCsv(fs.readFileSync(taskQueuePath, "utf8"));
  const taskIds = new Set(rows.map((row) => row.task_id).filter(Boolean));
  const duplicateTaskIds = findDuplicates(rows.map((row) => row.task_id));
  const missingDependencies = rows
    .filter((row) => row.dependency && row.dependency !== "none" && !taskIds.has(row.dependency))
    .map((row) => `${row.task_id}->${row.dependency}`);
  const missingLockKeys = rows
    .filter((row) => !row.lock_key)
    .map((row) => row.task_id || "NO_DECLARADO");
  const nonExecutedTasks = rows
    .filter((row) => row.status !== "EXECUTED_LOCAL_VALIDATED")
    .map((row) => `${row.task_id}:${row.status || "NO_DECLARADO"}`);

  const passed = duplicateTaskIds.length === 0
    && missingDependencies.length === 0
    && missingLockKeys.length === 0
    && nonExecutedTasks.length === 0;

  return {
    status: passed ? "PASS" : "FAIL",
    source: TASK_QUEUE_PATH,
    task_count: rows.length,
    executed_count: rows.filter((row) => row.status === "EXECUTED_LOCAL_VALIDATED").length,
    queued_count: rows.filter((row) => row.status === "QUEUED_READY").length,
    duplicate_task_ids: duplicateTaskIds,
    missing_dependencies: missingDependencies,
    missing_lock_keys: missingLockKeys,
    non_executed_tasks: nonExecutedTasks
  };
}

function readPacketField(text, field) {
  const match = text.match(new RegExp(`^- ${field}:\\s*(.+)$`, "m"));
  return match ? match[1].trim() : "";
}

function reviewLiveGatePackets(repoRoot) {
  const requiredFields = [
    "order_class",
    "preparer_agent",
    "reviewer_agent",
    "approver_role",
    "canon_as_of",
    "source_authority",
    "surface",
    "identity",
    "owner",
    "data_boundary",
    "allowed_actions",
    "blocked_actions",
    "rollback",
    "postcheck",
    "evidence",
    "validator",
    "expiration_rule",
    "stop_condition"
  ];
  const packets = LIVE_GATE_PACKET_PATHS.map((packetPath) => {
    const fullPath = path.join(repoRoot, packetPath);
    if (!fs.existsSync(fullPath)) {
      return {
        path: packetPath,
        exists: false,
        surface: "NO_ENCONTRADO",
        stop_condition: "order_packet_missing",
        missing_fields: requiredFields,
        pending_field_count: 0
      };
    }

    const text = fs.readFileSync(fullPath, "utf8");
    const missingFields = requiredFields.filter((field) => !readPacketField(text, field));
    const pendingFieldCount = requiredFields
      .map((field) => readPacketField(text, field))
      .filter((value) => value.includes("PENDING_")).length;
    return {
      path: packetPath,
      exists: true,
      surface: readPacketField(text, "surface") || "NO_DECLARADO",
      stop_condition: readPacketField(text, "stop_condition") || "NO_DECLARADO",
      missing_fields: missingFields,
      pending_field_count: pendingFieldCount,
      execution_boundary_declared: text.includes("## Execution Boundary"),
      live_execution_blocked: /does not|no ejecuta|no llama|does not call|does not write/i.test(text)
    };
  });

  const missingPackets = packets.filter((packet) => !packet.exists).map((packet) => packet.path);
  const packetsWithMissingFields = packets
    .filter((packet) => packet.missing_fields.length > 0)
    .map((packet) => `${packet.path}:${packet.missing_fields.join("|")}`);
  const packetsWithoutBoundary = packets
    .filter((packet) => packet.exists && !packet.execution_boundary_declared)
    .map((packet) => packet.path);
  const packetsWithoutLiveBlock = packets
    .filter((packet) => packet.exists && !packet.live_execution_blocked)
    .map((packet) => packet.path);
  const passed = missingPackets.length === 0
    && packetsWithMissingFields.length === 0
    && packetsWithoutBoundary.length === 0
    && packetsWithoutLiveBlock.length === 0;

  return {
    status: passed ? "PASS" : "FAIL",
    packet_count: packets.length,
    existing_packet_count: packets.filter((packet) => packet.exists).length,
    pending_field_count: packets.reduce((total, packet) => total + packet.pending_field_count, 0),
    missing_packets: missingPackets,
    packets_with_missing_fields: packetsWithMissingFields,
    packets_without_boundary: packetsWithoutBoundary,
    packets_without_live_block: packetsWithoutLiveBlock,
    packets
  };
}

function trimOutput(value) {
  const text = String(value || "");
  if (text.length <= 4000) return text;
  return `${text.slice(0, 3800)}\n[output truncated]`;
}

function runCommand(spec, repoRoot) {
  return new Promise((resolve) => {
    let stdout = "";
    let stderr = "";
    let child;
    const spawnSpec = resolveSpawnSpec(spec);

    try {
      child = spawn(spawnSpec.command, spawnSpec.args, {
        cwd: repoRoot,
        shell: false,
        windowsHide: true
      });
    } catch (error) {
      resolve({
        label: spec.label,
        command: [spec.command, ...spec.args].join(" "),
        status: "FAIL",
        exit_code: null,
        stdout: "",
        stderr: trimOutput(error.message)
      });
      return;
    }

    child.stdout.on("data", (chunk) => {
      stdout += chunk.toString();
    });
    child.stderr.on("data", (chunk) => {
      stderr += chunk.toString();
    });
    child.on("error", (error) => {
      resolve({
        label: spec.label,
        command: [spec.command, ...spec.args].join(" "),
        status: "FAIL",
        exit_code: null,
        stdout: trimOutput(stdout),
        stderr: trimOutput(error.message)
      });
    });
    child.on("close", (code) => {
      resolve({
        label: spec.label,
        command: [spec.command, ...spec.args].join(" "),
        status: code === 0 ? "PASS" : "FAIL",
        exit_code: code,
        stdout: trimOutput(stdout),
        stderr: trimOutput(stderr)
      });
    });
  });
}

export function buildLocalActions(canvasWorkbench, agentTaskQueue) {
  const activeLane = canvasWorkbench.active_governed_lane;
  const latestTask = [...agentTaskQueue].reverse()
    .find((row) => row.status && row.status.startsWith("EXECUTED"));

  return [
    {
      action_id: CANVAS_LANE_REVIEW_ACTION_ID,
      title: "Inspeccionar carril Agile Canvas",
      status: "READY_LOCAL_GOVERNED",
      surface: "agileagentcanvas_context",
      owner_agent: activeLane.owner_agent,
      target: activeLane.lane_id,
      evidence: "structured canvas lane review available",
      execution_mode: "structured_local_review",
      allowed_now: "run_structured_canvas_lane_review|review_canvas_artifacts|review_allowlist",
      blocked_actions: "live_provider_call|secret_handling|external_sync",
      stop_condition: "canvas_lane_structured_review_failed"
    },
    {
      action_id: "local.action.review_task_queue",
      title: "Revisar cola local VSI",
      status: agentTaskQueue.every((row) => row.status === "EXECUTED_LOCAL_VALIDATED")
        ? "EXECUTED_LOCAL_VALIDATED"
        : "NEEDS_REVIEW",
      surface: "agent_task_queue_dashboard",
      owner_agent: "codex.workspace_guardian",
      target: `${agentTaskQueue.length} tareas`,
      evidence: latestTask ? latestTask.task_id : "NO_DECLARADO",
      execution_mode: "structured_local_review",
      allowed_now: "run_structured_queue_review|review_stop_conditions",
      blocked_actions: "dispatch_live_agents|change_status_values",
      stop_condition: "task_queue_structured_review_failed"
    },
    {
      action_id: POSTCHECK_ACTION_ID,
      title: "Preparar validacion local",
      status: "READY_LOCAL_GOVERNED",
      surface: "local_agent_bridge",
      owner_agent: "codex.workspace_guardian",
      target: "local validators",
      evidence: "npm test|bridge validator|governance validators",
      execution_mode: "postcheck_allowlist",
      allowed_now: "run_local_tests|run_local_validators|smoke_loopback_dashboard",
      blocked_actions: "execute_arbitrary_shell_from_dashboard|production_write|live_provider_call",
      stop_condition: "local_validator_fails"
    },
    {
      action_id: LIVE_GATE_PACKET_REVIEW_ACTION_ID,
      title: "Revisar paquetes live-gateados",
      status: "READY_LOCAL_GOVERNED",
      surface: "live_gate_packet_review",
      owner_agent: "codex.workspace_guardian",
      target: "Jira|OpenAI|Microsoft|Power Platform",
      evidence: "order packets local structured review",
      execution_mode: "structured_local_review",
      allowed_now: "read_order_packets|review_missing_fields|review_live_boundaries",
      blocked_actions: "live_provider_call|secret_handling|connector_auth|production_write",
      stop_condition: "live_gate_packet_review_failed"
    }
  ];
}

export function getLocalActionExecutionPlan(actionId) {
  if (actionId === CANVAS_LANE_REVIEW_ACTION_ID) {
    return {
      action_id: actionId,
      execute_now: true,
      status: "READY_LOCAL_GOVERNED",
      command_execution_exposed: false,
      live_executed: false,
      shell_mode: "structured_local_review_no_shell",
      postcheck_commands: []
    };
  }

  if (actionId === LIVE_GATE_PACKET_REVIEW_ACTION_ID) {
    return {
      action_id: actionId,
      execute_now: true,
      status: "READY_LOCAL_GOVERNED",
      command_execution_exposed: false,
      live_executed: false,
      shell_mode: "structured_local_review_no_shell",
      postcheck_commands: []
    };
  }

  if (actionId === TASK_QUEUE_REVIEW_ACTION_ID) {
    return {
      action_id: actionId,
      execute_now: true,
      status: "READY_LOCAL_GOVERNED",
      command_execution_exposed: false,
      live_executed: false,
      shell_mode: "structured_local_review_no_shell",
      postcheck_commands: []
    };
  }

  if (actionId !== POSTCHECK_ACTION_ID) {
    return {
      action_id: actionId,
      execute_now: false,
      status: "GUIDED_READ_ONLY",
      command_execution_exposed: false,
      live_executed: false,
      postcheck_commands: []
    };
  }

  return {
    action_id: actionId,
    execute_now: true,
    status: "READY_LOCAL_GOVERNED",
    command_execution_exposed: false,
    live_executed: false,
    shell_mode: "purpose_built_postcheck_allowlist",
    postcheck_commands: getPostcheckCommands().map((spec) => spec.label)
  };
}

export async function runLocalAction(actionId, repoRoot) {
  const plan = getLocalActionExecutionPlan(actionId);
  if (actionId === CANVAS_LANE_REVIEW_ACTION_ID) {
    const canvasLaneReview = reviewCanvasLane(repoRoot);
    return {
      ...plan,
      status: canvasLaneReview.status,
      evidence: "structured canvas lane review executed",
      canvas_lane_review: canvasLaneReview,
      stop_condition: canvasLaneReview.status === "PASS"
        ? "canvas_lane_review_passed"
        : "canvas_lane_structured_review_failed"
    };
  }

  if (actionId === LIVE_GATE_PACKET_REVIEW_ACTION_ID) {
    const packetReview = reviewLiveGatePackets(repoRoot);
    return {
      ...plan,
      status: packetReview.status,
      evidence: "structured live-gate packet review executed",
      gate_packet_review: packetReview,
      stop_condition: packetReview.status === "PASS"
        ? "live_gate_packet_review_passed"
        : "live_gate_packet_review_failed"
    };
  }

  if (actionId === TASK_QUEUE_REVIEW_ACTION_ID) {
    const reviewResult = reviewTaskQueue(repoRoot);
    return {
      ...plan,
      status: reviewResult.status,
      evidence: "structured local task queue review executed",
      review_result: reviewResult,
      stop_condition: reviewResult.status === "PASS"
        ? "task_queue_review_passed"
        : "task_queue_structured_review_failed"
    };
  }

  if (!plan.execute_now) {
    return {
      ...plan,
      status: "ok",
      evidence: "guided read-only action selected"
    };
  }

  const results = [];
  for (const spec of getPostcheckCommands()) {
    const result = await runCommand(spec, repoRoot);
    results.push(result);
    if (result.status !== "PASS") break;
  }

  const passed = results.every((result) => result.status === "PASS");
  return {
    ...plan,
    status: passed ? "PASS" : "FAIL",
    evidence: "purpose-built local postcheck allowlist executed",
    postcheck_results: results,
    stop_condition: passed ? "postcheck_passed" : "local_validator_fails"
  };
}
