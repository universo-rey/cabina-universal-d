from sdu_runtime_common import main_guard, read_csv, require_columns, require_files, require_no_live, require_statuses


def validate() -> None:
    path = "governance/agents/SDU_AGENT_CAPABILITY_ASSIGNMENT_MATRIX_20260603.csv"
    rows = read_csv(path)
    require_columns(
        rows,
        [
            "agent_id",
            "chain_position",
            "capability_id",
            "surface",
            "mode",
            "allowed_actions",
            "blocked_actions",
            "requires_human_approval",
            "evidence",
            "validator",
            "rollback",
            "stop_condition",
            "status",
        ],
        path,
    )
    require_statuses(rows, {"ACTIVE_DEV"}, path)
    require_no_live(rows, path)

    agent_ids = [row["agent_id"] for row in rows]
    expected = [
        "rey.control_plane_orchestrator",
        "court.openai_dispatcher",
        "sdu-triage-agent",
        "court.sdu_gate",
        "court.seshat_evidence",
    ]
    if agent_ids != expected:
        raise AssertionError(f"unexpected agent chain: {agent_ids}")
    if len(agent_ids) > 5:
        raise AssertionError("seventh agent or extra agent detected")

    for row in rows:
        require_files([row["evidence"], row["validator"]])
        blocked = row["blocked_actions"].lower()
        if "secret" not in blocked and "material" not in blocked:
            raise AssertionError(f"{row['agent_id']} missing sensitive material block")

    unified = read_csv("governance/agents/SDU_AGENT_TEAMS_MCP_CODEX_CLOUD_MATRIX_20260603.csv")
    require_columns(
        unified,
        ["lane_id", "teams_route", "mcp_connection", "codex_cloud_assignment", "owner_agent", "status"],
        "governance/agents/SDU_AGENT_TEAMS_MCP_CODEX_CLOUD_MATRIX_20260603.csv",
    )
    require_statuses(unified, {"ACTIVE_DEV"}, "governance/agents/SDU_AGENT_TEAMS_MCP_CODEX_CLOUD_MATRIX_20260603.csv")


if __name__ == "__main__":
    main_guard("SDU_AGENT_CAPABILITY_ASSIGNMENT_VALIDATOR", validate)
