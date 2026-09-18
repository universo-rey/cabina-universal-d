"""Regression checks for the current Cabina startup contract."""

import sys
import unittest
from pathlib import Path
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts" / "validators"))
import cabina_startup_contract_validator as validator


class StartupContractTests(unittest.TestCase):
    def test_current_startup_documents_pass(self):
        validator.validate()

    def test_missing_current_execution_or_routing_token_is_rejected(self):
        original = validator.read_text("AGENTS.md")
        for required in (
            "ACTIVE_GOVERNED_EXECUTION_BY_DEFAULT",
            "RESOLVE_EXACT_OBJECT -> CONSUME_CURRENT_AUTHORITY -> EXECUTE -> POSTCHECK -> RETURN",
            "Lectura obligatoria selectiva",
            "02_AUTHORITY_CANON/CURRENT_STATE.md",
            ".agents/codex/agents.json",
            ".agents/codex/routing.json",
        ):
            with self.subTest(required=required):
                with patch.object(
                    validator,
                    "read_text",
                    return_value=original.replace(required, ""),
                ):
                    with self.assertRaises(AssertionError):
                        validator.validate_startup_text("AGENTS.md")

    def test_retired_contract_alone_does_not_satisfy_current_contract(self):
        legacy = (
            "ACTIVE_GOVERNED_EXECUTION_BY_DEFAULT MANIFEST.yaml "
            "CURRENT_STATE.md operational_chain_missing"
        )
        with patch.object(validator, "read_text", return_value=legacy):
            with self.assertRaises(AssertionError):
                validator.validate_startup_text("AGENTS.md")


if __name__ == "__main__":
    unittest.main()
