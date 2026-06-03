#!/usr/bin/env python3
"""Detect local Dataverse registry drift without contacting Dataverse."""

from __future__ import annotations

import csv
import hashlib
import json
from pathlib import Path
import sys


ROOT = Path(__file__).resolve().parents[2]
SCHEMA_DIR = ROOT / "dataverse" / "schema"
INVENTORY = ROOT / "matrices" / "dataverse" / "MATRIX_INVENTORY.csv"
SEED = ROOT / "dataverse" / "data" / "seed_matrices.csv"
OUT = ROOT / "dataverse" / "validation" / "dataverse_drift_latest.json"


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(newline="", encoding="utf-8-sig") as handle:
        return list(csv.DictReader(handle))


def main() -> int:
    findings: list[dict[str, str]] = []
    schema_files = sorted(SCHEMA_DIR.glob("*.yml"))
    if len([p for p in schema_files if p.name.startswith("sdu_")]) < 15:
        findings.append({"severity": "block", "rule": "DRIFT_001", "message": "schema table count below V1 minimum"})

    for path in schema_files:
        text = path.read_text(encoding="utf-8")
        for needle in ("logical_name:", "change_tracking: true", "auditing: true", "policy:"):
            if needle not in text:
                findings.append({"severity": "block", "rule": "DRIFT_001", "message": f"{path.name} missing {needle}"})

    inventory = read_csv(INVENTORY)
    seed = read_csv(SEED)
    inventory_by_id = {row["matrix_id"]: row for row in inventory}
    for row in seed:
        source_id = row["canonical_id"]
        source = inventory_by_id.get(source_id)
        if not source:
            findings.append({"severity": "warn", "rule": "DRIFT_002", "message": f"seed without inventory source {source_id}"})
            continue
        source_path = ROOT / source["source_path"]
        if source_path.exists() and row.get("sha256") and sha256(source_path) != row["sha256"]:
            findings.append({"severity": "warn", "rule": "DRIFT_002", "message": f"hash changed for {source_id}"})

    result = {
        "drift_clear": not any(item["severity"] == "block" for item in findings),
        "findings": findings,
    }
    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text(json.dumps(result, indent=2), encoding="utf-8")
    print("DATAVERSE_DRIFT_CLEAR" if result["drift_clear"] else "DATAVERSE_DRIFT_BLOCKED")
    return 0 if result["drift_clear"] else 10


if __name__ == "__main__":
    sys.exit(main())
