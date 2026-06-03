from __future__ import annotations

import json
import pathlib
import sys
import unittest


ROOT = pathlib.Path(__file__).resolve().parents[1]
SRC = ROOT / "src"
sys.path.insert(0, str(SRC))

from agents.sdu_triage_agent import triage_request  # noqa: E402
from schemas.triage_schema import validate_triage_output  # noqa: E402


class SduTriageAgentTests(unittest.TestCase):
    def test_local_request_returns_structured_json(self) -> None:
        result = triage_request({"text": "Review cabina matrices locally"})
        self.assertEqual(result["agent_id"], "sdu-triage-agent")
        self.assertEqual(result["mode"], "local_no_live")
        self.assertEqual(result["decision"], "local_governance_review")
        self.assertEqual(result["evidence"]["external_writes"], "forbidden")
        self.assertEqual(validate_triage_output(result), [])

    def test_forbidden_live_surfaces_are_blocked(self) -> None:
        result = triage_request({"text": "Use OpenAI API live and write to Microsoft Teams"})
        self.assertEqual(result["decision"], "blocked_governed_order_required")
        self.assertIn("openai_api_live", result["blocked_surfaces"])
        self.assertIn("microsoft_live", result["blocked_surfaces"])

    def test_synthetic_cases_match_expected_decisions(self) -> None:
        cases_path = ROOT / "src" / "evals" / "synthetic_cases.json"
        cases = json.loads(cases_path.read_text(encoding="utf-8"))
        for case in cases:
            with self.subTest(case_id=case["case_id"]):
                result = triage_request({"text": case["text"]})
                self.assertEqual(result["decision"], case["expected_decision"])


if __name__ == "__main__":
    unittest.main()
