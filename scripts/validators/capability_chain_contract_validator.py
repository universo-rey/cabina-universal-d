#!/usr/bin/env python3
"""Validate proportional contracts consumed from Cabina's existing matrices.

Catalog integrity remains in the PowerShell validators. This check guards the
operation policy projected by those catalogs; it does not execute a runtime,
establish credentials, or grant authority. Self-tests mutate the actual rows.
"""

import argparse
import copy
import csv
import json
from pathlib import Path


POLICIES = {
    "chain_policy": "APPLICABLE_COMPONENTS_ONLY",
    "discovery_policy": "UNKNOWN_AMBIGUOUS_OR_NEW_ONLY",
    "authority_policy": "HIGH_ONLY",
    "evidence_policy": "OPERATION_RESULT_ONLY",
    "missing_requirement_policy": "RESOLUTION_REQUIRED_AFFECTED_OPERATION_TIER_PRESERVED",
}
FILES = {
    "capability": "CAPABILITY_USE_HARDENING_MATRIX.csv",
    "chain": "OPERATIONAL_CHAIN_GOVERNANCE_MATRIX.csv",
    "autonomous": "AUTONOMOUS_AGENT_EXECUTION_MATRIX_20260602.csv",
}
HIGH_EFFECTS = {
    "production_activation_deploy_or_public_exposure", "permission_change", "tenant_identity_change",
    "secret_exposure_materialization_or_rotation",
    "destructive_effect", "open_ended_cost", "unbounded_bulk",
    "regulated_professional_decision", "external_material_communication",
    "scope_escalation", "merge_main",
}
GLOBAL_BLOCKS = {
    "microsoft_live", "openai_api_live", "dataverse_live", "powerautomate_live",
    "teams_live", "sharepoint_live", "tenant_write", "production", "batch_api",
    "execution_without_capability_preflight", "autonomous_agent_order_missing",
    "codex_cloud_apply_without_review", "permission_change",
}


def validate_rows(kind: str, rows: list[dict]) -> list[str]:
    errors = []
    id_field = {"capability": "stage_id", "chain": "chain_id", "autonomous": "execution_id"}[kind]
    if not rows:
        return [f"{kind}: empty contract matrix"]
    for row in rows:
        name = row.get(id_field, "<missing ID>")
        for field, expected in POLICIES.items():
            if row.get(field) != expected:
                errors.append(f"{name}: {field} must be {expected}")
        if kind != "autonomous" and row.get("status") != "ACTIVE_PROPORTIONAL":
            errors.append(f"{name}: active contract must be proportional")
        if kind == "autonomous":
            blocked = set(row.get("blocked_actions", "").split("|"))
            for token in sorted(blocked & GLOBAL_BLOCKS):
                errors.append(f"{name}: unconditional block {token}")
            required_blocks = {"secret_materialization", "regulated_data_dump",
                               "execution_without_required_capability_or_binding",
                               "high_effect_without_explicit_authorization"}
            if not required_blocks <= blocked:
                errors.append(f"{name}: preserve capability, HIGH authority and data boundaries")
            if set(row.get("requires_order_for", "").split("|")) != HIGH_EFFECTS:
                errors.append(f"{name}: order required for positive HIGH effects only")
            if row.get("discovery_skill_when_needed") != "tcu-descubridor-capacidades" or "mandatory_discovery_skill" in row:
                errors.append(f"{name}: discovery reference must remain conditional")
            actions = set(row.get("allowed_autonomous_actions", "").split("|"))
            if not {"execute_assigned_READ_with_binding", "execute_assigned_LOW_with_write_controls",
                    "prepare_HIGH_order_when_required"} <= actions:
                errors.append(f"{name}: assigned READ/LOW work must not require an order")
        elif kind == "capability":
            blocked = set(row.get("blocked_actions", "").split("|"))
            for token in sorted(blocked & GLOBAL_BLOCKS):
                errors.append(f"{name}: unconditional block {token}")
            for token in ("execution_without_required_capability_or_binding",
                          "high_effect_without_explicit_authorization", "secrets"):
                if token not in blocked:
                    errors.append(f"{name}: missing operation boundary {token}")
            if name == "capability_use.skill_discovery_assignment" and row.get("applies_to") != "unknown_ambiguous_or_new_capability":
                errors.append(f"{name}: discovery must be conditional")
            if name == "capability_use.before_live_or_cost":
                actions = set(row.get("allowed_actions", "").split("|"))
                if not {"route_READ_with_binding", "route_LOW_with_write_controls",
                        "prepare_HIGH_order_when_required"} <= actions:
                    errors.append(f"{name}: external operations need distinct READ/LOW/HIGH paths")
            if name == "capability_use.every_closeout" and row.get("evidence") != "operation_result_or_exact_limitation":
                errors.append(f"{name}: closeout cannot require a global evidence package")
        else:
            expected_block = "execution_missing_material_requirement"
            if name == "chain.chat_closeout_global":
                expected_block = "unverified_completion_claim"
                if row.get("required_evidence_source") != "operation_result_or_exact_limitation":
                    errors.append(f"{name}: result evidence must be scoped to the operation")
            if name == "chain.live_runtime_order_global":
                expected_block = "HIGH_execution_without_scoped_authority_or_material_requirement"
                if row.get("applies_to") != "HIGH_positive_effect_requiring_explicit_authorization":
                    errors.append(f"{name}: an order applies to HIGH effects only")
            if row.get("blocked_without_chain") != expected_block:
                errors.append(f"{name}: stop only for applicable material requirements")
    return errors


def validate_discovery_metadata(rows: list[dict]) -> list[str]:
    selected = [row for row in rows if row.get("skill_id") == "tcu-descubridor-capacidades"]
    if len(selected) != 1:
        return ["Discovery metadata must contain exactly one skill row"]
    row = selected[0]
    errors = []
    if row.get("trigger_boundary") != "unknown_ambiguous_materially_changed_or_new_capability_only":
        errors.append("Discovery metadata cannot mandate discovery for known tasks")
    blocked = set(row.get("blocked_actions", "").split("|"))
    required = {"invented_skill", "execution_without_required_capability_or_binding",
                "high_effect_without_explicit_authorization", "secret_exposure_or_materialization"}
    if blocked != required:
        errors.append("Discovery metadata must stop only unavailable capabilities, HIGH without authority or secret exposure")
    if row.get("stop_condition") != "operation_requirement_unresolved":
        errors.append("Discovery metadata stop must affect only the unresolved operation")
    return errors


def self_test(matrices: dict[str, list[dict]], metadata: list[dict]) -> list[str]:
    """Reject recurrent policy regressions against actual repository rows."""
    failures = []
    cases = [
        ("provider Microsoft blanket block", "capability", 0, "blocked_actions", "microsoft_live", True),
        ("provider OpenAI blanket block", "capability", 0, "blocked_actions", "openai_api_live", True),
        ("HIGH authorization removed", "capability", 0, "authority_policy", "NONE", False),
        ("required capability removed", "capability", 0, "blocked_actions", "secrets|high_effect_without_explicit_authorization", False),
        ("discovery for known operations", "capability", 0, "discovery_policy", "ALWAYS", False),
        ("global evidence at closeout", "chain", 0, "required_evidence_source", "global_evidence_package", False),
        ("full chain for simple READ", "chain", 0, "chain_policy", "ALL_COMPONENTS_REQUIRED", False),
        ("global stop on missing binding", "chain", 0, "missing_requirement_policy", "BLOCK_ALL_WORK", False),
        ("catalog-wide admission status", "chain", 0, "status", "ACTIVE_GLOBAL", False),
        ("autonomous Microsoft order", "autonomous", 0, "requires_order_for", "microsoft_live", True),
        ("autonomous PR order", "autonomous", 0, "requires_order_for", "github_pr_open", True),
        ("autonomous HIGH authority removed", "autonomous", 0, "requires_order_for", "", False),
        ("autonomous known binding rediscovery", "autonomous", 0, "discovery_policy", "ALWAYS", False),
        ("ordinary credential reuse made HIGH", "autonomous", 0, "requires_order_for", "secret_use", True),
        ("production label made HIGH", "autonomous", 0, "requires_order_for", "production", True),
    ]
    for label, kind, index, field, value, append in cases:
        rows = copy.deepcopy(matrices[kind])
        rows[index][field] = rows[index].get(field, "") + "|" + value if append else value
        if not validate_rows(kind, rows):
            failures.append(f"regression not rejected: {label}")
    # A resolved external path must retain both low-risk execution and HIGH authority.
    rows = copy.deepcopy(matrices["capability"])
    live = next(row for row in rows if row["stage_id"] == "capability_use.before_live_or_cost")
    live["allowed_actions"] = "prepare_HIGH_order_when_required"
    if not validate_rows("capability", rows):
        failures.append("regression not rejected: READ/LOW forced back into order preparation")
    for field, value in [("trigger_boundary", "mandatory_discovery_before_every_task"),
                         ("blocked_actions", "microsoft_live|openai_api_live|production|secrets")]:
        rows = copy.deepcopy(metadata)
        discovery = next(row for row in rows if row.get("skill_id") == "tcu-descubridor-capacidades")
        discovery[field] = value
        if not validate_discovery_metadata(rows):
            failures.append(f"regression not rejected: discovery metadata {field}")
    return failures


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=Path(__file__).resolve().parents[2] / ".agents/codex")
    parser.add_argument("--kind", choices=[*FILES, "all"], default="all")
    parser.add_argument("--self-test", action="store_true")
    args = parser.parse_args()
    kinds = list(FILES) if args.kind == "all" or args.self_test else [args.kind]
    matrices = {}
    metadata = []
    errors = []
    for kind in kinds:
        try:
            with (args.root / "matrices" / FILES[kind]).open(encoding="utf-8-sig", newline="") as stream:
                matrices[kind] = list(csv.DictReader(stream))
            errors.extend(validate_rows(kind, matrices[kind]))
        except (OSError, csv.Error) as exc:
            errors.append(f"{kind}: {exc}")
    if "capability" in kinds:
        try:
            with (args.root / "skills/SKILL_METADATA_QUALITY_MATRIX.csv").open(encoding="utf-8-sig", newline="") as stream:
                metadata = list(csv.DictReader(stream))
            errors.extend(validate_discovery_metadata(metadata))
        except (OSError, csv.Error) as exc:
            errors.append(f"discovery metadata: {exc}")
    # Baseline validity is a prerequisite for meaningful mutation tests.
    if args.self_test and not errors:
        errors.extend(self_test(matrices, metadata))
    print(json.dumps({"status": "FAIL" if errors else "PASS", "errors": errors,
                      "rows": sum(map(len, matrices.values())),
                      "negative_cases": 18 if args.self_test and not errors else 0}))
    return int(bool(errors))


if __name__ == "__main__":
    raise SystemExit(main())
