# Back-Reference Runtime Closure Rollback Plan

## Estado
HECHO_VERIFICADO: BACK_REFERENCE_RUNTIME_CLOSURE_ROLLBACK_READY

## Scope
- Environment: DEV only.
- Mapping table used: mon_sdu_agent_connection_mapping.
- Mapping record created: 408f3320-615f-f111-a826-00224805f8f9.
- Target final record updated: none.
- Schema patch applied: none.
- Additional Work Queue item processed: none.
- Flows activated: none.

## Rollback Strategy
Deletion is not part of the default rollback because this lane is governed by a
no-delete rule. If rollback is ordered, invalidate the mapping record with a
metadata-only update:

- mon_dispatch_status = rollback_invalidated
- mon_dispatch_result = invalidated_by_governed_rollback
- mon_queue_stop_condition = rollback_requested
- mon_last_queue_sync_at = rollback timestamp

## Flow Safety
If a future rollback touches flows, first verify the 9 manifest workflow ids and
then ensure every one is left at statecode=0 and statuscode=1.

## Git Rollback
Open a revert PR against the branch commit that introduces this closure
evidence if the versioned evidence must be removed from main.

## Stop Condition
Stop if rollback would delete data, delete schema, touch PROD/TEST/Default,
change permissions, print secrets or infer a target record.
