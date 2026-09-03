from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
CONSUMER = ROOT / "governance" / "canon" / "TCU_RISK_TIER_POLICY_CONSUMER.json"
EXPECTED_INVARIANTS = [
    "NO_ORDER_FOR_READS",
    "ACTIVE_GOVERNED_MICROSOFT_LIVE",
    "LOW_BY_DEFAULT_UNLESS_HIGH_TRIGGER",
    "EXPLICIT_AUTH_HIGH_RISK",
    "EVIDENCE_POSTCHECK_ALWAYS_FOR_WRITES",
]


def fail(message: str) -> None:
    raise SystemExit(message)


def main() -> None:
    data = json.loads(CONSUMER.read_text(encoding="utf-8"))
    if data.get("consumer_id") != "CABINA_FEDERAL_RISK_TIER_CONSUMER":
        fail("consumer identity drifted")
    if data.get("ownership") != "CONSUMER_NOT_POLICY_OWNER":
        fail("Cabina must not claim rector policy ownership")
    source = data.get("rector_registry", {})
    expected_source = {
        "repository": "SeshatSgin/tcu-control-plane",
        "path": "00_CONTEXT/RISK_TIER_POLICY.json",
        "policy_id": "TCU_PROPORTIONAL_EXECUTION_RISK_TIERS",
        "source_blob_sha": "0be6a492a4412783abc1235b4669f2191f743896",
    }
    if source != expected_source:
        fail(f"rector registry pointer drifted: {source}")
    if data.get("invariants") != EXPECTED_INVARIANTS:
        fail("canonical invariant IDs drifted")
    contract = data.get("local_contract", {})
    if contract.get("caller_tier_authoritative") is not False:
        fail("caller-controlled tier downgrade detected")
    if contract.get("default_known_write_without_high_trigger") != "LOW":
        fail("known writes without an objective HIGH trigger must default to LOW")
    if contract.get("classification") != "KNOWN_WRITE_WITHOUT_OBJECTIVE_HIGH_TRIGGER_IS_LOW_BY_DEFAULT":
        fail("LOW-by-default classification drifted")
    reads = contract.get("reads", "")
    expected_reads = "DIRECT_WITH_AUTHENTICATED_CAPABILITY_EXACT_BINDING_TARGET_MINIMIZATION_EVIDENCE"
    if reads != expected_reads:
        fail("direct read contract drifted")
    low = contract.get("low_writes", "")
    expected_low = (
        "DIRECT_WITH_CAPABILITY_BINDING_BOUNDED_TARGET_WITHIN_CAPABILITY_CEILING_"
        "PRECHECK_REVERSIBILITY_OR_COMPENSATING_ACTION_POSTCHECK_EVIDENCE_"
        "NO_ORDER_ALLOWLIST_OR_RECEIPT"
    )
    if low != expected_low:
        fail("LOW must execute without order/allowlist/receipt and retain recovery guarantees")
    if contract.get("high_actions") != "EXPLICIT_GOVERNED_ORDER_REQUIRED":
        fail("HIGH contract must require explicit governed order")
    if contract.get("high_classification") != "OBJECTIVE_POSITIVE_TRIGGER_REQUIRED":
        fail("HIGH requires an objective positive trigger")
    if contract.get("missing_prerequisite") != (
        "RESOLUTION_REQUIRED_AND_BLOCKED_NOT_EXECUTABLE_TIER_PRESERVED"
    ):
        fail("missing prerequisites must block execution without escalating risk")
    expected_triggers = {
        "destructive_or_irreversible",
        "permission_or_admin_mutation",
        "tenant_identity_or_binding_mutation",
        "secret_exposure_materialization_or_rotation",
        "production_activation_deploy_or_public_exposure",
        "unbounded_or_over_ceiling_bulk",
        "regulated_or_professional_decision",
        "open_ended_cost",
        "external_material_communication",
        "scope_escalation",
    }
    if set(data.get("high_positive_triggers", [])) != expected_triggers:
        fail("HIGH positive triggers drifted")
    print("risk_tier_policy_consumer_validator: PASS")


if __name__ == "__main__":
    main()
