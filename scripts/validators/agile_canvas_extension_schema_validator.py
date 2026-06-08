from __future__ import annotations

import json
import warnings
from pathlib import Path

warnings.filterwarnings("ignore", category=DeprecationWarning)

from jsonschema import Draft7Validator, RefResolver
from jsonschema.exceptions import RefResolutionError

from sdu_runtime_common import main_guard


NAME = "AGILE_CANVAS_EXTENSION_SCHEMA_VALIDATOR"

CONTEXT_ROOT = Path(".agileagentcanvas-context")
EXTENSION_ROOT = (
    Path.home()
    / ".vscode-insiders"
    / "extensions"
    / "msayedshokry.agileagentcanvas-0.5.2"
    / "resources"
    / "_aac"
    / "schemas"
)

EXPECTED_NO_SCHEMA = {
    "testing/test-strategy.json",
    "vision.json",
}

EXPECTED_SCHEMA_REF_FAIL = {
    "testing/atdd-checklist.json",
    "testing/test-design.json",
    "testing/traceability-matrix.json",
}


def load_json(path: Path) -> dict:
    with path.open(encoding="utf-8") as handle:
        return json.load(handle)


def artifact_candidates(relative_path: str, stem: str) -> list[tuple[str, str]]:
    first = relative_path.split("/")[0]
    if first in {"bmm", "planning", "discovery", "solutioning"}:
        return [("bmm", stem)]
    if first == "cis":
        return [("cis", stem)]
    if first == "testing":
        return [("tea", stem)]
    return [("bmm", stem), ("cis", stem), ("tea", stem)]


def build_schema_index() -> tuple[dict[tuple[str, str], tuple[Path, dict]], dict[str, dict]]:
    if not EXTENSION_ROOT.exists():
        raise AssertionError(f"Agile Agent Canvas schema root not found: {EXTENSION_ROOT}")

    by_key: dict[tuple[str, str], tuple[Path, dict]] = {}
    store: dict[str, dict] = {}
    for path in EXTENSION_ROOT.rglob("*.schema.json"):
        schema = load_json(path)
        key = path.name.replace(".schema.json", "")
        by_key[(path.parent.name, key)] = (path, schema)
        store[path.resolve().as_uri()] = schema
        if "$id" in schema:
            store[schema["$id"]] = schema
    return by_key, store


def validate() -> None:
    schema_by_key, store = build_schema_index()
    rows: list[dict] = []

    for artifact in sorted(CONTEXT_ROOT.rglob("*.json")):
        relative_path = artifact.relative_to(CONTEXT_ROOT).as_posix()
        chosen: tuple[Path, dict] | None = None
        for candidate in artifact_candidates(relative_path, artifact.stem):
            if candidate in schema_by_key:
                chosen = schema_by_key[candidate]
                break

        if chosen is None:
            rows.append({"artifact": relative_path, "status": "NO_SCHEMA", "error_count": 0})
            continue

        schema_path, schema = chosen
        data = load_json(artifact)
        try:
            resolver = RefResolver(base_uri=schema_path.resolve().as_uri(), referrer=schema, store=store)
            validator = Draft7Validator(schema, resolver=resolver)
            errors = sorted(validator.iter_errors(data), key=lambda error: list(error.path))
        except RefResolutionError as exc:
            rows.append(
                {
                    "artifact": relative_path,
                    "status": "SCHEMA_REF_FAIL",
                    "schema": schema_path.relative_to(EXTENSION_ROOT).as_posix(),
                    "error_count": 1,
                    "message": str(exc),
                }
            )
            continue

        rows.append(
            {
                "artifact": relative_path,
                "status": "PASS" if not errors else "FAIL",
                "schema": schema_path.relative_to(EXTENSION_ROOT).as_posix(),
                "error_count": len(errors),
                "messages": [error.message for error in errors[:5]],
            }
        )

    summary: dict[str, int] = {}
    for row in rows:
        summary[row["status"]] = summary.get(row["status"], 0) + 1

    unexpected_no_schema = sorted(
        row["artifact"] for row in rows if row["status"] == "NO_SCHEMA" and row["artifact"] not in EXPECTED_NO_SCHEMA
    )
    unexpected_ref_fail = sorted(
        row["artifact"]
        for row in rows
        if row["status"] == "SCHEMA_REF_FAIL" and row["artifact"] not in EXPECTED_SCHEMA_REF_FAIL
    )
    content_failures = [row for row in rows if row["status"] == "FAIL"]

    print(
        json.dumps(
            {
                "status": "PASS"
                if not content_failures and not unexpected_no_schema and not unexpected_ref_fail
                else "FAIL",
                "schema_root": str(EXTENSION_ROOT),
                "summary": summary,
                "expected_no_schema": sorted(EXPECTED_NO_SCHEMA),
                "expected_schema_ref_fail": sorted(EXPECTED_SCHEMA_REF_FAIL),
                "content_failures": content_failures,
                "unexpected_no_schema": unexpected_no_schema,
                "unexpected_schema_ref_fail": unexpected_ref_fail,
            },
            indent=2,
        )
    )

    if content_failures:
        raise AssertionError(f"Agile Canvas artifacts failing extension schemas: {len(content_failures)}")
    if unexpected_no_schema:
        raise AssertionError(f"Unexpected Agile Canvas artifacts without extension schema: {unexpected_no_schema}")
    if unexpected_ref_fail:
        raise AssertionError(f"Unexpected Agile Canvas schema ref failures: {unexpected_ref_fail}")


if __name__ == "__main__":
    main_guard(NAME, validate)
