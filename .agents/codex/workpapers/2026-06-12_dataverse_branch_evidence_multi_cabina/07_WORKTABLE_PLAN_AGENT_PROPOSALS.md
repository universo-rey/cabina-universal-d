# Worktable Plan - Analisis de agentes y plan propuesto

Fecha: 2026-06-12

Objeto analizado:

`C:\Users\enzo1\Documents\GitHub\cabina-universal-d\.agents\codex\readbacks\2026-06-12_codex_evolutionary_attachments_worktable_plan.md`

## Agentes consultados

- `Descartes`: arquitectura evolutiva Codex.
- `Pasteur`: Dataverse / Workers.
- `Sagan`: Gate / Runtime / Distribucion.

## Dictamen consolidado

El `Codex Evolutionary Attachments Worktable Plan` es valido como paquete de
analisis, arquitectura, evidencia y preparacion. No es autorizacion de runtime,
reparto multi-cabina, Dataverse live, Microsoft live, OpenAI API live,
checkout, cherry-pick, rebase, merge, commit, push, PR ni issue.

Los ciclos A-F pueden avanzar como carril documental/evolutivo local:

1. taxonomia;
2. evidencia;
3. aprendizaje;
4. mejora;
5. prueba;
6. promocion.

El ciclo G debe quedar separado como `GATE_RUNTIME_ACTIVATION_REVIEW`.

## Plan propuesto

### Fase 1 - Inventario y taxonomia

Inventariar los 34 agentes blueprint y clasificarlos por taxonomia local:

- `operation`
- `memory`
- `improvement`
- `expansion`
- `runtime_delta`

Resultado esperado:

`CODEX_EVOLUTIONARY_BLUEPRINT_AGENT_TAXONOMY.csv`

### Fase 2 - Reconciliacion contra familias existentes

No crear identidades nuevas por defecto. Mapear cada agente blueprint a una
familia de cabina existente:

- `rey.control_plane_orchestrator`
- `court.sdu_gate`
- `court.thot_schema`
- `court.seshat_evidence`
- `rey.frontier_guardian`
- `rey.governance_registrar`
- `codex.workspace_guardian`

Estados permitidos por fila:

- `MAP_TO_EXISTING_AGENT`
- `NEW_DECLARATIVE_AGENT_CANDIDATE`
- `NO_APLICA`
- `BLOCKED_BY_GATE`

Resultado esperado:

`CODEX_EVOLUTIONARY_BLUEPRINT_AGENT_RECONCILIATION.csv`

### Fase 3 - Matriz completa agente-schema-gate

Producir matriz:

`blueprint_agent -> cabina_family -> schema/table -> queue -> gate -> stop_condition`

Schemas/tablas base:

- `sdu_agent`
- `mon_sdu_agent_connection_mapping`
- `mon_sdu_evidence`
- `mon_sdu_validation_gate`
- `mon_sdu_apply_log`

Queues base:

- `SDU.Agent.Dispatch.Queue`
- `SDU.Evidence.Publish.Queue`
- cola pendiente solo si hay target exacto.

Gates:

- `GATE_BLUEPRINT_RECONCILIATION`
- `GATE_DATAVERSE_METADATA_ONLY`
- `GATE_RUNTIME_ACTIVATION_REVIEW`

Resultado esperado:

`CODEX_EVOLUTIONARY_AGENT_SCHEMA_GATE_MATRIX.csv`

### Fase 4 - Enriquecimiento Dataverse metadata-only

Usar la capa Dataverse ya evidenciada solo como metadata y backreference:

- `sdu.agent.*.runtime_actions` como registro rector de capacidades de workers;
- `cre3c-reconciliar-shell` como worker especifico evidenciado;
- `mon_sdu_agent_connection_mapping` como tabla de backreference metadata-only;
- `SDU.Agent.Dispatch.Queue` como cola operativa referenciada, sin activar
  flows ni procesar nuevos items.

Separar cuatro carriles:

- `metadata_only`
- `workqueue_backreference`
- `DEV_gate`
- `live_blocked`

Cada cabina debe quedar en uno de estos estados:

- `NO_WRITE_ALREADY_PRESENT`
- `READY_FOR_METADATA_ONLY_GATE`
- `PENDING_TARGET_ONLY`

Resultado esperado:

`CODEX_EVOLUTIONARY_DATAVERSE_WORKER_COMPATIBILITY_MATRIX.csv`

### Fase 5 - Gate runtime y reparto por cabinas

Separar A-F de G. G no avanza sin gate humano y target exacto.

Permitido ahora:

- leer plan;
- leer matrices;
- preparar dictamen;
- comparar evidencia;
- clasificar cabinas;
- armar paquetes locales en `.codex`;
- definir validators, rollback, postcheck y matriz de targets.

Bloqueado hasta gate:

- runtime activation;
- checkout, cherry-pick, rebase, merge;
- commit, push, PR, issue;
- Dataverse live;
- Microsoft live;
- OpenAI API live;
- cambios en owners, permisos, flows, queues, environments, conexiones,
  repos regulados o produccion.

Resultado esperado:

`CODEX_EVOLUTIONARY_RUNTIME_AND_DISTRIBUTION_GATE_PACKET.md`

## Campos requeridos para cualquier target

- cabina;
- repo;
- ruta local;
- rama base;
- rama trabajo;
- archivo destino;
- owner;
- reviewer;
- write scope;
- evidence path;
- validator;
- rollback;
- postcheck;
- environment URL DEV si aplica;
- tabla o cola;
- record scope;
- candidate count.

## Riesgos consolidados

- duplicar agentes;
- activar runtime por arrastre;
- escribir en Dataverse sin target exacto;
- mezclar evidencia historica con estado actual;
- inferir targets por nombre;
- tocar Default, TEST o PROD;
- activar flows;
- procesar colas reales;
- convertir evidencia historica en permiso live;
- repartir a cabinas externas sin target matrix.

## Stop conditions

- `no_cross_cabina_write_without_target_matrix`
- `candidate_count_not_one`
- `runtime_activation_without_gate`
- `target_identity_ambiguous`
- `wrong_environment_or_default`
- `rollback_missing`
- `postcheck_missing`
- `runtime_gate_missing`

## Primer deliverable recomendado

Crear un CSV de 34 filas con mapping completo y decision por agente:

`CODEX_EVOLUTIONARY_BLUEPRINT_AGENT_RECONCILIATION.csv`

Ese deliverable debe ser local y preparatorio. No debe activar runtime ni
escritura Dataverse.
