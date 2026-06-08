from __future__ import annotations

from sdu_runtime_common import main_guard, read_json, require_files


NAME = "AGILE_CANVAS_TASK_OPS_VALIDATOR"

EPICS_PATH = ".agileagentcanvas-context/planning/epics.json"
PRD_PATH = ".agileagentcanvas-context/planning/prd.json"
SPRINT_STATUS_PATH = ".agileagentcanvas-context/bmm/sprint-status.json"

TASK_OP_STORIES = [f"S-5.{index}" for index in range(1, 8)]
REQUIRED_STORY_FIELDS = ["id", "title", "description", "acceptanceCriteria", "governance", "executionEvidence"]
REQUIRED_GOVERNANCE_FIELDS = [
    "lane",
    "ownerAgent",
    "reviewerAgent",
    "lockKey",
    "allowedActions",
    "blockedActions",
    "rollback",
    "postcheck",
    "stopCondition",
]


def flatten_stories(epics: dict) -> list[dict]:
    stories: list[dict] = []
    for epic in epics.get("content", {}).get("epics", []):
        stories.extend(epic.get("stories", []))
    return stories


def validate() -> None:
    require_files([EPICS_PATH, PRD_PATH, SPRINT_STATUS_PATH])
    epics = read_json(EPICS_PATH)
    prd = read_json(PRD_PATH)
    sprint_status = read_json(SPRINT_STATUS_PATH)

    stories = flatten_stories(epics)
    story_ids = [story.get("id") for story in stories]
    duplicate_ids = sorted({story_id for story_id in story_ids if story_ids.count(story_id) > 1})
    if duplicate_ids:
        raise AssertionError(f"duplicate Agile Canvas story ids: {duplicate_ids}")

    stories_by_id = {story["id"]: story for story in stories if story.get("id")}
    missing_task_ops = [story_id for story_id in TASK_OP_STORIES if story_id not in stories_by_id]
    if missing_task_ops:
        raise AssertionError(f"missing task operation stories: {missing_task_ops}")

    for story_id in TASK_OP_STORIES:
        story = stories_by_id[story_id]
        if story.get("status") != "hecho":
            raise AssertionError(f"{story_id} must be hecho")
        missing_fields = [field for field in REQUIRED_STORY_FIELDS if not story.get(field)]
        if missing_fields:
            raise AssertionError(f"{story_id} missing required fields: {missing_fields}")
        if not story.get("acceptanceCriteria"):
            raise AssertionError(f"{story_id} must declare acceptance criteria")
        governance = story["governance"]
        missing_governance = [field for field in REQUIRED_GOVERNANCE_FIELDS if not governance.get(field)]
        if missing_governance:
            raise AssertionError(f"{story_id} missing governance fields: {missing_governance}")
        if governance.get("liveExecuted") is not False or governance.get("externalSync") is not False:
            raise AssertionError(f"{story_id} must remain local and no-live")
        blocked = set(governance.get("blockedActions", []))
        for blocked_action in ("openai_api_live", "microsoft_live_write", "production", "secret_materialization"):
            if blocked_action not in blocked:
                raise AssertionError(f"{story_id} missing blocked action {blocked_action}")
        evidence = story["executionEvidence"]
        if evidence.get("status") != "EXECUTED_LOCAL_VALIDATED":
            raise AssertionError(f"{story_id} execution evidence must be EXECUTED_LOCAL_VALIDATED")

    epic_status = {
        epic.get("id"): epic.get("status")
        for epic in epics.get("content", {}).get("epics", [])
    }
    for epic_id in ("EPIC-1", "EPIC-2", "EPIC-3", "EPIC-5"):
        if epic_status.get(epic_id) != "hecho":
            raise AssertionError(f"{epic_id} must be reconciled to hecho")

    task_operations = epics.get("metadata", {}).get("customFields", {}).get("taskOperations")
    if not task_operations or task_operations.get("mode") != "EXECUTED_LOCAL_VALIDATED":
        raise AssertionError("epics taskOperations must be EXECUTED_LOCAL_VALIDATED")
    if task_operations.get("liveExecuted") is True or task_operations.get("externalSync") is True:
        raise AssertionError("epics taskOperations must not execute live or external sync")

    prd_task_ops = prd.get("content", {}).get("taskOperations", {})
    if prd_task_ops.get("mode") != "EXECUTED_LOCAL_VALIDATED":
        raise AssertionError("prd taskOperations must be EXECUTED_LOCAL_VALIDATED")
    active_lane = prd.get("metadata", {}).get("customFields", {}).get("activeGovernedLane", {})
    validators = set(active_lane.get("validators", []))
    if "python scripts/validators/agile_canvas_task_ops_validator.py" not in validators:
        raise AssertionError("active governed lane must include task ops validator")

    development_status = sprint_status.get("development_status", {})
    for story_id in TASK_OP_STORIES:
        if development_status.get(story_id) != "done":
            raise AssertionError(f"sprint status must mark {story_id} done")
    active_sprint = sprint_status.get("sprints", {}).get("sprint_2026_06_08_canvas_reconciliation", {})
    if active_sprint.get("status") != "EXECUTED_LOCAL_VALIDATED":
        raise AssertionError("active sprint must be EXECUTED_LOCAL_VALIDATED")
    if active_sprint.get("safe_next_story") != "none":
        raise AssertionError("active sprint must have no remaining safe next story")
    if sprint_status.get("live_executed") is not False or sprint_status.get("external_sync") is not False:
        raise AssertionError("sprint status must remain no-live and no external sync")


if __name__ == "__main__":
    main_guard(NAME, validate)
