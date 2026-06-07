from __future__ import annotations

import csv
from pathlib import Path

from sdu_runtime_common import (
    main_guard,
    read_csv,
    rel,
    require_columns,
    require_files,
    require_no_materialized_sensitive_values,
)


NAME = "VSI_MEMORY_LOG_NO_PS_VALIDATOR"
MATRIX_PATH = ".agents/codex/matrices/VSI_MEMORY_LOG_NO_PS_MATRIX_20260607.csv"
TASK_QUEUE_PATH = ".agents/codex/matrices/VSCODE_INSIDERS_AGENT_TASK_QUEUE_20260606.csv"
COVERAGE_PATH = ".agents/codex/matrices/VALIDATION_COVERAGE_MATRIX.csv"
NO_PS_PREP_PATH = ".agents/codex/matrices/NO_PS_VALIDATOR_PREP_MATRIX_20260607.csv"
VALIDATOR_PATH = "scripts/validators/vsi_memory_log_no_ps_validator.py"

REQUIRED_COLUMNS = [
    "log_id",
    "artifact_path",
    "artifact_role",
    "current_use",
    "source_surface",
    "owner_agent",
    "reviewer_agent",
    "no_ps_policy",
    "expected_min_count",
    "allowed_actions",
    "blocked_actions",
    "validator",
    "postcheck_command",
    "rollback",
    "stop_condition",
    "status",
]

REQUIRED_LOG_IDS = {
    "vsi_memory_log.workpaper_evidence_logs",
    "vsi_memory_log.startup_readback",
    "vsi_memory_log.startup_command_map",
    "vsi_memory_log.agent_task_queue",
    "vsi_memory_log.validation_coverage",
    "vsi_memory_log.no_ps_validator_contract",
}

ALLOWED_STATUS = {"ACTIVE_NO_PS", "HISTORICAL_REFERENCE_ONLY"}
FORBIDDEN_COMMAND_TOKENS = ("powershell", "pwsh", ".ps1")
HISTORICAL_PS_REFERENCE_IDS = {
    "vsi_memory_log.startup_readback",
    "vsi_memory_log.startup_command_map",
}
PS_REFERENCE_REGISTRY_IDS = {
    "vsi_memory_log.agent_task_queue",
    "vsi_memory_log.validation_coverage",
    "vsi_memory_log.no_ps_validator_contract",
}
REQUIRED_TASK_ID = "vsi.agent.task.040"


def _contains_ps_token(value: str) -> bool:
    lowered = value.lower()
    return any(token in lowered for token in FORBIDDEN_COMMAND_TOKENS)


def _assert_python_postcheck(row: dict[str, str], line: int) -> None:
    command = row["postcheck_command"].lower()
    if _contains_ps_token(command):
        raise AssertionError(f"{MATRIX_PATH}:{line} {row['log_id']} postcheck uses blocked runtime")
    if command != f"python {VALIDATOR_PATH}":
        raise AssertionError(f"{MATRIX_PATH}:{line} {row['log_id']} postcheck must be python {VALIDATOR_PATH}")


def _expand_artifact_paths(row: dict[str, str], line: int) -> list[Path]:
    artifact_path = row["artifact_path"]
    expected_min = int(row["expected_min_count"] or "1")
    if artifact_path.startswith("glob:"):
        pattern = artifact_path.removeprefix("glob:")
        matches = sorted(rel(".").glob(pattern))
        if len(matches) < expected_min:
            raise AssertionError(
                f"{MATRIX_PATH}:{line} {row['log_id']} expected at least {expected_min} matches for {pattern}"
            )
        return matches

    target = rel(artifact_path)
    if not target.exists():
        raise AssertionError(f"{MATRIX_PATH}:{line} missing artifact {artifact_path}")
    return [target]


def _assert_artifact_policy(row: dict[str, str], paths: list[Path], line: int) -> None:
    log_id = row["log_id"]
    is_historical = row["status"] == "HISTORICAL_REFERENCE_ONLY"
    if log_id in HISTORICAL_PS_REFERENCE_IDS and not is_historical:
        raise AssertionError(f"{MATRIX_PATH}:{line} {log_id} must remain historical reference only")
    if is_historical and "historical" not in row["current_use"].lower():
        raise AssertionError(f"{MATRIX_PATH}:{line} {log_id} historical row must declare historical current_use")

    for path in paths:
        if path.is_dir():
            continue
        text = path.read_text(encoding="utf-8", errors="ignore")
        if _contains_ps_token(text) and not is_historical and log_id not in PS_REFERENCE_REGISTRY_IDS:
            rel_path = path.relative_to(rel("."))
            raise AssertionError(f"{MATRIX_PATH}:{line} {log_id} has unclassified PS reference in {rel_path}")


def _assert_csv_header(path: Path) -> None:
    with path.open("r", encoding="utf-8-sig", newline="") as handle:
        reader = csv.reader(handle)
        try:
            header = next(reader)
        except StopIteration as exc:
            raise AssertionError(f"empty evidence log: {path}") from exc
    required = {"date", "evidence_id", "source", "artifact", "validator", "result", "notes"}
    if set(header) != required:
        raise AssertionError(f"unexpected evidence log header: {path}")


def _assert_task_queue_row() -> None:
    rows = read_csv(TASK_QUEUE_PATH)
    matches = [row for row in rows if row.get("task_id") == REQUIRED_TASK_ID]
    if len(matches) != 1:
        raise AssertionError(f"{TASK_QUEUE_PATH} missing unique {REQUIRED_TASK_ID}")
    row = matches[0]
    if row.get("status") != "EXECUTED_LOCAL_VALIDATED":
        raise AssertionError(f"{REQUIRED_TASK_ID} must be EXECUTED_LOCAL_VALIDATED")
    if row.get("validator") != f"python {VALIDATOR_PATH}|python scripts/validators/no_ps_validator_prep_validator.py":
        raise AssertionError(f"{REQUIRED_TASK_ID} must declare python validators only")
    executable_fields = "|".join(row.get(field, "") for field in ("allowed_actions", "postcheck", "evidence", "validator"))
    if _contains_ps_token(executable_fields):
        raise AssertionError(f"{REQUIRED_TASK_ID} executable fields reference blocked shell runtime")


def _assert_coverage() -> None:
    rows = read_csv(COVERAGE_PATH)
    matches = [row for row in rows if row.get("artifact_class") == "vsi_memory_log_no_ps"]
    if len(matches) != 1:
        raise AssertionError("missing unique vsi_memory_log_no_ps coverage row")
    row = matches[0]
    if row.get("required_index") != MATRIX_PATH:
        raise AssertionError("vsi_memory_log_no_ps coverage row points to wrong matrix")
    if row.get("required_validator") != VALIDATOR_PATH:
        raise AssertionError("vsi_memory_log_no_ps coverage row points to wrong validator")
    if row.get("coverage_status") != "covered":
        raise AssertionError("vsi_memory_log_no_ps coverage must be covered")


def _assert_no_ps_contract() -> None:
    rows = read_csv(NO_PS_PREP_PATH)
    matches = [row for row in rows if row.get("validator_id") == "vsi_memory_log_no_ps"]
    if len(matches) != 1:
        raise AssertionError("missing unique no-ps prep row for vsi_memory_log_no_ps")
    row = matches[0]
    if row.get("validator_path") != VALIDATOR_PATH:
        raise AssertionError("vsi_memory_log_no_ps no-ps prep row points to wrong validator")
    if row.get("validates_artifact") != MATRIX_PATH:
        raise AssertionError("vsi_memory_log_no_ps no-ps prep row points to wrong artifact")
    for field in ("command", "postcheck"):
        value = row.get(field, "").lower()
        if value != f"python {VALIDATOR_PATH}" or _contains_ps_token(value):
            raise AssertionError(f"vsi_memory_log_no_ps no-ps prep {field} must be python-only")


def validate() -> None:
    require_files([MATRIX_PATH, TASK_QUEUE_PATH, COVERAGE_PATH, NO_PS_PREP_PATH, VALIDATOR_PATH])
    require_no_materialized_sensitive_values([MATRIX_PATH, TASK_QUEUE_PATH, COVERAGE_PATH, NO_PS_PREP_PATH])
    rows = read_csv(MATRIX_PATH)
    require_columns(rows, REQUIRED_COLUMNS, MATRIX_PATH)

    ids = {row["log_id"] for row in rows}
    missing = sorted(REQUIRED_LOG_IDS - ids)
    if missing:
        raise AssertionError("missing VSI memory-log rows: " + ", ".join(missing))
    if len(ids) != len(rows):
        raise AssertionError("duplicate log_id in VSI memory-log matrix")

    all_paths: list[Path] = []
    for index, row in enumerate(rows, start=2):
        log_id = row["log_id"]
        if row["status"] not in ALLOWED_STATUS:
            raise AssertionError(f"{MATRIX_PATH}:{index} {log_id} unexpected status {row['status']}")
        if row["validator"] != VALIDATOR_PATH:
            raise AssertionError(f"{MATRIX_PATH}:{index} {log_id} wrong validator")
        if "secret_detected" not in row["stop_condition"]:
            raise AssertionError(f"{MATRIX_PATH}:{index} {log_id} missing secret stop condition")
        blocked = row["blocked_actions"].lower()
        for token in ("powershell execution", "pwsh execution", ".ps1 execution", "live write", "secret handling"):
            if token not in blocked:
                raise AssertionError(f"{MATRIX_PATH}:{index} {log_id} missing blocked action {token}")
        _assert_python_postcheck(row, index)
        paths = _expand_artifact_paths(row, index)
        all_paths.extend(paths)
        _assert_artifact_policy(row, paths, index)

    for path in all_paths:
        if path.name == "EVIDENCE_LOG.csv":
            _assert_csv_header(path)

    _assert_task_queue_row()
    _assert_coverage()
    _assert_no_ps_contract()


if __name__ == "__main__":
    main_guard(NAME, validate)
