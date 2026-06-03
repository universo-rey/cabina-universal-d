from __future__ import annotations


REQUIRED_TOP_LEVEL_FIELDS = {
    "agent_id": str,
    "mode": str,
    "decision": str,
    "blocked_surfaces": list,
    "next_action": str,
    "evidence": dict,
}


def validate_triage_output(payload: dict) -> list[str]:
    errors: list[str] = []
    for field, expected_type in REQUIRED_TOP_LEVEL_FIELDS.items():
        if field not in payload:
            errors.append(f"missing:{field}")
            continue
        if not isinstance(payload[field], expected_type):
            errors.append(f"type:{field}")
    if payload.get("mode") != "local_no_live":
        errors.append("mode:not_local_no_live")
    evidence = payload.get("evidence")
    if isinstance(evidence, dict) and evidence.get("external_writes") != "forbidden":
        errors.append("external_writes:not_forbidden")
    return errors
