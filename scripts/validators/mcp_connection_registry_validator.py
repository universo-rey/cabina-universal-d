from sdu_runtime_common import main_guard, read_csv, read_json, require_columns, require_files, require_no_live


def validate() -> None:
    path = "governance/connections/MCP_CONNECTION_REGISTRY_20260603.csv"
    rows = read_csv(path)
    require_columns(
        rows,
        [
            "connection_id",
            "connection_type",
            "owner_agent",
            "tool_surface",
            "mode",
            "trust_level",
            "read_scope",
            "write_scope",
            "allowed_actions",
            "blocked_actions",
            "requires_approval",
            "auth_reference",
            "evidence",
            "validator",
            "rollback",
            "stop_condition",
            "status",
        ],
        path,
    )
    require_no_live(rows, path)

    expected = {
        "mcp.github.repo_scoped",
        "mcp.teams.chat.template",
        "mcp.local.bridge.mock",
        "mcp.codex.cloud.repo_scoped",
        "mcp.openai.responses.gate",
    }
    actual = {row["connection_id"] for row in rows}
    if actual != expected:
        raise AssertionError(f"unexpected MCP registry ids: {sorted(actual)}")

    for row in rows:
        require_files([row["evidence"], row["validator"]])
        if row["write_scope"] != "none" and row["requires_approval"] != "yes":
            raise AssertionError(f"{row['connection_id']} has write scope without approval")
        if row["connection_type"] in {"microsoft_teams", "codex_cloud", "openai"} and row["status"] not in {"TEMPLATE_ONLY", "CONTRACT_ONLY"}:
            raise AssertionError(f"{row['connection_id']} must remain template or contract only")

    config = read_json(".mcp/sdu-agents/mcp.config.template.json")
    if config["defaults"]["liveWrites"] is not False or config["defaults"]["production"] is not False:
        raise AssertionError("MCP template defaults must block live writes and production")
    for name, server in config["servers"].items():
        blocked = set(server.get("blockedActions", []))
        if name != "localAgentBridge" and server.get("enabledByDefault") is not False:
            raise AssertionError(f"{name} must not be enabled by default")
        if not blocked:
            raise AssertionError(f"{name} missing blocked actions")


if __name__ == "__main__":
    main_guard("MCP_CONNECTION_REGISTRY_VALIDATOR", validate)
