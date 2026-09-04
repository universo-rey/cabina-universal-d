from pathlib import Path
import unittest

from scripts.validators.risk_tier_policy_consumer_validator import (
    find_forbidden_active_semantics,
)


class RiskTierActiveContractSemanticTests(unittest.TestCase):
    def test_rejects_blanket_order_gate_hidden_in_active_contract(self) -> None:
        violations = find_forbidden_active_semantics(
            Path(".agents/codex/agents.json"),
            '{"microsoft_live_policy": "governed_requires_order"}',
        )
        self.assertIn(
            "blanket Microsoft order gate in .agents/codex/agents.json",
            violations,
        )

    def test_rejects_automatic_merge_rule(self) -> None:
        violations = find_forbidden_active_semantics(
            Path("01_GOVERNANCE_REGISTRY/GITHUB_BASE_WORK_MATRIX.csv"),
            "merge automatizable con ciclo aprobado",
        )
        self.assertIn(
            "automatic merge in 01_GOVERNANCE_REGISTRY/GITHUB_BASE_WORK_MATRIX.csv",
            violations,
        )

    def test_rejects_surface_based_apply_gate(self) -> None:
        violations = find_forbidden_active_semantics(
            Path("AGENTS.md"),
            "GATE_DATAVERSE_APPLY",
        )
        self.assertIn("surface-based Power Platform gate in AGENTS.md", violations)

    def test_rejects_mandatory_discovery_for_every_action(self) -> None:
        violations = find_forbidden_active_semantics(
            Path(".agents/codex/agents.json"),
            '"mandatory_capability_discovery_skill": "tcu-descubridor-capacidades"',
        )
        self.assertIn(
            "mandatory discovery bureaucracy in .agents/codex/agents.json",
            violations,
        )

    def test_rejects_parking_microsoft_by_surface(self) -> None:
        violations = find_forbidden_active_semantics(
            Path("02_AUTHORITY_CANON/CURRENT_STATE.md"),
            "Keep Microsoft live and production parked until exact target gates are met.",
        )
        self.assertIn(
            "parked Microsoft live surface in 02_AUTHORITY_CANON/CURRENT_STATE.md",
            violations,
        )
    def test_accepts_low_default_and_manual_merge(self) -> None:
        text = (
            "READ no requiere orden; LOW por defecto; solo HIGH requiere "
            "autorizacion explicita; MANUAL_OWNER_GATED"
        )
        self.assertEqual([], find_forbidden_active_semantics(Path("AGENTS.md"), text))


if __name__ == "__main__":
    unittest.main()
