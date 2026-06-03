# First Propagation Validation Report

## Estado
FIRST_SKILL_RECIPE_AGENT_PROPAGATION_VALIDATION_PASS

## Base
- Cabina main synced after PR70 merge: 9264e20067cdc4bb8d4f09fbd2a4909acc12a327.
- Working branch: codex/first-skill-recipe-agent-propagation-20260603.
- Nested repo branch: codex/adopt-learned-skills-recipes-20260603.

## Cabina Root Validation
- CSV parse: PASS for FIRST_PROPAGATION_TARGET_SELECTION_MATRIX.csv, rows=12.
- CSV parse: PASS for CABINA_PROPAGATION_APPLY_RESULT.csv, rows=5.
- git diff --check: PASS.
- local_validate_skill_recipe_agent_learning.ps1: PASS, files=22.
- local_run_governance_validation_suite.ps1: PASS, 19/19.
- local_run_change_aware_full_coverage_orchestrator.ps1: PASS, 19/19.
- coverage_equivalence: true.
- all_required_passed: true.
- blocked_surfaces_clear: true.
- no_hidden_flaky: true.
- material secret scan: PASS, 0 matches.

## Organizacion Repo Validation
- repo: universo-rey/organizacion.
- branch: codex/adopt-learned-skills-recipes-20260603.
- git diff --check: PASS.
- PYTHONPATH=src python -m tge_controlplane.cli validate: PASS.
- PYTHONPATH=src python -m tge_controlplane.cli validate-d-repo-agent-layers: PASS.
- PYTHONPATH=src python -m tge_controlplane.cli validate-manifest: PASS.
- PYTHONPATH=src python -m tge_controlplane.cli scan-secrets: PASS.
- PYTHONPATH=src python -m pytest -q: PASS, 22 tests.

## Not Executed
- Dataverse live.
- Power Automate live.
- OpenAI API.
- Batch API.
- SharePoint.
- Planner.
- broad Graph.
- PROD.
- TEST.
- Default.
- production.
- propagation to unselected repos.
- secrets.

## Rollback
- Cabina: revert the first propagation evidence PR.
- Organizacion: revert the repo-native propagation PR.

## Stop Condition
Do not merge first propagation PRs without explicit later order, clean checks
and repo-specific precheck.
