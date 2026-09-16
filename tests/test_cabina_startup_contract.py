"""Regression checks for the startup contract after AGENTS.md reconciliation."""

import sys
import unittest
from pathlib import Path
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts" / "validators"))
import cabina_startup_contract_validator as validator


class StartupContractTests(unittest.TestCase):
    def test_current_startup_documents_pass(self):
        validator.validate()

    def test_missing_execution_or_routing_is_rejected(self):
        original = validator.read_text("AGENTS.md")
        for required in (
            "RETOMAR ORDEN -> EJECUTAR O DELEGAR -> COMPROBAR RESULTADO -> CONTINUAR O CERRAR",
            "MANIFEST.yaml",
            "02_AUTHORITY_CANON/CURRENT_STATE.md",
            ".agents/codex/agents.json",
            ".agents/codex/routing.json",
        ):
            with self.subTest(required=required):
                with patch.object(validator, "read_text", return_value=original.replace(required, "")):
                    with self.assertRaises(AssertionError):
                        validator.validate_startup_text("AGENTS.md")

    def test_legacy_labels_alone_do_not_satisfy_current_contract(self):
        legacy = (
            "ACTIVE_GOVERNED_EXECUTION_BY_DEFAULT MANIFEST.yaml "
            "CURRENT_STATE.md operational_chain_missing"
        )
        with patch.object(validator, "read_text", return_value=legacy):
            with self.assertRaises(AssertionError):
                validator.validate_startup_text("AGENTS.md")


if __name__ == "__main__":
    unittest.main()
