from sdu_runtime_common import main_guard, read_csv, read_json, read_text, require_columns, require_files


def validate() -> None:
    require_files(
        [
            "local-agent-bridge/README.md",
            "local-agent-bridge/package.json",
            "local-agent-bridge/contracts/local-agent-bridge.contract.json",
            "local-agent-bridge/matrices/routes_matrix.csv",
            "local-agent-bridge/policies/security_policy.md",
            "local-agent-bridge/schemas/evidence.schema.json",
            "local-agent-bridge/src/server.mjs",
            "local-agent-bridge/src/router.mjs",
            "local-agent-bridge/src/policy.mjs",
            "local-agent-bridge/src/evidenceAdapter.mjs",
            "local-agent-bridge/src/mcpRegistry.mjs",
            "local-agent-bridge/src/shellConnector.mjs",
            "local-agent-bridge/src/localActions.mjs",
            "local-agent-bridge/tests/mock_bridge_flow.mjs",
            ".agents/codex/orders/ORDER_VSI_POWER_PLATFORM_DRY_RUN_20260607.md",
        ]
    )
    package = read_json("local-agent-bridge/package.json")
    if package["scripts"]["test"] != "node tests/mock_bridge_flow.mjs":
        raise AssertionError("local bridge test script mismatch")

    contract = read_json("local-agent-bridge/contracts/local-agent-bridge.contract.json")
    if contract["transport"] != "http-loopback" or contract["response"]["liveExecutedValue"] is not False:
        raise AssertionError("local bridge contract must remain loopback and no-live")
    if contract.get("shellConnector", {}).get("commandExecutionExposed") is not False:
        raise AssertionError("shell connector command execution must not be exposed")
    local_actions = contract.get("localActions", {})
    if local_actions.get("commandExecutionExposed") is not False:
        raise AssertionError("local actions must not expose arbitrary command execution")
    for action_id in (
        "local.action.inspect_canvas_lane",
        "local.action.review_task_queue",
        "local.action.prepare_local_validation",
        "local.action.review_live_gate_packets",
    ):
        if action_id not in local_actions.get("allowedActionIds", []):
            raise AssertionError(f"local action allowlist missing {action_id}")
    if "execute_arbitrary_shell_from_dashboard" not in local_actions.get("blockedActions", []):
        raise AssertionError("local actions must block arbitrary shell from dashboard")
    if contract.get("localReadSurface", {}).get("requiresLoopbackBindHost") is not True:
        raise AssertionError("local read surface must require loopback bind host")
    if contract.get("localReadSurface", {}).get("blockedStatus") != 403:
        raise AssertionError("non-loopback local reads must be blocked with 403")

    routes_path = "local-agent-bridge/matrices/routes_matrix.csv"
    routes = read_csv(routes_path)
    require_columns(routes, ["route_id", "http_method", "path", "assigned_agent", "blocked_actions", "status"], routes_path)
    for row in routes:
        if row["status"] != "ACTIVE_DEV":
            raise AssertionError(f"{row['route_id']} must be ACTIVE_DEV")
        if "external_write" not in row["blocked_actions"] and "teams_send" not in row["blocked_actions"]:
            raise AssertionError(f"{row['route_id']} missing write block")
    route_ids = {row["route_id"] for row in routes}
    for route_id in ("bridge.shell_status", "bridge.shell_command_blocked", "bridge.local_action_run"):
        if route_id not in route_ids:
            raise AssertionError(f"missing governed local route: {route_id}")

    server = read_text("local-agent-bridge/src/server.mjs")
    if '127.0.0.1' not in server:
        raise AssertionError("local bridge must default to loopback")
    if "live_executed: false" not in server:
        raise AssertionError("local bridge must report no live execution")
    if "assertLoopbackReadSurface(host)" not in server:
        raise AssertionError("dashboard and shell status must be loopback-gated")
    if '"/api/local-actions/run"' not in server:
        raise AssertionError("local action endpoint must be declared")
    policy = read_text("local-agent-bridge/src/policy.mjs")
    if "0.0.0.0" in policy:
        raise AssertionError("policy should not allow non-loopback wildcard hosts")
    if "assertLoopbackReadSurface" not in policy:
        raise AssertionError("policy must expose loopback read surface guard")
    shell_connector = read_text("local-agent-bridge/src/shellConnector.mjs")
    if "execute_arbitrary_command" not in shell_connector:
        raise AssertionError("shell connector must block arbitrary command execution")
    if "status_only" not in shell_connector:
        raise AssertionError("shell connector must remain status_only")
    local_actions_text = read_text("local-agent-bridge/src/localActions.mjs")
    if "execute_arbitrary_shell_from_dashboard" not in local_actions_text:
        raise AssertionError("local actions must block arbitrary shell execution")
    if "purpose_built_postcheck_allowlist" not in local_actions_text:
        raise AssertionError("local actions must use purpose-built postcheck allowlist")
    if "structured_local_review_no_shell" not in local_actions_text:
        raise AssertionError("local actions must support structured no-shell review")
    if "canvas_lane_review" not in local_actions_text:
        raise AssertionError("local actions must expose structured canvas lane review")
    if "ORDER_VSI_POWER_PLATFORM_DRY_RUN_20260607.md" not in local_actions_text:
        raise AssertionError("local actions must review Power Platform dry-run packet")


if __name__ == "__main__":
    main_guard("LOCAL_AGENT_BRIDGE_VALIDATOR", validate)
