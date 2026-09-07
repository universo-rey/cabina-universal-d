"""Offline regressions against the actual MCP/Cloud validators."""
from pathlib import Path
import sys
import unittest
from unittest.mock import patch

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "scripts/validators"))
import mcp_connection_registry_validator as registry
import sdu_mcp_dev_activation_validator as dev
import sdu_codex_cloud_assignment_validator as cloud
from sdu_runtime_common import read_csv, read_json


class ProportionalConnectionTests(unittest.TestCase):
    def test_current_contracts(self):
        for validator in (registry, dev, cloud):
            validator.validate()

    def test_approval_cannot_be_universal_or_disabled_for_high(self):
        for validator, path in (
            (registry, "governance/connections/MCP_CONNECTION_REGISTRY_20260603.csv"),
            (dev, dev.MATRIX),
        ):
            for approval in ("yes", "no"):
                rows = read_csv(path)
                rows[0]["requires_approval"] = approval
                with self.subTest(validator=validator.__name__, approval=approval):
                    with patch.object(validator, "read_csv", return_value=rows):
                        with self.assertRaises(AssertionError):
                            validator.validate()

    def test_cloud_repair_cannot_be_regated(self):
        path = "governance/codex-cloud/SDU_AGENT_CODEX_CLOUD_ASSIGNMENT_MATRIX_20260603.csv"
        rows = read_csv(path)
        repair = next(row for row in rows if row["assignment_id"] == "cloud.task.validator_repair")
        repair["allowed_actions"] = "inspect_validator|propose_patch"
        with patch.object(cloud, "read_csv", return_value=rows):
            with self.assertRaises(AssertionError):
                cloud.validate()

    def test_cloud_contradictory_actions_are_rejected(self):
        path = "governance/codex-cloud/SDU_AGENT_CODEX_CLOUD_ASSIGNMENT_MATRIX_20260603.csv"
        rows = read_csv(path)
        rows[1]["blocked_actions"] += "|codex_cloud_apply"
        with patch.object(cloud, "read_csv", return_value=rows):
            with self.assertRaises(AssertionError):
                cloud.validate()

    def test_unknown_connection_cannot_be_marked_executable(self):
        config = read_json(".mcp/sdu-agents/mcp.config.template.json")
        config["servers"]["teamsChatTemplate"]["enabledByDefault"] = True
        with patch.object(registry, "read_json", return_value=config):
            with self.assertRaises(AssertionError):
                registry.validate()

    def test_resolved_connection_is_not_forced_to_stay_template(self):
        rows = read_csv("governance/connections/MCP_CONNECTION_REGISTRY_20260603.csv")
        row = next(row for row in rows if row["connection_type"] == "microsoft_teams")
        row.update(status="ACTIVE_GOVERNED", mode="active_governed",
                   binding_ref="synthetic.bound.connection", exact_target="synthetic.team/channel")
        with patch.object(registry, "read_csv", return_value=rows):
            registry.validate()
        row["binding_ref"] = ""
        with patch.object(registry, "read_csv", return_value=rows):
            with self.assertRaises(AssertionError):
                registry.validate()

    def test_cloud_profile_has_no_provider_wide_blocks(self):
        text = (ROOT / ".codex/cloud/sdu-agents/profile.yml").read_text()
        blocked = text.split("blocked_actions:", 1)[1].split("required_evidence", 1)[0]
        for provider in ("microsoft_live", "openai_api_live"):
            self.assertNotIn(provider, blocked)


if __name__ == "__main__":
    unittest.main()
