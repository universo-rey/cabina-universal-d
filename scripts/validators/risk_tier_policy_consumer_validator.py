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

ACTIVE_CONSUMERS = (
    ROOT / ".agents" / "skills" / "cabina-sharepoint-plugin-adapter" / "SKILL.md",
    ROOT / ".agents" / "codex" / "plugins" / "PLUGIN_USAGE_MATRIX.csv",
    ROOT / ".agents" / "codex" / "matrices" / "CAPABILITY_MATRIX.csv",
    ROOT / ".agents" / "codex" / "matrices" / "TEAMS_AGENT_CAPABILITY_MATRIX.csv",
    ROOT / ".agents" / "codex" / "matrices" / "TEAMS_GOVERNANCE_SURFACE_MATRIX.csv",
    ROOT / ".agents" / "codex" / "matrices" / "USER_IDENTITY_GOVERNANCE_MATRIX.csv",
    ROOT / ".agents" / "codex" / "tools" / "local_generate_agent_workpapers.ps1",
)

VALIDATOR_CONSUMERS = (
    ROOT / ".agents" / "codex" / "tools" / "local_validate_teams_governance.ps1",
    ROOT / ".agents" / "codex" / "tools" / "local_validate_user_identity_governance.ps1",
)

FORBIDDEN_ACTIVE_SEMANTICS = {
    "order-first READ": re.compile(
        r"governed_order_required_before_[^\n,\"]*(?:read|lookup|inventory|probe)|"
        r"microsoft_live_requested_without_governed_order|"
        r"read_or_write_requires_governed_order|"
        r"microsoft_live_requires_order",
        re.IGNORECASE,
    ),
    "mandatory discovery bureaucracy": re.compile(
        r"mandatory_capability_discovery_skill|"
        r"tcu-descubridor-capacidades[^\n]*(?:obligatori[oa]|antes de toda)",
        re.IGNORECASE,
    ),
    "automatic merge": re.compile(
        r"merge automatizable|auto[-_ ]?merge[^\n]*(?:enabled|true)",
        re.IGNORECASE,
    ),
}


def fail(message: str) -> None:
    raise SystemExit(message)


def rows(path: Path) -> list[dict[str, str]]:
    with path.open(encoding="utf-8-sig", newline="") as stream:
        return list(csv.DictReader(stream))


def find_forbidden_active_semantics(path: Path, text: str) -> list[str]:
    return [
        f"{label} in {path.as_posix()}"
        for label, pattern in FORBIDDEN_ACTIVE_SEMANTICS.items()
        if pattern.search(text)
    ]


def validate_consumer_pointer() -> None:
    data = json.loads(CONSUMER.read_text(encoding="utf-8"))
    if data.get("consumer_id") != "CABINA_FEDERAL_RISK_TIER_CONSUMER":
        fail("consumer identity drifted")
    if data.get("ownership") != "CONSUMER_NOT_POLICY_OWNER":
        fail("Cabina must not claim rector policy ownership")

    expected_source = {
        "repository": "SeshatSgin/tcu-control-plane",
        "path": "00_CONTEXT/RISK_TIER_POLICY.json",
        "policy_id": "TCU_PROPORTIONAL_EXECUTION_RISK_TIERS",
        "source_blob_sha": "0be6a492a4412783abc1235b4669f2191f743896",
    }
    if data.get("rector_registry") != expected_source:
        fail("rector registry pointer drifted")
    if data.get("invariants") != EXPECTED_INVARIANTS:
        fail("canonical invariant IDs drifted")

    contract = data.get("local_contract", {})
    if contract.get("caller_tier_authoritative") is not False:
        fail("caller-controlled tier downgrade detected")
    if contract.get("default_known_write_without_high_trigger") != "LOW":
        fail("known writes without an objective HIGH trigger must default to LOW")
    if contract.get("reads") != (
        "DIRECT_WITH_AUTHENTICATED_CAPABILITY_EXACT_BINDING_TARGET_MINIMIZATION_EVIDENCE"
    ):
        fail("direct READ contract drifted")
    if contract.get("high_actions") != "EXPLICIT_GOVERNED_ORDER_REQUIRED":
        fail("HIGH contract must require explicit governed authorization")


def validate_root_consumer() -> None:
    payload = json.loads(
        (ROOT / ".agents" / "codex" / "agents.json").read_text(encoding="utf-8")
    )
    policy = payload.get("default_policy", {})
    if policy.get("risk_tier_policy") != "LOW_BY_DEFAULT_UNLESS_HIGH_TRIGGER":
        fail("agents.json must consume LOW_BY_DEFAULT_UNLESS_HIGH_TRIGGER")
    if policy.get("microsoft_live_policy") != (
        "READ_DIRECT_LOW_WITHOUT_ORDER_HIGH_EXPLICIT_AUTH"
    ):
        fail("agents.json Microsoft policy must preserve READ/LOW without order")
    if policy.get("no_live_writes_without_governed_order") is not False:
        fail("agents.json still applies blanket order-first write semantics")
    if policy.get("continuity_policy") != "CONTINUITY_FIRST":
        fail("TCU risk consumption must not regress CONTINUITY_FIRST")
    if "mandatory_capability_discovery_skill" in policy:
        fail("TCU risk consumption must not restore mandatory discovery")


def validate_committed_capability_matrix() -> None:
    matrix = ROOT / ".agents" / "codex" / "matrices" / "CAPABILITY_MATRIX.csv"
    matches = [
        row
        for row in rows(matrix)
        if row.get("capability_id") == "cap.sdu.sharepoint.complete_read.prepare"
    ]
    if len(matches) != 1:
        fail("SharePoint complete-read capability row must exist exactly once")
    row = matches[0]
    if row.get("governed_order_required") != "no":
        fail("SharePoint complete READ still requires order")
    if row.get("blocked_without_order") not in {"none", "broad_regulated_read"}:
        fail("SharePoint complete READ carries obsolete order-first blocking")


def validate_teams_surface_matrix() -> None:
    matrix = ROOT / ".agents" / "codex" / "matrices" / "TEAMS_GOVERNANCE_SURFACE_MATRIX.csv"
    team_rows = rows(matrix)
    if not team_rows:
        fail("Teams surface matrix is empty")
    for row in team_rows:
        gate = row.get("live_read_gate", "")
        if "governed_order_required" in gate:
            fail(f"Teams READ remains order-first: {row.get('surface_id')}")
        if not re.search(r"read_direct|resolution_required", gate, re.IGNORECASE):
            fail(f"Teams READ lacks direct-or-resolution semantics: {row.get('surface_id')}")


def validate_identity_matrix() -> None:
    matrix = ROOT / ".agents" / "codex" / "matrices" / "USER_IDENTITY_GOVERNANCE_MATRIX.csv"
    identity_rows = rows(matrix)
    if not identity_rows:
        fail("User identity governance matrix is empty")
    for row in identity_rows:
        gate = row.get("live_read_gate", "")
        if "governed_order_required" in gate:
            fail(f"Identity/Graph READ remains order-first: {row.get('surface')}")
        if not re.search(r"read_direct|resolution_required", gate, re.IGNORECASE):
            fail(f"Identity/Graph READ lacks direct-or-resolution semantics: {row.get('surface')}")


def validate_all_active_consumers() -> None:
    violations: list[str] = []
    for path in ACTIVE_CONSUMERS:
        if not path.is_file():
            violations.append(f"missing active consumer: {path.relative_to(ROOT)}")
            continue
        violations.extend(
            find_forbidden_active_semantics(
                path.relative_to(ROOT),
                path.read_text(encoding="utf-8-sig"),
            )
        )
    if violations:
        fail("active consumer semantic drift:\n- " + "\n- ".join(violations))

    for path in VALIDATOR_CONSUMERS:
        if not path.is_file():
            fail(f"missing active validator consumer: {path.relative_to(ROOT)}")
        text = path.read_text(encoding="utf-8-sig")
        if "reintroduces order-first READ" not in text:
            fail(f"{path.relative_to(ROOT)} does not reject order-first READ")
        if "must declare direct READ or exact resolution requirement" not in text:
            fail(f"{path.relative_to(ROOT)} does not enforce direct-or-resolution READ")
        if "missing governed live read gate" in text:
            fail(f"{path.relative_to(ROOT)} still positively enforces governed-order READ")


def main() -> None:
    validate_consumer_pointer()
    validate_root_consumer()
    validate_committed_capability_matrix()
    validate_teams_surface_matrix()
    validate_identity_matrix()
    validate_all_active_consumers()
    print("risk_tier_policy_consumer_validator: PASS")


if __name__ == "__main__":
    main()
