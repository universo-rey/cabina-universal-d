from __future__ import annotations

import json
from pathlib import Path

POLICY = Path(__file__).resolve().parents[4] / "governance/canon/TCU_RISK_TIER_POLICY_CONSUMER.json"
HIGH_EFFECTS = frozenset(json.loads(POLICY.read_text(encoding="utf-8"))["high_positive_triggers"])


def concrete(value: object) -> bool:
    return isinstance(value, str) and bool(value.strip()) and value.strip().lower() not in {
        "none", "null", "unknown", "pending", "tbd", "not_resolved", "n/a",
    }


def evaluate_forbidden_surfaces(text: str, metadata: dict | None = None, *, resolved_operation: dict | None = None) -> dict:
    """Route resolver-owned effects, never prompt keywords or caller risk labels.

    No connector or execution authority is created here. The application owns
    the resolver; request metadata cannot supply a resolved descriptor.
    """
    result = {"blocked_surfaces": [], "risk_tier": None, "missing_prerequisites": []}
    if resolved_operation is None:
        return result
    if not isinstance(resolved_operation, dict):
        result["missing_prerequisites"] = ["resolved_operation"]
        return result
    effects = resolved_operation.get("effects")
    if not isinstance(effects, list) or not effects or any(not isinstance(e, str) for e in effects):
        result["missing_prerequisites"] = ["effects"]
        return result
    high = HIGH_EFFECTS.intersection(effects)
    result["risk_tier"] = "HIGH" if high else ("LOW" if "bounded_write" in effects else "READ")
    result["blocked_surfaces"] = sorted(high)
    if set(effects) - HIGH_EFFECTS - {"read", "bounded_write"}:
        result["missing_prerequisites"].append("known_effects")
    for field in ("operation_ref", "capability_id", "binding_id", "tenant", "exact_target"):
        if not concrete(resolved_operation.get(field)):
            result["missing_prerequisites"].append(field)
    if resolved_operation.get("capability_available") is not True:
        result["missing_prerequisites"].append("capability_available")
    if resolved_operation.get("minimization") is not True:
        result["missing_prerequisites"].append("minimization")
    if result["risk_tier"] != "READ":
        for field in ("owner", "rollback_or_compensation", "postcheck"):
            if not concrete(resolved_operation.get(field)):
                result["missing_prerequisites"].append(field)
        if resolved_operation.get("precheck_passed") is not True:
            result["missing_prerequisites"].append("precheck_passed")
    return result
