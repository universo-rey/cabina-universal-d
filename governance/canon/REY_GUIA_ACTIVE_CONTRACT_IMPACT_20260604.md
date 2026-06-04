# REY_GUIA_ACTIVE_CONTRACT_IMPACT_20260604

Fecha: 2026-06-04

## Dictamen

El nuevo contrato operativo `ACTIVE_GOVERNED_EXECUTION_BY_DEFAULT` cambia el cierre del paquete Rey-Guia. La reconciliacion ya no debe quedar como paquete documental local "preparado"; debe convertirse en carriles activos, reversibles, trazables y validables cuando la accion sea local, mock, DEV, read-only o preflight.

No cambia los bloqueos de fondo: Microsoft live write, produccion, permisos, secretos, costos abiertos, datos regulados amplios, OpenAI API live sin gate y agentes productivos siguen requiriendo orden gobernada exacta.

## Impacto principal

| Area | Antes | Con contrato activo | Estado activo recomendado | Accion segura inmediata |
| --- | --- | --- | --- | --- |
| Paquete Rey-Guia en `D:\docs` | Cerrado localmente pero ignorado por Git | No basta como cierre durable | EXECUTE_LOCAL_NOW | Crear artefacto versionable en `D:\governance\canon` |
| Matriz maestra en `D:\matrices` | CSV local parseable, ignorado por Git | Debe tener copia o puntero durable allowlisted | EXECUTE_LOCAL_NOW | Mantener CSV local y registrar impacto/versionable aqui |
| Backlog | Tareas documentales separadas | Cada tarea debe tener estado activo o causa `PENDING_*_ONLY` | EXECUTE_LOCAL_NOW / PENDING_TARGET_ONLY | Reescribir prioridades como carriles activos |
| Decisiones humanas | Lista separada | Correcto, pero cada decision debe indicar si bloquea ejecucion o solo publicacion | PENDING_OWNER_ONLY | Resolver marca Rey, SEI, Centro Editorial, producto |
| Dataverse V2 | Brecha documentada | Hay accion local segura: disenar matriz V2 sin apply live | EXECUTE_LOCAL_NOW | Crear matriz semantica V2 local/versionable |
| Agentes | Reutilizar agentes existentes | Correcto; no crear agentes nuevos si alcanza con roles/recetas | EXECUTE_LOCAL_NOW | Consolidar mapa Corte/Rey -> SDU-CN/CDF |
| SEI | `EXISTE_PARCIAL` | No crear piloto; falta decision de rol | PENDING_OWNER_ONLY | Enzo decide vigente/historico/archivo |
| Centro Editorial ON | `FALTA_DECISION` | No crear marca productiva; puede quedar backlog | PENDING_OWNER_ONLY | Enzo decide frente/backlog/archivo |
| Integracion Git | Pendiente por allowlist | Debe pasar a carril activo repo-scoped | EXECUTE_LOCAL_NOW | Crear branch/PR solo si Enzo abre carril versionado |

## Cambios de criterio

1. `ABIERTO` o `EN_CURSO` ya no alcanzan como estados finales.
2. Todo carril debe mapear a un estado activo canonico: `EXECUTE_LOCAL_NOW`, `PENDING_TARGET_ONLY`, `PENDING_OWNER_ONLY`, `READY_FOR_PROD_HUMAN_GATE` u otro estado exacto.
3. Un documento preparado no cuenta como evidencia de ejecucion si existe una accion local verificable pendiente.
4. Los artefactos en rutas ignoradas por Git sirven como evidencia local, pero no como canon versionable.
5. El siguiente cierre correcto es una matriz de ejecucion activa Rey-Guia con estado, proximo comando y validador por carril.

## Proximo paso recomendado

Crear `REY_GUIA_ACTIVE_EXECUTION_QUEUE_20260604.csv` en `D:\governance\canon` con estos carriles minimos:

- `rey_guia.versionable_canon_pointer`
- `rey_guia.dataverse_v2_semantic_matrix`
- `rey_guia.agent_delegation_consolidation`
- `rey_guia.decisions_owner_review`
- `rey_guia.product_package_map`

Ese paso es local, seguro, reversible y validable. No requiere Microsoft live, OpenAI API live, produccion ni repos anidados.

## Stop condition

Detener cualquier subpaso que requiera target live, permiso, secreto, produccion, tenant ambiguo, datos regulados amplios o escritura remota no aprobada.
