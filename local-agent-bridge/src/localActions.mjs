import { spawn } from "node:child_process";
import fs from "node:fs";
import path from "node:path";

const POSTCHECK_ACTION_ID = "local.action.prepare_local_validation";
const CANVAS_LANE_REVIEW_ACTION_ID = "local.action.inspect_canvas_lane";
const TASK_QUEUE_REVIEW_ACTION_ID = "local.action.review_task_queue";
const LIVE_GATE_PACKET_REVIEW_ACTION_ID = "local.action.review_live_gate_packets";
const BRIDGE_CONTRACT_REVIEW_ACTION_ID = "local.action.review_bridge_contract";
const DASHBOARD_INTEGRITY_REVIEW_ACTION_ID = "local.action.review_dashboard_integrity";
const ACTION_BOUNDARY_REVIEW_ACTION_ID = "local.action.review_action_boundary";
const READINESS_BUNDLE_REVIEW_ACTION_ID = "local.action.review_readiness_bundle";
const UI_TRANSLATION_REVIEW_ACTION_ID = "local.action.review_ui_translation_integrity";
const TASK_LINEAGE_REVIEW_ACTION_ID = "local.action.review_task_lineage";
const CANVAS_STORY_SYNC_REVIEW_ACTION_ID = "local.action.review_canvas_story_sync";
const TASK_QUEUE_PATH = ".agents/codex/matrices/VSCODE_INSIDERS_AGENT_TASK_QUEUE_20260606.csv";
const BRIDGE_CONTRACT_PATH = "local-agent-bridge/contracts/local-agent-bridge.contract.json";
const ROUTES_MATRIX_PATH = "local-agent-bridge/matrices/routes_matrix.csv";
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

function getRequiredLocalActionIds() {
  return [
    CANVAS_LANE_REVIEW_ACTION_ID,
    TASK_QUEUE_REVIEW_ACTION_ID,
    POSTCHECK_ACTION_ID,
    LIVE_GATE_PACKET_REVIEW_ACTION_ID,
    BRIDGE_CONTRACT_REVIEW_ACTION_ID,
    DASHBOARD_INTEGRITY_REVIEW_ACTION_ID,
    ACTION_BOUNDARY_REVIEW_ACTION_ID,
    READINESS_BUNDLE_REVIEW_ACTION_ID,
    UI_TRANSLATION_REVIEW_ACTION_ID,
    TASK_LINEAGE_REVIEW_ACTION_ID,
    CANVAS_STORY_SYNC_REVIEW_ACTION_ID
  ];
}

function getStructuredReviewActionIds() {
  return [
    CANVAS_LANE_REVIEW_ACTION_ID,
    TASK_QUEUE_REVIEW_ACTION_ID,
    LIVE_GATE_PACKET_REVIEW_ACTION_ID,
    BRIDGE_CONTRACT_REVIEW_ACTION_ID,
    DASHBOARD_INTEGRITY_REVIEW_ACTION_ID,
    ACTION_BOUNDARY_REVIEW_ACTION_ID,
    READINESS_BUNDLE_REVIEW_ACTION_ID,
    UI_TRANSLATION_REVIEW_ACTION_ID,
    TASK_LINEAGE_REVIEW_ACTION_ID,
    CANVAS_STORY_SYNC_REVIEW_ACTION_ID
  ];
}

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

function readJsonFile(repoRoot, artifactPath) {
  return JSON.parse(fs.readFileSync(path.join(repoRoot, artifactPath), "utf8"));
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
    const parsed = readJsonFile(repoRoot, artifactPath);
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
    const prdJson = readJsonFile(repoRoot, ".agileagentcanvas-context/planning/prd.json");
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

function reviewBridgeContract(repoRoot) {
  const contractArtifact = readJsonArtifact(repoRoot, BRIDGE_CONTRACT_PATH);
  const contract = contractArtifact.parsed
    ? readJsonFile(repoRoot, BRIDGE_CONTRACT_PATH)
    : {};
  const routesPath = path.join(repoRoot, ROUTES_MATRIX_PATH);
  const routes = fs.existsSync(routesPath)
    ? parseCsv(fs.readFileSync(routesPath, "utf8"))
    : [];
  const routeIds = new Set(routes.map((row) => row.route_id).filter(Boolean));
  const allowedActionIds = contract?.localActions?.allowedActionIds || [];
  const blockedActions = contract?.localActions?.blockedActions || [];
  const requiredActionIds = getRequiredLocalActionIds();
  const missingAllowedActionIds = requiredActionIds
    .filter((actionId) => !allowedActionIds.includes(actionId))
    .sort();
  const requiredBlockedActions = [
    "execute_arbitrary_shell_from_dashboard",
    "live_provider_call",
    "secret_handling",
    "production_write"
  ];
  const missingBlockedActions = requiredBlockedActions
    .filter((action) => !blockedActions.includes(action))
    .sort();
  const missingRoutes = ["bridge.shell_status", "bridge.shell_command_blocked", "bridge.local_action_run"]
    .filter((routeId) => !routeIds.has(routeId));
  const unsafeRoutes = routes
    .filter((row) => {
      const blocked = String(row.blocked_actions || "");
      const externalBlocked = ["external_write", "teams_send", "graph_write", "live_call"]
        .some((action) => blocked.includes(action));
      const commandRouteBlocked = row.route_id !== "bridge.shell_command_blocked"
        || blocked.includes("execute_arbitrary_command");
      return row.status !== "ACTIVE_DEV" || !externalBlocked || !commandRouteBlocked;
    })
    .map((row) => row.route_id || "NO_DECLARADO");
  const missingContractFields = [
    ["transport", contract.transport === "http-loopback"],
    ["response.liveExecutedValue", contract?.response?.liveExecutedValue === false],
    ["shellConnector.commandExecutionExposed", contract?.shellConnector?.commandExecutionExposed === false],
    ["localActions.commandExecutionExposed", contract?.localActions?.commandExecutionExposed === false],
    ["localReadSurface.requiresLoopbackBindHost", contract?.localReadSurface?.requiresLoopbackBindHost === true],
    ["localReadSurface.blockedStatus", contract?.localReadSurface?.blockedStatus === 403]
  ]
    .filter(([, ok]) => !ok)
    .map(([field]) => field);
  const passed = contractArtifact.parsed
    && missingAllowedActionIds.length === 0
    && missingBlockedActions.length === 0
    && missingRoutes.length === 0
    && unsafeRoutes.length === 0
    && missingContractFields.length === 0;

  return {
    status: passed ? "PASS" : "FAIL",
    contract_path: BRIDGE_CONTRACT_PATH,
    route_matrix_path: ROUTES_MATRIX_PATH,
    transport: contract.transport || "NO_DECLARADO",
    allowed_action_count: allowedActionIds.length,
    missing_allowed_action_ids: missingAllowedActionIds,
    blocked_action_count: blockedActions.length,
    missing_blocked_actions: missingBlockedActions,
    route_count: routes.length,
    missing_routes: missingRoutes,
    unsafe_routes: unsafeRoutes,
    missing_contract_fields: missingContractFields,
    command_execution_exposed: contract?.localActions?.commandExecutionExposed === true
      || contract?.shellConnector?.commandExecutionExposed === true,
    live_executed: contract?.response?.liveExecutedValue === true
  };
}

function buildReviewCanvasWorkbench(repoRoot) {
  const prdArtifact = readJsonArtifact(repoRoot, ".agileagentcanvas-context/planning/prd.json");
  const activeLane = prdArtifact.parsed
    ? readJsonFile(repoRoot, ".agileagentcanvas-context/planning/prd.json")?.content?.activeGovernedLane || {}
    : {};
  return {
    active_governed_lane: {
      lane_id: activeLane.laneId || "NO_DECLARADO",
      status: activeLane.status || "NO_DECLARADO",
      owner_agent: activeLane.ownerAgent || "NO_DECLARADO",
      reviewer_agent: activeLane.reviewerAgent || "NO_DECLARADO",
      lock_key: activeLane.lockKey || "NO_DECLARADO",
      live_executed: activeLane.liveExecuted === true,
      external_sync: activeLane.externalSync === true
    }
  };
}

function readTaskQueueRows(repoRoot) {
  return parseCsv(fs.readFileSync(path.join(repoRoot, TASK_QUEUE_PATH), "utf8"));
}

function buildReviewLocalActions(repoRoot) {
  return buildLocalActions(buildReviewCanvasWorkbench(repoRoot), readTaskQueueRows(repoRoot));
}

function reviewDashboardIntegrity(repoRoot) {
  const taskQueueReview = reviewTaskQueue(repoRoot);
  const canvasLaneReview = reviewCanvasLane(repoRoot);
  const localActions = buildReviewLocalActions(repoRoot);
  const actionIds = localActions.map((action) => action.action_id);
  const requiredActionIds = getRequiredLocalActionIds();
  const missingRequiredActions = requiredActionIds.filter((actionId) => !actionIds.includes(actionId)).sort();
  const plans = requiredActionIds.map((actionId) => getLocalActionExecutionPlan(actionId));
  const nonReadyLocalActions = localActions
    .filter((action) => !["READY_LOCAL_GOVERNED", "EXECUTED_LOCAL_VALIDATED"].includes(action.status))
    .map((action) => `${action.action_id}:${action.status}`);
  const plansWithCommandExecution = plans
    .filter((plan) => plan.command_execution_exposed === true)
    .map((plan) => plan.action_id);
  const plansWithLiveExecution = plans
    .filter((plan) => plan.live_executed === true)
    .map((plan) => plan.action_id);
  const passed = taskQueueReview.status === "PASS"
    && canvasLaneReview.status === "PASS"
    && localActions.length === requiredActionIds.length
    && missingRequiredActions.length === 0
    && nonReadyLocalActions.length === 0
    && plansWithCommandExecution.length === 0
    && plansWithLiveExecution.length === 0;

  return {
    status: passed ? "PASS" : "FAIL",
    task_count: taskQueueReview.task_count,
    executed_task_count: taskQueueReview.executed_count,
    non_executed_tasks: taskQueueReview.non_executed_tasks,
    local_action_count: localActions.length,
    ready_local_action_count: localActions.filter((action) => action.status === "READY_LOCAL_GOVERNED").length,
    executed_local_action_count: localActions.filter((action) => action.status === "EXECUTED_LOCAL_VALIDATED").length,
    non_ready_local_actions: nonReadyLocalActions,
    canvas_artifact_count: canvasLaneReview.artifact_count,
    parsed_canvas_artifact_count: canvasLaneReview.parsed_artifact_count,
    active_lane_status: canvasLaneReview.lane_status,
    missing_required_actions: missingRequiredActions,
    command_execution_exposed: plansWithCommandExecution.length > 0,
    live_executed: canvasLaneReview.live_executed || plansWithLiveExecution.length > 0,
    plans_with_command_execution: plansWithCommandExecution,
    plans_with_live_execution: plansWithLiveExecution
  };
}

function reviewActionBoundary(repoRoot) {
  const localActions = buildReviewLocalActions(repoRoot);
  const requiredActionIds = getRequiredLocalActionIds();
  const actionIds = new Set(localActions.map((action) => action.action_id));
  const plans = requiredActionIds.map((actionId) => getLocalActionExecutionPlan(actionId));
  const actionsMissingStopCondition = localActions
    .filter((action) => !action.stop_condition)
    .map((action) => action.action_id);
  const actionsMissingBoundaryBlocks = localActions
    .filter((action) => !/live_provider_call|secret_handling|production_write|execute_arbitrary_shell_from_dashboard|dispatch_live_agents/.test(action.blocked_actions || ""))
    .map((action) => action.action_id);
  const plansWithCommandExecution = plans
    .filter((plan) => plan.command_execution_exposed === true)
    .map((plan) => plan.action_id);
  const plansWithLiveExecution = plans
    .filter((plan) => plan.live_executed === true)
    .map((plan) => plan.action_id);
  const unknownActions = localActions
    .filter((action) => !requiredActionIds.includes(action.action_id))
    .map((action) => action.action_id);
  const missingRequiredActions = requiredActionIds.filter((actionId) => !actionIds.has(actionId));
  const nonExecutableRequiredActions = plans
    .filter((plan) => !plan.execute_now)
    .map((plan) => plan.action_id);
  const passed = localActions.length === requiredActionIds.length
    && missingRequiredActions.length === 0
    && unknownActions.length === 0
    && actionsMissingStopCondition.length === 0
    && actionsMissingBoundaryBlocks.length === 0
    && plansWithCommandExecution.length === 0
    && plansWithLiveExecution.length === 0
    && nonExecutableRequiredActions.length === 0;

  return {
    status: passed ? "PASS" : "FAIL",
    action_count: localActions.length,
    plan_count: plans.length,
    executable_action_count: plans.filter((plan) => plan.execute_now).length,
    actions_missing_stop_condition: actionsMissingStopCondition,
    actions_missing_boundary_blocks: actionsMissingBoundaryBlocks,
    plans_with_command_execution: plansWithCommandExecution,
    plans_with_live_execution: plansWithLiveExecution,
    unknown_actions: unknownActions,
    missing_required_actions: missingRequiredActions,
    non_executable_required_actions: nonExecutableRequiredActions,
    command_execution_exposed: plansWithCommandExecution.length > 0,
    live_executed: plansWithLiveExecution.length > 0
  };
}

function reviewUiTranslationIntegrity(repoRoot) {
  const htmlPath = "local-agent-bridge/public/index.html";
  const html = fs.readFileSync(path.join(repoRoot, htmlPath), "utf8");
  const localActions = buildReviewLocalActions(repoRoot);
  const requiredTokens = [
    ...getRequiredLocalActionIds(),
    ...localActions.map((action) => action.surface),
    ...localActions.map((action) => action.stop_condition),
    "structured_local_review_no_shell",
    "live_executed"
  ];
  const missingTranslationTokens = [...new Set(requiredTokens)]
    .filter((token) => token && !html.includes(token))
    .sort();
  const missingResultRenderers = [
    "dashboard_integrity_review",
    "action_boundary_review",
    "readiness_bundle_review",
    "ui_translation_review",
    "task_lineage_review",
    "canvas_story_sync_review"
  ].filter((token) => !html.includes(token));
  const fileFallbackPresent = html.includes("renderFileFallback")
    && html.includes('window.location.protocol === "file:"');
  const passed = missingTranslationTokens.length === 0
    && missingResultRenderers.length === 0
    && fileFallbackPresent;

  return {
    status: passed ? "PASS" : "FAIL",
    html_path: htmlPath,
    required_token_count: [...new Set(requiredTokens)].length,
    missing_translation_tokens: missingTranslationTokens,
    missing_result_renderers: missingResultRenderers,
    file_fallback_present: fileFallbackPresent,
    command_execution_exposed: false,
    live_executed: false
  };
}

function reviewTaskLineage(repoRoot) {
  const rows = readTaskQueueRows(repoRoot);
  const taskIds = new Set(rows.map((row) => row.task_id).filter(Boolean));
  const duplicateTaskIds = findDuplicates(rows.map((row) => row.task_id));
  const missingDependencies = rows
    .filter((row) => row.dependency && row.dependency !== "none" && !taskIds.has(row.dependency))
    .map((row) => `${row.task_id}->${row.dependency}`);
  const dependencyCycles = [];
  for (const row of rows) {
    const seen = new Set([row.task_id]);
    let current = row.dependency;
    while (current && current !== "none") {
      if (seen.has(current)) {
        dependencyCycles.push(`${row.task_id}->${current}`);
        break;
      }
      seen.add(current);
      const parent = rows.find((candidate) => candidate.task_id === current);
      current = parent?.dependency;
    }
  }
  const branchlessCodexTasks = rows
    .filter((row) => row.branch && !row.branch.startsWith("codex/"))
    .map((row) => `${row.task_id}:${row.branch}`);
  const unlockedTasks = rows
    .filter((row) => !row.lock_key)
    .map((row) => row.task_id || "NO_DECLARADO");
  const unvalidatedTasks = rows
    .filter((row) => row.status !== "EXECUTED_LOCAL_VALIDATED")
    .map((row) => `${row.task_id}:${row.status || "NO_DECLARADO"}`);
  const passed = duplicateTaskIds.length === 0
    && missingDependencies.length === 0
    && dependencyCycles.length === 0
    && branchlessCodexTasks.length === 0
    && unlockedTasks.length === 0
    && unvalidatedTasks.length === 0;

  return {
    status: passed ? "PASS" : "FAIL",
    source: TASK_QUEUE_PATH,
    task_count: rows.length,
    duplicate_task_ids: duplicateTaskIds,
    missing_dependencies: missingDependencies,
    dependency_cycles: [...new Set(dependencyCycles)].sort(),
    branchless_codex_tasks: branchlessCodexTasks,
    unlocked_tasks: unlockedTasks,
    unvalidated_tasks: unvalidatedTasks,
    command_execution_exposed: false,
    live_executed: false
  };
}

function reviewCanvasStorySync(repoRoot) {
  const epicsPath = ".agileagentcanvas-context/planning/epics.json";
  const epics = readJsonFile(repoRoot, epicsPath);
  const stories = epics?.content?.epics?.flatMap((epic) => epic.stories || []) || [];
  const storyIds = stories.map((story) => story.id).filter(Boolean);
  const duplicateStoryIds = findDuplicates(storyIds);
  const declaredTotalStories = epics?.content?.overview?.totalStories;
  const totalStoriesMatches = declaredTotalStories === stories.length;
  const currentSyncStoryIds = new Set(["S-3.12", "S-3.13", "S-3.14"]);
  const unfinishedDashboardStories = stories
    .filter((story) => currentSyncStoryIds.has(story.id) && story.status !== "hecho")
    .map((story) => `${story.id}:${story.status || "NO_DECLARADO"}`);
  const functionalStoryRefs = new Set(
    (epics?.content?.requirementsInventory?.functional || [])
      .flatMap((item) => item.relatedStories || [])
  );
  const missingFunctionalStoryRefs = storyIds
    .filter((storyId) => storyId.startsWith("S-3.") && !functionalStoryRefs.has(storyId))
    .sort();
  const taskQueue = readTaskQueueRows(repoRoot);
  const recentTaskIds = ["vsi.agent.task.022", "vsi.agent.task.023", "vsi.agent.task.024"];
  const missingRecentTasks = recentTaskIds
    .filter((taskId) => !taskQueue.some((row) => row.task_id === taskId));
  const passed = duplicateStoryIds.length === 0
    && totalStoriesMatches
    && unfinishedDashboardStories.length === 0
    && missingFunctionalStoryRefs.length === 0
    && missingRecentTasks.length === 0;

  return {
    status: passed ? "PASS" : "FAIL",
    epics_path: epicsPath,
    declared_total_stories: declaredTotalStories,
    actual_story_count: stories.length,
    total_stories_matches: totalStoriesMatches,
    duplicate_story_ids: duplicateStoryIds,
    unfinished_dashboard_stories: unfinishedDashboardStories,
    missing_functional_story_refs: missingFunctionalStoryRefs,
    missing_recent_tasks: missingRecentTasks,
    command_execution_exposed: false,
    live_executed: false
  };
}

function reviewReadinessBundle(repoRoot) {
  const components = [
    ["task_queue", reviewTaskQueue(repoRoot)],
    ["canvas_lane", reviewCanvasLane(repoRoot)],
    ["live_gate_packets", reviewLiveGatePackets(repoRoot)],
    ["bridge_contract", reviewBridgeContract(repoRoot)],
    ["dashboard_integrity", reviewDashboardIntegrity(repoRoot)],
    ["action_boundary", reviewActionBoundary(repoRoot)],
    ["ui_translation_integrity", reviewUiTranslationIntegrity(repoRoot)],
    ["task_lineage", reviewTaskLineage(repoRoot)],
    ["canvas_story_sync", reviewCanvasStorySync(repoRoot)]
  ].map(([component, result]) => ({
    component,
    status: result.status,
    live_executed: result.live_executed === true,
    command_execution_exposed: result.command_execution_exposed === true
  }));
  const failingComponents = components
    .filter((component) => component.status !== "PASS")
    .map((component) => `${component.component}:${component.status}`);
  const commandExecutionComponents = components
    .filter((component) => component.command_execution_exposed)
    .map((component) => component.component);
  const liveExecutionComponents = components
    .filter((component) => component.live_executed)
    .map((component) => component.component);
  const passed = failingComponents.length === 0
    && commandExecutionComponents.length === 0
    && liveExecutionComponents.length === 0;

  return {
    status: passed ? "PASS" : "FAIL",
    component_count: components.length,
    passing_components: components.filter((component) => component.status === "PASS").length,
    failing_components: failingComponents,
    command_execution_components: commandExecutionComponents,
    live_execution_components: liveExecutionComponents,
    command_execution_exposed: commandExecutionComponents.length > 0,
    live_executed: liveExecutionComponents.length > 0,
    components
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
      action_id: TASK_QUEUE_REVIEW_ACTION_ID,
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
    },
    {
      action_id: BRIDGE_CONTRACT_REVIEW_ACTION_ID,
      title: "Revisar contrato del bridge local",
      status: "READY_LOCAL_GOVERNED",
      surface: "local_agent_bridge_contract",
      owner_agent: "codex.workspace_guardian",
      target: "http-loopback contract",
      evidence: "structured bridge contract review available",
      execution_mode: "structured_local_review",
      allowed_now: "read_bridge_contract|review_loopback_boundary|review_action_allowlist",
      blocked_actions: "execute_arbitrary_shell_from_dashboard|live_provider_call|secret_handling|production_write",
      stop_condition: "bridge_contract_structured_review_failed"
    },
    {
      action_id: DASHBOARD_INTEGRITY_REVIEW_ACTION_ID,
      title: "Revisar integridad del tablero",
      status: "READY_LOCAL_GOVERNED",
      surface: "local_dashboard_integrity",
      owner_agent: "codex.workspace_guardian",
      target: "acciones|cola|canvas",
      evidence: "structured dashboard integrity review available",
      execution_mode: "structured_local_review",
      allowed_now: "review_dashboard_counts|review_action_allowlist|review_no_live_boundary",
      blocked_actions: "execute_arbitrary_shell_from_dashboard|live_provider_call|secret_handling|production_write",
      stop_condition: "dashboard_integrity_review_failed"
    },
    {
      action_id: ACTION_BOUNDARY_REVIEW_ACTION_ID,
      title: "Revisar frontera de acciones",
      status: "READY_LOCAL_GOVERNED",
      surface: "local_action_boundary",
      owner_agent: "codex.workspace_guardian",
      target: "local action plans",
      evidence: "structured action boundary review available",
      execution_mode: "structured_local_review",
      allowed_now: "review_action_plans|review_no_live_boundary|review_stop_conditions",
      blocked_actions: "execute_arbitrary_shell_from_dashboard|live_provider_call|secret_handling|production_write",
      stop_condition: "action_boundary_review_failed"
    },
    {
      action_id: READINESS_BUNDLE_REVIEW_ACTION_ID,
      title: "Revisar readiness agregado",
      status: "READY_LOCAL_GOVERNED",
      surface: "local_readiness_bundle",
      owner_agent: "codex.workspace_guardian",
      target: "dashboard readiness bundle",
      evidence: "structured readiness bundle review available",
      execution_mode: "structured_local_review",
      allowed_now: "review_readiness_bundle|review_component_status|review_no_live_boundary",
      blocked_actions: "execute_arbitrary_shell_from_dashboard|live_provider_call|secret_handling|production_write",
      stop_condition: "readiness_bundle_review_failed"
    },
    {
      action_id: UI_TRANSLATION_REVIEW_ACTION_ID,
      title: "Revisar traducciones del tablero",
      status: "READY_LOCAL_GOVERNED",
      surface: "local_ui_translation_integrity",
      owner_agent: "codex.workspace_guardian",
      target: "human dashboard labels",
      evidence: "structured UI translation review available",
      execution_mode: "structured_local_review",
      allowed_now: "review_human_labels|review_result_renderers|review_file_fallback",
      blocked_actions: "execute_arbitrary_shell_from_dashboard|live_provider_call|secret_handling|production_write",
      stop_condition: "ui_translation_review_failed"
    },
    {
      action_id: TASK_LINEAGE_REVIEW_ACTION_ID,
      title: "Revisar linaje de tareas",
      status: "READY_LOCAL_GOVERNED",
      surface: "local_task_lineage",
      owner_agent: "codex.workspace_guardian",
      target: "VSI task queue dependencies",
      evidence: "structured task lineage review available",
      execution_mode: "structured_local_review",
      allowed_now: "review_task_dependencies|review_lock_keys|review_codex_branches",
      blocked_actions: "execute_arbitrary_shell_from_dashboard|dispatch_live_agents|live_provider_call|secret_handling|production_write",
      stop_condition: "task_lineage_review_failed"
    },
    {
      action_id: CANVAS_STORY_SYNC_REVIEW_ACTION_ID,
      title: "Revisar sincronía historias-tareas",
      status: "READY_LOCAL_GOVERNED",
      surface: "local_canvas_story_sync",
      owner_agent: "codex.workspace_guardian",
      target: "Agile Canvas epics and task queue",
      evidence: "structured canvas story sync review available",
      execution_mode: "structured_local_review",
      allowed_now: "review_story_counts|review_functional_refs|review_task_story_sync",
      blocked_actions: "execute_arbitrary_shell_from_dashboard|live_provider_call|secret_handling|production_write|external_sync",
      stop_condition: "canvas_story_sync_review_failed"
    }
  ];
}

export function getLocalActionExecutionPlan(actionId) {
  if (getStructuredReviewActionIds().includes(actionId)) {
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
  if (actionId === READINESS_BUNDLE_REVIEW_ACTION_ID) {
    const readinessBundleReview = reviewReadinessBundle(repoRoot);
    return {
      ...plan,
      status: readinessBundleReview.status,
      evidence: "structured readiness bundle review executed",
      readiness_bundle_review: readinessBundleReview,
      stop_condition: readinessBundleReview.status === "PASS"
        ? "readiness_bundle_review_passed"
        : "readiness_bundle_review_failed"
    };
  }

  if (actionId === CANVAS_STORY_SYNC_REVIEW_ACTION_ID) {
    const canvasStorySyncReview = reviewCanvasStorySync(repoRoot);
    return {
      ...plan,
      status: canvasStorySyncReview.status,
      evidence: "structured canvas story sync review executed",
      canvas_story_sync_review: canvasStorySyncReview,
      stop_condition: canvasStorySyncReview.status === "PASS"
        ? "canvas_story_sync_review_passed"
        : "canvas_story_sync_review_failed"
    };
  }

  if (actionId === TASK_LINEAGE_REVIEW_ACTION_ID) {
    const taskLineageReview = reviewTaskLineage(repoRoot);
    return {
      ...plan,
      status: taskLineageReview.status,
      evidence: "structured task lineage review executed",
      task_lineage_review: taskLineageReview,
      stop_condition: taskLineageReview.status === "PASS"
        ? "task_lineage_review_passed"
        : "task_lineage_review_failed"
    };
  }

  if (actionId === UI_TRANSLATION_REVIEW_ACTION_ID) {
    const uiTranslationReview = reviewUiTranslationIntegrity(repoRoot);
    return {
      ...plan,
      status: uiTranslationReview.status,
      evidence: "structured UI translation review executed",
      ui_translation_review: uiTranslationReview,
      stop_condition: uiTranslationReview.status === "PASS"
        ? "ui_translation_review_passed"
        : "ui_translation_review_failed"
    };
  }

  if (actionId === ACTION_BOUNDARY_REVIEW_ACTION_ID) {
    const actionBoundaryReview = reviewActionBoundary(repoRoot);
    return {
      ...plan,
      status: actionBoundaryReview.status,
      evidence: "structured local action boundary review executed",
      action_boundary_review: actionBoundaryReview,
      stop_condition: actionBoundaryReview.status === "PASS"
        ? "action_boundary_review_passed"
        : "action_boundary_review_failed"
    };
  }

  if (actionId === DASHBOARD_INTEGRITY_REVIEW_ACTION_ID) {
    const dashboardIntegrityReview = reviewDashboardIntegrity(repoRoot);
    return {
      ...plan,
      status: dashboardIntegrityReview.status,
      evidence: "structured dashboard integrity review executed",
      dashboard_integrity_review: dashboardIntegrityReview,
      stop_condition: dashboardIntegrityReview.status === "PASS"
        ? "dashboard_integrity_review_passed"
        : "dashboard_integrity_review_failed"
    };
  }

  if (actionId === BRIDGE_CONTRACT_REVIEW_ACTION_ID) {
    const bridgeContractReview = reviewBridgeContract(repoRoot);
    return {
      ...plan,
      status: bridgeContractReview.status,
      evidence: "structured bridge contract review executed",
      bridge_contract_review: bridgeContractReview,
      stop_condition: bridgeContractReview.status === "PASS"
        ? "bridge_contract_review_passed"
        : "bridge_contract_structured_review_failed"
    };
  }

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
