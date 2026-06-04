from __future__ import annotations

from sdu_runtime_common import (
    main_guard,
    read_text,
    require_files,
    require_no_materialized_sensitive_values,
)


NAME = "ACTIVE_GOVERNED_EXECUTION_POLICY_VALIDATOR"

REQUIRED_FILES = [
    "AGENTS.md",
    "02_AUTHORITY_CANON/CURRENT_STATE.md",
    "governance/canon/ACTIVE_GOVERNED_EXECUTION_BY_DEFAULT_POLICY_20260603.md",
    "governance/canon/ACTIVE_EXECUTION_CAPABILITY_MATRIX_20260603.csv",
    "governance/canon/CANON_CONSERVATIVE_LANGUAGE_AUDIT_20260603.md",
    "governance/teams/TEAMS_ACTIVE_DEV_EXECUTION_POLICY_20260603.md",
    "governance/connections/MCP_ACTIVE_EXECUTION_POLICY_20260603.md",
    "governance/codex-cloud/CODEX_CLOUD_ACTIVE_EXECUTION_POLICY_20260603.md",
]

REQUIRED_STATES = [
    "ACTIVE_GOVERNED_EXECUTION_BY_DEFAULT",
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
    "PENDING_COST_BOUNDARY_ONLY",
    "BLOCKED_SECURITY_RISK",
    "BLOCKED_SECRET_EXPOSURE",
    "BLOCKED_TENANT_AMBIGUOUS",
    "BLOCKED_PRODUCTION_UNAPPROVED",
    "BLOCKED_COST_BOUNDARY_MISSING",
]


def require_contains(path: str, fragments: list[str]) -> None:
    text = read_text(path)
    missing = [fragment for fragment in fragments if fragment not in text]
    if missing:
        raise AssertionError(f"{path} missing required fragments: {', '.join(missing)}")


def validate() -> None:
    require_files(REQUIRED_FILES)

    policy_path = "governance/canon/ACTIVE_GOVERNED_EXECUTION_BY_DEFAULT_POLICY_20260603.md"
    require_contains(
        policy_path,
        [
            "La cabina ejecuta por defecto",
            "seguro, reversible, trazable y validable",
            "Queda prohibido cerrar un carril",
            "Regla anti-escalamiento",
            "Limite de costo",
            "Comando exacto obligatorio",
            "Evidencia significa ejecucion o verificacion real",
        ],
    )
    require_contains(policy_path, REQUIRED_STATES)

    require_contains(
        "governance/canon/CANON_CONSERVATIVE_LANGUAGE_AUDIT_20260603.md",
        [
            "OVER_CONSERVATIVE",
            "VALID_HARD_STOP",
            "HISTORICAL_EVIDENCE",
            "ACTIVE_GOVERNED_EXECUTION_BY_DEFAULT",
        ],
    )
    require_contains(
        "AGENTS.md",
        [
            "Canon activo de ejecucion gobernada",
            "ACTIVE_GOVERNED_EXECUTION_BY_DEFAULT",
            "PENDING_*_ONLY",
        ],
    )
    require_contains(
        "02_AUTHORITY_CANON/CURRENT_STATE.md",
        [
            "ACTIVE_GOVERNED_EXECUTION_BY_DEFAULT",
            "governance/canon/ACTIVE_EXECUTION_CAPABILITY_MATRIX_20260603.csv",
        ],
    )

    for path in [
        "governance/teams/TEAMS_ACTIVE_DEV_EXECUTION_POLICY_20260603.md",
        "governance/connections/MCP_ACTIVE_EXECUTION_POLICY_20260603.md",
        "governance/codex-cloud/CODEX_CLOUD_ACTIVE_EXECUTION_POLICY_20260603.md",
    ]:
        require_contains(path, ["Estado:", "rollback", "postcheck", "evidencia", "stop_condition"])

    require_no_materialized_sensitive_values(REQUIRED_FILES)


if __name__ == "__main__":
    main_guard(NAME, validate)
