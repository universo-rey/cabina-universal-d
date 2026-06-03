# CANON_CONSERVATIVE_LANGUAGE_AUDIT_20260603

Estado: `CANON_CONSERVATIVE_LANGUAGE_AUDIT_COMPLETE`

## Alcance

Auditoria sobre lenguaje vivo de canon, matrices, rutas, workflows y politicas. No modifica readbacks historicos. Los readbacks historicos conservan su evidencia contextual; los nuevos cierres deben usar estados activos con causa y comando exacto.

## Hallazgos

| source | current_language | classification | active_status | action |
| --- | --- | --- | --- | --- |
| `AGENTS.md` | `preparada y no ejecutada`; `no live sin gate`; `ENABLED_GOVERNED_GATED_NOT_EXECUTED` | `OVER_CONSERVATIVE` | `EXECUTE_*_NOW` o `PENDING_*_ONLY` | Agregar seccion de canon activo que obliga ejecutar subpasos seguros y reemplazar cierres pasivos por estado activo con proximo comando. |
| `02_AUTHORITY_CANON/CURRENT_STATE.md` | Microsoft/Teams/SharePoint/Planner/Graph/Power Platform/produccion como `ENABLED_GOVERNED_GATED_NOT_EXECUTED` | `OVER_CONSERVATIVE` | `EXECUTE_LIVE_READ_NOW`, `EXECUTE_LIVE_WRITE_GATED_NOW`, `READY_FOR_PROD_HUMAN_GATE`, `PENDING_TARGET_ONLY` | Mantener frontera, pero declarar ejecucion activa por defecto cuando target/identidad/rollback/postcheck existan. |
| `.agents/codex/agents.json` | `no_live_writes_without_governed_order`, `codex_cloud_policy=...NO_LIVE_NO_PRODUCTION` | `OVER_CONSERVATIVE` | `ACTIVE_GOVERNED_EXECUTION_BY_DEFAULT` | Agregar politica de ejecucion activa: no live write ciego, pero si live gated con campos completos. |
| `.agents/codex/routing.json` | Rutas generales sin estados `execute_*_now` | `OVER_CONSERVATIVE` | `EXECUTE_LOCAL_NOW` etc. | Agregar rutas activas reutilizando la cadena estandar; no crear agentes nuevos. |
| `governance/connections/SDU_AGENT_MCP_CONNECTION_POLICY_20260603.md` | "herramientas con escritura quedan bloqueadas" | `OVER_CONSERVATIVE` | `EXECUTE_MCP_READ_PROBE_NOW` / `EXECUTE_LIVE_WRITE_GATED_NOW` | Agregar politica MCP activa: read probe ahora, write solo cuando target/rollback/postcheck esten completos. |
| `governance/codex-cloud/SDU_CODEX_CLOUD_DEV_ACTIVATION_PLAN_20260603.md` | Codex Cloud "preparado como plantilla"; apply bloqueado | `OVER_CONSERVATIVE` para smoke, `VALID_HARD_STOP` para apply sin revision | `EXECUTE_CODEX_CLOUD_SMOKE_NOW` / `PENDING_TARGET_ONLY` | Ejecutar smoke no-diff si hay environment; mantener apply como gate con tarea/diff revisados. |
| `governance/teams/SDU_TEAMS_IDENTITY_DEV_TARGET_MATRIX_20260603.csv` | placeholders `[TEAMS_APP_ID]`, `[BOT_ID]`, `[TARGET_CHAT_OR_CHANNEL_ID]` | `VALID_HARD_STOP` para install/message real | `EXECUTE_DEV_NOW` para validacion, `PENDING_TARGET_ONLY` para install/message | Ejecutar validadores DEV ahora; no enviar mensaje ni instalar app hasta target exacto. |
| `validation/**` y readbacks historicos | `blocked`, `not executed`, `disabled`, `pending` | `HISTORICAL_EVIDENCE` | no aplica | No reescribir historicos; los nuevos validadores solo bloquean cierres pasivos en artefactos activos nuevos. |

## Decision

Se adopta `ACTIVE_GOVERNED_EXECUTION_BY_DEFAULT`: el lenguaje restrictivo sigue valido solo cuando describe hard stops reales, secretos, produccion, permisos, tenant ambiguo o falta concreta de target/identidad/owner. En todo otro caso se reemplaza por ejecucion activa, prueba local/mock/DEV/read-only/smoke o estado `PENDING_*_ONLY` con proximo comando.
