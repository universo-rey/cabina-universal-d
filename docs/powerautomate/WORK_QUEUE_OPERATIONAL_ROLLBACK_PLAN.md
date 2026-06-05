# Work Queue Operational Rollback Plan

## Estado
WORK_QUEUE_OPERATIONAL_ROLLBACK_READY

## Scope
- Environment URL: https://org084965d9.crm.dynamics.com
- Environment ID: 7f65fc04-c27a-ea0d-bd2d-266aa9203c1e
- Pilot batch: 20260603_workqueue_pilot_dev_v1
- Queues: SDU.* DEV queues only
- Production/TEST/Default: out of scope and not touched

## Preferred Rollback
1. Reconfirm PAC/Dataverse target is the exact DEV sandbox.
2. Locate pilot queue items by uniqueidbyqueue from matrices\powerautomate\WORK_QUEUE_PILOT_RESULT.csv or by payload batch_id = 20260603_workqueue_pilot_dev_v1.
3. Cancel/deactivate pilot items if the table operation supports it; otherwise leave with processing disabled and mark rollback in evidence.
4. Do not delete queues unless a separate governed order names exact queues and postcheck.
5. Do not delete Dataverse tables, columns, prior seed rows or snapshots.
6. Disable any DEV flows if a later lane creates them. This lane created no flows.
7. Invalidate OpenAI-assisted outputs by marking downstream matrices superseded; do not delete logs/readbacks.

## Stop Condition
Stop rollback if target is Default, TEST, PROD, production-like, or if item IDs/queue IDs do not match the recorded pilot evidence.
