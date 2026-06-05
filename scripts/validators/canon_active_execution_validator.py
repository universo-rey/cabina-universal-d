#!/usr/bin/env python3
from __future__ import annotations

import argparse
import csv
import re
import shlex
from pathlib import Path


CANONICAL_STATES = {
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
}

EXECUTE_NOW_STATES = {
    "EXECUTE_LOCAL_NOW",
    "EXECUTE_MOCK_NOW",
    "EXECUTE_DEV_NOW",
    "EXECUTE_LIVE_READ_NOW",
    "EXECUTE_LIVE_WRITE_GATED_NOW",
    "EXECUTE_CODEX_CLOUD_SMOKE_NOW",
    "EXECUTE_MCP_READ_PROBE_NOW",
    "EXECUTE_TEAMS_DEV_TEST_NOW",
}

NON_EXECUTE_NOW_PREFIXES = ("PENDING_", "BLOCKED_", "READY_FOR_PROD_")
QUEUE_STATUSES = {
    "QUEUED_ACTIVE_LOCAL",
    "RUNNING_LOCAL",
    "VALIDATED_LOCAL",
    "PENDING_OWNER_ONLY",
    "PENDING_TARGET_ONLY",
    "PENDING_SECRET_ONLY",
    "FAILED_STOPPED",
    "CLOSED_VALIDATED",
}
ALLOWED_SECRET_VALUES = {"yes", "no", "conditional"}
REMOTE_WRITE_PATTERNS = [
    r"\bgit\s+push\b",
    r"\bgh\s+pr\s+create\b",
    r"\bgh\s+pr\s+merge\b",
    r"\bgh\s+release\s+create\b",
    r"\bcodex\s+cloud\s+apply\b",
    r"\baz\s+.*\bcreate\b",
    r"\baz\s+.*\bdelete\b",
    r"\baz\s+.*\bupdate\b",
]
COMMAND_PREFIXES = (
    "python ",
    "python3 ",
    "pwsh ",
    "powershell ",
    "bash ",
    "sh ",
    "node ",
    "npm ",
    "pnpm ",
    "yarn ",
    "git ",
    "gh ",
    "just ",
    "make ",
    "codex ",
    "./",
)
COMMAND_SCRIPT_EXECUTABLES = {"python", "python3", "node", "pwsh", "powershell", "bash", "sh"}
COMMAND_PATH_SUFFIXES = {".py", ".ps1", ".mjs", ".js", ".sh"}
NARRATIVE_COMMAND_FRAGMENTS = (
    " after approval",
    " after target",
    " after exact",
    " after key",
    " after reviewed",
    " execute only ",
    " when provided",
    " cuando ",
    " despues ",
)
ADMIN_BYPASS_STOP_CONDITIONS = {
    "BREAK_GLASS_APPROVAL_MISSING",
    "ADMIN_BYPASS_PRECHECK_MISSING",
    "HEAD_CHANGED",
    "CHECKS_NOT_GREEN",
    "NORMAL_MERGE_AVAILABLE",
    "BYPASS_PERMISSION_NOT_AVAILABLE",
}


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open("r", encoding="utf-8-sig", newline="") as file:
        rows = list(csv.DictReader(file))
    if not rows:
        raise AssertionError(f"empty csv: {path}")
    return rows


def is_remote_write(command: str) -> bool:
    command_lower = command.lower()
    return any(re.search(pattern, command_lower) for pattern in REMOTE_WRITE_PATTERNS)


def is_exact_command(command: str) -> bool:
    return command.strip().startswith(COMMAND_PREFIXES)


def command_parts(command: str, capability_id: str) -> list[str]:
    try:
        return shlex.split(command, posix=False)
    except ValueError as exc:
        raise AssertionError(f"{capability_id}: command is not parseable") from exc


def command_script_path(command: str, capability_id: str) -> str | None:
    parts = command_parts(command, capability_id)
    if not parts:
        raise AssertionError(f"{capability_id}: missing command")
    executable = parts[0].lower()
    if executable not in COMMAND_SCRIPT_EXECUTABLES:
        return None
    for token in parts[1:]:
        candidate = token.strip("'\"")
        if not candidate or candidate.startswith("-"):
            continue
        if Path(candidate).suffix.lower() in COMMAND_PATH_SUFFIXES:
            return candidate
        return None
    raise AssertionError(f"{capability_id}: script command must name a repo-visible script")


def validate_command(command: str, capability_id: str) -> list[str]:
    errors: list[str] = []
    command_lower = command.lower()
    if not is_exact_command(command):
        errors.append(f"{capability_id}: command_or_workflow is not exact executable command")
        return errors
    for fragment in NARRATIVE_COMMAND_FRAGMENTS:
        if fragment in command_lower:
            errors.append(f"{capability_id}: command_or_workflow contains narrative fragment={fragment.strip()}")
    try:
        script_path = command_script_path(command, capability_id)
    except AssertionError as exc:
        errors.append(str(exc))
        return errors
    if script_path and not Path(script_path).exists():
        errors.append(f"{capability_id}: command_or_workflow script does not exist: {script_path}")
    return errors


def has_placeholder(value: str) -> bool:
    return "[" in value and "]" in value


def is_local_placeholder_preflight(command: str) -> bool:
    command_lower = command.replace("\\", "/").lower()
    if is_remote_write(command_lower):
        return False
    return any(
        marker in command_lower
        for marker in [
            "scripts/validators/",
            ".agents/codex/tools/local_validate_",
            "tests/",
            "local-agent-bridge/tests/",
        ]
    )


def validate_queue(queue_path: Path, impact_path: Path | None) -> tuple[list[str], list[str]]:
    errors: list[str] = []
    warnings: list[str] = []
    queue_rows = read_csv(queue_path)
    lane_ids = {row.get("lane_id", "").strip() for row in queue_rows}

    impact_areas: set[str] = set()
    if impact_path and impact_path.exists():
        impact_rows = read_csv(impact_path)
        impact_areas = {row.get("area", "").strip() for row in impact_rows}

    for row in queue_rows:
        lane_id = row.get("lane_id", "").strip()
        active_state = row.get("active_state", "").strip()
        execute_now = row.get("execute_now", "").strip().lower()
        command = row.get("next_command", "").strip()
        dependency = row.get("dependency", "").strip()
        write_scope = row.get("write_scope", "").strip()
        queue_status = row.get("queue_status", row.get("status", "")).strip()
        source_impact_area = row.get("source_impact_area", "").strip()

        if not lane_id:
            errors.append("Queue row without lane_id")
            continue
        if active_state not in CANONICAL_STATES:
            errors.append(f"{lane_id}: invalid active_state={active_state}")
        if execute_now not in {"yes", "no"}:
            errors.append(f"{lane_id}: execute_now must be yes/no")
        if active_state in EXECUTE_NOW_STATES and execute_now != "yes":
            errors.append(f"{lane_id}: {active_state} should have execute_now=yes")
        if active_state.startswith(NON_EXECUTE_NOW_PREFIXES) and execute_now != "no":
            errors.append(f"{lane_id}: {active_state} must have execute_now=no")
        if queue_status and queue_status not in QUEUE_STATUSES:
            warnings.append(f"{lane_id}: unknown queue_status/status={queue_status}")
        if "*" in write_scope:
            errors.append(f"{lane_id}: write_scope must not contain wildcard")
        if dependency and dependency != "none" and dependency not in lane_ids:
            errors.append(f"{lane_id}: dependency points to missing lane_id={dependency}")
        if not command:
            errors.append(f"{lane_id}: missing next_command")
        elif not is_exact_command(command):
            errors.append(f"{lane_id}: next_command is not exact executable command")
        if active_state == "EXECUTE_LOCAL_NOW" and is_remote_write(command):
            errors.append(f"{lane_id}: EXECUTE_LOCAL_NOW cannot include remote write command")
        if impact_areas and source_impact_area:
            for area in source_impact_area.split("|"):
                area = area.strip()
                if area and area not in impact_areas:
                    errors.append(f"{lane_id}: source_impact_area not in impact CSV: {area}")

    return errors, warnings


def validate_capability_matrix(matrix_path: Path) -> tuple[list[str], list[str]]:
    errors: list[str] = []
    warnings: list[str] = []
    rows = read_csv(matrix_path)

    for row in rows:
        capability_id = row.get("capability_id", "").strip()
        active_status = row.get("active_status", "").strip()
        execute_now = row.get("execute_now", "").strip().lower()
        command = row.get("command_or_workflow", "").strip()
        required_secret = row.get("required_secret", "").strip().lower()
        canonical_status = row.get("canonical_status", "").strip()
        cost_boundary = row.get("cost_boundary", "").strip()

        if not capability_id:
            errors.append("Capability row without capability_id")
            continue
        if active_status not in CANONICAL_STATES:
            errors.append(f"{capability_id}: invalid active_status={active_status}")
        if execute_now not in {"yes", "no"}:
            errors.append(f"{capability_id}: execute_now must be yes/no")
        if active_status in EXECUTE_NOW_STATES and execute_now != "yes":
            errors.append(f"{capability_id}: {active_status} should have execute_now=yes")
        if active_status.startswith(NON_EXECUTE_NOW_PREFIXES) and execute_now != "no":
            errors.append(f"{capability_id}: {active_status} must have execute_now=no")
        if required_secret and required_secret not in ALLOWED_SECRET_VALUES:
            errors.append(f"{capability_id}: required_secret must be yes/no/conditional")
        errors.extend(validate_command(command, capability_id))
        if active_status in EXECUTE_NOW_STATES and has_placeholder(cost_boundary):
            errors.append(f"{capability_id}: executable status cannot keep placeholder cost boundary")
        if active_status in EXECUTE_NOW_STATES and row.get("approval_ref", "").strip().startswith("required_"):
            errors.append(f"{capability_id}: executable status cannot keep symbolic approval_ref")
        if active_status in EXECUTE_NOW_STATES and has_placeholder(command) and not is_local_placeholder_preflight(command):
            errors.append(f"{capability_id}: executable status cannot keep operational placeholders in command_or_workflow")
        if active_status in {"EXECUTE_LOCAL_NOW", "EXECUTE_CODEX_CLOUD_SMOKE_NOW"} and is_remote_write(command):
            errors.append(f"{capability_id}: {active_status} cannot include remote write command")
        if capability_id == "codex_cloud.pr":
            errors.append("codex_cloud.pr must be split into local packet and gated PR create")
        if capability_id == "github.lifecycle":
            errors.append("github.lifecycle must be split into local commit remote push and PR create")
        if canonical_status != "ACTIVE_GOVERNED_EXECUTION_BY_DEFAULT":
            warnings.append(f"{capability_id}: canonical_status should be ACTIVE_GOVERNED_EXECUTION_BY_DEFAULT")
        if capability_id == "github.admin_bypass":
            stop_conditions = {part.strip() for part in row.get("stop_condition", "").split("|") if part.strip()}
            missing_admin_conditions = sorted(ADMIN_BYPASS_STOP_CONDITIONS - stop_conditions)
            if missing_admin_conditions:
                errors.append(f"{capability_id}: admin bypass missing stop conditions: {', '.join(missing_admin_conditions)}")
            if active_status != "BLOCKED_SECURITY_RISK":
                errors.append(f"{capability_id}: admin bypass must be BLOCKED_SECURITY_RISK")
            if row.get("execution_mode", "").strip() != "break_glass_only":
                errors.append(f"{capability_id}: admin bypass must use break_glass_only execution_mode")
            if row.get("approval_ref", "").strip() != "required_break_glass_approval":
                errors.append(f"{capability_id}: admin bypass must require break-glass approval")
            if "--admin" not in command or "--match-head-commit" not in command:
                errors.append(f"{capability_id}: admin bypass must require admin and match-head-commit")

    return errors, warnings


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--queue", type=Path)
    parser.add_argument("--impact", type=Path)
    parser.add_argument("--matrix", type=Path, required=True)
    args = parser.parse_args()

    errors: list[str] = []
    warnings: list[str] = []

    matrix_errors, matrix_warnings = validate_capability_matrix(args.matrix)
    errors.extend(matrix_errors)
    warnings.extend(matrix_warnings)

    if args.queue:
        queue_errors, queue_warnings = validate_queue(args.queue, args.impact)
        errors.extend(queue_errors)
        warnings.extend(queue_warnings)

    for message in warnings:
        print(f"WARN: {message}")
    for message in errors:
        print(f"ERROR: {message}")

    if errors:
        print(f"FAILED: {len(errors)} error(s), {len(warnings)} warning(s)")
        return 1

    print(f"PASS: 0 error(s), {len(warnings)} warning(s)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
