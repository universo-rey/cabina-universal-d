from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
CONSUMER = ROOT / "governance" / "canon" / "TCU_RISK_TIER_POLICY_CONSUMER.json"
EXPECTED_INVARIANTS = [
    "NO_ORDER_FOR_READS",
    "ACTIVE_GOVERNED_MICROSOFT_LIVE",
    "DIRECT_PREAUTHORIZED_LOW_RISK",
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
        "source_blob_sha": "6263f38f5f760b6b283276d14880e9f6630a43f6",
    }
    if source != expected_source:
        fail(f"rector registry pointer drifted: {source}")
    if data.get("invariants") != EXPECTED_INVARIANTS:
        fail("canonical invariant IDs drifted")
    contract = data.get("local_contract", {})
    if contract.get("caller_tier_authoritative") is not False:
        fail("caller-controlled tier downgrade detected")
    if contract.get("default_unclassified") != "HIGH":
        fail("unclassified actions must fail closed to HIGH")
    reads = contract.get("reads", "")
    if "DIRECT" not in reads or "EXACT_BINDING" not in reads or "ORDER_REQUIRED" in reads:
        fail("direct read contract drifted")
    low = contract.get("low_writes", "")
    expected_low = (
        "RECTOR_ALLOWLIST_AND_CEILINGS_PLUS_PRECHECK_"
        "ROLLBACK_OR_IDEMPOTENCY_POSTCHECK_EVIDENCE"
    )
    if low != expected_low:
        fail("LOW contract must match rector allowlist, ceilings and recovery guarantees")
    if contract.get("high_actions") != "EXPLICIT_GOVERNED_ORDER_REQUIRED":
        fail("HIGH contract must require explicit governed order")
    print("risk_tier_policy_consumer_validator: PASS")


if __name__ == "__main__":
    main()
