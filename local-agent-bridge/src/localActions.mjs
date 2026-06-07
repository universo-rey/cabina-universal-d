import { spawn } from "node:child_process";
import fs from "node:fs";
import path from "node:path";

const POSTCHECK_ACTION_ID = "local.action.prepare_local_validation";
const TASK_QUEUE_REVIEW_ACTION_ID = "local.action.review_task_queue";
const TASK_QUEUE_PATH = ".agents/codex/matrices/VSCODE_INSIDERS_AGENT_TASK_QUEUE_20260606.csv";

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
      action_id: "local.action.inspect_canvas_lane",
      title: "Inspeccionar carril Agile Canvas",
      status: activeLane.status,
      surface: "agileagentcanvas_context",
      owner_agent: activeLane.owner_agent,
      target: activeLane.lane_id,
      evidence: "active_governed_lane visible en /api/dashboard",
      execution_mode: "guided_read_only",
      allowed_now: "read_dashboard_api|review_canvas_artifacts",
      blocked_actions: "live_provider_call|secret_handling|external_sync",
      stop_condition: "active_lane_not_visible_in_dashboard"
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
    }
  ];
}

export function getLocalActionExecutionPlan(actionId) {
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
