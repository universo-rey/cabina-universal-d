from __future__ import annotations

import csv

from sdu_runtime_common import main_guard, read_csv, read_text, rel


NAME = "NO_PASSIVE_BLOCKING_LANGUAGE_VALIDATOR"

MATRIX = "governance/canon/ACTIVE_EXECUTION_CAPABILITY_MATRIX_20260603.csv"
DOCS = [
    "governance/canon/ACTIVE_GOVERNED_EXECUTION_BY_DEFAULT_POLICY_20260603.md",
    "governance/canon/CANON_CONSERVATIVE_LANGUAGE_AUDIT_20260603.md",
    "governance/teams/TEAMS_ACTIVE_DEV_EXECUTION_POLICY_20260603.md",
    "governance/connections/MCP_ACTIVE_EXECUTION_POLICY_20260603.md",
    "governance/codex-cloud/CODEX_CLOUD_ACTIVE_EXECUTION_POLICY_20260603.md",
    "readbacks/20260603_ACTIVE_EXECUTION_DEV_ATTEMPT_READBACK.md",
    "readbacks/20260603_CANON_ACTIVE_GOVERNED_EXECUTION_BY_DEFAULT_READBACK.md",
]

PASSIVE_EXACT = {"disabled", "blocked", "not executed", "prepared", "pending"}
ALLOWED_CONTEXT_FRAGMENTS = [
    "sin causa exacta",
    "OVER_CONSERVATIVE",
    "HISTORICAL_EVIDENCE",
    "VALID_HARD_STOP",
    "PENDING_",
    "BLOCKED_",
    "not executed`",
    "`prepared`",
    "`pending`",
    "`blocked`",
    "`disabled`",
    "historical_evidence",
    "valid_hard_stop",
    "over_conservative",
]


def validate_matrix() -> None:
    rows = read_csv(MATRIX)
    for index, row in enumerate(rows, start=2):
        for field in ["current_status", "active_status", "canonical_status"]:
            value = row.get(field, "").strip().lower()
            if value in PASSIVE_EXACT:
                raise AssertionError(f"{MATRIX}:{index} uses passive exact state in {field}")
        if row.get("execute_now", "").strip().lower() == "yes" and not row.get("command_or_workflow", "").strip():
            raise AssertionError(f"{MATRIX}:{index} executable row lacks command_or_workflow")


def validate_docs() -> None:
    for path in DOCS:
        text = read_text(path)
        for line_number, line in enumerate(text.splitlines(), start=1):
            lowered = line.strip().lower()
            if not lowered:
                continue
            for token in PASSIVE_EXACT:
                if lowered == f"estado: {token}" or lowered == f"status: {token}":
                    raise AssertionError(f"{path}:{line_number} passive bare state {token!r}")
            if any(token in lowered for token in ["not executed", "prepared", "disabled", "blocked", "pending"]):
                if not any(fragment.lower() in lowered for fragment in ALLOWED_CONTEXT_FRAGMENTS):
                    raise AssertionError(f"{path}:{line_number} passive wording lacks active context")


def validate_csv_headers() -> None:
    for path in [
        ".agents/codex/matrices/AGENT_TOOL_RECIPE_SKILL_MATRIX.csv",
        ".agents/codex/matrices/PURPOSE_SURFACE_CAPABILITY_MATRIX.csv",
        ".agents/codex/matrices/GITHUB_ACTIONS_WORKFLOW_MATRIX.csv",
    ]:
        with rel(path).open("r", encoding="utf-8-sig", newline="") as handle:
            rows = list(csv.reader(handle))
        if not rows:
            raise AssertionError(f"{path} is empty")


def validate() -> None:
    validate_matrix()
    validate_docs()
    validate_csv_headers()


if __name__ == "__main__":
    main_guard(NAME, validate)
