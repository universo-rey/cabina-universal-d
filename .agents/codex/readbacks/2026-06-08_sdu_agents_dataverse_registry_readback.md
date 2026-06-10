# SDU Agents Dataverse Registry Readback - 2026-06-08

## Scope

- Repo: `universo-rey/cabina-universal-d`
- Branch: `codex/sharepoint-document-inventory-20260608`
- Dataverse DEV URL: `https://org084965d9.crm.dynamics.com`
- Solution: `SDUCapabilityControlPlane`
- Table: `mon_sdu_agent_connection_mapping`
- Entity set: `mon_sdu_agent_connection_mappings`
- Source CSV: `dataverse/data/seed_sdu_agent_runtime_actions.csv`
- Batch ID: `20260608_sdu_agent_runtime_actions_registry_dev_v1`

## Registered Agents

| Agent | Canonical ID | Status |
| --- | --- | --- |
| `seshat-normativa` | `sdu.agent.seshat_normativa.runtime_actions` | `POSTCHECKED` |
| `thot-tecnico` | `sdu.agent.thot_tecnico.runtime_actions` | `POSTCHECKED` |
| `anubis-gate` | `sdu.agent.anubis_gate.runtime_actions` | `POSTCHECKED` |
| `maat-cumplimiento` | `sdu.agent.maat_cumplimiento.runtime_actions` | `POSTCHECKED` |
| `horus-riesgo` | `sdu.agent.horus_riesgo.runtime_actions` | `POSTCHECKED` |
| `narrador-normativo` | `sdu.agent.narrador_normativo.runtime_actions` | `POSTCHECKED` |

## Action Model

Each registered row stores the agent domain, owner/reviewer, allowed actions,
gated actions, blocked actions, operational surfaces, queue modes, target
Dataverse tables, risk level, active status, source path and source hash.

The action model is queue-worker oriented and does not require Power Automate
flows. The queue-facing modes are:

- `IngestSharePointEvent`
- `ProcessOneQueueItem`
- `ProcessNextQueueItem`

## Execution Evidence

1. DEV environment precheck returned `DATAVERSE_DEV_PRECHECK_PASS`.
2. Dry run returned `SDU_AGENT_RUNTIME_ACTIONS_REGISTRY_DRY_RUN_PASS`.
3. Apply returned `SDU_AGENT_RUNTIME_ACTIONS_REGISTRY_APPLY_PASS`.
4. Postcheck read each row by exact `mon_canonical_id` and verified
   `mon_source_hash`.
5. Candidate count after apply was exactly `1` for all six agents.

Validation summaries were written under:

- `dataverse/validation/sdu_agent_runtime_actions_registry_20260608/`

## Gates And Boundaries

- Gate used: `GATE_DATAVERSE_APPLY`
- Surface: Dataverse DEV only
- No Power Automate flow was created, invoked or modified.
- No SharePoint document was modified.
- No production deployment was performed.
- No secrets or tokens were printed.

## Rollback

Rollback is a governed status patch, not a physical delete:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File dataverse\scripts\invoke_sdu_agent_runtime_actions_registry_dev.ps1 -Apply -GateConfirmation 'GATE_DATAVERSE_APPLY' -Rollback
```

Rollback marks the exact `mon_canonical_id` rows as:

- `mon_status = ROLLBACK_SUPERSEDED`
- `mon_stop_condition = sdu_agent_runtime_actions_registry_rollback_marker`

Physical deletion is intentionally not part of this rollback and requires a
separate destructive-action gate.

## Stop Condition

`sdu_agent_runtime_actions_registered_postchecked`
