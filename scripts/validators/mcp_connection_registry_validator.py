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
        if row["requires_approval"] != "high_only":
            raise AssertionError(f"{row['connection_id']} must reserve approval for HIGH")
        if row["connection_type"] in {"microsoft_teams", "codex_cloud", "openai"}:
            if row["status"] not in {"TEMPLATE_ONLY", "CONTRACT_ONLY", "ACTIVE_GOVERNED"}:
                raise AssertionError(f"{row['connection_id']} has unknown connection status")
            if row["status"] == "ACTIVE_GOVERNED" and any(
                not row.get(field, "").strip() or row[field].lower() in {"pending", "unknown", "none"}
                for field in ("binding_ref", "exact_target")
            ):
                raise AssertionError("active connection requires a resolved binding and exact target")

    config = read_json(".mcp/sdu-agents/mcp.config.template.json")
    if config["defaults"].get("executionPolicy") != "READ_DIRECT_LOW_WITHOUT_ORDER_HIGH_EXPLICIT_AUTH":
        raise AssertionError("MCP template must consume proportional execution policy")
    if config["defaults"].get("unresolvedBindingsExecutable") is not False:
        raise AssertionError("MCP template must not invent resolved connections")
    for name, server in config["servers"].items():
        blocked = set(server.get("blockedActions", []))
        if name != "localAgentBridge" and server.get("enabledByDefault") is not False:
            if server.get("mode") != "active_governed" or not all(
                isinstance(server.get(field), str) and server[field].strip()
                and server[field].lower() not in {"pending", "unknown", "none"}
                for field in ("binding_ref", "exact_target")
            ):
                raise AssertionError(f"{name} requires resolved configuration before enabling")
        if not blocked:
            raise AssertionError(f"{name} missing blocked actions")


if __name__ == "__main__":
    main_guard("MCP_CONNECTION_REGISTRY_VALIDATOR", validate)
