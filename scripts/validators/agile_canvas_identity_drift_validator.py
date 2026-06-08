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

FORBIDDEN_ACTIVE_TOKENS = [
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


def validate_file(path: str) -> None:
    text = read_text(path)
    for token in FORBIDDEN_ACTIVE_TOKENS:
        if token in text:
            raise AssertionError(f"{path} contains forbidden active canvas drift token: {token}")
    if REQUIRED_IDENTITY not in text:
        raise AssertionError(f"{path} missing required identity: {REQUIRED_IDENTITY}")


def validate() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--all",
        action="store_true",
        help="Scan every Agile Agent Canvas JSON file instead of the active reconciled set.",
    )
    args = parser.parse_args()

    paths = discover_all_canvas_json() if args.all else ACTIVE_CANVAS_FILES
    require_files(paths)
    for path in paths:
        validate_file(path)


if __name__ == "__main__":
    main_guard(NAME, validate)
