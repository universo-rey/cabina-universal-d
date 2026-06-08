# Dataverse Queue Worker Consumption Readback - 2026-06-08

## Scope

- Repo: `universo-rey/cabina-universal-d`
- Branch: `codex/sharepoint-document-inventory-20260608`
- Dataverse DEV URL: `https://org084965d9.crm.dynamics.com`
- Work Queue: `SDU.Agent.Dispatch.Queue`
- Work Queue key: `sdu_agent_dispatch_queue`
- Worker: `sdu_dataverse_queue_worker`
- SharePoint reference site:
  `https://escribaniabitsch.sharepoint.com/sites/Soporte-Gobierno-Sistema-Declarativo-Torre-Control`

## Item Consumed

- Work queue item ID: `06ac8b40-7963-f111-ab0d-00224805fc91`
- Work queue item name:
  `queue.sdu_agent_dispatch.anubis-gate.spdoc.1fca431a960b82ca`
- Agent: `anubis-gate`
- Agent runtime registry row:
  `sdu.agent.anubis_gate.runtime_actions`
- Source artifact canonical ID: `spdoc.1fca431a960b82ca`
- Evidence canonical ID: `agentresult.anubis-gate.7054f958bdfd69ee`

## Execution Model

The worker consumes `workqueueitems` directly from Dataverse:

1. Resolve exact work queue by `workqueuekey`.
2. Resolve exact queue item by name or ID.
3. Validate queue item is `En cola`.
4. Validate payload shape and target environment.
5. Validate the assigned agent exists in `mon_sdu_agent_connection_mapping`.
6. Validate the agent permits the requested queue mode.
7. Validate source artifact candidate count is exactly one.
8. Claim the queue item by setting it to `Procesando`.
9. Persist agent evidence in `mon_sdu_evidence`.
10. Patch source artifact status to `Completed`.
11. Complete the queue item as `Procesado`.

No Power Automate flow was created, invoked or modified.

## Postcheck

- Queue item state/status: `2 / 2` (`Procesado`)
- Queue item `completedon`: `2026-06-08T21:02:33Z`
- Source artifact candidate count: `1`
- Source artifact status: `Completed`
- Source artifact stop condition:
  `dataverse_queue_worker_item_completed_postchecked`
- Evidence candidate count: `1`
- Evidence status: `Completed`
- Evidence owner: `anubis-gate`
- Tokens printed: `false`
- SharePoint write: `false`
- Flow dependency: `false`

## Rollback

Rollback is a governed exact-row patch:

1. Patch exact workqueue item `06ac8b40-7963-f111-ab0d-00224805fc91` back to
   `statecode=0`, `statuscode=0`, clear or supersede `completedon`, and record
   rollback in `processingresult`.
2. Patch exact source artifact `spdoc.1fca431a960b82ca` back to `Pending` with
   rollback stop condition.
3. Patch exact evidence row `agentresult.anubis-gate.7054f958bdfd69ee` to
   `ROLLBACK_SUPERSEDED`; do not physically delete without separate destructive
   gate.

Physical deletion is intentionally out of scope.

## Stop Condition

`dataverse_queue_worker_item_completed_postchecked`
