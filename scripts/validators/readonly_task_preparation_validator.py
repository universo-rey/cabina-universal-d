from __future__ import annotations

from sdu_runtime_common import (
    main_guard,
    read_csv,
    require_columns,
    require_files,
    require_no_materialized_sensitive_values,
)


NAME = "READONLY_TASK_PREPARATION_VALIDATOR"
QUEUE_PATH = ".agents/codex/matrices/READONLY_TASK_PREPARATION_QUEUE_20260607.csv"

REQUIRED_COLUMNS = [
    "task_id",
    "source_issue",
    "title",
    "surface",
    "mode",
    "lead_agent",
    "owner_agent",
    "reviewer_agent",
    "skill",
    "recipe",
    "tool",
    "allowed_actions",
    "blocked_actions",
    "required_evidence",
    "validator",
    "rollback",
    "stop_condition",
    "status",
]

REQUIRED_TASKS = {
    "TAREA_RO_01",
    "TAREA_RO_02",
    "TAREA_RO_03",
    "TAREA_RO_04",
    "TAREA_RO_05",
    "TAREA_RO_06",
    "TAREA_RO_07",
}

GLOBAL_BLOCKED_TOKENS = {
    "secrets",
    "openai live",
    "microsoft live",
    "production",
}


def _contains_powershell_runtime(value: str) -> bool:
    lowered = value.lower()
    return any(token in lowered for token in ("powershell", "pwsh", ".ps1"))


def validate() -> None:
    require_files([QUEUE_PATH])
    require_no_materialized_sensitive_values([QUEUE_PATH])
    rows = read_csv(QUEUE_PATH)
    require_columns(rows, REQUIRED_COLUMNS, QUEUE_PATH)

    task_ids = {row["task_id"] for row in rows}
    missing_tasks = sorted(REQUIRED_TASKS - task_ids)
    if missing_tasks:
        raise AssertionError("missing read-only tasks: " + ", ".join(missing_tasks))
    if len(task_ids) != len(rows):
        raise AssertionError("duplicate task_id in read-only queue")

    for index, row in enumerate(rows, start=2):
        task_id = row["task_id"]
        if row["status"] != "PREPARED_READONLY":
            raise AssertionError(f"{QUEUE_PATH}:{index} {task_id} must be PREPARED_READONLY")
        if not row["mode"].startswith("read_only"):
            raise AssertionError(f"{QUEUE_PATH}:{index} {task_id} must remain read_only")
        if row["skill"] != "tcu-descubridor-capacidades":
            raise AssertionError(f"{QUEUE_PATH}:{index} {task_id} missing mandatory discovery skill")
        if row["validator"] != "scripts/validators/readonly_task_preparation_validator.py":
            raise AssertionError(f"{QUEUE_PATH}:{index} {task_id} must use the Python queue validator")
        if row["rollback"] != "no write performed":
            raise AssertionError(f"{QUEUE_PATH}:{index} {task_id} rollback must declare no write performed")
        if "secret_detected" not in row["stop_condition"]:
            raise AssertionError(f"{QUEUE_PATH}:{index} {task_id} missing secret stop condition")
        if not row["required_evidence"]:
            raise AssertionError(f"{QUEUE_PATH}:{index} {task_id} missing required evidence")
        combined = "|".join(row.values()).lower()
        if _contains_powershell_runtime(combined):
            raise AssertionError(f"{QUEUE_PATH}:{index} {task_id} references blocked shell runtime")
        blocked_actions = row["blocked_actions"].lower()
        for token in GLOBAL_BLOCKED_TOKENS:
            if token not in blocked_actions:
                raise AssertionError(f"{QUEUE_PATH}:{index} {task_id} missing blocked action {token}")
        if row["surface"] == "codex_cloud_environment" and "codex cloud apply" not in blocked_actions:
            raise AssertionError(f"{QUEUE_PATH}:{index} {task_id} missing blocked action codex cloud apply")


if __name__ == "__main__":
    main_guard(NAME, validate)
