import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "09_RUNTIME_SMOKES"))

from tcu_controlled_runtime_harness import (  # noqa: E402
    build_runtime_decision,
    build_cookbook_expansion_manifest,
    run_local_fixture_harness,
    run_cookbook_expansion_harness,
)


def main():
    failures = []

    fixture_path = ROOT / "07_FIXTURES_SANITIZED" / "normalized_runtime_assets.json"
    assets = json.loads(fixture_path.read_text(encoding="utf-8"))

    blocked_asset = next(asset for asset in assets if asset["runtime_lane"] == "BLOCKED_DEPLOYMENT_REFERENCE")
    blocked_decision = build_runtime_decision(blocked_asset)
    if blocked_decision["execution_status"] != "BLOCKED":
        failures.append({"case": "blocked_asset_is_blocked", "got": blocked_decision})
    if "live" not in blocked_decision["blocked_reason"].lower() and "deploy" not in blocked_decision["blocked_reason"].lower():
        failures.append({"case": "blocked_asset_reason_mentions_live_or_deploy", "got": blocked_decision})

    prompt_asset = next(asset for asset in assets if asset["runtime_lane"] == "PROMOTE_PROMPT_PATTERN")
    prompt_decision = build_runtime_decision(prompt_asset)
    if prompt_decision["execution_status"] != "PASS":
        failures.append({"case": "prompt_pattern_passes_local_harness", "got": prompt_decision})
    if prompt_decision["allowed_surface"] != "LOCAL_FIXTURE_ONLY":
        failures.append({"case": "prompt_pattern_is_local_only", "got": prompt_decision})

    harness_result = run_local_fixture_harness(limit=6)
    if harness_result["status"] != "PASS":
        failures.append({"case": "local_harness_status", "got": harness_result})
    if harness_result["assets_checked"] != 6:
        failures.append({"case": "local_harness_limit", "got": harness_result})
    if harness_result["data_policy"] != "SYNTHETIC_OR_METADATA_ONLY":
        failures.append({"case": "local_harness_data_policy", "got": harness_result})

    expansion_manifest = build_cookbook_expansion_manifest()
    required_patterns = {
        "structured_outputs",
        "function_tools",
        "evals",
        "tracing_summary",
        "agent_as_tool_handoff",
        "guardrail_failure",
        "session_stub",
        "sandbox_manifest",
        "sharepoint_ready_write_artifact",
    }
    got_patterns = set(expansion_manifest.get("patterns") or [])
    missing_patterns = required_patterns - got_patterns
    if missing_patterns:
        failures.append({"case": "cookbook_expansion_patterns", "missing": sorted(missing_patterns)})
    if expansion_manifest.get("data_policy") != "SYNTHETIC_OR_METADATA_ONLY":
        failures.append({"case": "cookbook_expansion_data_policy", "got": expansion_manifest})

    expansion_result = run_cookbook_expansion_harness()
    if expansion_result["status"] != "PASS":
        failures.append({"case": "cookbook_expansion_status", "got": expansion_result})
    if expansion_result["guardrail_failure"]["status"] != "BLOCKED":
        failures.append({"case": "guardrail_failure_blocks", "got": expansion_result["guardrail_failure"]})
    if expansion_result["session_stub"]["persistence"] != "IN_MEMORY_ONLY":
        failures.append({"case": "session_stub_is_in_memory_only", "got": expansion_result["session_stub"]})
    if expansion_result["tracing_summary"]["external_upload"] != "BLOCKED":
        failures.append({"case": "tracing_summary_external_upload_blocked", "got": expansion_result["tracing_summary"]})
    sp_artifact = expansion_manifest["sharepoint_ready_artifact"]
    if sp_artifact["site_label"] != "Auditoria Integrada":
        failures.append({"case": "sharepoint_artifact_site_label", "got": sp_artifact})
    if sp_artifact["sharepoint_write"] != "NOT_EXECUTED":
        failures.append({"case": "sharepoint_write_not_executed", "got": sp_artifact})

    out_dir = ROOT / "04_EVALS" / "results"
    out_dir.mkdir(parents=True, exist_ok=True)
    (out_dir / "controlled_runtime_harness_latest.json").write_text(
        json.dumps({"local_harness": harness_result, "failures": failures}, indent=2),
        encoding="utf-8",
    )
    print(json.dumps({"cases": 15, "failures": len(failures)}, indent=2))
    if failures:
        sys.exit(1)


if __name__ == "__main__":
    main()
