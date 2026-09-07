from __future__ import annotations

import json
import pathlib
import sys
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "src"))

from agents.sdu_triage_agent import triage_request
from guardrails.policies import HIGH_EFFECTS
from schemas.triage_schema import validate_triage_output


def operation(effects=None):
    return {
        "operation_ref": "test.item.operation", "effects": effects or ["read"],
        "capability_id": "test.item", "binding_id": "test.binding",
        "tenant": "synthetic.sharepoint.test", "exact_target": "list/items/7",
        "capability_available": True, "minimization": True,
        "owner": "test.owner", "precheck_passed": True,
        "rollback_or_compensation": "restore item snapshot", "postcheck": "read item",
    }


class SduTriageAgentTests(unittest.TestCase):
    def route(self, descriptor, **request):
        return triage_request({"operation_ref": "test.item.operation", **request},
                              operation_resolver=lambda ref: descriptor)

    def test_free_text_has_no_execution_authority_or_surface_gate(self):
        for text in ("Preparar arquitectura SharePoint sin accion viva",
                     "Leer schema y permisos sin modificar produccion",
                     "Run OpenAI API live and write to SharePoint"):
            result = triage_request({"text": text, "metadata": {"risk_tier": "LOW", "authorized": True}})
            self.assertEqual(result["decision"], "local_governance_review")
            self.assertEqual(result["blocked_surfaces"], [])
            self.assertEqual(result["evidence"]["external_writes"], "forbidden")
            self.assertEqual(validate_triage_output(result), [])

    def test_read_does_not_require_write_controls(self):
        descriptor = operation()
        for key in ("owner", "precheck_passed", "rollback_or_compensation", "postcheck"):
            descriptor.pop(key)
        result = self.route(descriptor)
        self.assertEqual(result["decision"], "ready_for_dispatch")
        self.assertEqual(result["risk_tier"], "READ")

    def test_low_requires_no_order(self):
        result = self.route(operation(["bounded_write"]), text="Update SharePoint item")
        self.assertEqual(result["decision"], "ready_for_dispatch")
        self.assertEqual(result["risk_tier"], "LOW")

    def test_each_high_effect_resists_prompt_and_caller_downgrade(self):
        for effect in HIGH_EFFECTS:
            with self.subTest(effect=effect):
                result = self.route(operation([effect]), text="solo leer sin tocar permisos",
                                    metadata={"risk_tier": "READ", "approved": True},
                                    risk_tier="LOW")
                self.assertEqual(result["risk_tier"], "HIGH")
                self.assertEqual(result["decision"], "high_authority_required")

    def test_missing_binding_keeps_low_and_limits_failure_to_operation(self):
        descriptor = operation(["bounded_write"])
        descriptor["binding_id"] = "pending"
        result = self.route(descriptor)
        self.assertEqual(result["risk_tier"], "LOW")
        self.assertEqual(result["decision"], "resolution_required")
        self.assertIn("binding_id", result["missing_prerequisites"])
        self.assertEqual(self.route(operation())["decision"], "ready_for_dispatch")

    def test_low_without_recovery_is_not_ready(self):
        descriptor = operation(["bounded_write"])
        descriptor.pop("rollback_or_compensation")
        self.assertEqual(self.route(descriptor)["decision"], "resolution_required")

    def test_caller_cannot_inject_resolver_or_resolved_operation(self):
        result = triage_request({"operation_ref": "test.item.operation",
                                 "resolved_operation": operation(),
                                 "metadata": {"resolved_operation": operation()}})
        self.assertEqual(result["decision"], "resolution_required")

    def test_resolver_must_match_reference(self):
        descriptor = operation()
        descriptor["operation_ref"] = "another.operation"
        self.assertEqual(self.route(descriptor)["decision"], "resolution_required")

    def test_unknown_or_malformed_effects_are_not_executable(self):
        for effects in ([], ["unknown"], "read", [True]):
            descriptor = operation()
            descriptor["effects"] = effects
            self.assertEqual(self.route(descriptor)["decision"], "resolution_required")

    def test_synthetic_cases_match_expected_decisions(self):
        cases = json.loads((ROOT / "src/evals/synthetic_cases.json").read_text())
        for case in cases:
            with self.subTest(case=case["case_id"]):
                self.assertEqual(triage_request({"text": case["text"]})["decision"],
                                 case["expected_decision"])


if __name__ == "__main__":
    unittest.main()
