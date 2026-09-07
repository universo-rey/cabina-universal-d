from __future__ import annotations

from guardrails.policies import concrete, evaluate_forbidden_surfaces
from schemas.triage_schema import validate_triage_output
from tools.local_context import summarize_request
from tracing.local_trace import trace_event

AGENT_ID = "sdu-triage-agent"
MODE = "full_live_governed"


def triage_request(request: dict, *, operation_resolver=None) -> dict:
    """Route locally. Only the application may inject an operation resolver."""
    text = str(request.get("text", ""))
    operation_ref = request.get("operation_ref")
    resolved = None
    missing = []
    if operation_ref is not None:
        if not concrete(operation_ref) or operation_resolver is None:
            missing.append("operation_resolver")
        else:
            resolved = operation_resolver(operation_ref)
            if not isinstance(resolved, dict) or resolved.get("operation_ref") != operation_ref:
                missing.append("resolved_operation")
                resolved = None
    surface_result = evaluate_forbidden_surfaces(text, resolved_operation=resolved)
    missing.extend(surface_result["missing_prerequisites"])
    if missing:
        decision, next_action = "resolution_required", "resolve_operation_prerequisites"
    elif surface_result["blocked_surfaces"]:
        decision, next_action = "high_authority_required", "resolve_exact_high_authority"
    elif resolved is not None:
        decision, next_action = "ready_for_dispatch", "dispatch_resolved_operation"
    else:
        decision, next_action = "local_governance_review", "resolve_operation_if_execution_requested"
    summary = summarize_request(text)
    payload = {
        "agent_id": AGENT_ID,
        "mode": MODE,
        "decision": decision,
        "blocked_surfaces": surface_result["blocked_surfaces"],
        "risk_tier": surface_result["risk_tier"],
        "missing_prerequisites": sorted(set(missing)),
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
