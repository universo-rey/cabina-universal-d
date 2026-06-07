import { spawn } from "node:child_process";

const POSTCHECK_ACTION_ID = "local.action.prepare_local_validation";

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
      execution_mode: "guided_read_only",
      allowed_now: "read_task_queue|review_stop_conditions",
      blocked_actions: "dispatch_live_agents|change_status_values",
      stop_condition: "queued_task_rendered_as_executed"
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
