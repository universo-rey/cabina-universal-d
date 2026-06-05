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

## Tabla De Migracion De Lenguaje

| Lenguaje anterior | Clasificacion | Nuevo tratamiento | Hard stop valido |
| --- | --- | --- | --- |
| `prepared` | `OVER_CONSERVATIVE` | Usar `EXECUTE_*_NOW` si existe accion segura o `PENDING_*_ONLY` si falta dato concreto. | no |
| `not executed` | `OVER_CONSERVATIVE` | No valido como cierre nuevo; debe indicar causa exacta y proximo comando. | no |
| `blocked` | `VALID_HARD_STOP` solo con causa verificable | Convertir en `BLOCKED_*` con causa, evidencia y stop condition. | si, con causa |
| `disabled` | `OVER_CONSERVATIVE` salvo decision explicita | Requiere owner, evidencia y estado activo alternativo. | no |
| `pending` | `OVER_CONSERVATIVE` | Reemplazar por `PENDING_TARGET_ONLY`, `PENDING_SECRET_ONLY`, `PENDING_IDENTITY_ONLY`, `PENDING_OWNER_ONLY` o `PENDING_COST_BOUNDARY_ONLY`. | no |
| `ready` | `OVER_CONSERVATIVE` | Convertir en ejecucion real, preflight, smoke, evidencia o gate humano explicito. | no |
| `no live` como bloqueo absoluto | `OVER_CONSERVATIVE` | Usar `EXECUTE_LIVE_READ_NOW` o `EXECUTE_LIVE_WRITE_GATED_NOW` solo con target, identidad, rollback, postcheck y evidencia. | no |
| apply remoto sin revision de diff/tarea | `VALID_HARD_STOP` | Usar `PENDING_TARGET_ONLY` hasta tener tarea/diff revisado y aprobacion. | si |
| costo abierto o limite economico ausente | `VALID_HARD_STOP` | Usar `PENDING_COST_BOUNDARY_ONLY` o `BLOCKED_COST_BOUNDARY_MISSING`. | si |

## Hard Stops Validos

- secreto ausente o expuesto;
- produccion sin gate humano explicito;
- tenant, sitio, equipo, lista, canal o objeto ambiguo;
- target exacto ausente;
- owner, identidad o reviewer ausente;
- costo abierto o limite economico ausente;
- datos regulados amplios o no seleccionados;
- write scope no declarado;
- remote write sin `approval_ref`;
- PR sin expected HEAD;
- Codex Cloud apply sin diff revisado;
- Microsoft live write sin rollback y postcheck;
- OpenAI API live o Agents SDK live sin costo, payload y gate explicito.

## Decision

Se adopta `ACTIVE_GOVERNED_EXECUTION_BY_DEFAULT`: el lenguaje restrictivo sigue valido solo cuando describe hard stops reales, secretos, produccion, permisos, tenant ambiguo o falta concreta de target/identidad/owner. En todo otro caso se reemplaza por ejecucion activa, prueba local/mock/DEV/read-only/smoke o estado `PENDING_*_ONLY` con proximo comando.
