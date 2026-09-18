from __future__ import annotations

from sdu_runtime_common import (
    main_guard,
    read_csv,
    require_columns,
    require_files,
    require_no_live,
    require_statuses,
)


MATRIX = "governance/connections/MCP_DEV_ACTIVATION_MATRIX_20260603.csv"


def validate() -> None:
    require_files([MATRIX])
    rows = read_csv(MATRIX)
    require_columns(
        rows,
        [
            "connection_id",
            "dev_target",
            "owner_agent",
            "mode",
            "read_scope",
            "write_scope",
            "allowed_actions",
            "blocked_actions",
            "requires_approval",
            "auth_reference",
            "rollback",
            "postcheck",
            "evidence",
            "validator",
            "status",
        ],
        MATRIX,
    )
    require_no_live(rows, MATRIX)
    require_statuses(rows, {"DEV_READY", "CONTRACT_ONLY"}, MATRIX)
    expected = {
        "mcp.teams.dev",
        "mcp.local.bridge.dev",
        "mcp.codex.cloud.dev",
        "mcp.github.dev",
        "mcp.openai.responses.gate",
    }
    actual = {row["connection_id"] for row in rows}
    if actual != expected:
        raise AssertionError(f"unexpected MCP DEV connection ids: {sorted(actual)}")
    for row in rows:
        require_files([row["evidence"], row["validator"]])
        if row["requires_approval"] != "yes":
            raise AssertionError(f"{row['connection_id']} must require approval")
        blocked = row["blocked_actions"]
        if row["connection_id"] == "mcp.teams.dev" and ("teams_message" not in blocked or "graph_write" not in blocked):
            raise AssertionError("Teams MCP DEV row must block message and Graph write")
        if row["connection_id"] == "mcp.codex.cloud.dev" and "codex_cloud_apply" not in blocked:
            raise AssertionError("Codex Cloud MCP DEV row must block apply")
        if row["connection_id"] == "mcp.openai.responses.gate" and "openai_live" not in blocked:
            raise AssertionError("OpenAI gate row must block live")
        if "external_governed_store" not in row["auth_reference"] and row["connection_id"] != "mcp.github.dev":
            raise AssertionError(f"{row['connection_id']} must reference external governed store")


if __name__ == "__main__":
    main_guard("SDU_MCP_DEV_ACTIVATION_VALIDATOR", validate)
