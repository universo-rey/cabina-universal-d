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


NAME = "VSI_FUNCTION_UTILIZATION_VALIDATOR"
MATRIX_PATH = ".agents/codex/matrices/VSI_FUNCTION_UTILIZATION_MATRIX_20260607.csv"
TASKS_PATH = ".vscode/tasks.json"
SETTINGS_PATH = ".vscode/settings.json"
COVERAGE_PATH = ".agents/codex/matrices/VALIDATION_COVERAGE_MATRIX.csv"
NO_PS_PREP_PATH = ".agents/codex/matrices/NO_PS_VALIDATOR_PREP_MATRIX_20260607.csv"
MATRIX_INDEX_PATH = ".agents/codex/matrices/MATRIX_INDEX.csv"
TASK_QUEUE_PATH = ".agents/codex/matrices/VSCODE_INSIDERS_AGENT_TASK_QUEUE_20260606.csv"
WORKSPACE_EVIDENCE_PATH = ".agents/codex/workpapers/codex.workspace_guardian/EVIDENCE_LOG.csv"
SESHAT_EVIDENCE_PATH = ".agents/codex/workpapers/court.seshat_evidence/EVIDENCE_LOG.csv"
MEMORY_LOCAL_SYNC_PATH = ".vscode/memory/AGENT_MEMORY_SYNC.md"
MEMORY_WORKPAPER_EXPORT_PATH = ".agents/codex/workpapers/codex.workspace_guardian/AGENT_MEMORY_SYNC.md"
VALIDATOR_PATH = "scripts/validators/vsi_function_utilization_validator.py"
TASK_LABEL = "Cabina: Validate VSI function utilization"
TASK_ID = "vsi.agent.task.042"
EVIDENCE_ID = "EVD-VSI-FUNCTION-UTILIZATION-20260607"

REQUIRED_COLUMNS = [
    "function_id",
    "category",
    "installed_signal",
    "active_signal",
    "current_use",
    "unused_gap",
    "owner_agent",
    "reviewer_agent",
    "next_action",
    "task_label",
    "validator",
    "evidence",
    "rollback",
    "stop_condition",
    "status",
]

REQUIRED_FUNCTION_IDS = {
    "vsi.function.agile_agent_canvas",
    "vsi.function.codex_chat_panel",
    "vsi.function.agent_skills_mcp",
    "vsi.function.memory_panel",
    "vsi.function.memory_log_panel",
    "vsi.function.vscode_tasks_no_ps",
    "vsi.function.github_pr_actions_ui",
    "vsi.function.cross_repo_status_noise",
    "vsi.function.integrated_terminal_default",
    "vsi.function.remote_codespaces_containers",
    "vsi.function.codeql",
    "vsi.function.power_platform_pac",
    "vsi.function.docs_tooling",
}

ALLOWED_STATUSES = {
    "ACTIVE_USED",
    "ACTIVE_UNDERUSED",
    "INSTALLED_UNDERUSED",
    "DRIFT_DETECTED_RECONCILIATION_READY",
    "PRESENT_NOT_DESIRED",
    "ACTIVE_READY",
    "ACTIVE_GATED",
}

FORBIDDEN_TASK_TOKENS = ("powershell", "pwsh", ".ps1", "-encodedcommand", "start-process")


def _contains_forbidden_task_token(value: object) -> bool:
    text = json.dumps(value, ensure_ascii=True).lower() if not isinstance(value, str) else value.lower()
    return any(token in text for token in FORBIDDEN_TASK_TOKENS)


def _task_by_label() -> dict[str, dict[str, object]]:
    data = read_json(TASKS_PATH)
    if not isinstance(data, dict):
        raise AssertionError(f"{TASKS_PATH} must be a JSON object")
    tasks = data.get("tasks")
    if not isinstance(tasks, list):
        raise AssertionError(f"{TASKS_PATH} missing tasks list")
    by_label: dict[str, dict[str, object]] = {}
    for task in tasks:
        if not isinstance(task, dict):
            raise AssertionError(f"{TASKS_PATH} task entries must be objects")
        label = task.get("label")
        if isinstance(label, str):
            by_label[label] = task
    return by_label


def _assert_task_contract() -> None:
    task = _task_by_label().get(TASK_LABEL)
    if task is None:
        raise AssertionError(f"{TASKS_PATH} missing {TASK_LABEL}")
    if task.get("type") != "process":
        raise AssertionError(f"{TASK_LABEL} must use type=process")
    if task.get("command") != "python":
        raise AssertionError(f"{TASK_LABEL} must use python command")
    if task.get("args") != [VALIDATOR_PATH]:
        raise AssertionError(f"{TASK_LABEL} args mismatch")
    if _contains_forbidden_task_token(task):
        raise AssertionError(f"{TASK_LABEL} references blocked shell runtime")


def _assert_memory_bridge_settings() -> None:
    settings = read_json(SETTINGS_PATH)
    if not isinstance(settings, dict):
        raise AssertionError(f"{SETTINGS_PATH} must be a JSON object")
    if settings.get("agentMemory.storageBackend") != "disk":
        raise AssertionError("agentMemory.storageBackend must be disk")
    if settings.get("agentMemory.autoSyncToFile") != MEMORY_LOCAL_SYNC_PATH:
        raise AssertionError("agentMemory.autoSyncToFile must point to ignored local memory buffer")
    if settings.get("agentMemory.tldr.enabled") is not False:
        raise AssertionError("agentMemory.tldr.enabled must be false for no implicit AI summary")


def _assert_coverage() -> None:
    rows = read_csv(COVERAGE_PATH)
    matches = [row for row in rows if row.get("artifact_class") == "vsi_function_utilization"]
    if len(matches) != 1:
        raise AssertionError("missing unique vsi_function_utilization coverage row")
    row = matches[0]
    if row.get("required_index") != MATRIX_PATH:
        raise AssertionError("vsi_function_utilization coverage row points to wrong matrix")
    if row.get("required_validator") != VALIDATOR_PATH:
        raise AssertionError("vsi_function_utilization coverage row points to wrong validator")
    if row.get("coverage_status") != "covered":
        raise AssertionError("vsi_function_utilization coverage must be covered")


def _assert_no_ps_prep() -> None:
    rows = read_csv(NO_PS_PREP_PATH)
    matches = [row for row in rows if row.get("validator_id") == "vsi_function_utilization"]
    if len(matches) != 1:
        raise AssertionError("missing unique no-ps prep row for vsi_function_utilization")
    row = matches[0]
    if row.get("validator_path") != VALIDATOR_PATH:
        raise AssertionError("vsi_function_utilization no-ps prep path mismatch")
    if row.get("validates_artifact") != MATRIX_PATH:
        raise AssertionError("vsi_function_utilization no-ps prep artifact mismatch")
    for field in ("command", "postcheck"):
        value = row.get(field, "").lower()
        if value != f"python {VALIDATOR_PATH}" or _contains_forbidden_task_token(value):
            raise AssertionError(f"vsi_function_utilization no-ps prep {field} must be python-only")


def _assert_matrix_index() -> None:
    rows = read_csv(MATRIX_INDEX_PATH)
    matches = [row for row in rows if row.get("matrix_id") == "vsi_function_utilization"]
    if len(matches) != 1:
        raise AssertionError("missing unique MATRIX_INDEX row for vsi_function_utilization")
    if matches[0].get("path") != MATRIX_PATH:
        raise AssertionError("MATRIX_INDEX row points to wrong path")


def _assert_task_queue() -> None:
    rows = read_csv(TASK_QUEUE_PATH)
    matches = [row for row in rows if row.get("task_id") == TASK_ID]
    if len(matches) != 1:
        raise AssertionError(f"{TASK_QUEUE_PATH} missing unique {TASK_ID}")
    row = matches[0]
    if row.get("status") != "EXECUTED_LOCAL_VALIDATED":
        raise AssertionError(f"{TASK_ID} must be EXECUTED_LOCAL_VALIDATED")
    if row.get("validator") != f"python {VALIDATOR_PATH}|python scripts/validators/vsi_usage_expansion_validator.py":
        raise AssertionError(f"{TASK_ID} validator must declare python validators only")
    executable_fields = "|".join(row.get(field, "") for field in ("allowed_actions", "postcheck", "evidence", "validator"))
    if _contains_forbidden_task_token(executable_fields):
        raise AssertionError(f"{TASK_ID} executable fields reference blocked shell runtime")


def _assert_evidence_logs() -> None:
    for path in (WORKSPACE_EVIDENCE_PATH, SESHAT_EVIDENCE_PATH):
        rows = read_csv(path)
        matches = [row for row in rows if row.get("evidence_id") == EVIDENCE_ID]
        if len(matches) != 1:
            raise AssertionError(f"{path} missing unique {EVIDENCE_ID}")
        row = matches[0]
        if row.get("validator") != VALIDATOR_PATH:
            raise AssertionError(f"{path} {EVIDENCE_ID} validator mismatch")
        if row.get("result") != "EXECUTED_LOCAL_VALIDATED":
            raise AssertionError(f"{path} {EVIDENCE_ID} result mismatch")


def validate() -> None:
    require_files([
        MATRIX_PATH,
        TASKS_PATH,
        SETTINGS_PATH,
        COVERAGE_PATH,
        NO_PS_PREP_PATH,
        MATRIX_INDEX_PATH,
        TASK_QUEUE_PATH,
        WORKSPACE_EVIDENCE_PATH,
        SESHAT_EVIDENCE_PATH,
        MEMORY_WORKPAPER_EXPORT_PATH,
        VALIDATOR_PATH,
    ])
    require_no_materialized_sensitive_values([
        MATRIX_PATH,
        TASKS_PATH,
        SETTINGS_PATH,
        COVERAGE_PATH,
        NO_PS_PREP_PATH,
        MATRIX_INDEX_PATH,
        TASK_QUEUE_PATH,
        WORKSPACE_EVIDENCE_PATH,
        SESHAT_EVIDENCE_PATH,
        MEMORY_WORKPAPER_EXPORT_PATH,
    ])
    rows = read_csv(MATRIX_PATH)
    require_columns(rows, REQUIRED_COLUMNS, MATRIX_PATH)

    ids = {row["function_id"] for row in rows}
    missing = sorted(REQUIRED_FUNCTION_IDS - ids)
    if missing:
        raise AssertionError("missing VSI function rows: " + ", ".join(missing))
    if len(ids) != len(rows):
        raise AssertionError("duplicate function_id in VSI function utilization matrix")

    for index, row in enumerate(rows, start=2):
        function_id = row["function_id"]
        if row["status"] not in ALLOWED_STATUSES:
            raise AssertionError(f"{MATRIX_PATH}:{index} {function_id} unexpected status {row['status']}")
        if row["task_label"] != TASK_LABEL:
            raise AssertionError(f"{MATRIX_PATH}:{index} {function_id} wrong task label")
        if row["validator"] != VALIDATOR_PATH:
            raise AssertionError(f"{MATRIX_PATH}:{index} {function_id} wrong validator")
        if "secret_detected" not in row["stop_condition"]:
            raise AssertionError(f"{MATRIX_PATH}:{index} {function_id} missing secret stop condition")
        for field in ("installed_signal", "active_signal", "current_use", "unused_gap", "next_action", "evidence"):
            if not row[field].strip():
                raise AssertionError(f"{MATRIX_PATH}:{index} {function_id} missing {field}")

    _assert_task_contract()
    _assert_memory_bridge_settings()
    _assert_coverage()
    _assert_no_ps_prep()
    _assert_matrix_index()
    _assert_task_queue()
    _assert_evidence_logs()


if __name__ == "__main__":
    main_guard(NAME, validate)
