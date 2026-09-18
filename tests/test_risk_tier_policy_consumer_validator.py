from pathlib import Path
import unittest

from scripts.validators.risk_tier_policy_consumer_validator import (
    find_forbidden_active_semantics,
)


class RiskTierActiveConsumerSemanticTests(unittest.TestCase):
    def test_rejects_order_first_read_gate(self) -> None:
        violations = find_forbidden_active_semantics(
            Path(".agents/codex/matrices/USER_IDENTITY_GOVERNANCE_MATRIX.csv"),
            "governed_order_required_before_account_profile_read",
        )
        self.assertIn(
            "order-first READ in .agents/codex/matrices/USER_IDENTITY_GOVERNANCE_MATRIX.csv",
            violations,
        )

    def test_rejects_legacy_microsoft_order_stop(self) -> None:
        violations = find_forbidden_active_semantics(
            Path(".agents/codex/matrices/TEAMS_GOVERNANCE_SURFACE_MATRIX.csv"),
            "microsoft_live_requested_without_governed_order",
        )
        self.assertIn(
            "order-first READ in .agents/codex/matrices/TEAMS_GOVERNANCE_SURFACE_MATRIX.csv",
            violations,
        )

    def test_rejects_mandatory_discovery_for_every_action(self) -> None:
        violations = find_forbidden_active_semantics(
            Path(".agents/codex/agents.json"),
            '"mandatory_capability_discovery_skill": "tcu-descubridor-capacidades"',
        )
        self.assertIn(
            "mandatory discovery bureaucracy in .agents/codex/agents.json",
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

    def test_accepts_direct_read_and_low_default(self) -> None:
        text = (
            "READ direct with exact binding; LOW_BY_DEFAULT_UNLESS_HIGH_TRIGGER; "
            "HIGH requires explicit authorization"
        )
        self.assertEqual(
            [],
            find_forbidden_active_semantics(Path("consumer.txt"), text),
        )


if __name__ == "__main__":
    unittest.main()
