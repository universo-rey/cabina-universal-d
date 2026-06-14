# Panel review - Blueprint Agent Reconciliation

Fecha: 2026-06-12

Tabla revisada:

`C:\Users\enzo1\.codex\workpapers\2026-06-12_dataverse_branch_evidence_multi_cabina\09_CODEX_EVOLUTIONARY_BLUEPRINT_AGENT_RECONCILIATION.csv`

## Cobertura

La tabla completa de 34 agentes fue revisada por familias:

- `court.thot_schema`: 10 filas + coherencia global de taxonomia/schema.
- `court.sdu_gate`: 7 filas + revision transversal de gates y stop conditions.
- `court.seshat_evidence`: 4 filas de evidencia/memoria/readback.
- `rey.frontier_guardian`: 4 filas + revision transversal de riesgo alto.
- `codex.workspace_guardian`: 4 filas de workspace/rutas/versionado.
- `rey.control_plane_orchestrator` + `rey.governance_registrar`: 5 filas.

## Dictamen consolidado

La tabla base es valida como primer deliverable: contiene 34 agentes unicos,
decisiones presentes y taxonomia general util. Sin embargo, todos los agentes
coinciden en que no debe quedar como matriz final sin una version v2
endurecida.

Problema principal:

`GATE_BLUEPRINT_RECONCILIATION` sirve para analisis inicial, pero es demasiado
generico para autoridad, ejecucion, promocion, regresion, runtime, Dataverse,
workspace, registry, riesgo alto y reparto multi-cabina.

La fila critica es:

- `local-executor`

Motivo:

Combina `SDU.Agent.Dispatch.Queue` con `GATE_DATAVERSE_METADATA_ONLY` y
`runtime_or_live_execution_without_gate`. Eso puede confundir metadata-only con
ejecucion/runtime. Debe pasar a `GATE_LOCAL_EXECUTION_REVIEW` o
`GATE_RUNTIME_ACTIVATION_REVIEW`, y la queue debe ser `NO_QUEUE_GATE_ONLY`
salvo que exista dispatch item exacto.

## Ajustes por fila recomendados

| blueprint_agent | ajuste recomendado |
| --- | --- |
| `order-intake` | `schema_table=mon_sdu_validation_gate`; `queue=NO_QUEUE_METADATA_ONLY`; `gate=GATE_ORDER_PACKET_INTAKE` |
| `risk-arbiter` | `gate=GATE_LIVE_RISK_ARBITRATION`; stop conditions acumulativas de secreto, live, produccion, rollback y postcheck |
| `context-router` | `schema_table=mon_sdu_agent_connection_mapping`; `gate=GATE_CONTEXT_ROUTING_RESOLUTION`; dispatch queue solo con superficie exacta |
| `authority-resolver` | `gate=GATE_AUTHORITY_CANON_SOURCE_RESOLUTION`; agregar `authority_conflict_unresolved` |
| `capability-selector` | `schema_table=mon_sdu_agent_connection_mapping` |
| `workspace-router` | `gate=GATE_WORKSPACE_TARGET_RESOLUTION`; agregar stops de path, repo anidado y D legacy |
| `parallel-agent-dispatcher` | `gate=GATE_PARALLEL_ORDER_GOVERNANCE`; exigir lock key, scopes, base sha, validator y max parallel |
| `dependency-checker` | `gate=GATE_WORKSPACE_DEPENDENCY_PREFLIGHT`; agregar stops de validador, admin y auth live |
| `local-executor` | cambiar a `GATE_LOCAL_EXECUTION_REVIEW` o `GATE_RUNTIME_ACTIVATION_REVIEW`; `queue=NO_QUEUE_GATE_ONLY`; considerar dividir metadata probe vs executor |
| `validator` | `gate=GATE_VALIDATOR_REQUIRED_PASS`; agregar `validator_scope_unmapped` |
| `closure-judge` | `gate=GATE_EVIDENCE_CLOSURE`; agregar `readback_missing` |
| `failure-classifier` | `gate=GATE_FAILURE_TAXONOMY_REVIEW`; agregar stops de scope, sanitizacion y datos regulados |
| `repair-loop-planner` | `gate=GATE_REPAIR_LOOP_REVIEW`; agregar blast radius, cross-cabina target y live/runtime write |
| `synthetic-eval-runner` | reasignar a `court.sdu_gate` o `codex.workspace_guardian` |
| `validator-orchestrator` | `gate=GATE_VALIDATION_ORCHESTRATION`; agregar `required_validator_not_declared` |
| `regression-checker` | `gate=GATE_REGRESSION_EVIDENCE`; agregar `baseline_missing` y `regression_detected` |
| `promotion-advisor` | `gate=GATE_PROMOTION_REVIEW`; agregar `promotion_without_human_gate` |
| `capability-expansion-planner` | `gate=GATE_CAPABILITY_EXPANSION_REVIEW`; `queue=NO_QUEUE_METADATA_ONLY` |
| `agent-factory-planner` | `gate=GATE_AGENT_IDENTITY_CREATION_REVIEW`; stop `agent_creation_without_no_duplication_gate` |
| `skill-gap-proposer` | `schema_table=mon_sdu_agent_connection_mapping` |
| `registry-normalizer` | usar `mon_sdu_evidence` solo para punteros/evidencia; si normaliza relaciones, usar `mon_sdu_agent_connection_mapping` |
| `promotion-gate-resolver` | `gate=GATE_PROMOTION_GATE_RESOLUTION`; agregar `runtime_activation_without_gate` |
| `versioning-advisor` | `gate=GATE_VERSIONING_CHANGE_PLAN`; agregar base branch, rollback, dirty worktree y repo write stops |
| `rollback-planner` | `gate=GATE_ROLLBACK_PLAN_REQUIRED`; agregar rollback testable, postcheck, owner y target identity |

## Columnas recomendadas para v2

Agregar:

- `owner_agent`
- `reviewer_agent`
- `target_required`
- `candidate_count_required`
- `rollback_required`
- `postcheck_required`
- `evidence_path`
- `readback_path`
- `source_artifact`
- `sanitization_status`
- `evidence_hash`
- `retention_scope`

## Reglas transversales recomendadas

- Toda fila con `SDU.Agent.Dispatch.Queue` debe exigir owner, reviewer,
  target exacto, `candidate_count=1`, rollback y postcheck.
- Ninguna fila puede convertir evidencia historica en permiso actual de
  live/runtime.
- `GATE_BLUEPRINT_RECONCILIATION` solo queda como gate de fase inicial.
- Cualquier runtime, OpenAI API, Microsoft live, Dataverse live, repo write,
  produccion, permisos o cross-cabina write requiere gate especifico.
- `agent-factory-planner` no crea agentes; solo prepara candidato declarativo
  despues de no-duplicacion.
- `local-executor` no ejecuta por arrastre.

## Riesgos consolidados

- promocion por arrastre;
- activacion runtime sin gate;
- Dataverse live confundido con metadata-only;
- uso operativo de cola sin item exacto;
- escritura cross-cabina sin matriz destino;
- secretos o datos regulados en evidencia;
- repo write sobre rama equivocada;
- tocar repos anidados o `D:\` legacy sin gate;
- rollback declarativo pero no ejecutable;
- duplicacion de agentes.

## Stop conditions consolidadas

- `runtime_gate_missing`
- `target_identity_ambiguous`
- `candidate_count_not_one`
- `wrong_environment_or_default`
- `production_unapproved`
- `secret_detected`
- `rollback_missing`
- `postcheck_missing`
- `no_cross_cabina_write_without_target_matrix`
- `schema_family_mismatch`
- `agent_creation_without_no_duplication_gate`
- `sanitization_status_missing`
- `repo_write_without_target_order`
- `path_outside_allowed_roots`
- `nested_repo_boundary_unmapped`
- `lock_key_missing`

## Recomendacion

Preparar una v2 del CSV sin tocar repos ni live:

`11_CODEX_EVOLUTIONARY_BLUEPRINT_AGENT_RECONCILIATION_V2.csv`

La v2 debe incorporar gates especificos, columnas de trazabilidad y stop
conditions acumulativas. Debe seguir siendo un artefacto local en `.codex`
hasta que exista orden para versionar o repartir.
