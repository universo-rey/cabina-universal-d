from __future__ import annotations

import argparse
from pathlib import Path

from sdu_runtime_common import main_guard, read_text, require_files


NAME = "AGILE_CANVAS_IDENTITY_DRIFT_VALIDATOR"

ACTIVE_CANVAS_FILES = [
    ".agileagentcanvas-context/vision.json",
    ".agileagentcanvas-context/discovery/product-brief.json",
    ".agileagentcanvas-context/planning/prd.json",
    ".agileagentcanvas-context/planning/epics.json",
    ".agileagentcanvas-context/bmm/sprint-status.json",
    ".agileagentcanvas-context/bmm/source-tree.json",
    ".agileagentcanvas-context/bmm/risks.json",
    ".agileagentcanvas-context/bmm/retrospective.json",
    ".agileagentcanvas-context/bmm/readiness-report.json",
]

FORBIDDEN_DRIFT_TOKENS = [
    "TaskFlow Pro",
    '"NOKEY"',
    "Dr. Aisha Patel",
    "Sarah Chen",
    "Marcus Rodriguez",
    "BMAD",
]

REQUIRED_IDENTITY = "Cabina Universal Agent Control"


def discover_all_canvas_json() -> list[str]:
    root = Path(".agileagentcanvas-context")
    return [str(path).replace("\\", "/") for path in root.rglob("*.json")]


def validate_file(path: str, *, require_identity: bool) -> None:
    text = read_text(path)
    for token in FORBIDDEN_DRIFT_TOKENS:
        if token in text:
            raise AssertionError(f"{path} contains forbidden Agile Canvas drift token: {token}")
    if require_identity and REQUIRED_IDENTITY not in text:
        raise AssertionError(f"{path} missing required identity: {REQUIRED_IDENTITY}")


def validate() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--all",
        action="store_true",
        help="Deprecated compatibility flag; all Agile Agent Canvas JSON files are scanned by default.",
    )
    parser.add_argument(
        "--active-only",
        action="store_true",
        help="Scan only the active reconciled set.",
    )
    args = parser.parse_args()

    paths = ACTIVE_CANVAS_FILES if args.active_only else discover_all_canvas_json()
    require_files(paths)
    identity_required = set(ACTIVE_CANVAS_FILES)
    for path in paths:
        validate_file(path, require_identity=path in identity_required)


if __name__ == "__main__":
    main_guard(NAME, validate)
