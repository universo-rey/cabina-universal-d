# One Flow One Item Live Pilot Readback - 2026-06-08

## Scope

- repo: universo-rey/cabina-universal-d
- branch: codex/sharepoint-document-inventory-20260608
- environment: HUBDesarrollo / Dataverse DEV
- queue: SDU.Agent.Dispatch.Queue
- queue key: sdu_agent_dispatch_queue
- mode: governed live DEV pilot
- sharepoint write: false
- token printed: false

## Exact Document

- file: SGSD_TC_SHAREPOINT_DATAVERSE_ALIGNMENT_DECISION_20260522.md
- site: https://escribaniabitsch.sharepoint.com/sites/Soporte-Gobierno-Sistema-Declarativo-Torre-Control
- library: LIB_SGSD_Modelo_SDU
- source artifact canonical id: spdoc.1fca431a960b82ca
- source artifact row id: f5ab8b40-7963-f111-ab0d-00224805fc91

## Exact Queue Item

- workqueue id: 310d36ee-3f5f-f111-a826-00224805f8f9
- workqueueitem id: 06ac8b40-7963-f111-ab0d-00224805fc91
- item name: queue.sdu_agent_dispatch.anubis-gate.spdoc.1fca431a960b82ca
- assigned agent: anubis-gate
- queue item type: AGENT_DISPATCH

## Exact Flow Object

- flow name: SDU_Work_Queue_Agent_Dispatcher
- workflow id: 7c838398-515f-f111-a826-00224805f8f9
- candidate count: 1
- action: detected only; not activated and not invoked by this pilot
- operator correction: flows are not required for this phase; the operational
  core is the Dataverse tables plus the existing Work Queue item surface.

## Execution

1. Dataverse DEV precheck passed with explicit environment, tenant, publisher and solution inputs.
2. Resolved SDU.Agent.Dispatch.Queue by exact workqueuekey; candidate count was 1.
3. Initial workqueue item query for that queue returned count 0.
4. Ingested the exact SharePoint document reference through Invoke-SduSharePointDataverseLiveBridge.ps1.
5. Created or upserted mon_sdu_source_artifact with status Pending.
6. Created one workqueueitem in SDU.Agent.Dispatch.Queue.
7. Resolved the workqueueitem by exact name; candidate count was 1.
8. Processed only that workqueueitem through ProcessOneQueueItem.
9. Persisted one mon_sdu_evidence row for the agent result.
10. Patched the source artifact status to Completed by exact row id.

## Postcheck

- mon_sdu_source_artifact count by canonical id: 1
- mon_sdu_source_artifact status: Completed
- mon_sdu_source_artifact stop condition: live_one_flow_one_item_pilot_completed_postchecked
- workqueueitem count by id: 1
- workqueueitem statecode/statuscode observed: 0 / 0
- mon_sdu_evidence count by canonical id: 1
- mon_sdu_evidence canonical id: agentresult.anubis-gate.7054f958bdfd69ee
- mon_sdu_evidence status: Completed
- mon_sdu_evidence type: live_agent_result
- mon_sdu_evidence owner: anubis-gate

## Rollback

Rollback is non-destructive and limited to the exact pilot rows:

1. Patch mon_sdu_source_artifact f5ab8b40-7963-f111-ab0d-00224805fc91 back to:
   - mon_status = Pending
   - mon_stop_condition = live_one_flow_one_item_pilot_rollback_marker
2. Cancel or deactivate exact workqueueitem 06ac8b40-7963-f111-ab0d-00224805fc91 if operational policy requires queue cleanup.
3. Patch mon_sdu_evidence 09078558-7963-f111-ab0d-00224805f8f9 to:
   - mon_status = ROLLBACK_SUPERSEDED
   - mon_stop_condition = live_one_flow_one_item_pilot_rollback_marker
4. Do not physically delete rows without a separate destructive gate.

## Limits

- The pilot did not modify SharePoint content.
- The pilot did not perform broad document reading.
- The pilot did not activate the Power Automate cloud flow.
- The live processing was executed by the governed bridge script against exactly one Dataverse queue item.
- Follow-up flow activation was explicitly canceled after operator correction;
  postcheck confirmed the dispatcher remained Draft (`statecode=0`, `statuscode=1`).

## Bridge Hardening Follow-Up

- The bridge now operates as a Dataverse Work Queue worker with `flow_dependency=false`.
- Supported worker modes:
  - `ProcessOneQueueItem` by exact `QueueItemId` or exact `QueueItemName`.
  - `ProcessNextQueueItem` only when the queue filter returns exactly one active candidate.
- The worker validates:
  - exact queue key and queue name,
  - item membership in `SDU.Agent.Dispatch.Queue`,
  - required `AGENT_DISPATCH` input fields,
  - `source_artifact_canonical_id`,
  - target environment id,
  - created-by system marker.
- Stop conditions added:
  - `workqueue_candidate_count_not_one`
  - `queue_item_candidate_count_not_one`
  - `queue_next_item_candidate_count_not_one`
  - `queue_item_wrong_queue`
  - `queue_input_field_missing`
- The validator now fails if the bridge depends on `SDU_Work_Queue_Agent_Dispatcher`.
