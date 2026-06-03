# Dataverse Queue Back-Reference Rollback Plan

## Estado
DATAVERSE_QUEUE_BACK_REFERENCE_ROLLBACK_PREPARED_NOT_EXECUTED

## Alcance
Rollback solo para columnas de back-reference creadas en DEV dentro de SDUCapabilityControlPlane.

## Columnas
- mon_queue_name
- mon_queue_item_id
- mon_queue_item_status
- mon_correlation_id
- mon_idempotency_key
- mon_dispatch_batch_id
- mon_dispatch_status
- mon_dispatched_at
- mon_dispatch_result
- mon_last_queue_sync_at
- mon_queue_stop_condition
- mon_ai_assisted
- mon_ai_validation_status

## Reglas
- No ejecutar rollback sin orden posterior explícita.
- No borrar registros.
- No tocar PROD, TEST ni Default.
- No tocar columnas fuera de la matriz de aplicación.
- Antes de rollback, exportar solución unmanaged y verificar dependencias.
- Postcheck de rollback: metadata attribute missing only for explicitly targeted created columns.

## Evidencia de base
- Created in continuation: 29
- Existing before continuation/found in postcheck: 257
- Apply result: D:\matrices\dataverse\DATAVERSE_QUEUE_BACK_REFERENCE_COLUMN_APPLY_RESULT.csv

## Stop Condition
rollback_target_ambiguous_or_dependency_detected_or_wrong_environment_or_secret
