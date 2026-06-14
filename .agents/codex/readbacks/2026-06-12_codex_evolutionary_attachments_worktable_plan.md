# Codex Evolutionary Attachments Worktable Plan

## Estado

`CODEX_EVOLUTIONARY_ATTACHMENTS_ANALYZED_LOCAL_PLAN_READY`

## Orden

Preparar una mesa de trabajo entre agentes para analizar:

- `C:/Users/enzo1/Downloads/codex_evolutionary_runtime_activation_v2.zip`
- `C:/Users/enzo1/Downloads/codex_evolutionary_blueprint_package.zip`

No se extrajeron ejecutables, no se ejecuto runtime, no se modifico `.codex`
home, no se toco Dataverse live, Microsoft live, OpenAI API live, GitHub
remoto, produccion, permisos ni secretos.

## Evidencia de adjuntos

| Paquete | SHA256 | Entradas |
| --- | --- | ---: |
| codex_evolutionary_runtime_activation_v2.zip | 556A97298B9B3EFD3D8A02F3B9E58086EA7224BEB88C58FA9FDAAFB3E7748AD2 | 6 |
| codex_evolutionary_blueprint_package.zip | 8E7E7F0B218E5A8E6E052C3CE159BDAA4B3406A106C3D9E22AACB6B8C3114739 | 13 |

## Sintesis

El blueprint base define una cabina local evolutiva en `.codex` con ciclos
A-F:

1. Orden a evidencia.
2. Evidencia a aprendizaje.
3. Aprendizaje a mejora.
4. Mejora a prueba.
5. Prueba a promocion.
6. Promocion a expansion.

El delta v2 agrega el ciclo G:

7. Promocion a activacion de runtime.

La correccion clave es que `CODEX_LOCAL_EVOLUTIONARY_AGENTIC_MACHINE_BLUEPRINT_READY_NO_RUNTIME`
no significa "nunca habra runtime". Significa "blueprint listo, sin runtime
activado en este gate". El runtime queda permitido solo como activacion
posterior, agent-controlled, con gate humano, precheck, rollback, healthcheck y
readback.

## Inventario de agentes del paquete

- 34 agentes blueprint:
  - 14 operation.
  - 6 memory.
  - 7 improvement.
  - 7 expansion.
- 3 agentes runtime delta:
  - `runtime-activation-controller`
  - `runtime-healthcheck-validator`
  - `runtime-suspension-agent`

Agentes de alto riesgo detectados: `risk-arbiter`, `authority-resolver`,
`local-executor`, `decision-memory-writer`, `repair-loop-planner`,
`regression-checker`, `promotion-advisor`, `capability-expansion-planner`,
`agent-factory-planner`, `promotion-gate-resolver`, `rollback-planner`,
`runtime-activation-controller` y `runtime-suspension-agent`.

## Mesa de trabajo

La matriz operativa queda en:

`.agents/codex/matrices/CODEX_EVOLUTIONARY_ATTACHMENTS_WORKTABLE_20260612.csv`

Distribucion:

- `rey.control_plane_orchestrator`: intake, alcance y coordinacion.
- `court.thot_schema`: taxonomia de agentes, schemas, loops y matrices.
- `court.sdu_gate`: gates, stop conditions, rollback y promocion.
- `court.openai_dispatcher`: modelo local de runtime y frontera OpenAI/Agents SDK.
- `court.seshat_evidence`: evidencia, memoria saneada y readback.
- `rey.governance_registrar`: registry de recursos y punteros.
- `rey.frontier_guardian`: riesgo, tenant, runtime, secretos y produccion.
- `codex.workspace_guardian`: integracion serial con cabina local.

## Plan consolidado

### Fase 0 - No ejecutar, consolidar

Registrar los adjuntos como evidencia externa saneada y tratarlos como
propuesta de arquitectura. No copiarlos dentro de `.codex` ni activar runtime.

Resultado: `ATTACHMENTS_CLASSIFIED_AS_BLUEPRINT_AND_RUNTIME_DELTA`.

### Fase 1 - Reconciliar con cabina vigente

Cruzar los 34 agentes blueprint contra los agentes reales de la cabina. No
crear agentes nuevos si ya existe equivalente local. Marcar cada agente como:

- `MAP_TO_EXISTING_AGENT`
- `NEW_DECLARATIVE_AGENT_CANDIDATE`
- `NO_APLICA`
- `BLOCKED_BY_GATE`

Resultado: matriz de reconciliacion agente-paquete-cabina.

### Fase 2 - Separar ciclos A-F de ciclo G

Adoptar A-F como modelo documental/evolutivo local solo si no contradice
AGENTS.md. Mantener G como gate separado: runtime activation no entra en el
mismo carril que blueprint.

Resultado: decision packet para `GATE_CODEX_RUNTIME_ACTIVATION_MODEL_REVIEW`.

### Fase 3 - Resolver rutas

Validar la ambiguedad entre `C:\Users\enzo1.codex` y
`C:\Users\enzo1\.codex`. La ruta operativa esperada es
`C:\Users\enzo1\.codex`, pero no se debe crear ni modificar nada sin gate.

Resultado: `CODEX_HOME_PATH_PRECHECK_REPORT`.

### Fase 4 - Integrar con Dataverse workers sin escribir

Cruzar el blueprint con la capa ya detectada:

- `sdu.agent.*.runtime_actions`
- `cre3c-reconciliar-shell`
- `SDU.Agent.Dispatch.Queue`
- `mon_sdu_agent_connection_mapping`

Antes de reusar esa capa, resolver el gap:
`dataverse/data/seed_sdu_agent_runtime_actions.csv` esta referenciado por el
summary de apply, pero no existe en la ruta local actual.

Resultado: plan de compatibilidad Dataverse-worker sin apply.

### Fase 5 - Preparar artefactos versionables

Solo despues de decision humana:

- matriz de reconciliacion de agentes;
- registro pointer-only de recursos;
- gate matrix local;
- plan de bootstrap F1-F3;
- fixtures sinteticos;
- rollback plan.

No activar conectores, runtime, MCP, tenant, produccion ni push remoto.

## Enriquecimiento Dataverse y agentes

La mesa queda enriquecida con una matriz especifica:

`.agents/codex/matrices/CODEX_EVOLUTIONARY_DATAVERSE_AGENT_ENRICHMENT_20260612.csv`

### Cruce principal

El paquete blueprint trae 34 agentes distribuidos asi:

- 14 agentes de operacion.
- 6 agentes de memoria.
- 7 agentes de mejora.
- 7 agentes de expansion.

La recomendacion no es crear esos 34 agentes como identidades nuevas. La
mayoria debe mapearse a familias existentes de la cabina:

- Operacion: `rey.control_plane_orchestrator`, `rey.frontier_guardian`,
  `court.sdu_gate`, `court.thot_schema`, `court.seshat_evidence`.
- Memoria: `court.seshat_evidence`, `codex.workspace_guardian`.
- Mejora: `court.thot_schema`, `court.openai_dispatcher`, `court.sdu_gate`.
- Expansion: `rey.governance_registrar`, `rey.frontier_guardian`,
  `court.sdu_gate`.

Los tres agentes del delta runtime se tratan como candidatos o familias, no
como runtime listo:

- `runtime-activation-controller`: `BLOCKED_BY_GATE`.
- `runtime-healthcheck-validator`: mapeable a familia de validadores locales.
- `runtime-suspension-agent`: `BLOCKED_BY_GATE` hasta que exista runtime
  aprobado, rollback y postcheck.

### Metadata Dataverse relevante

- `sdu_agent` existe como schema declarativo local con `sdu_canonical_id` como
  alternate key, auditing, change tracking y politica
  `no_remote_persistent_agent_creation=true`.
- `mon_sdu_agent_connection_mapping` tiene `row_count=11` y puede generar
  trabajo hacia `SDU.Agent.Dispatch.Queue`.
- `mon_sdu_evidence` tiene `row_count=5000` y se vincula conceptualmente con
  evidencia/memoria saneada hacia `SDU.Evidence.Publish.Queue`.
- `mon_sdu_apply_log` tiene `row_count=0`; se mantiene como superficie
  operativa futura, no como apply abierto.
- `mon_sdu_validation_gate` tiene `row_count=0`; sirve para gates futuros, no
  como aprobacion implicita.
- `SDU.Agent.Dispatch.Queue` tiene snapshot local con 10 items completados,
  0 pendientes, 0 en proceso, 0 excepciones y 0 residuales.

### Agentes Dataverse ya observados

El ultimo summary local de `sdu_agent_runtime_actions_registry_20260608`
registra 7 runtime actions postcheckeadas sobre
`mon_sdu_agent_connection_mapping`:

- `seshat-normativa`
- `thot-tecnico`
- `anubis-gate`
- `maat-cumplimiento`
- `horus-riesgo`
- `cre3c-reconciliar-shell`
- `narrador-normativo`

Cada una quedo con `candidate_count_before=1`, `candidate_count_after=1` y
estado `POSTCHECKED`.

### Evidencia encontrada en otras ramas

Busqueda posterior por ramas e historial Git confirmo que el seed no esta
perdido: existe en `main` y en varias ramas locales/remotas. El problema es
que la rama actual no lo tiene en su worktree.

Evidencia:

- `git log --all -- dataverse/data/seed_sdu_agent_runtime_actions.csv`
  muestra:
  - `09e9e2c7640e0ac106664240c6ebd832bf524503` del 2026-06-08:
    `feat: connect Dataverse workqueue worker and SDU runtime registry`.
  - `3b58208a8bec8ec222e24bea6ed8201d6b6b3aa2` del 2026-06-10:
    `Reconcile SDU agent runtime registry for Consolidar Shell in HUBDesarrollo`.
  - `a605f80efe7caf073af15bad798a817aa72e9d42` del 2026-06-10:
    `Governed default runtime and readback supersedence`.
- `git show main:dataverse/data/seed_sdu_agent_runtime_actions.csv` contiene
  7 filas: los 6 SDU-CN mas `cre3c-reconciliar-shell` / `Serafín RFA`.
- `main:.agents/codex/readbacks/2026-06-10_cre3c_reconciliar_she_registry_sync_readback.md`
  declara candidate count `1`, row id
  `96d651ad-4f64-f111-ab0d-00224805f8f9`, estado live `ACTIVE_DEV` y
  validator `SDU_AGENT_RUNTIME_ACTIONS_REGISTRY_VALIDATOR=PASS`.
- `main:.agents/codex/readbacks/2026-06-10_cre3c_reconciliar_she_chain_closeout_readback.md`
  declara que se agrego `cre3c-reconciliar-shell` al seed, se actualizo el
  validador y el script de invoke, con `git diff --check` limpio salvo warning
  CRLF no bloqueante.
- `main:.agents/codex/readbacks/2026-06-08_sdu_agents_dataverse_registry_readback.md`
  documenta el registro original de 6 agentes con `GATE_DATAVERSE_APPLY`,
  `DRY_RUN_PASS`, `APPLY_PASS`, postcheck por `mon_canonical_id` y rollback
  por status patch.

Ramas donde aparece evidencia:

- `main`
- `codex/sdu-reconciliar-she-training-sync-20260610`
- `codex/sharepoint-pnp-live-map`
- `codex/cabina-universal-d-coordination-20260611`
- `codex/sdu-dataverse-readback-main-merge`
- `codex/sdu-workqueue-readback`
- `codex/sdu-workqueue-daily-monitor`
- `codex/tenant-controlled-dataverse-segments-20260608`

Por eso el estado corregido es:

`READY_WITH_BRANCH_EVIDENCE_CURRENT_BRANCH_GAP`

No hay que reconstruir desde cero. Hay que seleccionar fuente rectora
(`main` o rama especifica), restaurar o referenciar el archivo exacto y fijar
el readback timestamped rector antes de reusar workers.

### Decision de arquitectura

Dataverse puede enriquecer el blueprint como capa de metadata, evidencia,
dispatch y gates. No debe convertirse en fuente unica de autoridad ni activar
workers por inferencia.

Regla propuesta:

```text
Blueprint agent -> cabina existing agent family -> Dataverse metadata pointer -> Work Queue item only after gate
```

No se permite:

- crear 34 agentes nuevos sin reconciliacion;
- declarar runtime ready;
- escribir Dataverse por inferencia;
- reusar runtime actions sin recuperar o reconstruir el seed CSV faltante;
- activar `SDU.Dataverse.Apply.Queue` sin orden gobernada.

### Proximo carril enriquecido

`EVOL-WT-08` queda agregado a la mesa:

- owner: `court.thot_schema`
- reviewer: `court.seshat_evidence`
- evidencia: matriz de enriquecimiento Dataverse/agentes
- stop conditions:
  - `dataverse_apply_without_governed_order`
  - `source_seed_missing_for_runtime_actions`

Resultado recomendado:

`PREPARE_DATAVERSE_ENRICHED_AGENT_RECONCILIATION_ONLY`

## Despacho a agentes locales

Por orden posterior del operador, la mesa fue enviada a agentes locales en
modo lectura:

| Carril | Agente local | Agent id | Alcance | Estado |
| --- | --- | --- | --- | --- |
| EVOL-LOCAL-THOT | `court.thot_schema` | `019eba78-e30d-7540-97e6-36c2a12c033b` | mapeo de 34 agentes blueprint a familias existentes, schemas y matrices faltantes | DISPATCHED_LOCAL_READONLY |
| EVOL-LOCAL-GATE | `court.sdu_gate` / `rey.frontier_guardian` | `019eba79-0a40-78d1-b67e-94d74cb5be02` | carriles ejecutables, bloqueos Microsoft live/runtime/Dataverse apply y campos faltantes | DISPATCHED_LOCAL_READONLY |
| EVOL-LOCAL-EVIDENCE | `court.seshat_evidence` | `019eba79-3287-7ec2-a262-ccaafb7a6033` | evidencia, gap de trazabilidad y readback/fuente requerida antes de reusar workers | DISPATCHED_LOCAL_READONLY |

No se les autorizo escribir archivos, ejecutar Microsoft live, activar runtime,
usar OpenAI API ni modificar Dataverse.

### Resultados recibidos

#### `court.thot_schema`

Dictamen:

- No crear los 34 agentes del blueprint como identidades nuevas.
- Mapearlos a familias existentes:
  - operacion: `rey.control_plane_orchestrator`, `rey.frontier_guardian`,
    `court.sdu_gate`, `court.thot_schema`, `court.seshat_evidence`;
  - memoria: `court.seshat_evidence`, `codex.workspace_guardian`;
  - mejora: `court.thot_schema`, `court.openai_dispatcher`,
    `court.sdu_gate`;
  - expansion: `rey.governance_registrar`, `rey.frontier_guardian`,
    `court.sdu_gate`.
- Los agentes `runtime-activation-controller` y `runtime-suspension-agent`
  quedan `BLOCKED_BY_GATE`.
- `runtime-healthcheck-validator` puede mapearse a familia de validador
  local, no a runtime nuevo.

Faltante estructural:

`blueprint_agent -> cabina_family -> schema/table -> queue -> gate -> stop_condition`

#### `court.sdu_gate` / `rey.frontier_guardian`

Dictamen:

- Ejecutable localmente: `EVOL-WT-01`, `EVOL-WT-02`, `EVOL-WT-03`,
  `EVOL-WT-05`, `EVOL-WT-06`, `EVOL-WT-07` como integracion/readback y
  `EVOL-WT-08`.
- Bloqueado para ejecucion material:
  - ciclo G runtime;
  - `SDU.Dataverse.Apply.Queue`;
  - `mon_sdu_apply_log`;
  - imports/exports/deployment/solution components;
  - Microsoft live sin target exacto;
  - reuso de runtime actions mientras falte
    `dataverse/data/seed_sdu_agent_runtime_actions.csv`.

Campos faltantes para Microsoft live:

`surface`, `identity`, `owner`, `tenant`, `selected_data`, `data_boundary`,
`allowed_actions`, `blocked_actions`, `rollback`, `postcheck`, `evidence`,
`validator`, `stop_condition`, `readback`, `capability_chain`, `skill`,
`recipe`, `plugin`, `tool`.

Para Power Platform/Dataverse agregar:

`environment_url`, `environment_type`, `connected_user`, `role`,
`dataverse_present`, `target_table_or_queue`, `target_record_scope` e impacto
sobre apps, flows, conexiones y usuarios.

#### `court.seshat_evidence`

Dictamen:

- El enriquecimiento esta sostenido como plan local, no como runtime
  reutilizable.
- Evidencia fuerte:
  - hashes e inventario de ZIPs;
  - matriz EVOL-DV;
  - `sdu_agent.yml`;
  - `seed_agent_connection_mapping.csv`;
  - summary Dataverse con 7 runtime actions `POSTCHECKED`;
  - snapshot local de `SDU.Agent.Dispatch.Queue`.
- Gap critico acotado:
  - el summary referencia `dataverse/data/seed_sdu_agent_runtime_actions.csv`;
  - ese CSV existe en `main` y otras ramas, pero no en la rama actual;
  - falta elegir fuente rectora y fijar un summary timestamped como evidencia
    estable.

Decision:

`READY_WITH_BRANCH_EVIDENCE_CURRENT_BRANCH_GAP`, no `READY_FOR_REUSE`.

## Carril Microsoft live

El operador pidio incluir Microsoft live. Queda agregado como `EVOL-WT-09`,
pero no se ejecuto porque falta target exacto.

Paquete de orden preparado:

`.agents/codex/orders/ORDER_CODEX_EVOLUTIONARY_MICROSOFT_LIVE_GATE_20260612.md`

Microsoft live puede entrar de dos maneras:

1. `EXECUTE_LIVE_READ_NOW`: lectura puntual y postcheckeable sobre una
   superficie exacta.
2. `EXECUTE_LIVE_WRITE_GATED_NOW`: solo con target, identidad, owner,
   rollback, postcheck, evidencia y orden concreta.

Campos minimos faltantes para ejecutar:

- superficie exacta: SharePoint, Teams, Planner, Power Platform, Dataverse o
  Graph;
- tenant/environment/site/team/list/queue exacto;
- identidad conectada o perfil esperado;
- owner humano;
- limite de datos;
- accion permitida;
- accion bloqueada;
- rollback;
- postcheck;
- evidencia esperada;
- stop condition.

Estado:

`MICROSOFT_LIVE_INCLUDED_BUT_NOT_EXECUTED_PENDING_TARGET_ONLY`

Nota de reconciliacion: el dictamen local de `court.sdu_gate` trato su tarea
como local-only porque el dispatch a subagente fue explicitamente read-only.
La orden humana posterior queda reflejada en `EVOL-WT-09` y en el paquete de
orden Microsoft live. Esto incluye Microsoft live en la mesa, pero no autoriza
ejecucion sin target.

## Riesgos principales

- Secretos en memoria.
- Escritura tenant/Power Platform sin gate.
- Activacion accidental de runtime.
- Registry que copia datos en vez de apuntar.
- Agentes sin frontera.
- Promocion sin evidencia.
- Ambiguedad de ruta `.codex`.
- Fuente CSV faltante para runtime actions Dataverse.

## Decision recomendada

Avanzar con una Fase 0/Fase 1 local:

`PREPARE_LOCAL_RECONCILIATION_ONLY_NO_RUNTIME`

No avanzar todavia a F1 fisica de `.codex` ni ciclo G runtime. Primero hay que
reconciliar agentes, rutas, Dataverse worker layer y gates.

## Cierre operativo

- agente: `rey.control_plane_orchestrator`
- orden: mesa de trabajo para adjuntos evolutivos Codex
- superficie: `Downloads ZIPs | cabina local repo`
- skill: `tcu-descubridor-capacidades | parallel-order-governance`
- receta: `recipe.parallel_agent_operation | recipe.governed_order_preparation`
- tool: `PowerShell read-only zip inspection | apply_patch local artifacts`
- estado: `PLAN_READY_LOCAL_ONLY`
- evidencia: matriz y readback locales
- validador: `NO_EJECUTADO_BY_OPERATOR_CONTEXT`
- riesgo: medium/high si se intenta activar runtime o tocar `.codex`
- rollback: borrar los dos artefactos agregados en este carril
- stop_condition: `runtime_accidental_enable|secret_detected|gate_absent|source_seed_missing_for_runtime_actions`
- proximos_carriles: reconciliacion de agentes, path precheck, Dataverse worker compatibility, gate runtime review
