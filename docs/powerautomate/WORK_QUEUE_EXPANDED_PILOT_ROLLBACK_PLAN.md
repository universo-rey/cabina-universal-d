# Work Queue Expanded Pilot Rollback Plan

## Estado
WORK_QUEUE_EXPANDED_PILOT_ROLLBACK_PREPARED_NOT_EXECUTED

## Alcance
Rollback solo para los ítems creados por el batch 20260603_workqueue_expanded_pilot_dev_v1 con prefijo idempotente 20260603_wqexp_v1.

## Target
- Environment ID: 7f65fc04-c27a-ea0d-bd2d-266aa9203c1e
- Organization ID: f982db28-49e3-f011-aa23-000d3a5ca83f
- New items created: 225

## Rollback
- Revalidar ambiente DEV por WhoAmI.
- Consultar solo workqueueitems cuyo uniqueidbyqueue empiece con 20260603_wqexp_v1.
- Eliminar solo esos ítems si existe orden posterior explícita.
- No borrar los 25 ítems piloto previos.
- No tocar PROD, TEST ni Default.
- Postcheck: agregado por prefijo idempotente queda en 0 y no quedan flows activos.

## Bloqueado
- Deletes ciegos.
- Rollback sin orden posterior explícita.
- Ambigüedad de prefijo o ambiente.
- Secretos, PII, documentos, SharePoint items, Planner tasks o Graph dumps.

## Stop Condition
item_identity_ambiguous_or_wrong_environment_or_secret_or_pii_or_delete_scope_unclear
