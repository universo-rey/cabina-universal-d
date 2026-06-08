from __future__ import annotations

import importlib.util
from pathlib import Path

from sdu_runtime_common import main_guard, require_files


ROOT = Path(__file__).resolve().parents[2]
PIPELINE_PATH = ROOT / "scripts" / "sharepoint" / "sdu_sharepoint_agent_pipeline.py"


def load_pipeline_module():
    spec = importlib.util.spec_from_file_location("sdu_sharepoint_agent_pipeline", PIPELINE_PATH)
    if spec is None or spec.loader is None:
        raise AssertionError("unable to load SDU SharePoint agent pipeline module")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def validate() -> None:
    require_files(
        [
            "scripts/sharepoint/sdu_sharepoint_agent_pipeline.py",
            ".agents/codex/tools/Export-SharePointDocumentInventory.ps1",
            "governance/agents/SDU_AGENT_CAPABILITY_ASSIGNMENT_MATRIX_20260603.csv",
            "02_AUTHORITY_CANON/SDU_CN_CANONICAL_AGENT_PANTHEON_20260604.md",
        ]
    )
    module = load_pipeline_module()
    expected_agents = [
        "seshat-normativa",
        "thot-tecnico",
        "anubis-gate",
        "maat-cumplimiento",
        "horus-riesgo",
    ]
    if module.AGENT_ORDER != expected_agents:
        raise AssertionError(f"unexpected agent order: {module.AGENT_ORDER}")
    if module.NARRATOR_AGENT != "narrador-normativo":
        raise AssertionError("missing narrador-normativo output")
    if module.DATAVERSE_OPERATING_MODEL["queue"]["name"] != "SDU.Agent.Dispatch.Queue":
        raise AssertionError("pipeline must reuse the existing SDU.Agent.Dispatch.Queue")
    if module.DATAVERSE_OPERATING_MODEL["queue"]["processing_active"] is not False:
        raise AssertionError("pipeline must not activate Power Automate queue processing")
    if module.DATAVERSE_OPERATING_MODEL["mode"] != "metadata_only_local_plan":
        raise AssertionError("pipeline must keep non-live Dataverse planning mode")
    expected_tables = {
        "mon_sdu_source_artifact",
        "mon_sdu_evidence",
        "mon_sdu_agent_connection_mapping",
        "mon_sdu_connection_instance",
        "mon_sdu_connection_risk",
        "mon_sdu_validation_gate",
        "mon_sdu_apply_log",
        "mon_sdu_readback",
    }
    observed_tables = set(module.DATAVERSE_OPERATING_MODEL["tables"].values())
    missing_tables = sorted(expected_tables - observed_tables)
    if missing_tables:
        raise AssertionError(f"missing existing Dataverse table mappings: {missing_tables}")
    for agent_id in expected_agents:
        rules = module.AGENT_RULES.get(agent_id)
        if not rules or not rules.get("keywords") or not rules.get("domain"):
            raise AssertionError(f"{agent_id} missing domain rules")
        assignment = module.AGENT_DATAVERSE_ASSIGNMENTS.get(agent_id)
        if not assignment or not assignment.get("read_tables") or not assignment.get("write_plan_tables"):
            raise AssertionError(f"{agent_id} missing Dataverse assignment")
    if module.NARRATOR_AGENT not in module.AGENT_DATAVERSE_ASSIGNMENTS:
        raise AssertionError("narrador-normativo missing Dataverse assignment")
    module.self_test()


if __name__ == "__main__":
    main_guard("SDU_SHAREPOINT_AGENT_PIPELINE_VALIDATOR", validate)
