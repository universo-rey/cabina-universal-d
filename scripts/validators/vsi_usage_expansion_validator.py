from __future__ import annotations

import json

from sdu_runtime_common import (
    main_guard,
    read_csv,
    read_json,
    rel,
    require_columns,
    require_files,
    require_no_materialized_sensitive_values,
)


NAME = "VSI_USAGE_EXPANSION_VALIDATOR"
MATRIX_PATH = ".agents/codex/matrices/VSI_USAGE_EXPANSION_MATRIX_20260607.csv"
TASKS_PATH = ".vscode/tasks.json"

REQUIRED_COLUMNS = [
    "capability_id",
    "vsi_surface",
    "artifact_path",
    "owner_agent",
    "reviewer_agent",
    "task_label",
    "command",
    "args",
    "allowed_actions",
    "blocked_actions",
    "validator",
    "postcheck_command",
    "rollback",
    "stop_condition",
    "status",
]

REQUIRED_TASKS = {
    "Cabina: Validate VSI memory log no-PS": ("python", ["scripts/validators/vsi_memory_log_no_ps_validator.py"]),
    "Cabina: Validate VSI usage expansion": ("python", ["scripts/validators/vsi_usage_expansion_validator.py"]),
    "Cabina: Validate no-PS validator prep": ("python", ["scripts/validators/no_ps_validator_prep_validator.py"]),
    "Cabina: Validate readonly task prep": ("python", ["scripts/validators/readonly_task_preparation_validator.py"]),
    "Cabina: Git diff check": ("git", ["diff", "--check"]),
    "Cabina: VSI status": ("code-insiders", ["--status"]),
}

FORBIDDEN_TOKENS = ("powershell", "pwsh", ".ps1", "-encodedcommand", "start-process")


def _contains_forbidden(value: object) -> bool:
    text = json.dumps(value, ensure_ascii=True).lower() if not isinstance(value, str) else value.lower()
    return any(token in text for token in FORBIDDEN_TOKENS)


def _normalize_args(value: str) -> list[str]:
    return [part for part in value.split(" ") if part]


def _validate_tasks_json() -> None:
    data = read_json(TASKS_PATH)
    if not isinstance(data, dict):
        raise AssertionError(f"{TASKS_PATH} must be a JSON object")
    if data.get("version") != "2.0.0":
        raise AssertionError(f"{TASKS_PATH} must use version 2.0.0")
    tasks = data.get("tasks")
    if not isinstance(tasks, list):
        raise AssertionError(f"{TASKS_PATH} missing tasks list")

    by_label = {}
    for task in tasks:
        if not isinstance(task, dict):
            raise AssertionError(f"{TASKS_PATH} task entries must be objects")
        label = task.get("label")
        if not isinstance(label, str) or not label:
            raise AssertionError(f"{TASKS_PATH} task missing label")
        if label in by_label:
            raise AssertionError(f"{TASKS_PATH} duplicate task label: {label}")
        by_label[label] = task
        if task.get("type") != "process":
            raise AssertionError(f"{TASKS_PATH} {label} must use type=process")
        if _contains_forbidden(task):
            raise AssertionError(f"{TASKS_PATH} {label} references blocked runtime token")
        if task.get("command") not in {"python", "git", "code-insiders"}:
            raise AssertionError(f"{TASKS_PATH} {label} command not allowlisted")
        if "problemMatcher" not in task:
            raise AssertionError(f"{TASKS_PATH} {label} missing problemMatcher")

    missing = sorted(set(REQUIRED_TASKS) - set(by_label))
    if missing:
        raise AssertionError("missing VS Code tasks: " + ", ".join(missing))

    for label, (command, args) in REQUIRED_TASKS.items():
        task = by_label[label]
        if task.get("command") != command:
            raise AssertionError(f"{TASKS_PATH} {label} command mismatch")
        if task.get("args") != args:
            raise AssertionError(f"{TASKS_PATH} {label} args mismatch")


def validate() -> None:
    require_files([MATRIX_PATH, TASKS_PATH])
    require_no_materialized_sensitive_values([MATRIX_PATH, TASKS_PATH])
    rows = read_csv(MATRIX_PATH)
    require_columns(rows, REQUIRED_COLUMNS, MATRIX_PATH)
    _validate_tasks_json()

    labels = set(REQUIRED_TASKS)
    seen_labels: set[str] = set()
    for index, row in enumerate(rows, start=2):
        capability_id = row["capability_id"]
        label = row["task_label"]
        if label not in labels:
            raise AssertionError(f"{MATRIX_PATH}:{index} unknown task label {label}")
        if label in seen_labels:
            raise AssertionError(f"{MATRIX_PATH}:{index} duplicate task label {label}")
        seen_labels.add(label)
        if row["status"] != "ACTIVE_NO_PS":
            raise AssertionError(f"{MATRIX_PATH}:{index} {capability_id} must be ACTIVE_NO_PS")
        if row["artifact_path"] != TASKS_PATH:
            raise AssertionError(f"{MATRIX_PATH}:{index} {capability_id} must target {TASKS_PATH}")
        if row["validator"] != "scripts/validators/vsi_usage_expansion_validator.py":
            raise AssertionError(f"{MATRIX_PATH}:{index} {capability_id} validator mismatch")
        if row["postcheck_command"] != "python scripts/validators/vsi_usage_expansion_validator.py":
            raise AssertionError(f"{MATRIX_PATH}:{index} {capability_id} postcheck mismatch")
        if "secret_detected" not in row["stop_condition"]:
            raise AssertionError(f"{MATRIX_PATH}:{index} {capability_id} missing secret stop condition")
        blocked = row["blocked_actions"].lower()
        for token in ("powershell execution", "pwsh execution", "live write", "secret handling"):
            if token not in blocked:
                raise AssertionError(f"{MATRIX_PATH}:{index} {capability_id} missing blocked action {token}")
        if _contains_forbidden(row["command"]) or _contains_forbidden(row["args"]) or _contains_forbidden(row["postcheck_command"]):
            raise AssertionError(f"{MATRIX_PATH}:{index} {capability_id} references blocked runtime token")
        expected_command, expected_args = REQUIRED_TASKS[label]
        if row["command"] != expected_command:
            raise AssertionError(f"{MATRIX_PATH}:{index} {capability_id} command mismatch")
        if _normalize_args(row["args"]) != expected_args:
            raise AssertionError(f"{MATRIX_PATH}:{index} {capability_id} args mismatch")
        for arg in expected_args:
            if arg.startswith("scripts/validators/") and not rel(arg).exists():
                raise AssertionError(f"{MATRIX_PATH}:{index} missing validator {arg}")

    missing_rows = sorted(labels - seen_labels)
    if missing_rows:
        raise AssertionError("missing VSI usage expansion matrix rows: " + ", ".join(missing_rows))


if __name__ == "__main__":
    main_guard(NAME, validate)
