from __future__ import annotations

import csv
from pathlib import Path

from sdu_runtime_common import main_guard, require_files


ROOT = Path(__file__).resolve().parents[2]
CSV_PATH = ROOT / "dataverse" / "data" / "seed_sdu_agent_runtime_actions.csv"
SCRIPT_PATH = ROOT / "dataverse" / "scripts" / "invoke_sdu_agent_runtime_actions_registry_dev.ps1"

EXPECTED_AGENTS = {
    "seshat-normativa",
    "thot-tecnico",
    "anubis-gate",
    "maat-cumplimiento",
    "horus-riesgo",
    "cre3c-reconciliar-shell",
    "narrador-normativo",
}

REQUIRED_COLUMNS = {
    "canonical_id",
    "agent_id",
    "display_name",
    "domain",
    "owner_agent",
    "reviewer_agent",
    "allowed_actions",
    "gated_actions",
    "blocked_actions",
    "surfaces",
    "queue_modes",
    "dataverse_tables",
    "risk_level",
    "status",
    "stop_condition",
}


def split_pipe(value: str) -> list[str]:
    return [item for item in value.split("|") if item]


def validate() -> None:
    require_files(
        [
            "dataverse/data/seed_sdu_agent_runtime_actions.csv",
            "dataverse/scripts/invoke_sdu_agent_runtime_actions_registry_dev.ps1",
            "matrices/dataverse/DATAVERSE_APPLIED_TABLE_MODEL_DEV.csv",
            "02_AUTHORITY_CANON/SDU_CN_CANONICAL_AGENT_PANTHEON_20260604.md",
        ]
    )
    rows = list(csv.DictReader(CSV_PATH.read_text(encoding="utf-8-sig").splitlines()))
    if len(rows) != 7:
        raise AssertionError(f"expected 7 SDU canonical agents, found {len(rows)}")
    columns = set(rows[0])
    missing_columns = sorted(REQUIRED_COLUMNS - columns)
    if missing_columns:
        raise AssertionError(f"missing columns: {missing_columns}")

    observed_agents = {row["agent_id"] for row in rows}
    if observed_agents != EXPECTED_AGENTS:
        raise AssertionError(f"unexpected agents: {sorted(observed_agents)}")

    canonical_ids = [row["canonical_id"] for row in rows]
    if len(canonical_ids) != len(set(canonical_ids)):
        raise AssertionError("canonical ids must be unique")

    for row in rows:
        agent_id = row["agent_id"]
        if not row["canonical_id"].startswith("sdu.agent."):
            raise AssertionError(f"{agent_id} canonical id must use sdu.agent prefix")
        allowed = split_pipe(row["allowed_actions"])
        gated = split_pipe(row["gated_actions"])
        blocked = split_pipe(row["blocked_actions"])
        tables = split_pipe(row["dataverse_tables"])
        if not allowed:
            raise AssertionError(f"{agent_id} must have allowed actions")
        if "dataverse_apply" not in gated:
            raise AssertionError(f"{agent_id} must gate dataverse_apply")
        if "production" not in blocked or "secret_materialization" not in blocked:
            raise AssertionError(f"{agent_id} must block production and secret materialization")
        if "mon_sdu_agent_connection_mapping" not in tables:
            raise AssertionError(f"{agent_id} must register through mon_sdu_agent_connection_mapping")
        if "workqueueitems" not in tables:
            raise AssertionError(f"{agent_id} must include workqueueitems")
        if row["status"] != "ACTIVE_DEV":
            raise AssertionError(f"{agent_id} must be ACTIVE_DEV")

    script = SCRIPT_PATH.read_text(encoding="utf-8")
    required_script_terms = [
        "GATE_DATAVERSE_APPLY",
        "mon_sdu_agent_connection_mapping",
        "mon_sdu_agent_connection_mappings",
        "mon_canonical_id",
        "mon_owner_agent",
        "mon_reviewer_agent",
        "mon_surfaces",
        "mon_notes",
        "candidate_count_not_one",
        "postcheck_source_hash_mismatch",
        "ROLLBACK_SUPERSEDED",
        "ROLLBACK_REQUIRES_APPLY",
        "rollback_candidate_count_not_one",
        "rollback_postcheck_status_mismatch",
        "sdu_agent_runtime_actions_registry_rollback_marker",
    ]
    for term in required_script_terms:
        if term not in script:
            raise AssertionError(f"registry script missing {term}")
    if "sdu_agent" in script and "mon_sdu_agent_connection_mapping" not in script:
        raise AssertionError("script must not use unapplied sdu_agent table")


if __name__ == "__main__":
    main_guard("SDU_AGENT_RUNTIME_ACTIONS_REGISTRY_VALIDATOR", validate)
