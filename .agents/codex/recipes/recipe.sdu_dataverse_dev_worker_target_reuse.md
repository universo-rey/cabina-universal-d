# recipe.sdu_dataverse_dev_worker_target_reuse

## Purpose

Reuse the already verified SDU Dataverse DEV worker target packet so the next
lane does not repeat PAC profile discovery, exact flow lookup, exact queue
lookup, or global validators when nothing changed.

## Inputs

- `.agents/codex/evals/results/sdu_dataverse_dev_worker_target_latest.json`
- `powerplatform/settings/deployment-settings.dev.json`
- `powerplatform/flows/dev-disabled-flow-manifest.yml`
- `powerplatform/workqueues/workqueue.manifest.yml`

## Steps

1. Read the cached target packet with
   `tool.sdu_dataverse_dev_worker_target_cache`.
2. Confirm the requested worker is
   `SDU_Process_Dataverse_Apply_Work_Items`.
3. Confirm the requested queue is `SDU.Dataverse.Apply.Queue`.
4. If the cache reports `NO_OP_LISTO_ALREADY_ACTIVE`, do not call PAC and do
   not activate the flow again.
5. If the cache is missing, stale for the requested ids, or contradictory,
   run one exact live read only against the named DEV environment.
6. If a write becomes necessary, execute only the named worker action and
   return to the normal live activation skill boundary.

## Gates

- Do not use `SDU-DATAVERSE-DEV` while it points to a Default environment.
- Do not call `pac org fetch` when the cache already proves active state.
- Do not rerun full agent-layer or global validators for unchanged target
  evidence.
- Do not activate any sibling flow or queue.

## Validators

- Focal target-cache existence check.
- `git diff --check` when files changed.
- Skill metadata validator only when skill metadata changed.

## Rollback

No live write occurs on cache reuse. If a future write is executed, rollback is
the exact flow disable command for workflow
`65468687-515f-f111-a826-00224805fc91`.

## Stop Condition

`candidate_count_not_one`
