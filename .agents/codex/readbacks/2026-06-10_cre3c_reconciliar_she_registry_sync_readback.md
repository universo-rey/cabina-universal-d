# 2026-06-10 - SDU registry sync for cre3c-ReconciliarShe

## Context

Metadata-only sync for the SDU training front of the agent currently known in the registry as `cre3c-reconciliar-shell` / `Serafin RFA`.

## Live evidence

- Environment URL: `https://org084965d9.crm.dynamics.com`
- Exact canonical id queried: `sdu.agent.cre3c_reconciliar-shell.runtime_actions`
- Candidate count: `1`
- Live row id: `96d651ad-4f64-f111-ab0d-00224805f8f9`
- Live display name observed: `Seraf�n RFA`
- Live status: `ACTIVE_DEV`
- Live owner/reviewer: `rey.frontier_guardian`
- Live stop condition: `AGENT_CRE3C_RUNTIME_REGISTERED`

## Local sync

- Added the agent row to `dataverse/data/seed_sdu_agent_runtime_actions.csv`
- Added the expected agent entry to `scripts/validators/sdu_agent_runtime_actions_registry_validator.py`
- Validator result: `SDU_AGENT_RUNTIME_ACTIONS_REGISTRY_VALIDATOR=PASS`

## Notes

- The live display name was returned with mojibake in the shell output; the intended readable form appears to be `Serafín RFA`.
- This was a metadata-only sync. No live Dataverse write was performed in this step.

## Stop condition

`AGENT_CRE3C_RUNTIME_REGISTERED`
