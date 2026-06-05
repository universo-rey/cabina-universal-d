from __future__ import annotations

from sdu_runtime_common import (
    main_guard,
    read_csv,
    read_text,
    require_columns,
    require_files,
    require_no_materialized_sensitive_values,
)


NAME = "CABINA_UNIVERSAL_D_POST_MERGE_VALIDATOR"

REQUIRED_FILES = [
    "08_READBACKS/GATE_CABINA_UNIVERSAL_D_POST_MERGE_READBACK.md",
    "00_CONTEXT/MERGE_SERIAL_GOVERNED_PATTERN.md",
    "00_CONTEXT/SDU_REPO_AUTHORITY_MATRIX.csv",
    "00_CONTEXT/SDU_OPEN_FRONTS_CURRENT_BASELINE.md",
    "00_CONTEXT/SDU_REPO_REVIEW_QUEUE.csv",
    "00_CONTEXT/SDU_REPO_REVIEW_QUEUE.md",
    "08_READBACKS/GATE_CABINA_UNIVERSAL_D_REPO_QUEUE_READBACK.md",
]

AUTHORITY_MATRIX = "00_CONTEXT/SDU_REPO_AUTHORITY_MATRIX.csv"
REVIEW_QUEUE = "00_CONTEXT/SDU_REPO_REVIEW_QUEUE.csv"

FOCUS_REPOS = {
    "universo-rey/cabina-universal-d",
    "SeshatSgin/torre-gemela-escribania",
    "SeshatSgin/seshat-bootstrap-sdu-cn",
    "SeshatSgin/cdf-soluciones",
    "SeshatSgin/tge-agentic-runtime-control-escribania",
}

FORBIDDEN_EXECUTION_MARKERS = [
    "microsoft_live_executed",
    "openai_api_live_executed",
    "responses_api_live_executed",
    "agents_sdk_live_executed",
    "production_executed",
    "tenant_write_executed",
    "admin_bypass_used",
    "branch_deleted_without_authorization",
    "--admin",
]


def require_contains(path: str, fragments: list[str]) -> None:
    text = read_text(path)
    missing = [fragment for fragment in fragments if fragment not in text]
    if missing:
        raise AssertionError(f"{path} missing required fragments: {', '.join(missing)}")


def validate_no_forbidden_markers() -> None:
    for path in REQUIRED_FILES:
        text = read_text(path).lower()
        for marker in FORBIDDEN_EXECUTION_MARKERS:
            if marker in text:
                raise AssertionError(f"{path} contains forbidden marker {marker}")


def validate_post_merge_readback() -> None:
    path = "08_READBACKS/GATE_CABINA_UNIVERSAL_D_POST_MERGE_READBACK.md"
    require_contains(
        path,
        [
            "#92",
            "#91",
            "12bbd8fcd9db950b4c86e78bf988497938ffffad",
            "4aa594f460818d1c2dd7ec1725a5d646f923e69c",
            "9bce9f4e87d548a8ee6afe67ff729c66c34d2688",
            "77c957d1ae5de055ab3ef2869e597a2c8be50714",
            "eliminacion autorizada explicitamente",
            "conservada",
            "Rollback",
            "Stop conditions",
            "OK_NO_API_CALL",
        ],
    )


def validate_pattern() -> None:
    path = "00_CONTEXT/MERGE_SERIAL_GOVERNED_PATTERN.md"
    require_contains(
        path,
        [
            "MERGE_SERIAL_GOVERNED_PATTERN_CANONIZED_FOR_REPLICATION",
            "gh pr merge <PR> --merge --match-head-commit <HEAD>",
            "Conservar la branch remota por defecto",
            "Eliminar la branch remota solo cuando",
            "Rollback",
            "Stop conditions",
            "admin_bypass_requested",
            "branch_deletion_without_explicit_authorization",
        ],
    )


def validate_authority_matrix() -> None:
    rows = read_csv(AUTHORITY_MATRIX)
    require_columns(
        rows,
        [
            "repo",
            "repo_role",
            "surface",
            "external_live_policy",
            "github_pattern",
            "next_lane",
            "owner_agent",
            "reviewer_agent",
            "validator",
            "stop_conditions",
        ],
        AUTHORITY_MATRIX,
    )
    root_rows = [row for row in rows if row["repo"] == "universo-rey/cabina-universal-d"]
    if len(root_rows) != 1:
        raise AssertionError(f"{AUTHORITY_MATRIX} must contain one cabina root row")
    root = root_rows[0]
    expected = {
        "repo_role": "REPO_CABINA_GOBERNADA",
        "surface": "github_repo_scoped",
        "external_live_policy": "no_external_live",
        "github_pattern": "recipe.github_pr_lifecycle_governed",
        "next_lane": "revision_otros_repos",
    }
    for field, value in expected.items():
        if root[field] != value:
            raise AssertionError(f"{AUTHORITY_MATRIX} root {field} must be {value}")
    if "cabina_universal_d_post_merge_validator.py" not in root["validator"]:
        raise AssertionError(f"{AUTHORITY_MATRIX} root validator must be post merge validator")
    if "secret_detected" not in root["stop_conditions"]:
        raise AssertionError(f"{AUTHORITY_MATRIX} root stop conditions must include secret_detected")


def validate_review_queue() -> None:
    rows = read_csv(REVIEW_QUEUE)
    require_columns(
        rows,
        [
            "repo",
            "motivo_revision",
            "riesgo",
            "estado_actual",
            "requiere_lectura_agents",
            "requiere_lectura_validators",
            "requiere_lectura_workflows",
            "requiere_pr_abierto",
            "proximo_gate",
            "prioridad",
            "stop_conditions",
        ],
        REVIEW_QUEUE,
    )
    repos = {row["repo"] for row in rows}
    missing = sorted(FOCUS_REPOS - repos)
    if missing:
        raise AssertionError(f"{REVIEW_QUEUE} missing focus repos: {', '.join(missing)}")
    for index, row in enumerate(rows, start=2):
        for field in [
            "motivo_revision",
            "riesgo",
            "estado_actual",
            "proximo_gate",
            "stop_conditions",
        ]:
            if not row[field].strip():
                raise AssertionError(f"{REVIEW_QUEUE}:{index} missing {field}")
        for field in [
            "requiere_lectura_agents",
            "requiere_lectura_validators",
            "requiere_lectura_workflows",
            "requiere_pr_abierto",
        ]:
            if row[field] not in {"yes", "no"}:
                raise AssertionError(f"{REVIEW_QUEUE}:{index} {field} must be yes or no")
        if row["prioridad"] not in {"P0", "P1", "P2", "P3"}:
            raise AssertionError(f"{REVIEW_QUEUE}:{index} invalid prioridad")
        if "secret_detected" not in row["stop_conditions"]:
            raise AssertionError(f"{REVIEW_QUEUE}:{index} stop conditions must include secret_detected")


def validate_baseline_and_final_readback() -> None:
    require_contains(
        "00_CONTEXT/SDU_OPEN_FRONTS_CURRENT_BASELINE.md",
        [
            "CABINA_UNIVERSAL_D_POST_MERGE_BASELINE_READY",
            "REPO_CABINA_GOBERNADA",
            "github_repo_scoped",
            "no_external_live",
            "recipe.github_pr_lifecycle_governed",
            "revision_otros_repos",
        ],
    )
    require_contains(
        "08_READBACKS/GATE_CABINA_UNIVERSAL_D_REPO_QUEUE_READBACK.md",
        [
            "CABINA_UNIVERSAL_D_POST_MERGE_BASELINE_READY",
            "Patron cristalizado",
            "Baseline actualizado",
            "Repos en cola",
            "SeshatSgin/torre-gemela-escribania",
            "GATE_TGE_ACTIVE_HARDENING_REVIEW",
            "Rollback",
            "Stop conditions",
        ],
    )


def validate() -> None:
    require_files(REQUIRED_FILES)
    require_no_materialized_sensitive_values(REQUIRED_FILES)
    validate_no_forbidden_markers()
    validate_post_merge_readback()
    validate_pattern()
    validate_authority_matrix()
    validate_review_queue()
    validate_baseline_and_final_readback()


if __name__ == "__main__":
    main_guard(NAME, validate)
