# PR64_MERGE_ROLLBACK_PLAN

## Estado
ROLLBACK_PLAN_READY_NOT_EXECUTED

## Target
- Repo: universo-rey/cabina-universal-d
- Base: main
- Merge commit to revert if required: 222ba2e3f7dea64ad773b9896949d8c386d67a37
- PR: https://github.com/universo-rey/cabina-universal-d/pull/64

## Boundary
- Rollback is GitHub repo-scoped only.
- No force push.
- No direct push to main.
- No remote branch deletion.
- No Dataverse live rollback unless separately authorized with target, owner, rollback and postcheck.
- No Power Automate live rollback unless separately authorized with target, owner, rollback and postcheck.
- No OpenAI API, Batch API, Microsoft live, PROD, TEST, Default or permission changes.

## Procedure
1. Confirm main is aligned with origin/main.
2. Create branch codex/revert-pr64-20260603 from main.
3. Run git revert -m 1 222ba2e3f7dea64ad773b9896949d8c386d67a37.
4. Run validators proportional to the revert:
   - git diff --check
   - Dataverse manifest validator
   - CSV versioning parse
   - local_validate_agent_layer.ps1
   - local_validate_operational_chain.ps1
   - local_validate_capability_use_hardening.ps1
   - local_run_governance_validation_suite.ps1
   - Change-Aware Full-Coverage Orchestrator
   - material secret scan
5. Stage explicit revert files only.
6. Commit the revert.
7. Push the branch normally.
8. Open PR against main.
9. Merge only after fixed-head precheck, clean merge state and green checks.

## Postcheck
- PR #64 changes absent from main after revert merge.
- main local aligned with origin/main.
- validators PASS.
- no secrets printed or persisted.
- no external live mutation executed.

## Stop Conditions
- rollback_target_ambiguous
- revert_conflict_outside_scope
- validator_failed
- secret_detected
- live_target_missing
- rollback_or_postcheck_missing
