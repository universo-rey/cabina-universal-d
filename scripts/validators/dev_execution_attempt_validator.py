from __future__ import annotations

from sdu_runtime_common import main_guard, read_csv, read_text, require_files, require_no_materialized_sensitive_values


NAME = "DEV_EXECUTION_ATTEMPT_VALIDATOR"

READBACK = "readbacks/20260603_ACTIVE_EXECUTION_DEV_ATTEMPT_READBACK.md"
CANON_READBACK = "readbacks/20260603_CANON_ACTIVE_GOVERNED_EXECUTION_BY_DEFAULT_READBACK.md"
MATRIX = "governance/canon/ACTIVE_EXECUTION_CAPABILITY_MATRIX_20260603.csv"

REQUIRED_MARKERS = [
    "SDU_LOCAL_AGENT_BRIDGE_MOCK_FLOW_PASS",
    "SDU_TEAMS_IDENTITY_DEV_ACTIVATION_VALIDATOR=PASS",
    "SDU_MCP_DEV_ACTIVATION_VALIDATOR=PASS",
    "SDU_LOCAL_BRIDGE_DEV_ACTIVATION_VALIDATOR=PASS",
    "SDU_CODEX_CLOUD_DEV_ACTIVATION_VALIDATOR=PASS",
    "SDU_DEV_ACTIVATION_SECRET_CONTRACT_VALIDATOR=PASS",
    "task_e_6a20a9c306c0832e940f4e416165494c",
    "CLOUD_TASK_CREATED_STATUS_ERROR_NO_DIFF_AVAILABLE",
    "NO_TEAMS_INSTALL",
    "NO_TEAMS_MESSAGE_SENT",
    "NO_GRAPH_WRITE",
    "NO_MCP_REMOTE_WRITE",
    "NO_OPENAI_LIVE",
    "NO_CODEX_CLOUD_APPLY",
    "NO_PRODUCTION",
    "NO_SECRET_PRINT",
]

REQUIRED_CANON_MARKERS = [
    "ACTIVE_GOVERNED_EXECUTION_BY_DEFAULT",
    "EXECUTE_LOCAL_NOW",
    "EXECUTE_MOCK_NOW",
    "EXECUTE_DEV_NOW",
    "PENDING_TARGET_ONLY",
    "PENDING_SECRET_ONLY",
    "READY_FOR_PROD_HUMAN_GATE",
]


def validate_matrix_links() -> None:
    rows = read_csv(MATRIX)
    active_rows = [row for row in rows if row["active_status"].startswith("EXECUTE_")]
    pending_rows = [row for row in rows if row["active_status"].startswith("PENDING_")]
    if not active_rows:
        raise AssertionError("active execution matrix has no executable rows")
    if not pending_rows:
        raise AssertionError("active execution matrix has no target/secret pending rows")

    for index, row in enumerate(rows, start=2):
        if row["active_status"].startswith("EXECUTE_") and row["execute_now"] != "yes":
            raise AssertionError(f"{MATRIX}:{index} executable row lacks execute_now=yes")
        if row["active_status"].startswith("PENDING_") and row["execute_now"] != "no":
            raise AssertionError(f"{MATRIX}:{index} pending row must not execute now")
        if row["active_status"].startswith("PENDING_") and "[" not in row["required_target"] and row["active_status"] != "PENDING_SECRET_ONLY":
            raise AssertionError(f"{MATRIX}:{index} pending target row must preserve missing target placeholder")


def validate() -> None:
    require_files([READBACK, CANON_READBACK, MATRIX])

    readback = read_text(READBACK)
    missing = [marker for marker in REQUIRED_MARKERS if marker not in readback]
    if missing:
        raise AssertionError(f"{READBACK} missing execution markers: {', '.join(missing)}")

    canon = read_text(CANON_READBACK)
    missing_canon = [marker for marker in REQUIRED_CANON_MARKERS if marker not in canon]
    if missing_canon:
        raise AssertionError(f"{CANON_READBACK} missing canon markers: {', '.join(missing_canon)}")

    validate_matrix_links()
    require_no_materialized_sensitive_values([READBACK, CANON_READBACK, MATRIX])


if __name__ == "__main__":
    main_guard(NAME, validate)
