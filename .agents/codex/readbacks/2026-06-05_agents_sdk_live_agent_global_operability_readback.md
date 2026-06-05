# READBACK_AGENTS_SDK_LIVE_AGENT_GLOBAL_OPERABILITY_20260605

## Estado

HECHO_VERIFICADO: `AGENTS_SDK_LIVE_AGENT_GLOBAL_OPERABILITY_EXECUTED`

## Gate

`GATE_AGENTS_SDK_LIVE_AGENT_GLOBAL_OPERABILITY_20260605`

## Target

- PR: `#100`
- `origin/main`: `3d2fc2747a14949652a05858f46dbda5f315e75c`
- Archivo analizado:
  `.agents/codex/matrices/AGENTS_GLOBAL_OPERABILITY_INVENTORY_20260605.csv`

## Runtime

- Runtime live usado: `agents_sdk`
- Modelo: `gpt-4.1-mini`
- Límite autorizado: `MAX_USD=1`
- Credencial: reutilizada desde destino local seguro, sin imprimir valor.

## Datos Analizados

- Filas: 26
- Columnas: 18
- Datos permitidos: repo-scoped no secretos.

## Resultado Live

El agente live clasifico el inventario como activo con brechas documentadas.
Riesgo general: `medium`.

Brechas principales:

- GitHub write requiere alcance explicito.
- OpenAI y Agents SDK deben mantenerse como runtime, no autoridad.
- Microsoft live write requiere target, owner, rollback, postcheck y evidencia.
- MODO_ON y ESCRIBANIA deben permanecer separados.
- Live o produccion no pueden autoaprobarse desde el gate agent.
- Referencias tecnicas no deben tratarse como canon.
- Worktree distinto de raiz efectiva requiere re-anclaje antes de writes.
- Migraciones de clones requieren gate especifico.
- Subagentes requieren lane fields, scopes disjuntos y serializacion en indices compartidos.

## Artefactos Locales

- `.agents/codex/matrices/AGENTS_SDK_LIVE_AGENT_GLOBAL_OPERABILITY_FINDINGS_20260605.csv`
- `.agents/codex/matrices/AGENTS_SDK_LIVE_AGENT_GLOBAL_OPERABILITY_DECISION_MATRIX_20260605.csv`
- `.agents/codex/matrices/AGENTS_SDK_LIVE_AGENT_GLOBAL_OPERABILITY_RACI_MATRIX_20260605.csv`
- `.agents/codex/matrices/AGENTS_SDK_LIVE_AGENT_GLOBAL_OPERABILITY_REVIEW_EVALUATION_DECISION_WORKFLOW_20260605.csv`
- `.agents/codex/matrices/AGENTS_SDK_LIVE_AGENT_GLOBAL_OPERABILITY_ORG_CHART_20260605.csv`
- `.agents/codex/maps/AGENTS_SDK_LIVE_AGENT_GLOBAL_OPERABILITY_ORG_CHART_20260605.md`
- `.agents/codex/matrices/AGENTS_SDK_LIVE_AGENT_GLOBAL_OPERABILITY_SDU_SEARCH_SELECTION_PLAN_20260605.csv`
- `.agents/codex/maps/AGENTS_SDK_LIVE_AGENT_GLOBAL_OPERABILITY_SDU_SEARCH_SELECTION_PLAN_20260605.md`
- `.agents/codex/matrices/AGENTS_SDK_LIVE_AGENT_GLOBAL_OPERABILITY_FRAMEWORK_20260605.csv`
- `.agents/codex/maps/AGENTS_SDK_LIVE_AGENT_GLOBAL_OPERABILITY_FRAMEWORK_20260605.md`
- `.agents/codex/readbacks/2026-06-05_agents_sdk_live_agent_global_operability_readback.md`

## Decisiones Formalizadas

La matriz de decisiones convierte los hallazgos live en acciones gobernadas:

- `KEEP_GATED`: conservar frontera y no ejecutar sin gate.
- `RETAIN_BOUNDARY`: preservar separacion de autoridad, universo o referencia.
- `REQUIRE_LIVE_GATE`: exigir gate live antes de cualquier write.
- `REQUIRE_HUMAN_GATE`: impedir autoaprobacion de live o produccion.
- `REQUIRE_WORKTREE_GATE`: exigir gate de topologia/worktree.
- `EXECUTE_ON_NEXT_LANE`: ejecutar solo en carril siguiente local y validado.
- `SERIALIZE`: mantener serializacion para indices compartidos.

## RACI Formalizado

La matriz RACI asigna ownership operativo para cada decision live formalizada:

- `responsible`: agente o subagente que ejecuta o prepara la accion.
- `accountable`: agente que responde por la decision del carril.
- `consulted`: agentes que deben validar frontera o coherencia antes de ejecutar.
- `informed`: agente que conserva evidencia y readback.
- `gate_owner`: agente que controla el gate cuando hay live costo produccion o frontera critica.
- `evidence_owner`: `court.seshat_evidence` como owner transversal de evidencia.
- `validator_owner`: `court.thot_schema` como owner transversal de validacion.

## Flujo Revision Evaluacion Decision

El workflow formalizado conecta los artefactos en una cadena ejecutable:

1. Revisar hallazgos saneados.
2. Mapear hallazgos contra canon y fronteras.
3. Evaluar riesgo gate y superficie.
4. Asignar RACI.
5. Separar decisiones ejecutables de decisiones gateadas o serializadas.
6. Preparar carril siguiente solo para `EXECUTE_ON_NEXT_LANE`.
7. Validar localmente antes de versionar.
8. Registrar evidencia y detener en PR review hasta aprobacion humana.

## Organigrama Formalizado

El organigrama del carril declara la jerarquia operativa del paquete:

- `rey.control_plane_orchestrator` coordina el carril y autoriza solo
  packaging repo-scoped.
- `rey.frontier_guardian` controla gates y fronteras criticas.
- `court.openai_dispatcher` mantiene OpenAI y Agents SDK como runtime.
- `court.sdu_gate` revisa decisiones y bloquea autoaprobacion.
- `court.seshat_evidence` conserva evidencia y readback.
- `court.thot_schema` conserva validacion y consistencia de matrices.
- Subagentes delegados operan solo por carril declarado y stop condition.

## Agentes SDU Activados Repo-Local

Los seis agentes SDU-CN quedan activados como roles de busqueda y seleccion
para este paquete, sin runtime live nuevo:

- `seshat-normativa`: evidencia y trazabilidad documental.
- `thot-tecnico`: schemas, matrices, validators e indices.
- `horus-riesgo`: filtro de riesgo y contradicciones.
- `anubis-gate`: gates, rollback, postcheck y stop conditions.
- `maat-cumplimiento`: seleccion por coherencia, proporcionalidad y RACI.
- `narrador-normativo`: narrativa solo despues de evidencia aprobada.

## Plan Busqueda Y Seleccion

El plan de busqueda y seleccion queda formalizado en matriz y mapa. La regla
de seleccion es estricta: solo las decisiones `EXECUTE_ON_NEXT_LANE` pueden
pasar al proximo carril local. Las decisiones `KEEP_GATED`,
`REQUIRE_LIVE_GATE`, `REQUIRE_HUMAN_GATE`, `REQUIRE_WORKTREE_GATE` y
`SERIALIZE` permanecen retenidas hasta gate humano o carril serial explicito.

## Framework Formalizado

El framework del paquete conecta inventario fuente, hallazgos live,
decisiones, RACI, organigrama, workflow, plan SDU, indices, cobertura y
readback en un contrato operativo unico.

Reglas:

- Los hallazgos son evidencia, no autoridad.
- Las decisiones son acciones gobernadas, no ejecucion automatica.
- La RACI define ownership antes de cualquier carril siguiente.
- El organigrama define escalamiento y ownership de gates.
- El workflow define orden y stop conditions.
- El plan SDU define busqueda, filtro, seleccion y narrativa.
- El paquete se detiene en PR review hasta aprobacion humana.

## Sistemas Tocados

- OpenAI API live mediante Agents SDK.
- Archivos locales de salida saneada.

## Sistemas No Tocados

- Microsoft live.
- SharePoint, Teams, Planner, Graph, Dataverse y Power Platform.
- Produccion.
- Tenants, permisos, secretos y repos externos.
- GitHub writes durante la ejecucion live original.

## Postcheck

- No se imprimieron secretos.
- No hubo writes externos.
- Durante la ejecucion live original no hubo stage, commit, push ni PR.
- La salida live fue reducida a matriz local saneada.

## Versionado Posterior

- El carril repo-scoped posterior versiona la evidencia saneada en PR `#101`.
- El versionado posterior agrego hallazgos, decisiones, RACI y workflow de
  revision evaluacion decision.
- El versionado posterior uso stage explicito, commit, push y PR draft
  repo-scoped.
- El versionado posterior no re-ejecuto OpenAI API live ni Agents SDK live.

## Proximos Carriles

1. Revisar la matriz de hallazgos y decisiones.
2. Preparar `serial_agent_global_improvement_integration` para ejecutar solo decisiones `EXECUTE_ON_NEXT_LANE`.
3. Mantener `KEEP_GATED`, `REQUIRE_LIVE_GATE`, `REQUIRE_HUMAN_GATE` y `REQUIRE_WORKTREE_GATE` hasta orden explicita.

## Stop Condition

`AGENTS_SDK_LIVE_AGENT_GLOBAL_OPERABILITY_DECISIONS_READY`
