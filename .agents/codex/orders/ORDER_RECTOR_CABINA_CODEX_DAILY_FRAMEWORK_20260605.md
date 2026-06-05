# Orden rectora diaria - Cabina Codex - 2026-06-05

estado: `DRAFT_RECTOR_ORDER_LOCAL_VALIDATED`
gate: `GATE_CABINA_DAILY_RECTOR_FRAMEWORK_20260605`
superficie: repo-scoped local, bibliotecas locales SGSD read-only, GitHub canon read-only/write repo-scoped bajo rama `codex/*`

## Mision del dia

Levantar el framework operativo de la Cabina Codex para decidir y ejecutar con evidencia sobre los carriles foco del dia:

- `SeshatSgin/cdf-soluciones`
- `SeshatSgin/torre-gemela-escribania`
- `SeshatSgin/seshat-bootstrap-sdu-cn`
- `SeshatSgin/tge-agentic-runtime-control-escribania`
- `universo-rey/organizacion`

La cabina `universo-rey/cabina-universal-d` actua como control plane: interpreta, valida, registra ordenes, emite readbacks y gobierna gates. No reemplaza el canon nativo de cada repo.

## Regla rectora

GitHub canon -> Cabina Codex interpreta y valida -> Dataverse modela estado y relaciones -> Work Queue organiza tareas -> Power Automate ejecuta solo con gate.

## Agentes obligatorios

Todo carril debe usar agentes por defecto:

- `rey.control_plane_orchestrator`: intake, clasificacion y despacho.
- `rey.frontier_guardian`: frontera, riesgo, gate y stop condition.
- `court.seshat_evidence`: evidencia, readback, memoria declarativa.
- `court.sdu_gate`: criterio canonico, aprobacion, bloqueo y escalamiento.
- `court.thot_schema`: metadata, Dataverse, matrices, schemas y validators.
- `rey.authority_canonist`: actas, canon, decisiones y contradicciones.

## Carriles aprobados ahora

1. Versionar lectura de bibliotecas locales SGSD en matriz/readback repo-scoped.
2. Preparar acta u orden rectora del dia en la cabina.
3. Leer bibliotecas locales SGSD operativas adicionales solo en modo read-only y saneado.
4. Preparar mapa de decisiones para Dataverse y Work Queue sin ejecutar writes live.
5. Preparar paquetes de siguiente gate por repo foco sin merge, produccion, secretos ni live write.
6. Reconciliar drift local SGSD detectado sin live: conexiones `62/63`, tareas Planner `4/5` y Copilot `ready-not-live`.

## Evidencia SGSD local incorporada

La lectura local saneada de `LIB_SGSD_Postchecks`, `LIB_SGSD_Paquetes_Activacion` y `LIB_SGSD_Evidencias` confirma:

- SGSD-TC tiene evidencia historica de operacion SharePoint: corpus publicado, home activa, navegacion aditiva, 20/20 archivos verificados, listas/bibliotecas linkeadas, evidencia live item `12` y readback item `6`.
- Estado operativo honesto: `SGSD_TC_SUBSISTEMA_SDU_OPERATIONAL_WITH_POWER_PLATFORM_COPILOT_BLOCKERS`.
- Copilot queda `ready-not-live`: 7 agentes empaquetados, 0 copilots/topics live creados, proximo paso dry-run/revision de template antes de `pac create`.
- Backlog de automatizacion: 5 carriles utiles, todos requieren gates de SharePoint/Power Automate write.
- Drift menor pendiente: una evidencia registra 62 conexiones y 4 tareas Planner; postcheck posterior registra 63 conexiones y 5 tareas.

## Bloqueos y gates

No ejecutar sin gate humano:

- SharePoint, Teams, Planner, Graph, Dataverse o Power Platform write.
- Produccion, tenant, permisos, identidades, consentimientos o admin.
- Secretos, certificados, tokens, claves, cookies o connection strings.
- Datos regulados amplios, protocolo, escrituras, CED o expedientes.
- Merge a `main`, force push, borrado de ramas, cambio de remotos o `core.worktree`.

Gates requeridos:

- `GATE_DATA_REGULATED`
- `GATE_SECRET_USE`
- `GATE_TENANT_IDENTITY`
- `GATE_MICROSOFT_LIVE_WRITE`
- `GATE_POWER_PLATFORM_APPLY`
- `GATE_DATAVERSE_APPLY`
- `GATE_MERGE_MAIN`

## Criterios de cierre del dia

- Cada carril tiene agente, skill, receta, tool, superficie, evidencia, validador y stop condition.
- Cada decision distingue canon tecnico GitHub, verdad operativa SharePoint/SGSD y metadata Dataverse.
- Toda ejecucion live queda preparada, no ejecutada, salvo gate explicito con target, owner, rollback, postcheck y evidencia.
- Toda lectura local queda saneada y no incluye secretos ni datos regulados amplios.
- La cabina produce readback accionable con proximos carriles.
