from __future__ import annotations

from sdu_runtime_common import main_guard, read_csv, read_text, require_columns, require_files


MATRIX = "governance/connections/MCP_TEAMS_ACTIVE_LIVE_GATE_MATRIX_20260603.csv"
EXPECTED_IDS = {
    "conn_canon_003504",
    "conn_canon_003505",
    "conn_canon_003736",
    "conn_canon_004173",
}
EXPECTED_COLUMNS = [
    "canonical_id",
    "connection_name",
    "surface",
    "current_status",
    "active_status",
    "auth_companion_id",
    "tenant_required",
    "identity_required",
    "secret_required",
    "target_required",
    "owner_required",
    "live_read_probe_allowed",
    "live_write_allowed",
    "first_probe_command",
    "first_probe_status",
    "first_message_allowed",
    "rollback_required",
    "postcheck_required",
    "evidence_required",
    "blocked_actions",
    "stop_condition",
    "next_command_exact",
]


def validate() -> None:
    require_files([MATRIX, "governance/teams/MCP_TEAMS_FIRST_CONTROLLED_MESSAGE_GATE_20260603.md"])
    rows = read_csv(MATRIX)
    require_columns(rows, EXPECTED_COLUMNS, MATRIX)

    ids = {row["canonical_id"] for row in rows}
    if ids != EXPECTED_IDS:
        raise AssertionError(f"unexpected canonical ids: {sorted(ids)}")

    by_id = {row["canonical_id"]: row for row in rows}
    active = by_id["conn_canon_003505"]
    if active["active_status"] != "LIVE_READ_PROBE_ALLOWED_IF_AUTH_READY":
        raise AssertionError("conn_canon_003505 must be active live read candidate")
    if active["live_read_probe_allowed"] != "true":
        raise AssertionError("conn_canon_003505 must allow live read probe")
    if active["live_write_allowed"] != "false":
        raise AssertionError("conn_canon_003505 must not allow live write")
    if active["auth_companion_id"] not in {"conn_canon_003503", "conn_canon_004172"}:
        raise AssertionError("active row missing auth companion")
    if "--connection-id conn_canon_003505" not in active["next_command_exact"]:
        raise AssertionError("active next command must use conn_canon_003505")
    if "--no-body-print" not in active["next_command_exact"]:
        raise AssertionError("active next command must force no body print")

    if by_id["conn_canon_003504"]["active_status"] != "PATTERN_REFERENCE_CANON":
        raise AssertionError("conn_canon_003504 must remain pattern reference")
    for canon_id in ["conn_canon_003736", "conn_canon_004173"]:
        if by_id[canon_id]["active_status"] != "EVIDENCE_REFERENCE_CANON":
            raise AssertionError(f"{canon_id} must remain evidence reference")

    for row in rows:
        if row["connection_name"] != "mcp_TeamsServer":
            raise AssertionError(f"{row['canonical_id']} must refer to mcp_TeamsServer")
        if row["surface"] != "Teams":
            raise AssertionError(f"{row['canonical_id']} must stay Teams surface")
        if row["live_write_allowed"] != "false":
            raise AssertionError(f"{row['canonical_id']} enables live write")
        for token in ["teams_send", "graph_write", "token_print", "secret_persist"]:
            if token not in row["blocked_actions"]:
                raise AssertionError(f"{row['canonical_id']} missing blocked action {token}")

    gate = read_text("governance/teams/MCP_TEAMS_FIRST_CONTROLLED_MESSAGE_GATE_20260603.md")
    for token in [
        "FIRST_MESSAGE_PENDING_TARGET_OR_APPROVAL",
        "PENDING_TARGET_ONLY",
        "TEAMS_MESSAGE_WITHOUT_TARGET",
        "GRAPH_WRITE_ATTEMPTED",
        "Seshat SDU Agent DEV: prueba controlada de identidad MCP Teams. No ejecutar acciones productivas.",
    ]:
        if token not in gate:
            raise AssertionError(f"message gate missing {token}")


if __name__ == "__main__":
    main_guard("MCP_TEAMS_ACTIVE_LIVE_GATE_VALIDATOR", validate)
