from __future__ import annotations

from pathlib import Path

from sdu_runtime_common import (
    main_guard,
    read_csv,
    read_text,
    rel,
    require_columns,
    require_files,
)


NAME = "AGILE_CANVAS_DEMO_QUARANTINE_VALIDATOR"

MATRIX_PATH = ".agents/codex/matrices/AAC_DEMO_QUARANTINE_MATRIX_20260608.csv"
SCAN_ROOTS = [
    ".agileagentcanvas-context/bmm",
    ".agileagentcanvas-context/cis",
    ".agileagentcanvas-context/solutioning",
    ".agileagentcanvas-context/testing",
]
DEMO_PATTERNS = {
    "Task CRUD": ["task crud"],
    "Focus Mode": ["focus mode"],
    "TaskFlow": ["taskflow"],
    "SOC 2": ["soc 2"],
    "10000": ["10,000", "10000"],
    "TEA Agent": ["tea agent"],
    "Sprint 12": ["sprint 12"],
    "WebSocket": ["websocket"],
    "SaaS": ["saas"],
}
REQUIRED_COLUMNS = [
    "artifact_path",
    "classification",
    "quarantine_status",
    "quarantine_scope",
    "detected_patterns",
    "allowed_use",
    "blocked_use",
    "owner_agent",
    "reviewer_agent",
    "validator",
    "evidence",
    "status",
    "live_executed",
    "external_sync",
    "stop_condition",
]
ALLOWED_CLASSIFICATIONS = {"demo_quarantine", "drift_reference"}
ALLOWED_QUARANTINE_STATUSES = {"DEMO_QUARANTINE", "DRIFT_REFERENCE_CONTROLLED"}


def normalize(path: Path) -> str:
    return str(path.relative_to(rel("."))).replace("\\", "/")


def patterns_in_text(text: str) -> set[str]:
    lower_text = text.lower()
    found: set[str] = set()
    for canonical, needles in DEMO_PATTERNS.items():
        if any(needle in lower_text for needle in needles):
            found.add(canonical)
    return found


def validate_matrix_rows(rows: list[dict[str, str]]) -> set[str]:
    covered_paths: set[str] = set()
    for index, row in enumerate(rows, start=2):
        artifact_path = row["artifact_path"]
        require_files([artifact_path])
        covered_paths.add(artifact_path)
        if row["classification"] not in ALLOWED_CLASSIFICATIONS:
            raise AssertionError(f"{MATRIX_PATH}:{index} invalid classification")
        if row["quarantine_status"] not in ALLOWED_QUARANTINE_STATUSES:
            raise AssertionError(f"{MATRIX_PATH}:{index} invalid quarantine_status")
        if row["status"] != "CONTROLLED":
            raise AssertionError(f"{MATRIX_PATH}:{index} status must be CONTROLLED")
        if row["live_executed"] != "false" or row["external_sync"] != "false":
            raise AssertionError(f"{MATRIX_PATH}:{index} must stay no-live/no-external-sync")
        if row["validator"] != "scripts/validators/agile_canvas_demo_quarantine_validator.py":
            raise AssertionError(f"{MATRIX_PATH}:{index} validator mismatch")
        if row["allowed_use"] != "read_only_drift_evidence":
            raise AssertionError(f"{MATRIX_PATH}:{index} allowed_use must be read_only_drift_evidence")
        if "active_canvas_context" not in row["blocked_use"]:
            raise AssertionError(f"{MATRIX_PATH}:{index} blocked_use must block active canvas context")
        declared = {item.strip() for item in row["detected_patterns"].split("|") if item.strip()}
        actual = patterns_in_text(read_text(artifact_path))
        missing = declared - actual
        if missing:
            raise AssertionError(f"{artifact_path} missing declared demo patterns: {sorted(missing)}")
    return covered_paths


def validate_scan_coverage(covered_paths: set[str]) -> None:
    uncovered: list[str] = []
    for root in SCAN_ROOTS:
        for path in rel(root).rglob("*.json"):
            relative = normalize(path)
            if patterns_in_text(read_text(relative)) and relative not in covered_paths:
                uncovered.append(relative)
    if uncovered:
        raise AssertionError("demo drift files not covered by quarantine matrix: " + ", ".join(sorted(uncovered)))


def validate() -> None:
    rows = read_csv(MATRIX_PATH)
    require_columns(rows, REQUIRED_COLUMNS, MATRIX_PATH)
    covered_paths = validate_matrix_rows(rows)
    validate_scan_coverage(covered_paths)


if __name__ == "__main__":
    main_guard(NAME, validate)
