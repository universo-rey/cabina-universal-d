# DEV Disabled Flow Rollback Plan

## Estado
DEV_DISABLED_FLOW_ROLLBACK_PREPARED_NOT_EXECUTED

## Alcance
Aplica solo a los 9 workflows creados via Dataverse Web API en DEV y registrados en D:\matrices\powerautomate\DEV_DISABLED_FLOW_CREATION_RESULT.csv.

## Target
- Environment ID: 7f65fc04-c27a-ea0d-bd2d-266aa9203c1e
- Solution: SDUCapabilityControlPlane
- API surface: Dataverse Web API workflows

## Rollback
- Revalidar ambiente DEV por WhoAmI.
- Revalidar que cada workflowid objetivo sigue statecode=0.
- Eliminar solo workflows cuyo nombre y workflowid coincidan con la matriz de resultado.
- No borrar flows fuera de la matriz.
- No tocar PROD, TEST ni Default.
- Postcheck: los 9 workflowids no existen y no hay flows activos residuales.

## Bloqueado
- Deletes ciegos.
- Rollback sin orden posterior explícita.
- Activar triggers.
- Secretos o ambiente incorrecto.

## Stop Condition
flow_identity_ambiguous_or_wrong_environment_or_active_trigger_or_secret
