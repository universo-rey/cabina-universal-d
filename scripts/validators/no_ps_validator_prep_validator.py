from __future__ import annotations

from sdu_runtime_common import (
    main_guard,
    read_csv,
    require_columns,
    require_files,
    require_no_materialized_sensitive_values,
    rel,
)


NAME = "NO_PS_VALIDATOR_PREP_VALIDATOR"
MATRIX_PATH = ".agents/codex/matrices/NO_PS_VALIDATOR_PREP_MATRIX_20260607.csv"

REQUIRED_COLUMNS = [
    "validator_id",
    "target_surface",
    "validator_path",
    "command",
    "owner_agent",
    "reviewer_agent",
    "validates_artifact",
    "allowed_actions",
    "blocked_actions",
    "postcheck",
    "rollback",
    "stop_condition",
    "status",
]

REQUIRED_VALIDATORS = {
    "readonly_task_preparation": "scripts/validators/readonly_task_preparation_validator.py",
    "no_ps_validator_prep": "scripts/validators/no_ps_validator_prep_validator.py",
    "vsi_memory_log_no_ps": "scripts/validators/vsi_memory_log_no_ps_validator.py",
    "vsi_usage_expansion": "scripts/validators/vsi_usage_expansion_validator.py",
    "vsi_function_utilization": "scripts/validators/vsi_function_utilization_validator.py",
}

FORBIDDEN_COMMAND_TOKENS = ("powershell", "pwsh", ".ps1")


def _assert_python_command(value: str, field: str, row_id: str, line: int) -> None:
    lowered = value.lower()
    if any(token in lowered for token in FORBIDDEN_COMMAND_TOKENS):
        raise AssertionError(f"{MATRIX_PATH}:{line} {row_id} {field} uses a blocked shell runtime")
    if not lowered.startswith("python scripts/validators/"):
        raise AssertionError(f"{MATRIX_PATH}:{line} {row_id} {field} must start with python scripts/validators/")


def validate() -> None:
    require_files([MATRIX_PATH])
    require_no_materialized_sensitive_values([MATRIX_PATH])
    rows = read_csv(MATRIX_PATH)
    require_columns(rows, REQUIRED_COLUMNS, MATRIX_PATH)

    ids = {row["validator_id"] for row in rows}
    missing = sorted(set(REQUIRED_VALIDATORS) - ids)
    if missing:
        raise AssertionError("missing no-ps validators: " + ", ".join(missing))
    if len(ids) != len(rows):
        raise AssertionError("duplicate validator_id in no-ps prep matrix")

    for index, row in enumerate(rows, start=2):
        validator_id = row["validator_id"]
        expected_path = REQUIRED_VALIDATORS.get(validator_id)
        if expected_path and row["validator_path"] != expected_path:
            raise AssertionError(f"{MATRIX_PATH}:{index} {validator_id} path mismatch")
        if not rel(row["validator_path"]).exists():
            raise AssertionError(f"{MATRIX_PATH}:{index} validator file missing: {row['validator_path']}")
        if not rel(row["validates_artifact"]).exists():
            raise AssertionError(f"{MATRIX_PATH}:{index} validates missing artifact: {row['validates_artifact']}")
        if row["status"] != "ACTIVE":
            raise AssertionError(f"{MATRIX_PATH}:{index} {validator_id} must be ACTIVE")
        if "secret_detected" not in row["stop_condition"]:
            raise AssertionError(f"{MATRIX_PATH}:{index} {validator_id} missing secret stop condition")
        if "no ps runtime" not in row["blocked_actions"].lower():
            raise AssertionError(f"{MATRIX_PATH}:{index} {validator_id} must block ps runtime")
        _assert_python_command(row["command"], "command", validator_id, index)
        _assert_python_command(row["postcheck"], "postcheck", validator_id, index)


if __name__ == "__main__":
    main_guard(NAME, validate)
