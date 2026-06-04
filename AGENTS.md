# AGENTS

## Rol de esta carpeta

Esta raiz `D:\` es la Cabina Universal del Rey para ordenar universos, torres, repos, herramientas, sistemas, licencias, agentes y evidencia local.

Esta carpeta puede abrirse como proyecto en Codex. Su primera funcion es orientar, clasificar y preparar trabajo gobernado. Ya opera como repo raiz envoltorio gobernado para visibilidad nativa de Codex/Git, sin absorber repos anidados y sin versionar fuera de allowlist.

Estado actualizado 2026-06-01: por orden expresa del operador, `D:\` puede
estar inicializado como repo local envoltorio con allowlist. Esto no absorbe ni
reemplaza los repos anidados; `organizacion` conserva su propio repo en
`D:\01_GOVERNANCE_REGISTRY\10_REPOS\02_ACTIVE\organizacion`.

Estado GitHub actualizado 2026-06-01: el repo raiz envoltorio remoto es
`universo-rey/cabina-universal-d`. El PR raiz #1 fue mergeado a `main` con
merge commit `f7bfdf5a2b1044fd358438d8078942303b68c02b`. La rama historica
`codex/d-root-ui-visibility-20260601` queda conservada; todo nuevo trabajo
versionable debe abrir una rama `codex/*` desde `main` y avanzar por PR.

Estado prompt UI actualizado 2026-06-01: el PR raiz #2 fue mergeado a `main`
con merge commit `98b7ddb6969abda83c36b3101307a99075856c7f`. El prompt
maestro distingue base rectora/remota `main` de rama activa de trabajo.

Estado GitHub Actions actualizado 2026-06-01: por orden expresa del operador,
GitHub Actions queda aprobado como superficie de validacion repo-scoped en
`universo-rey/cabina-universal-d`, con permisos `contents: read` y sin
secretos, produccion, Microsoft live, OpenAI API live ni permisos.

Estado receta GitHub lifecycle actualizado 2026-06-01: por orden expresa del
operador, GitHub live repo-scoped puede operar como un solo ciclo gobernado
para branch `codex/*`, stage explicito, commit, push, PR draft/update,
comentarios/checks y fixes en alcance. No pedir aprobacion nueva por cada
subpaso dentro del mismo alcance. Merge queda automatizable dentro del ciclo
cuando el operador aprueba el ciclo o el merge y el PR pasa preflight, HEAD
fijo, base `main`, rama `codex/*`, checks requeridos y evidencia. Force push,
permisos, secrets, produccion, Microsoft live, OpenAI API live o datos
regulados siguen requiriendo orden separada.

Estado merge automatizado actualizado 2026-06-01: Codex puede ejecutar
`gh pr merge --match-head-commit` cuando exista orden aprobada y verificable.
Debe detenerse con `automated_merge_precheck_failed` si el PR no esta limpio,
esta en draft, apunta fuera de `main`, no usa rama `codex/*`, cambio el HEAD,
fallan checks, falta validador o cruza secretos, permisos, produccion,
Microsoft live, OpenAI API live, force push o borrado de rama remota.

Estado operacion paralela actualizado 2026-06-01: los agentes y subagentes
deben operar bajo matriz de carriles, owner, alcance disjunto, evidencia,
validador y stop condition. Las ordenes gobernadas deben ser preparadas por
agentes asignados antes de cualquier live, API, produccion, permisos, secretos,
costo o datos regulados.

Estado endurecimiento actualizado 2026-06-01: ningun carril paralelo es valido
sin `lead_agent`, `owner_agent`, `reviewer_agent`, `read_scope`,
`write_scope`, `lock_key`, `dependency`, `max_parallel`, evidencia, validador
y stop condition. Ninguna orden preparada es valida sin canon vigente,
autoridad fuente, superficie, owner, identidad, limite de datos, acciones
permitidas/bloqueadas, rollback, postcheck, evidencia, validador, expiracion y
stop condition.

Estado cola paralela actualizado 2026-06-01: los carriles por issue deben
declararse en
`D:\.agents\codex\matrices\PARALLEL_ISSUE_LANE_QUEUE.csv` con `base_sha`,
rama `codex/*`, file set exacto, `lock_key` unico, dependencias y
`max_parallel`. La cola se valida con
`D:\.agents\codex\tools\local_validate_parallel_issue_queue.ps1`. Los indices
compartidos requieren carril serial de integracion.

Estado merge cola paralela 2026-06-01: el PR raiz #22 fue mergeado a `main`
con merge commit `38c3bd0439e512504d39b97b8cef41144f545f87`. `main` es la
base rectora vigente para runtime no mutante, preflight Agents SDK local y
cola paralela por issue.

Estado biblioteca de referencias actualizado 2026-06-02: el PR raiz #25 fue
mergeado a `main` con merge commit
`c3c44dff12cd4957cbf27bd4dbf09e971497127d`. El issue #12 queda cerrado. La
cabina adopta `SKILL_REFERENCE_LIBRARY_POLICY.md`,
`SKILL_REFERENCE_SOURCE_MATRIX.csv` y
`local_validate_skill_reference_sources.ps1` para separar referencias tecnicas
de canon rector, controlar frescura/licencia y bloquear OpenAI API live,
Microsoft live, produccion, permisos, secretos y datos regulados.

Estado frontend-design actualizado 2026-06-02: el PR raiz #26 fue mergeado a
`main` con merge commit `d72fff9569ffbb5056276f5fb92fcc03e57b4bb8`. El issue
#15 queda cerrado. La cabina adopta `FRONTEND_DESIGN_LANE.md`,
`FRONTEND_DESIGN_LANE_MATRIX.csv` y
`local_validate_frontend_design_lane.ps1` para enrutar UI/apps/sites a
estandares de diseno, assets y verificacion local sin implicar produccion.

Estado integracion indices compartidos actualizado 2026-06-02: el PR raiz #27
fue mergeado a `main` con merge commit
`96d378e539018d8bf2fb139e3041888bba8a5b0e`. La cabina integra los carriles
cerrados #12 y #15 en indices compartidos, GitHub Actions, templates, canon y
manifiesto sin abrir Microsoft live, OpenAI API live ni produccion.

Estado alineacion todos repositorios actualizado 2026-06-02: los 12 repos
registrados quedan verificados localmente y contra GitHub read-only mediante
`D:\.agents\codex\tools\local_validate_all_repo_github_alignment.ps1`. La
evidencia vive en
`D:\.agents\codex\evals\results\all_repo_github_alignment_latest.json` y el
readback en
`D:\.agents\codex\readbacks\2026-06-02_all_repositories_alignment_readback.md`.
La alineacion no absorbe repos anidados; `SESHAT_BOOTSTRAP` conserva cambios
locales propios que requieren carril repo-nativo.

Estado cadena operativa global actualizado 2026-06-01: toda accion operativa
debe declarar y validar agente, skill, receta, tool, evidencia, validador y
stop condition. Si falta algun componente y no existe `NO_APLICA` justificado,
la ejecucion se detiene con `operational_chain_missing`.

Estado uso endurecido de capacidades actualizado 2026-06-02: toda entrada,
lectura, escritura, derivacion, dispatch paralelo, gate live/costo/produccion
y cierre debe declarar desde el inicio agente, skill, receta, plugin, tool,
superficie, evidencia, validador y stop condition. La matriz vive en
`D:\.agents\codex\matrices\CAPABILITY_USE_HARDENING_MATRIX.csv` y se valida
con `D:\.agents\codex\tools\local_validate_capability_use_hardening.ps1`. Si
falta algun componente o la asignacion no resuelve, detener antes de ejecutar
con `capability_use_preflight_missing`.

Estado autonomia gobernada actualizado 2026-06-02: antes de toda asignacion,
derivacion, ejecucion autonoma, Codex Cloud o cierre, debe usarse
`D:\.agents\skills\tcu-descubridor-capacidades\SKILL.md` para descubrir y
asignar skills, recetas, plugins y tools reales o marcar `NO_DISPONIBLE`. La
matriz `D:\.agents\codex\matrices\AUTONOMOUS_AGENT_EXECUTION_MATRIX_20260602.csv`
y el validador
`D:\.agents\codex\tools\local_validate_autonomous_agent_execution.ps1`
gobiernan agentes locales task-scoped, task agents y Codex Cloud repo-scoped.
Los repos sin environment visible quedan bloqueados con
`codex_cloud_environment_missing`; los agentes remotos persistentes siguen
requiriendo orden gobernada separada.

Estado skills repo-locales actualizado 2026-06-01: las skills portables de la
cabina viven en `D:\.agents\skills\<skill>\SKILL.md`. La carpeta
`D:\.agents\codex\skills` conserva el catalogo, source refs, matrices de uso y
subskills. Las instalaciones globales de usuario son runtime local, no fuente
durable rectora.

Estado metadata de skills actualizado 2026-06-01: toda skill repo-local debe
declarar description activable, trigger boundary, allowed actions, blocked
actions, validator, evidencia y stop condition. La matriz vive en
`D:\.agents\codex\skills\SKILL_METADATA_QUALITY_MATRIX.csv` y el validador en
`D:\.agents\codex\tools\local_validate_skill_metadata.ps1`.

Estado carril documental actualizado 2026-06-01: los trabajos DOCX, PDF,
spreadsheets y presentaciones se enrutan por
`D:\.agents\codex\matrices\DOCUMENT_SKILL_LANE_MATRIX.csv` y se validan con
`D:\.agents\codex\tools\local_validate_document_skill_lane.ps1`. El carril es
local-only; documentos amplios, regulados, secretos o live requieren orden
gobernada separada.

Estado runtime local actualizado 2026-06-01: el runtime de alineacion se puede
verificar sin escribir evidencia mutable con
`D:\.agents\codex\tools\local_run_repo_alignment_runtime.ps1 -NoWrite`. El
preflight Agents SDK local se valida con
`D:\.agents\codex\tools\local_validate_github_automation_preflight.ps1 -CheckLocalSdk`
y debe cerrar en `smoke=OK_NO_API_CALL`. Esto no habilita OpenAI API live,
Agents SDK live, costos ni agentes remotos persistentes.

Estado Codex Cloud gobernado actualizado 2026-06-02: Codex Cloud queda como
carril remoto repo-scoped activo bajo
`D:\.agents\codex\maps\CODEX_CLOUD_GOVERNED_LANE.md`,
`D:\.agents\codex\matrices\CODEX_CLOUD_GOVERNED_LANE_MATRIX.csv` y
`D:\.agents\codex\tools\local_validate_codex_cloud_governed_lane.ps1`.
`SeshatSgin/sgin-cloud` queda reconocido y verificado como environment Cloud
remoto para smoke/CI read-only o no sensible con branch fija. Quedan
registrados el smoke read-only
`task_e_6a1f19895190832ebd427cf6b955bc31` y el smoke CI mock
`task_e_6a1f1b60bc04832e855fe676e91c9ea7`, ambos `READY`, `files_changed=0`
y sin diff. El clon canonico local para este carril es
`C:\Users\enzo1\Documents\GitHub\sgin-cloud` en `67f04f9` coincidente con
`origin/main`; el clon OneDrive en `194d4db` queda marcado como atrasado y no
debe usarse para Cloud CI sin orden de refresh o higiene. Los environments
visibles quedan registrados en
`D:\.agents\codex\matrices\CODEX_CLOUD_ENVIRONMENT_INVENTORY_20260602.csv`.
`universo-rey/cabina-universal-d` queda probado con smoke read-only
`task_e_6a1f119843d4832e9ed821834222c003`, estado `READY`, sin diff. Esto no
habilita secretos, Microsoft live, SharePoint real, produccion, permisos,
OpenAI API live, costos ni agentes remotos persistentes.
La segunda ola aprobada por el operador ejecuto smokes read-only sobre
`SeshatSgin/tcu-control-plane`, `SGIN_Canonico_Puro` y `Sgin`, todos con estado
`READY`, `files_changed=0` y sin diff.
Actualizacion P0 Codex Cloud 2026-06-02: `universo-rey/organizacion` quedo
verificado con smoke read-only `task_e_6a1f4b4d699c832ea45166ff611319da`,
estado `READY` y sin diff. Reconciliacion posterior verifico tambien
`SeshatSgin/sgin-cumplimiento`
`task_e_6a1f4ee18c3c832eb9f0a6dbc427e65b` y
`universo-rey/microsoft-agents-governed-lab`
`task_e_6a1f4efb4d4c832e87a3fbf0d0f62433`, ambos `READY_NO_DIFF`.
La matriz autonoma queda sincronizada con nueve environments repo-base
nuevos/visibles mas la raiz y `Sgin`; permanecen pendientes por
label/environment real `SeshatSgin/modo-on-foundation` y
`SeshatSgin/sdu-canon`.

Estado entornos Codex actualizado 2026-06-02: la cabina crea entorno Codex app
local/worktree repo-visible en `D:\.codex\environments\environment.toml` para
`universo-rey/cabina-universal-d`. La matriz
`D:\.agents\codex\matrices\CODEX_APP_LOCAL_ENVIRONMENT_MATRIX_20260602.csv`,
la cola `D:\.agents\codex\matrices\CODEX_ENVIRONMENT_CREATION_QUEUE_20260602.csv`
y el validador
`D:\.agents\codex\tools\local_validate_codex_app_environments.ps1` gobiernan
entornos Codex app y Cloud. El CLI disponible no crea Cloud environments; los
faltantes quedan `NEEDS_CODEX_CLOUD_UI_CREATE` con
`codex_environment_creation_tool_unavailable` hasta UI/API real con rollback y
postcheck. No habilita secretos, OpenAI API live, Microsoft live, produccion,
tenant writes, permisos ni `codex cloud apply` sin revision.

Estado carriles live Codex Cloud actualizado 2026-06-02: por orden expresa del
operador, quedan finalizados solo los carriles objetivo de Codex Cloud para
`SeshatSgin/cdf-soluciones`, `universo-rey/cabina-universal-d`,
`SeshatSgin/torre-gemela-escribania`, `SeshatSgin/tcu-control-plane` como
referencia fuera de base, `SeshatSgin/seshat-bootstrap-sdu-cn`,
`SeshatSgin/tcu-agentic-runtime-control`,
`SeshatSgin/tge-agentic-runtime-control-escribania` y
`universo-rey/organizacion`. El resto de repos queda `PENDING_BY_SCOPE` o
pendiente de environment real. La clave OpenAI aprobada para este entorno vive
solo en `D:\.env.local`, ignorado por Git, bajo target `Modo On/SYS-SDU`; el
smoke OpenAI API cerro `PASS_HTTP_200_NO_BODY_PRINTED` sin imprimir cuerpo ni
secreto. La matriz
`D:\.agents\codex\matrices\CODEX_CLOUD_LIVE_LANE_FINALIZATION_20260602.csv`
y el readback
`D:\.agents\codex\readbacks\2026-06-02_codex_cloud_live_lane_finalization_readback.md`
registran evidencia, rollback y stop conditions. Esto no habilita `codex cloud
apply`, Microsoft live, produccion, tenant writes, permisos, costos abiertos,
datos regulados ni uso amplio de OpenAI API sin orden gobernada separada.

Estado performance de validadores actualizado 2026-06-02: los analisis
adjuntos del operador se implementan en una primera ola de bajo riesgo.
`local_validate_agent_layer.ps1`, `local_run_repo_alignment_runtime.ps1`,
`local_validate_operational_chain.ps1` y
`local_validate_capability_use_hardening.ps1` cachean lecturas CSV/JSON por
proceso donde aplica. El workflow `cabina-validation.yml` usa
`-SkipWorkflowNestedValidators` solo en el paso `Agent layer` para evitar
re-ejecutar operational chain, parallel order governance y order packets,
porque esos validadores ya corren como pasos propios; agent levels y
workpapers permanecen dentro del validador paraguas. El escaneo de secretos
del validador paraguas lee cada archivo una vez y preserva evidencia de linea.
La matriz rectora vive en
`D:\.agents\codex\matrices\VALIDATOR_PERFORMANCE_IMPROVEMENT_MATRIX_20260602.csv`
y el readback en
`D:\.agents\codex\readbacks\2026-06-02_validator_performance_improvements_readback.md`.

Estado runner agregado de validacion actualizado 2026-06-02: la Fase 3
introduce `D:\.agents\codex\tools\local_run_governance_validation_suite.ps1`
como runner agregado. Tras tres corridas manuales adicionales exitosas en
GitHub Actions (`26855967863`, `26856014739`, `26856054210`), el runner fue
promovido a gate principal inicial de `cabina-validation.yml` para
`pull_request`, `push` y `workflow_dispatch`. Desde la incorporacion del
Change-Aware Full-Coverage Orchestrator el runner queda retenido como conjunto
completo de validadores y evidencia diagnostica, compuesto por el gate
change-aware productivo. Ejecuta la suite existente, emite JSON con duracion
por validador y puede escribir resultado solo con `-WriteResult`; en GitHub
Actions debe cerrar con `result_written=false` cuando se lo use como artefacto
diagnostico. La evidencia historica vive en
`D:\.agents\codex\readbacks\2026-06-02_governance_validation_suite_phase3_readback.md`
y
`D:\.agents\codex\readbacks\2026-06-02_governance_validation_suite_gate_promotion_readback.md`.

Estado hash sets validadores actualizado 2026-06-03: por aprobacion del
operador, el carril `validator_perf.hash_set_membership` queda implementado en
`local_validate_agent_layer.ps1`, `local_run_repo_alignment_runtime.ps1`,
`local_validate_operational_chain.ps1` y
`local_validate_capability_use_hardening.ps1`. Los chequeos repetidos de ids,
columnas y stop conditions usan `HashSet[string]` case-insensitive para
preservar la semantica de `-notin/-notcontains` de PowerShell. La evidencia
queda en
`D:\.agents\codex\readbacks\2026-06-03_validator_hash_set_performance_readback.md`.
No habilita Microsoft live, OpenAI API live, produccion, permisos, secretos ni
cambios de workflow.

Estado Change-Aware Full-Coverage Orchestrator actualizado 2026-06-03: el
workflow `cabina-validation.yml` usa
`D:\.agents\codex\tools\local_run_change_aware_full_coverage_orchestrator.ps1`
como gate productivo para `pull_request`, `push` y `workflow_dispatch`.
Change-awareness solo ordena, prioriza riesgo, ajusta paralelismo declarado,
emite evidencia y acelera diagnostico; no elimina tests obligatorios ni
reemplaza el full gate por test selection. El manifiesto obligatorio vive en
`D:\.agents\codex\matrices\CHANGE_AWARE_TEST_MANIFEST.csv`, la politica de
riesgo en `D:\.agents\codex\matrices\CHANGE_AWARE_RISK_POLICY.csv`, el grafo
de impacto en `D:\.agents\codex\matrices\CHANGE_AWARE_IMPACT_GRAPH.csv` y la
evidencia local en
`D:\.agents\codex\evals\results\change_aware_full_coverage_audit_latest.json`.
Un PR solo puede pasar si `all_required_passed`, `coverage_equivalence`,
`manifest_valid`, `graph_valid`, `no_hidden_flaky` y
`blocked_surfaces_clear` son verdaderos. Este estado ingreso por el PR raiz
`#53`, merge commit `d21aad4280180328c41e4ca91c61e033a63551b6`; la corrida
remota de `main` `26859024863` cerro `success` y subio el artifact saneado
`change-aware-full-coverage-26859024863`.

Estado canon full-live global actualizado 2026-06-03: el PR raiz
`universo-rey/cabina-universal-d#56` fue mergeado a `main` con merge commit
`df8a0beac2c610e58f97b753ee10969d47174b2a`. La cabina queda en estado rector
`CABINA_FULL_LIVE_GOVERNED_GLOBAL_CANON`. Ya no opera solo como repo-scoped:
opera como control plane global full-live governed para OpenAI API, Responses
API, Agents SDK runtime, Codex Cloud, GitHub, Microsoft 365, SharePoint,
Teams, Planner, Microsoft Graph, Power Platform, produccion y propagacion
multi-repo. OpenAI API, Responses API, Agents SDK runtime, Codex Cloud y
GitHub quedan `ENABLED_GOVERNED`. Microsoft 365, SharePoint, Teams, Planner,
Graph, Power Platform, produccion y propagacion quedan
`ENABLED_GOVERNED_GATED`. Ninguna accion live queda autorizada como write
ciego: toda ejecucion requiere target exacto, owner, identidad, alcance,
rollback, postcheck, evidencia, stop condition y readback. Si falta target,
rollback o postcheck, la accion queda preparada y no ejecutada.

Estado reconciliacion extendida base canonizado 2026-06-03: despues del
fan-in extendido inicial de 45 PRs mergeados reales, sin PRs inventados, la
cabina quedo en `CABINA_EXTENDED_RECONCILIATION_CANONIZED` sobre `main`
`d070e87f77a510edd724dc220ade9228040ee8b7`, con PR final historico #62. Ese
hito conserva la activacion de cadena estandar, pero ya no es el ultimo
estado root vigente tras la reconciliacion textual a #78. El canon operativo
subyacente sigue siendo `CABINA_FULL_LIVE_GOVERNED_GLOBAL_CANON` y la cadena
activa sigue siendo `STANDARD_AGENT_CHAIN_ACTIVE`. Los hitos #53, #56 y #62
quedan como `HISTORICAL/SUPERSEDED` para ultimo-estado-raiz. La regla
semantica vigente es no decir "no live" como bloqueo absoluto: usar "no live
sin gate", `ENABLED_GOVERNED` o `ENABLED_GOVERNED_GATED_NOT_EXECUTED` segun
corresponda. Microsoft live write, SharePoint write, Teams write, Planner
write, Graph mutation, Power Platform mutation, produccion y propagacion
quedan habilitados solo como `ENABLED_GOVERNED_GATED_NOT_EXECUTED` hasta
target exacto, owner, rollback, postcheck, evidencia y orden concreta.

Estado canon textual a #78 actualizado 2026-06-04: por seleccion expresa del
operador, el canon textual queda reconciliado al estado real de `origin/main`
en `9285edc43000166259d04d684ab34aa16beb50de`, con PR final incluido
`universo-rey/cabina-universal-d#78`. Se detectan 60 PRs mergeados reales a
`main`, sin PRs inventados. Los PRs post #62 incluidos son #63, #64, #65,
#66, #67, #68, #69, #70, #71, #72, #73, #74, #76, #77 y #78. Los PRs #75,
#79 y #80 permanecen abiertos y no quedan canonizados por este texto; el PR
#81 esta cerrado sin merge y queda excluido. Esta reconciliacion no ejecuta
Microsoft live, OpenAI API live, produccion, permisos, secretos ni
propagacion; solo actualiza la lectura canonica del repo raiz hasta #78.

## Cadena operativa estándar activa

Estado:

`STANDARD_AGENT_CHAIN_ACTIVE`

Cadena:

rey.control_plane_orchestrator
→ court.openai_dispatcher
→ sdu-triage-agent
→ court.sdu_gate
→ court.seshat_evidence

Regla:
Toda tarea Codex Cloud debe declarar:

* agente rector;
* agente delegado;
* agente runtime;
* gate;
* evidencia;
* skill;
* receta;
* tool;
* superficie;
* validador;
* stop condition.

Estado jerarquia AGENTS.md actualizado 2026-06-01: `D:\AGENTS.md` es la
instruccion rectora local de mayor precedencia. Las instrucciones anidadas,
perfiles de agentes, skills repo-locales, plugins y runtimes globales solo
pueden acotar o ejecutar dentro de esa frontera; nunca pueden debilitarla ni
absorber repos anidados. La matriz verificable vive en
`D:\.agents\codex\matrices\AGENTS_INSTRUCTION_SURFACE_MATRIX.csv` y el
validador en
`D:\.agents\codex\tools\local_validate_agents_instruction_hierarchy.ps1`.

## Prompt maestro para UI Codex

Cuando Codex abra `D:\`, la UI debe tratar esta carpeta como la Cabina
Universal del Rey y como repo raiz envoltorio activo:

- workspace raiz: `D:\`;
- repo raiz remoto: `https://github.com/universo-rey/cabina-universal-d.git`;
- base rectora/remota: `main`;
- rama de trabajo: verificar estado actual; para nuevos cambios usar `codex/*`
  creada desde `main`;
- PR raiz historico: `https://github.com/universo-rey/cabina-universal-d/pull/1`
  con estado `MERGED`;
- PR raiz prompt UI: `https://github.com/universo-rey/cabina-universal-d/pull/2`
  con estado `MERGED`;
- PR raiz cola paralela/runtime:
  `https://github.com/universo-rey/cabina-universal-d/pull/22` con estado
  `MERGED`;
- PR raiz readback canon:
  `https://github.com/universo-rey/cabina-universal-d/pull/23` con estado
  `MERGED`;
- PR raiz biblioteca de referencias:
  `https://github.com/universo-rey/cabina-universal-d/pull/25` con estado
  `MERGED`;
- PR raiz frontend-design:
  `https://github.com/universo-rey/cabina-universal-d/pull/26` con estado
  `MERGED`;
- PR raiz integracion indices compartidos:
  `https://github.com/universo-rey/cabina-universal-d/pull/27` con estado
  `MERGED`;
- PR raiz Change-Aware Full-Coverage Orchestrator:
  `https://github.com/universo-rey/cabina-universal-d/pull/53` con estado
  `MERGED`;
- PR raiz Agents SDK baseline / full-live governed:
  `https://github.com/universo-rey/cabina-universal-d/pull/56` con estado
  `MERGED`;
- PR raiz full-live global canon:
  `https://github.com/universo-rey/cabina-universal-d/pull/57` con estado
  `MERGED`;
- PR raiz setup Codex Cloud cross-platform:
  `https://github.com/universo-rey/cabina-universal-d/pull/58` con estado
  `MERGED`;
- PR raiz GitHub lifecycle repo-scoped:
  `https://github.com/universo-rey/cabina-universal-d/pull/60` con estado
  `MERGED`;
- PR raiz SDK + Codex Cloud lifecycle:
  `https://github.com/universo-rey/cabina-universal-d/pull/61` con estado
  `MERGED`;
- PR raiz standard agent chain:
  `https://github.com/universo-rey/cabina-universal-d/pull/62` con estado
  `MERGED`;
- PRs raiz post #62 canonizados a #78: #63, #64, #65, #66, #67, #68, #69,
  #70, #71, #72, #73, #74, #76, #77 y #78 con estado `MERGED`; ultimo PR
  incluido:
  `https://github.com/universo-rey/cabina-universal-d/pull/78`;
- PRs raiz abiertos no canonizados por este texto:
  `https://github.com/universo-rey/cabina-universal-d/pull/75`,
  `https://github.com/universo-rey/cabina-universal-d/pull/79` y
  `https://github.com/universo-rey/cabina-universal-d/pull/80`;
- PR raiz cerrado sin merge excluido:
  `https://github.com/universo-rey/cabina-universal-d/pull/81`;
- estado canonico actual: `CABINA_EXTENDED_RECONCILIATION_CANONIZED`;
- ultimo main efectivo incluido:
  `9285edc43000166259d04d684ab34aa16beb50de`;
- canon operativo: `CABINA_FULL_LIVE_GOVERNED_GLOBAL_CANON`;
- cadena activa: `STANDARD_AGENT_CHAIN_ACTIVE`;
- allowlist: solo gobierno, canon, agentes locales, matrices, prompts,
  recetas, tools, evals, plugins, templates, readbacks/workpapers saneados y
  workflows GitHub Actions de validacion, mas skills repo-locales bajo
  `D:\.agents\skills` y entorno Codex app local/worktree bajo `D:\.codex`;
- repos anidados: conservar su propio `.git`, remoto, rama y PR;
- `organizacion`: permanece separado en
  `D:\01_GOVERNANCE_REGISTRY\10_REPOS\02_ACTIVE\organizacion`.

Si el prompt de UI, el resumen lateral o una instruccion heredada contradice
este `AGENTS.md`, declarar la contradiccion y usar `D:\AGENTS.md` como fuente
rectora local antes de actuar.

## Jerarquia de instrucciones locales

1. `D:\AGENTS.md`: fuente rectora local y frontera de seguridad.
2. Lectura obligatoria local: manifiesto, mapa humano, routing, registry,
   canon, README de `.agents\codex`, `agents.json` y `routing.json`.
3. Instrucciones anidadas locales: README de subnivel, perfiles de agentes,
   matrices, mapas, recetas, tools, skills repo-locales y templates.
4. Repos anidados: cada repo conserva su propio `.git`, remoto, rama, PR y sus
   instrucciones internas; la cabina raiz no los absorbe.
5. Runtime global o plugins: son herramientas de ejecucion local; no son canon
   durable y no pueden contradecir este archivo.

Si una instruccion de menor precedencia contradice una de mayor precedencia, se
detiene la accion que dependa de esa contradiccion y se registra
`instruction_precedence_missing` o `nested_instruction_surface_unmapped` segun
corresponda.

## Lectura obligatoria

Antes de responder, mover, crear, borrar, ejecutar o proponer cambios, leer en este orden:

1. `D:\MANIFEST.yaml`
2. `D:\MAPA_HUMANO.md`
3. `D:\00_CONTROL_PLANE_INGRESS\ROUTING.json`
4. `D:\01_GOVERNANCE_REGISTRY\README.md`
5. `D:\02_AUTHORITY_CANON\CURRENT_STATE.md`
6. `D:\.agents\codex\README.md`
7. `D:\.agents\codex\agents.json`
8. `D:\.agents\codex\routing.json`

Si falta un archivo rector, registrar hallazgo y detener la ejecucion destructiva. Se puede preparar borrador local de correccion.

## Jerarquia operativa

1. Cabina Universal del Rey: plano de gobierno transversal y entrada comun.
2. Corte Ejecutora del Rey: agentes OpenAI, Seshat y SDU como capa ejecutora/canonica transversal.
3. Universos: superficies soberanas con torre propia.
4. Torres de control de universo: gobierno operativo dentro de cada universo.
5. Repos, herramientas, sistemas y licencias: activos gobernados por universo o por referencia tecnica.

## Universos vigentes iniciales

- `ESCRIBANIA`: universo institucional regulado. TGE pertenece a este universo.
- `MODO_ON`: universo proveedor/operativo. CDF y Jara pertenecen a este universo.

## Corte Ejecutora inicial

- `Seshat`: evidencia, registro, trazabilidad y memoria declarativa.
- `SDU`: criterio canonico, orden, gates, coherencia y escalamiento.
- Agentes OpenAI: corte ejecutora operativa cuando exista orden gobernada, superficie, datos permitidos, rollback, postcheck y evidencia.
- OpenAI y Agents SDK: prompts, docs, diseno de agentes, evals sinteticos,
  OpenAI API live gobernado, Responses API live gobernado y Agents SDK runtime
  live gobernado pueden operar cuando exista gate con target, identidad,
  alcance, rollback, postcheck, evidencia y stop condition. Agent Builder,
  vector stores externos, costos abiertos o agentes remotos persistentes
  requieren orden gobernada completa.

## Conducta obligatoria

- Leer antes de escribir.
- Ejecutar primero lo local, reversible y seguro.
- Antes de cualquier ejecucion, asignacion o derivacion, declarar cadena de
  capacidad: agente, skill, receta, plugin, tool, superficie, evidencia,
  validador y stop condition; si falta, detener con
  `capability_use_preflight_missing`.
- Microsoft live es gobernado: SharePoint, Teams, Outlook, Entra, Graph,
  Power Platform, Planner, Dataverse o tenant requieren orden gobernada con
  superficie, identidad, owner, rollback, postcheck y evidencia.
- Produccion es `ENABLED_GOVERNED_GATED`: solo se ejecuta con target exacto,
  owner, identidad, rollback, postcheck, evidencia, stop condition y readback.
- No mover clones locales sin plan de migracion, inventario, origen, destino, rollback y readback.
- No versionar, commitear, pushear ni crear PR sin orden expresa. Merge solo
  con orden o ciclo aprobado, HEAD fijo, checks verdes y evidencia.
- No usar `git add .` en `D:\`; el repo raiz usa allowlist y excluye clones anidados.
- No escribir en Microsoft, GitHub, OpenAI API, Responses API, Agents SDK,
  SharePoint, Power Platform, tenant, produccion ni repos de propagacion sin
  orden gobernada, target exacto, owner, rollback, postcheck y evidencia.
- No persistir secretos en archivos, logs, prompts, matrices o readbacks.
- No confundir referencia tecnica con canon rector.
- No tratar carpetas de herramientas, sistemas o licencias como repos salvo que tengan metadata que lo declare.
- Mantener separacion estricta entre `ESCRIBANIA`, `MODO_ON`, Corte Ejecutora y referencias tecnicas.
- No cerrar ni ejecutar trabajo operativo sin cadena agente/skill/receta/plugin/tool/superficie/validador/evidencia/stop_condition.
- Toda salida operativa debe declarar agente, skill, receta, plugin, tool, superficie, orden, evidencia, validador y condicion de detencion.

## Cadena de trabajo

1. Entrada: `00_CONTROL_PLANE_INGRESS`.
2. Clasificacion: universo, activo, frontera, riesgo y owner.
3. Registro: `01_GOVERNANCE_REGISTRY`.
4. Canon: `02_AUTHORITY_CANON`.
5. Ejecucion delegada: `.agents\codex`, Corte Ejecutora o torre de universo.
6. Evidencia: readback local, matriz o acta.
7. Cierre: validacion, estado final y proximos carriles.

## Permitido sin nueva orden

- Leer archivos locales bajo `D:\`.
- Crear o ajustar borradores locales de mapas, manifiestos, matrices, perfiles de agentes y readbacks.
- Preparar planes de migracion sin mover activos.
- Clasificar repos, herramientas, sistemas y licencias por metadata.
- Preparar prompts, recetas y perfiles declarativos.

## Requiere orden gobernada explicita

- Mover clones locales.
- Crear repos remotos, branches, commits, pushes, PRs o issues.
- Ejecutar OpenAI API live, Responses API live, Agents SDK live, Agent Builder
  o costos externos sin gate exacto y evidencia.
- Escribir en SharePoint, Teams, Outlook, Power Platform, Microsoft Graph o tenant.
- Ejecutar produccion sin target exacto, owner, rollback, postcheck,
  evidencia y stop condition.
- Modificar permisos, identidades, conectores, licencias o configuraciones productivas.
- Leer datos regulados amplios o no seleccionados.

## Bloqueado siempre

- Secretos en repo, prompts, logs o readbacks.
- Dumps de expedientes o datos regulados fuera de frontera.
- Acciones destructivas sin inventario, rollback y autorizacion.
- Sustituir autoridad humana/institucional por un agente.

## Formato minimo de salida de agentes

Cada agente debe cerrar con:

- `agente`
- `orden`
- `superficie`
- `skill`
- `receta`
- `tool`
- `estado`
- `evidencia`
- `validador`
- `stop_condition`
- `proximos_carriles`
