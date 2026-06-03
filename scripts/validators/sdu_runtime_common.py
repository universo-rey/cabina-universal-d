from __future__ import annotations

import csv
import json
import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]


def rel(path: str) -> Path:
    return ROOT / path


def read_csv(path: str) -> list[dict[str, str]]:
    target = rel(path)
    if not target.exists():
        raise AssertionError(f"missing csv: {path}")
    with target.open("r", encoding="utf-8-sig", newline="") as handle:
        rows = list(csv.DictReader(handle))
    if not rows:
        raise AssertionError(f"empty csv: {path}")
    return rows


def read_json(path: str) -> object:
    target = rel(path)
    if not target.exists():
        raise AssertionError(f"missing json: {path}")
    with target.open("r", encoding="utf-8") as handle:
        return json.load(handle)


def read_text(path: str) -> str:
    target = rel(path)
    if not target.exists():
        raise AssertionError(f"missing file: {path}")
    return target.read_text(encoding="utf-8")


def require_files(paths: list[str]) -> None:
    missing = [path for path in paths if not rel(path).exists()]
    if missing:
        raise AssertionError("missing files: " + ", ".join(missing))


def require_columns(rows: list[dict[str, str]], columns: list[str], path: str) -> None:
    actual = set(rows[0].keys())
    missing = [column for column in columns if column not in actual]
    if missing:
        raise AssertionError(f"{path} missing columns: {', '.join(missing)}")


def require_no_live(rows: list[dict[str, str]], path: str) -> None:
    for index, row in enumerate(rows, start=2):
        combined = "|".join(str(value).lower() for value in row.values())
        if "live_executed=true" in combined or "production_mutation" in combined:
            raise AssertionError(f"{path}:{index} suggests live execution")


def require_statuses(rows: list[dict[str, str]], allowed: set[str], path: str) -> None:
    for index, row in enumerate(rows, start=2):
        status = row.get("status", "")
        if status not in allowed:
            raise AssertionError(f"{path}:{index} unexpected status {status!r}")


def require_no_materialized_sensitive_values(paths: list[str]) -> None:
    risky_patterns = [
        re.compile(r"(?i)(client[_-]?secret|password|" + "author" + r"ization:|bearer\s+)"),
        re.compile(r"(?i)(api[_-]?key|token)\s*[:=]\s*['\"]?[A-Za-z0-9_\-]{12,}"),
        re.compile(r"sk-[A-Za-z0-9]{20,}"),
    ]
    for path in paths:
        text = read_text(path)
        for pattern in risky_patterns:
            if pattern.search(text):
                raise AssertionError(f"materialized sensitive-looking value in {path}")


def pass_message(name: str) -> None:
    print(f"{name}=PASS")


def main_guard(name: str, fn) -> None:
    try:
        fn()
    except Exception as exc:  # noqa: BLE001
        print(f"{name}=FAIL: {exc}", file=sys.stderr)
        raise SystemExit(1) from exc
    pass_message(name)
