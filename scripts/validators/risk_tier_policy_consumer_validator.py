from __future__ import annotations

import csv
import json
import re
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
CONCRETE_CONSUMERS = (
    ROOT / ".agents" / "skills" / "cabina-sharepoint-plugin-adapter" / "SKILL.md",
    ROOT / ".agents" / "codex" / "tools" / "TOOL_INDEX.csv",
    ROOT / ".agents" / "codex" / "matrices" / "TEAMS_AGENT_CAPABILITY_MATRIX.csv",
    ROOT / ".agents" / "codex" / "plugins" / "PLUGIN_USAGE_MATRIX.csv",
    ROOT / ".agents" / "codex" / "tools" / "local_generate_agent_workpapers.ps1",
    ROOT / ".agents" / "codex" / "recipes" / "recipe.sharepoint_complete_read_order.md",
)
ACTIVE_HIGH_PRECEDENCE_CONTRACTS = (
    ROOT / "AGENTS.md",
    ROOT / "MANIFEST.yaml",
    ROOT / "02_AUTHORITY_CANON" / "CURRENT_STATE.md",
    ROOT / ".agents" / "codex" / "README.md",
    ROOT / ".agents" / "codex" / "agents.json",
    ROOT / "01_GOVERNANCE_REGISTRY" / "README.md",
    ROOT / "01_GOVERNANCE_REGISTRY" / "GITHUB_BASE_WORK_MATRIX.csv",
)
FORBIDDEN_ACTIVE_SEMANTICS = {
    "blanket live-write order gate": re.compile(
        r"no[_ ]live[_ ]writes?[_ ]without[_ ](?:governed[_ ])?order", re.IGNORECASE
    ),
    "blanket Microsoft order gate": re.compile(
        r"(?:microsoft[_ ]live[_ ]policy[^\n]*governed_requires_order|"
        r"microsoft live (?:queda gobernado por|requiere) orden)",
        re.IGNORECASE,
    ),
    "agent blanket order gate": re.compile(
        r"(?:live_write_requested|sharepoint_write|tenant_write|"
        r"writing_external_records|tool_live_execution)[_ ]without[_ ]order",
        re.IGNORECASE,
    ),
    "automatic merge": re.compile(r"merge automatizable|auto[-_ ]?merge[^\n]*(?:enabled|true)", re.IGNORECASE),
    "blanket separate gate": re.compile(r"(?:microsoft|sharepoint|runtime) live requiere gate separado", re.IGNORECASE),
    "surface-based Power Platform gate": re.compile(r"GATE_(?:POWER_PLATFORM|DATAVERSE)_APPLY", re.IGNORECASE),
    "mandatory discovery bureaucracy": re.compile(
        r"mandatory_capability_discovery_skill|"
        r"tcu-descubridor-capacidades[^\n]*(?:obligatori[oa]|antes de toda)",
        re.IGNORECASE,
    ),
    "global operational-chain bureaucracy": re.compile(
        r"Toda accion operativa debe declarar cadena|ACTIVE_GLOBAL_REQUIRED|ACTIVE_REQUIRED_FROM_INTAKE",
        re.IGNORECASE,
    ),
    "parked Microsoft live surface": re.compile(
        r"Microsoft live and production parked", re.IGNORECASE
    ),
}


def fail(message: str) -> None:
    raise SystemExit(message)


def find_forbidden_active_semantics(path: Path, text: str) -> list[str]:
    return [
        f"{label} in {path.as_posix()}"
        for label, pattern in FORBIDDEN_ACTIVE_SEMANTICS.items()
        if pattern.search(text)
    ]


def validate_active_contracts() -> None:
    violations: list[str] = []
    for path in ACTIVE_HIGH_PRECEDENCE_CONTRACTS:
        if not path.is_file():
            violations.append(f"missing active contract: {path.relative_to(ROOT)}")
            continue
        violations.extend(
            find_forbidden_active_semantics(path.relative_to(ROOT), path.read_text(encoding="utf-8-sig"))
        )
    if violations:
        fail("active contract semantic drift:\n- " + "\n- ".join(violations))

    agents = json.loads((ROOT / ".agents" / "codex" / "agents.json").read_text(encoding="utf-8"))
    defaults = agents.get("default_policy", {})
    if defaults.get("risk_tier_policy") != "LOW_BY_DEFAULT_UNLESS_HIGH_TRIGGER":
        fail("agents default policy must consume LOW_BY_DEFAULT_UNLESS_HIGH_TRIGGER")
    if defaults.get("microsoft_live_policy") != "READ_DIRECT_LOW_WITHOUT_ORDER_HIGH_EXPLICIT_AUTH":
        fail("agents Microsoft policy must keep READ/LOW available and reserve explicit auth for HIGH")
    if "mandatory_capability_discovery_skill" in defaults:
        fail("capability discovery cannot gate every known READ/LOW action")

    matrix = ROOT / "01_GOVERNANCE_REGISTRY" / "GITHUB_BASE_WORK_MATRIX.csv"
    with matrix.open(encoding="utf-8-sig", newline="") as stream:
        rows = list(csv.DictReader(stream))
    if not rows:
        fail("GitHub base work matrix must contain repositories")
    for row in rows:
        merge_rule = row.get("merge_rule", "")
        if not merge_rule.startswith("MANUAL_OWNER_GATED:"):
            fail(f"{row.get('repo_id', '<unknown>')} merge must be MANUAL_OWNER_GATED")
        if "fixed HEAD" not in merge_rule or "green checks" not in merge_rule:
            fail(f"{row.get('repo_id', '<unknown>')} manual merge safeguards drifted")

    agents_contract = (ROOT / "AGENTS.md").read_text(encoding="utf-8")
    required_semantics = (
        "READ no requiere orden",
        "LOW por defecto",
        "RESOLUTION_REQUIRED_AND_BLOCKED_NOT_EXECUTABLE_TIER_PRESERVED",
        "MANUAL_OWNER_GATED",
        "HUMAN_RESERVED",
    )
    for semantic in required_semantics:
        if semantic not in agents_contract:
            fail(f"active AGENTS contract missing semantic: {semantic}")

    current_state = (ROOT / "02_AUTHORITY_CANON" / "CURRENT_STATE.md").read_text(encoding="utf-8")
    for semantic in ("RESOLUTION_REQUIRED", "READ directo", "LOW sin orden"):
        if semantic not in current_state:
            fail(f"current state missing proportional execution semantic: {semantic}")


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
    forbidden = (
        "microsoft_live_read_without_order",
        "microsoft_live_requested_without_governed_order",
        "read_or_write_requires_governed_order",
        "microsoft_live_requires_order",
    )
    for path in CONCRETE_CONSUMERS:
        text = path.read_text(encoding="utf-8-sig")
        for token in forbidden:
            if token in text:
                fail(f"obsolete order-first token in {path.relative_to(ROOT)}: {token}")
    validate_active_contracts()
    print("risk_tier_policy_consumer_validator: PASS")


if __name__ == "__main__":
    main()
