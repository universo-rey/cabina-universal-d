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
            "local-agent-bridge/tests/mock_bridge_flow.mjs",
        ]
    )
    package = read_json("local-agent-bridge/package.json")
    if package["scripts"]["test"] != "node tests/mock_bridge_flow.mjs":
        raise AssertionError("local bridge test script mismatch")

    contract = read_json("local-agent-bridge/contracts/local-agent-bridge.contract.json")
    if contract["transport"] != "http-loopback" or contract["response"]["liveExecutedValue"] is not False:
        raise AssertionError("local bridge contract must remain loopback and no-live")

    routes_path = "local-agent-bridge/matrices/routes_matrix.csv"
    routes = read_csv(routes_path)
    require_columns(routes, ["route_id", "http_method", "path", "assigned_agent", "blocked_actions", "status"], routes_path)
    for row in routes:
        if row["status"] != "ACTIVE_DEV":
            raise AssertionError(f"{row['route_id']} must be ACTIVE_DEV")
        if "external_write" not in row["blocked_actions"] and "teams_send" not in row["blocked_actions"]:
            raise AssertionError(f"{row['route_id']} missing write block")

    server = read_text("local-agent-bridge/src/server.mjs")
    if '127.0.0.1' not in server:
        raise AssertionError("local bridge must default to loopback")
    if "live_executed: false" not in server:
        raise AssertionError("local bridge must report no live execution")


if __name__ == "__main__":
    main_guard("LOCAL_AGENT_BRIDGE_VALIDATOR", validate)
