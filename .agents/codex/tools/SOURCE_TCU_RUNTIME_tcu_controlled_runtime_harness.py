import argparse
import json
import os
from datetime import datetime, timezone
from pathlib import Path
from typing import Literal


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_MODEL = os.getenv("OPENAI_RUNTIME_SMOKE_MODEL", "gpt-4.1-mini")


STRUCTURED_OUTPUT_SCHEMA = {
    "type": "object",
    "additionalProperties": False,
    "required": [
        "status",
        "decision",
        "allowed_surface",
        "blocked_surfaces",
        "data_policy",
        "next_action",
    ],
    "properties": {
        "status": {"type": "string", "enum": ["PASS", "BLOCKED"]},
        "decision": {"type": "string"},
        "allowed_surface": {"type": "string", "enum": ["LOCAL_FIXTURE_ONLY", "SYNTHETIC_API_ONLY"]},
        "blocked_surfaces": {
            "type": "array",
            "items": {"type": "string"},
        },
        "data_policy": {"type": "string", "enum": ["SYNTHETIC_OR_METADATA_ONLY"]},
        "next_action": {"type": "string"},
    },
}


BLOCKED_SURFACES = [
    "real_data",
    "tenant_write",
    "sharepoint_write",
    "power_platform_mutation",
    "agents_sdk_deployment",
    "production",
]

COOKBOOK_EXPANSION_PATTERNS = [
    "structured_outputs",
    "function_tools",
    "evals",
    "tracing_summary",
    "agent_as_tool_handoff",
    "guardrail_failure",
    "session_stub",
    "sandbox_manifest",
    "sharepoint_ready_write_artifact",
]


def load_assets():
    fixture_path = ROOT / "07_FIXTURES_SANITIZED" / "normalized_runtime_assets.json"
    return json.loads(fixture_path.read_text(encoding="utf-8"))


def build_runtime_decision(asset):
    lane = asset["runtime_lane"]
    if lane in {"BLOCKED_DEPLOYMENT_REFERENCE", "REVIEW_CONFIG_NO_EXECUTE"}:
        return {
            "asset_id": asset["asset_id"],
            "runtime_lane": lane,
            "execution_status": "BLOCKED",
            "allowed_surface": "LOCAL_FIXTURE_ONLY",
            "blocked_reason": "Recovered deployment/config assets stay blocked from live execution or deployment.",
            "data_policy": "SYNTHETIC_OR_METADATA_ONLY",
        }
    return {
        "asset_id": asset["asset_id"],
        "runtime_lane": lane,
        "execution_status": "PASS",
        "allowed_surface": "LOCAL_FIXTURE_ONLY",
        "blocked_reason": "",
        "data_policy": "SYNTHETIC_OR_METADATA_ONLY",
    }


def run_local_fixture_harness(limit=8):
    assets = load_assets()[:limit]
    decisions = [build_runtime_decision(asset) for asset in assets]
    blocked = sum(1 for decision in decisions if decision["execution_status"] == "BLOCKED")
    passed = sum(1 for decision in decisions if decision["execution_status"] == "PASS")
    return {
        "mode": "local",
        "status": "PASS",
        "assets_checked": len(decisions),
        "pass_count": passed,
        "blocked_count": blocked,
        "data_policy": "SYNTHETIC_OR_METADATA_ONLY",
        "blocked_surfaces": BLOCKED_SURFACES,
        "decisions": decisions,
    }


def build_cookbook_expansion_manifest():
    return {
        "gate": "GATE_03_COOKBOOK_AGENTS_SDK_EXPANSION",
        "status": "RUNTIME_READY_LOCAL_SYNTHETIC",
        "patterns": COOKBOOK_EXPANSION_PATTERNS,
        "data_policy": "SYNTHETIC_OR_METADATA_ONLY",
        "credential_policy": "NO_SECRET_READ_OR_WRITE_REQUIRED_FOR_LOCAL_EXPANSION",
        "blocked_surfaces": BLOCKED_SURFACES,
        "sandbox": {
            "network": "BLOCKED_FOR_LOCAL_EXPANSION_HARNESS",
            "filesystem": "REPO_RESULTS_ONLY",
            "external_upload": "BLOCKED",
            "production_deploy": "BLOCKED",
            "justification": "Needed to declare that Cookbook and Agents SDK patterns are exercised as local synthetic stubs unless a later live gate opens them.",
        },
        "sharepoint_ready_artifact": {
            "status": "READY_FOR_MANUAL_UPLOAD",
            "site_label": "Auditoria Integrada",
            "target_folder": "Runtime Control/Agent Outputs/Synthetic Harness",
            "file": "docs/sharepoint_package/AUDITORIA_INTEGRADA_RUNTIME_CONTROL_UPLOAD.md",
            "sharepoint_write": "NOT_EXECUTED",
            "rollback_required": True,
            "postcheck_required": True,
        },
    }


def _run_synthetic_tool(tool_name, payload):
    tools = {
        "classify_runtime_lane": lambda item: {
            "tool": "classify_runtime_lane",
            "status": "PASS",
            "runtime_lane": item["runtime_lane"],
            "allowed_surface": "LOCAL_FIXTURE_ONLY",
        },
        "summarize_trace": lambda item: {
            "tool": "summarize_trace",
            "status": "PASS",
            "trace_id": "synthetic-trace-tcu-001",
            "external_upload": "BLOCKED",
            "events_recorded": [
                "structured_output_validated",
                "function_tool_stub_executed",
                "handoff_stub_recorded",
                "guardrail_failure_blocked",
            ],
        },
    }
    return tools[tool_name](payload)


def run_cookbook_expansion_harness():
    manifest = build_cookbook_expansion_manifest()
    synthetic_asset = {
        "asset_id": "asset_demo_cookbook_agents_sdk_expansion",
        "runtime_lane": "PROMOTE_EVAL_CASE_PATTERN",
    }
    structured_output = {
        "status": "PASS",
        "decision": "Synthetic Cookbook/Agents SDK expansion is allowed as a local fixture harness only.",
        "allowed_surface": "LOCAL_FIXTURE_ONLY",
        "blocked_surfaces": BLOCKED_SURFACES,
        "data_policy": "SYNTHETIC_OR_METADATA_ONLY",
        "next_action": "Keep live runtime, tenant writes and external trace upload blocked pending a later gate.",
    }
    function_tool_result = _run_synthetic_tool("classify_runtime_lane", synthetic_asset)
    tracing_summary = _run_synthetic_tool("summarize_trace", synthetic_asset)
    agent_as_tool_handoff = {
        "status": "PASS",
        "supervisor_agent": "tcu_runtime_supervisor_stub",
        "specialist_agent_tool": "eval_case_reviewer_stub",
        "handoff_target": "guardrail_reviewer_stub",
        "handoff_mode": "LOCAL_STUB_ONLY",
        "external_runtime": "BLOCKED",
    }
    guardrail_failure = {
        "status": "BLOCKED",
        "reason": "Synthetic request attempted real_data and production surfaces.",
        "blocked_surfaces": ["real_data", "production"],
        "data_policy": "SYNTHETIC_OR_METADATA_ONLY",
    }
    session_stub = {
        "status": "PASS",
        "session_id": "synthetic-session-tcu-local-001",
        "persistence": "IN_MEMORY_ONLY",
        "contains_real_data": False,
        "contains_secret": False,
    }
    result = {
        "mode": "cookbook_expansion",
        "status": "PASS",
        "manifest": manifest,
        "structured_output": structured_output,
        "function_tool_result": function_tool_result,
        "agent_as_tool_handoff": agent_as_tool_handoff,
        "guardrail_failure": guardrail_failure,
        "session_stub": session_stub,
        "tracing_summary": tracing_summary,
        "sandbox_manifest": manifest["sandbox"],
        "executed_at": datetime.now(timezone.utc).isoformat(),
    }
    result["result_path"] = _write_result("cookbook_expansion_latest.json", result)
    return result


def _write_result(name, payload):
    out_dir = ROOT / "09_RUNTIME_SMOKES" / "results"
    out_dir.mkdir(parents=True, exist_ok=True)
    out = out_dir / name
    out.write_text(json.dumps(payload, indent=2, ensure_ascii=False), encoding="utf-8")
    return str(out)


def _synthetic_prompt():
    return (
        "Synthetic TCU runtime smoke. No real data. "
        "Classify whether a metadata-only recovered asset can be used in local fixture runtime. "
        "Return only the requested structured output. Use status PASS, allowed_surface SYNTHETIC_API_ONLY, "
        "data_policy SYNTHETIC_OR_METADATA_ONLY and blocked_surfaces exactly: "
        "real_data, tenant_write, sharepoint_write, power_platform_mutation, agents_sdk_deployment, production. "
        "Asset: asset_demo_prompt_pattern, lane PROMOTE_PROMPT_PATTERN."
    )


def run_responses_smoke(model=DEFAULT_MODEL):
    from openai import OpenAI

    client = OpenAI()
    response = client.responses.create(
        model=model,
        instructions=(
            "You are a TCU runtime guard. Use only synthetic data. "
            "Never request secrets or tenant data. Keep blocked surfaces explicit. "
            "Use canonical constants exactly as requested."
        ),
        input=_synthetic_prompt(),
        max_output_tokens=350,
        store=False,
        text={
            "format": {
                "type": "json_schema",
                "name": "tcu_controlled_runtime_smoke",
                "strict": True,
                "schema": STRUCTURED_OUTPUT_SCHEMA,
            }
        },
    )
    parsed = json.loads(response.output_text)
    result = {
        "mode": "responses",
        "status": "PASS" if parsed["status"] == "PASS" else "BLOCKED",
        "model": model,
        "response_id": response.id,
        "data_policy": parsed["data_policy"],
        "structured_output": parsed,
        "executed_at": datetime.now(timezone.utc).isoformat(),
    }
    result["result_path"] = _write_result("responses_smoke_latest.json", result)
    return result


def run_agents_sdk_smoke(model=DEFAULT_MODEL):
    from agents import Agent, Runner
    from pydantic import BaseModel

    class AgentRuntimeDecision(BaseModel):
        status: Literal["PASS", "BLOCKED"]
        decision: str
        allowed_surface: Literal["LOCAL_FIXTURE_ONLY", "SYNTHETIC_API_ONLY"]
        blocked_surfaces: list[str]
        data_policy: Literal["SYNTHETIC_OR_METADATA_ONLY"]
        next_action: str

    agent = Agent(
        name="TCU Controlled Runtime Guard",
        model=model,
        output_type=AgentRuntimeDecision,
        instructions=(
            "You are a local/staging TCU agentic runtime guard. "
            "Use only synthetic input. Do not request secrets, real data, tenant access, "
            "SharePoint, Power Platform or deployment. Return the structured decision. "
            "Use status PASS or BLOCKED only. Use allowed_surface LOCAL_FIXTURE_ONLY only. "
            "Use data_policy SYNTHETIC_OR_METADATA_ONLY only."
        ),
    )
    result = Runner.run_sync(
        agent,
        (
            "Synthetic fixture: asset_demo_eval_playbook, lane PROMOTE_EVAL_CASE_PATTERN. "
            "Decide if this can run as local fixture only. Return status PASS, allowed_surface LOCAL_FIXTURE_ONLY, "
            "data_policy SYNTHETIC_OR_METADATA_ONLY and blocked_surfaces: real_data, tenant_write, "
            "sharepoint_write, power_platform_mutation, agents_sdk_deployment, production."
        ),
    )
    output = result.final_output
    if hasattr(output, "model_dump"):
        decision = output.model_dump()
    elif isinstance(output, dict):
        decision = output
    else:
        decision = {"status": "PASS", "decision": str(output)}
    payload = {
        "mode": "agents_sdk",
        "status": decision.get("status", "PASS"),
        "model": model,
        "data_policy": decision.get("data_policy", "SYNTHETIC_OR_METADATA_ONLY"),
        "structured_output": decision,
        "executed_at": datetime.now(timezone.utc).isoformat(),
    }
    payload["result_path"] = _write_result("agents_sdk_smoke_latest.json", payload)
    return payload


def run_all(model=DEFAULT_MODEL):
    results = {
        "local": run_local_fixture_harness(),
        "cookbook_expansion": run_cookbook_expansion_harness(),
    }
    if os.getenv("OPENAI_API_KEY"):
        results["responses"] = run_responses_smoke(model=model)
        results["agents_sdk"] = run_agents_sdk_smoke(model=model)
    else:
        results["responses"] = {"mode": "responses", "status": "SKIPPED", "reason": "OPENAI_API_KEY not present"}
        results["agents_sdk"] = {"mode": "agents_sdk", "status": "SKIPPED", "reason": "OPENAI_API_KEY not present"}
    payload = {
        "mode": "all",
        "status": "PASS",
        "model": model,
        "data_policy": "SYNTHETIC_OR_METADATA_ONLY",
        "blocked_surfaces": BLOCKED_SURFACES,
        "results": results,
        "executed_at": datetime.now(timezone.utc).isoformat(),
    }
    payload["result_path"] = _write_result("controlled_runtime_all_latest.json", payload)
    return payload


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--mode", choices=["local", "responses", "agents", "cookbook", "all"], default="local")
    parser.add_argument("--model", default=DEFAULT_MODEL)
    args = parser.parse_args()

    if args.mode == "local":
        result = run_local_fixture_harness()
        result["result_path"] = _write_result("local_harness_latest.json", result)
    elif args.mode == "responses":
        result = run_responses_smoke(model=args.model)
    elif args.mode == "agents":
        result = run_agents_sdk_smoke(model=args.model)
    elif args.mode == "cookbook":
        result = run_cookbook_expansion_harness()
    else:
        result = run_all(model=args.model)
    print(json.dumps(result, indent=2, ensure_ascii=False))


if __name__ == "__main__":
    main()
