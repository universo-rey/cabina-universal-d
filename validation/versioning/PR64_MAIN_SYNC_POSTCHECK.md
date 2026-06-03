# PR64_MAIN_SYNC_POSTCHECK

## Estado
PR64_MAIN_SYNC_POSTCHECK_PASS

## Merge
- Repo: universo-rey/cabina-universal-d
- PR: https://github.com/universo-rey/cabina-universal-d/pull/64
- PR state: MERGED
- Merge commit: 222ba2e3f7dea64ad773b9896949d8c386d67a37
- Authorized head: 404ae78baf12e507b667dfe90646a6fb1b5c6c0d
- Merge strategy: merge commit
- Squash: no
- Rebase: no
- Remote branch deleted: no

## Main Sync
- Local branch: main
- Local HEAD: 222ba2e3f7dea64ad773b9896949d8c386d67a37
- origin/main: 222ba2e3f7dea64ad773b9896949d8c386d67a37
- Alignment: PASS

## Post-Merge Validators
- git diff --check: PASS_WITH_LINE_ENDING_WARNING_ONLY
- Dataverse manifest validator: PASS
- CSV versioning parse: PASS, 2 files
- local_validate_agent_layer.ps1: PASS
- local_validate_operational_chain.ps1: PASS
- local_validate_capability_use_hardening.ps1: PASS
- local_run_governance_validation_suite.ps1: PASS, 19/19
- local_validate_change_aware_full_coverage_orchestrator.ps1: PASS
- Change-Aware Full-Coverage Orchestrator: PASS, 19/19 required

## Coverage And Gates
- all_required_passed: true
- coverage_equivalence: true
- manifest_valid: true
- graph_valid: true
- no_hidden_flaky: true
- blocked_surfaces_clear: true

## Secret Boundary
- Merge commit files scanned: 170
- Material secret findings: 0
- D:/.env.local: ignored by Git
- Secrets printed: no

## Surfaces Not Executed
- Dataverse live: no
- Power Automate live: no
- OpenAI API live: no
- Batch API: no
- Microsoft live: no
- PROD: no
- TEST: no
- Default: no
- Permissions: no
- Production: no

## Local Evidence State
- Local evidence artifacts were created after merge and intentionally not committed.
- Additional branch/PR for post-merge evidence requires explicit authorization.
