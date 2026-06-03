from __future__ import annotations

from guardrails.policies import evaluate_forbidden_surfaces
from schemas.triage_schema import validate_triage_output
from tools.local_context import summarize_request
from tracing.local_trace import trace_event


AGENT_ID = "sdu-triage-agent"
MODE = "local_no_live"


def triage_request(request: dict) -> dict:
    """Return structured local triage without external calls or writes."""
    text = str(request.get("text", ""))
    metadata = request.get("metadata") or {}
    surface_result = evaluate_forbidden_surfaces(text, metadata)
    summary = summarize_request(text)
    decision = "blocked_governed_order_required" if surface_result["blocked_surfaces"] else "local_governance_review"
    next_action = "prepare_governed_order" if surface_result["blocked_surfaces"] else "run_local_validators"

    payload = {
        "agent_id": AGENT_ID,
        "mode": MODE,
        "decision": decision,
        "blocked_surfaces": surface_result["blocked_surfaces"],
        "next_action": next_action,
        "evidence": {
            "summary_hash": summary["summary_hash"],
            "input_length": summary["input_length"],
            "external_writes": "forbidden",
            "trace": trace_event(AGENT_ID, decision),
        },
    }
    errors = validate_triage_output(payload)
    if errors:
        raise ValueError("invalid triage output: " + "; ".join(errors))
    return payload
