import path from "node:path";

export function getShellConnectorStatus(repoRoot = process.cwd()) {
  return {
    status: "ok",
    connector_id: "local.shell.connector.governed",
    surface: "local_shell",
    mode: "status_only",
    repo_root: path.resolve(repoRoot),
    default_shell: "powershell",
    live_executed: false,
    allowed_actions: [
      "status",
      "preflight",
      "route_to_codex_shell_tool"
    ],
    blocked_actions: [
      "execute_arbitrary_command",
      "external_write",
      "secret_printing",
      "production",
      "permission_change",
      "destructive_action"
    ],
    required_gate_for_execution: "GATE_DESTRUCTIVE_ACTION_OR_EXPLICIT_TASK_SCOPE",
    stop_condition: "LOCAL_SHELL_COMMAND_EXECUTION_NOT_EXPOSED"
  };
}

export function buildShellCommandBlockedResponse(repoRoot = process.cwd()) {
  return {
    ...getShellConnectorStatus(repoRoot),
    status: "blocked",
    reason: "shell command execution is not exposed by the local bridge"
  };
}
