from __future__ import annotations

from sdu_runtime_common import (
    main_guard,
    read_csv,
    read_text,
    require_columns,
    require_files,
    require_no_materialized_sensitive_values,
)


NAME = "REY_GUIA_ACTIVE_EXECUTION_QUEUE_VALIDATOR"

IMPACT_MD = "governance/canon/REY_GUIA_ACTIVE_CONTRACT_IMPACT_20260604.md"
IMPACT_CSV = "governance/canon/REY_GUIA_ACTIVE_CONTRACT_IMPACT_20260604.csv"
QUEUE = "governance/canon/REY_GUIA_ACTIVE_EXECUTION_QUEUE_20260604.csv"
PACKAGE_POINTER = "governance/canon/REY_GUIA_BROWNFIELD_LOCAL_PACKAGE_POINTER_20260604.csv"
READBACK = "readbacks/versioning/READBACK_REY_GUIA_ACTIVE_EXECUTION_QUEUE_20260604.md"

REQUIRED_FILES = [IMPACT_MD, IMPACT_CSV, QUEUE, PACKAGE_POINTER, READBACK]

REQUIRED_LANES = {
    "rey_guia.versionable_canon_pointer": "EXECUTE_LOCAL_NOW",
    "rey_guia.dataverse_v2_semantic_matrix": "EXECUTE_LOCAL_NOW",
    "rey_guia.agent_delegation_consolidation": "EXECUTE_LOCAL_NOW",
    "rey_guia.decisions_owner_review": "PENDING_OWNER_ONLY",
    "rey_guia.product_package_map": "PENDING_OWNER_ONLY",
}

REQUIRED_COLUMNS = [
    "lane_id",
    "title",
    "source_impact_area",
    "active_state",
    "queue_status",
    "execute_now",
    "owner_agent",
    "reviewer_agent",
    "skill",
    "recipe",
    "tool",
    "surface",
    "write_scope",
    "lock_key",
    "dependency",
    "next_command",
    "validator",
    "evidence",
    "rollback",
    "postcheck",
    "blocked_actions",
    "stop_condition",
]

PACKAGE_POINTER_COLUMNS = [
    "artifact_id",
    "local_path",
    "role",
    "git_visibility",
    "length_bytes",
    "sha256",
    "hash_algorithm",
    "verified_at",
    "verified_by",
    "exists_at_verification",
    "versioning_decision",
    "active_queue_lane",
]

EXPECTED_PACKAGE_PATHS = {
    "docs/canon/CANON_REY_GUIA_V1.md": "ignored_by_root_allowlist",
    "docs/metodologia/METODO_DECRETO_ON.md": "ignored_by_root_allowlist",
    "docs/reconciliacion/MATRIZ_MAESTRA_RECONCILIACION.md": "ignored_by_root_allowlist",
    "matrices/reconciliacion/MATRIZ_MAESTRA_RECONCILIACION.csv": "ignored_by_root_allowlist",
    "docs/reconciliacion/INVENTARIO_ACTIVOS_EXISTENTES.md": "ignored_by_root_allowlist",
    "docs/reconciliacion/GAP_ANALYSIS_REY_GUIA.md": "ignored_by_root_allowlist",
    "docs/reconciliacion/MAPA_TRADUCCION_CANON_A_ECOSISTEMA.md": "ignored_by_root_allowlist",
    "docs/backlog/BACKLOG_CIERRE_RECONCILIACION.md": "ignored_by_root_allowlist",
    "docs/reconciliacion/DECISIONES_REQUERIDAS.md": "ignored_by_root_allowlist",
    "docs/reconciliacion/README.md": "ignored_by_root_allowlist",
    ".agents/codex/evals/results/rey_guia_reconciliation_summary_20260604.json": "tracked_repo_visible",
}

ALLOWED_STATES = {
    "EXECUTE_LOCAL_NOW",
    "EXECUTE_MOCK_NOW",
    "EXECUTE_DEV_NOW",
    "EXECUTE_LIVE_READ_NOW",
    "EXECUTE_LIVE_WRITE_GATED_NOW",
    "EXECUTE_CODEX_CLOUD_SMOKE_NOW",
    "EXECUTE_MCP_READ_PROBE_NOW",
    "EXECUTE_TEAMS_DEV_TEST_NOW",
    "READY_FOR_PROD_HUMAN_GATE",
    "PENDING_TARGET_ONLY",
    "PENDING_SECRET_ONLY",
    "PENDING_IDENTITY_ONLY",
    "PENDING_OWNER_ONLY",
    "BLOCKED_SECURITY_RISK",
    "BLOCKED_SECRET_EXPOSURE",
    "BLOCKED_TENANT_AMBIGUOUS",
    "BLOCKED_PRODUCTION_UNAPPROVED",
}

FORBIDDEN_PASSIVE_STATES = {
    "ABIERTO",
    "EN_CURSO",
    "PREPARADO",
    "PENDIENTE",
    "prepared",
    "pending",
    "blocked",
    "disabled",
    "not executed",
}

FORBIDDEN_BOUNDARY_PHRASES = {
    "microsoft_live_executed",
    "openai_api_live_executed",
    "responses_api_live_executed",
    "agents_sdk_live_executed",
    "production_executed",
    "permission_changed",
    "secret_materialized",
    "tenant_write_executed",
    "dataverse_live_apply_executed",
    "remote_write_executed",
}

ALLOWED_QUEUE_STATUSES = {
    "QUEUED_ACTIVE_LOCAL",
    "RUNNING_LOCAL",
    "VALIDATED_LOCAL",
    "STOPPED_BY_CONDITION",
    "PENDING_OWNER_ONLY",
    "CLOSED_VALIDATED",
}

EXECUTABLE_COMMAND_PREFIXES = ("python ", "pwsh ", "powershell ", "git ", "gh ")
ABSOLUTE_LOCAL_PATH_MARKERS = ("D:/", "D:\\")


def require_text_markers() -> None:
    impact = read_text(IMPACT_MD)
    for marker in [
        "ACTIVE_GOVERNED_EXECUTION_BY_DEFAULT",
        "EXECUTE_LOCAL_NOW",
        "PENDING_OWNER_ONLY",
        "REY_GUIA_ACTIVE_EXECUTION_QUEUE_20260604.csv",
        "No requiere Microsoft live",
        "Stop condition",
    ]:
        if marker not in impact:
            raise AssertionError(f"{IMPACT_MD} missing marker: {marker}")

    readback = read_text(READBACK)
    for marker in [
        "REY_GUIA_ACTIVE_EXECUTION_QUEUE_READY_LOCAL",
        "ACTIVE_GOVERNED_EXECUTION_BY_DEFAULT",
        "NO_MICROSOFT_LIVE",
        "NO_OPENAI_LIVE",
        "NO_PRODUCTION",
        "NO_SECRETS",
    ]:
        if marker not in readback:
            raise AssertionError(f"{READBACK} missing marker: {marker}")


def require_no_absolute_local_paths() -> None:
    for path in REQUIRED_FILES:
        text = read_text(path)
        for marker in ABSOLUTE_LOCAL_PATH_MARKERS:
            if marker in text:
                raise AssertionError(f"{path} contains absolute local path marker {marker!r}")


def validate_impact_csv() -> None:
    rows = read_csv(IMPACT_CSV)
    require_columns(
        rows,
        [
            "area",
            "before_contract",
            "active_contract_impact",
            "recommended_active_status",
            "safe_next_action",
            "risk",
            "stop_condition",
        ],
        IMPACT_CSV,
    )
    statuses = {row["recommended_active_status"] for row in rows}
    if "EXECUTE_LOCAL_NOW" not in statuses:
        raise AssertionError(f"{IMPACT_CSV} must include EXECUTE_LOCAL_NOW impacts")
    if "PENDING_OWNER_ONLY" not in statuses:
        raise AssertionError(f"{IMPACT_CSV} must include PENDING_OWNER_ONLY impacts")
    areas = {row["area"] for row in rows}
    if "Producto" not in areas:
        raise AssertionError(f"{IMPACT_CSV} must formalize Producto as an impact area")
    if len(rows) < 5:
        raise AssertionError(f"{IMPACT_CSV} must preserve the Rey-Guia impact scope")


def validate_package_pointer() -> None:
    rows = read_csv(PACKAGE_POINTER)
    require_columns(rows, PACKAGE_POINTER_COLUMNS, PACKAGE_POINTER)
    if len(rows) != len(EXPECTED_PACKAGE_PATHS):
        raise AssertionError(f"{PACKAGE_POINTER} must contain exactly the brownfield package artifacts")

    seen_paths = set()
    for index, row in enumerate(rows, start=2):
        path = row["local_path"]
        seen_paths.add(path)
        expected_visibility = EXPECTED_PACKAGE_PATHS.get(path)
        if expected_visibility is None:
            raise AssertionError(f"{PACKAGE_POINTER}:{index} unexpected local_path {path!r}")
        if row["git_visibility"] != expected_visibility:
            raise AssertionError(f"{PACKAGE_POINTER}:{index} unexpected git_visibility")
        if not row["length_bytes"].isdigit() or int(row["length_bytes"]) <= 0:
            raise AssertionError(f"{PACKAGE_POINTER}:{index} invalid length_bytes")
        sha = row["sha256"]
        if len(sha) != 64 or not all(char in "0123456789ABCDEF" for char in sha):
            raise AssertionError(f"{PACKAGE_POINTER}:{index} invalid sha256")
        if row["hash_algorithm"] != "SHA256":
            raise AssertionError(f"{PACKAGE_POINTER}:{index} hash_algorithm must be SHA256")
        if row["verified_at"] != "2026-06-04":
            raise AssertionError(f"{PACKAGE_POINTER}:{index} unexpected verified_at")
        if not row["verified_by"].strip():
            raise AssertionError(f"{PACKAGE_POINTER}:{index} missing verified_by")
        if row["exists_at_verification"] not in {"yes", "no"}:
            raise AssertionError(f"{PACKAGE_POINTER}:{index} invalid exists_at_verification")
        if row["active_queue_lane"] not in REQUIRED_LANES:
            raise AssertionError(f"{PACKAGE_POINTER}:{index} active_queue_lane is not in queue")
        if "pointer_only" not in row["versioning_decision"] and row["git_visibility"] != "tracked_repo_visible":
            raise AssertionError(f"{PACKAGE_POINTER}:{index} ignored artifact must be pointer-only")

    if seen_paths != set(EXPECTED_PACKAGE_PATHS):
        raise AssertionError(f"{PACKAGE_POINTER} package path mismatch")


def validate_queue() -> None:
    rows = read_csv(QUEUE)
    require_columns(rows, REQUIRED_COLUMNS, QUEUE)
    impact_areas = {row["area"] for row in read_csv(IMPACT_CSV)}
    if len(rows) != len(REQUIRED_LANES):
        raise AssertionError(f"{QUEUE} must contain exactly {len(REQUIRED_LANES)} lanes")

    seen_lanes = set()
    seen_locks = set()
    executable_count = 0
    pending_owner_count = 0

    for index, row in enumerate(rows, start=2):
        lane_id = row["lane_id"]
        seen_lanes.add(lane_id)

        expected_state = REQUIRED_LANES.get(lane_id)
        if expected_state is None:
            raise AssertionError(f"{QUEUE}:{index} unexpected lane_id {lane_id!r}")
        if row["active_state"] != expected_state:
            raise AssertionError(f"{QUEUE}:{index} {lane_id} must be {expected_state}")
        if row["active_state"] not in ALLOWED_STATES:
            raise AssertionError(f"{QUEUE}:{index} unsupported active_state {row['active_state']!r}")
        if row["active_state"] in FORBIDDEN_PASSIVE_STATES:
            raise AssertionError(f"{QUEUE}:{index} passive final state is not allowed")
        if row["queue_status"] not in ALLOWED_QUEUE_STATUSES:
            raise AssertionError(f"{QUEUE}:{index} unsupported queue_status {row['queue_status']!r}")
        if row["active_state"].startswith("PENDING_") and row["queue_status"] != row["active_state"]:
            raise AssertionError(f"{QUEUE}:{index} pending lane queue_status must match active_state")

        source_areas = {area.strip() for area in row["source_impact_area"].split("|") if area.strip()}
        missing_areas = source_areas - impact_areas
        if missing_areas:
            raise AssertionError(f"{QUEUE}:{index} source_impact_area not in impact CSV: {sorted(missing_areas)}")
        if lane_id == "rey_guia.versionable_canon_pointer" and "Matriz maestra en matrices" not in source_areas:
            raise AssertionError(f"{QUEUE}:{index} pointer lane must cover Matriz maestra en matrices")

        execute_now = row["execute_now"]
        if row["active_state"].startswith("EXECUTE_"):
            executable_count += 1
            if execute_now != "yes":
                raise AssertionError(f"{QUEUE}:{index} executable lane must have execute_now=yes")
        if row["active_state"].startswith("PENDING_"):
            if execute_now != "no":
                raise AssertionError(f"{QUEUE}:{index} pending lane must have execute_now=no")
            if "_ONLY" not in row["active_state"]:
                raise AssertionError(f"{QUEUE}:{index} pending lane must name exact missing condition")
        if row["active_state"] == "PENDING_OWNER_ONLY":
            pending_owner_count += 1
            if "owner" not in row["stop_condition"].lower() and "decision" not in row["next_command"].lower():
                raise AssertionError(f"{QUEUE}:{index} owner pending lane must name owner decision")

        next_command = row["next_command"].strip()
        if not next_command:
            raise AssertionError(f"{QUEUE}:{index} missing next_command")
        if not next_command.startswith(EXECUTABLE_COMMAND_PREFIXES):
            raise AssertionError(f"{QUEUE}:{index} next_command must be an exact command or script invocation")
        if row["validator"] != "python scripts/validators/rey_guia_active_execution_queue_validator.py":
            raise AssertionError(f"{QUEUE}:{index} unexpected validator")
        if not row["rollback"].strip() or not row["postcheck"].strip():
            raise AssertionError(f"{QUEUE}:{index} missing rollback or postcheck")
        if "secret_materialization" not in row["blocked_actions"]:
            raise AssertionError(f"{QUEUE}:{index} must block secret materialization")
        if "production" not in row["blocked_actions"]:
            raise AssertionError(f"{QUEUE}:{index} must block production")
        if "live" in row["surface"].lower():
            raise AssertionError(f"{QUEUE}:{index} surface must remain local/order-only")
        if "*" in row["write_scope"]:
            raise AssertionError(f"{QUEUE}:{index} write_scope must not contain wildcards")

        lock_key = row["lock_key"]
        if lock_key in seen_locks:
            raise AssertionError(f"{QUEUE}:{index} duplicate lock_key {lock_key}")
        seen_locks.add(lock_key)

        combined = "|".join(row.values()).lower()
        for phrase in FORBIDDEN_BOUNDARY_PHRASES:
            if phrase in combined:
                raise AssertionError(f"{QUEUE}:{index} forbidden boundary phrase: {phrase}")

    if seen_lanes != set(REQUIRED_LANES):
        raise AssertionError(f"{QUEUE} lane set mismatch: {sorted(seen_lanes)}")
    if executable_count < 3:
        raise AssertionError(f"{QUEUE} must keep local executable lanes")
    if pending_owner_count < 2:
        raise AssertionError(f"{QUEUE} must identify owner-only pending lanes")


def validate() -> None:
    require_files(REQUIRED_FILES)
    require_no_materialized_sensitive_values(REQUIRED_FILES)
    require_no_absolute_local_paths()
    require_text_markers()
    validate_impact_csv()
    validate_package_pointer()
    validate_queue()


if __name__ == "__main__":
    main_guard(NAME, validate)
