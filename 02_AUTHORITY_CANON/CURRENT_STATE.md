# Current State

Estado: `D_ROOT_WRAPPER_REPO_LOCAL_ACTIVE`

La estructura en `D:/` fue creada para revision local y ya tiene repo GitHub
raiz envoltorio gobernado activo sobre `main`.

Actualizacion 2026-06-01: por orden expresa del operador, `D:/` queda
inicializado como repo local envoltorio nuevo y separado. Este repo raiz no
absorbe `organizacion` ni otros clones; `organizacion` conserva su repo y PR
propios.

Actualizacion remota 2026-06-01: el repo raiz de cabina tiene remoto privado
separado en `universo-rey/cabina-universal-d`. El repo `universo-rey/organizacion`
continua como repo rector documental separado y no fue reemplazado.

Actualizacion merge raiz 2026-06-01: el PR raiz
`universo-rey/cabina-universal-d#1` fue mergeado a `main` con merge commit
`f7bfdf5a2b1044fd358438d8078942303b68c02b`. La rama
`codex/d-root-ui-visibility-20260601` queda como rama historica conservada. La
base visible para nuevo trabajo de la UI Codex es `main`, con nuevas ramas
`codex/*` cuando corresponda cambiar archivos.

Actualizacion prompt UI raiz 2026-06-01: el PR raiz
`universo-rey/cabina-universal-d#2` fue mergeado a `main` con merge commit
`98b7ddb6969abda83c36b3101307a99075856c7f`. El prompt maestro de UI ya
distingue base rectora/remota `main` de rama activa de trabajo.

Actualizacion merge runtime/cola 2026-06-01: el PR raiz
`universo-rey/cabina-universal-d#22` fue mergeado a `main` con merge commit
`38c3bd0439e512504d39b97b8cef41144f545f87`. `main` queda como canon vigente
para runtime `-NoWrite`, preflight Agents SDK local sin API call y cola
paralela por issue. Los issues #12 y #15 permanecen abiertos como entregables
de carril; #22 no los cierra.

Actualizacion readback canon 2026-06-01: el PR raiz
`universo-rey/cabina-universal-d#23` fue mergeado a `main` con merge commit
`0d0a2b782ddf288f795219c3481f125182535878`. Ese merge dejo en canon el estado
de #22 antes de abrir la politica de merge automatizado.

Actualizacion merge automatizado 2026-06-01: el PR raiz
`universo-rey/cabina-universal-d#24` fue mergeado a `main` con merge commit
`a164a5d5743ebb1ddc55cbfc627feb23492efb37`. Ese merge dejo aprobada la
politica de merge automatizado repo-scoped con HEAD fijo, checks verdes,
postcheck y bloqueos para force push, permisos, secrets, produccion, Microsoft
live, OpenAI API live y datos regulados.

Actualizacion biblioteca de referencias 2026-06-02: el PR raiz
`universo-rey/cabina-universal-d#25` fue mergeado a `main` con merge commit
`c3c44dff12cd4957cbf27bd4dbf09e971497127d`. El issue #12 queda cerrado. La
cabina adopta `SKILL_REFERENCE_LIBRARY_POLICY.md`,
`SKILL_REFERENCE_SOURCE_MATRIX.csv` y
`local_validate_skill_reference_sources.ps1` para registrar fuentes de
skills/API docs como referencia tecnica, no canon rector, con frescura,
licencia, owner/reviewer, evidencia y stop conditions.

Actualizacion frontend-design 2026-06-02: el PR raiz
`universo-rey/cabina-universal-d#26` fue mergeado a `main` con merge commit
`d72fff9569ffbb5056276f5fb92fcc03e57b4bb8`. El issue #15 queda cerrado. La
cabina adopta `FRONTEND_DESIGN_LANE.md`,
`FRONTEND_DESIGN_LANE_MATRIX.csv` y
`local_validate_frontend_design_lane.ps1` para trabajo UI local con assets,
responsive fit, estados interactivos, evidencia Browser/Playwright cuando
exista app local y bloqueo de produccion sin autorizacion separada.

Actualizacion integracion indices compartidos 2026-06-02: el PR raiz
`universo-rey/cabina-universal-d#27` fue mergeado a `main` con merge commit
`96d378e539018d8bf2fb139e3041888bba8a5b0e`. La cabina integra los carriles
cerrados #12 y #15 en indices compartidos, workflow de validacion,
templates, canon y manifiesto. El merge no habilita Microsoft live, OpenAI
API live, produccion, permisos, secrets, force push ni absorcion de repos
anidados.

Actualizacion alineacion todos repositorios 2026-06-02: los 12 repos
registrados en `GITHUB_BASE_WORK_MATRIX.csv` quedan verificados con ruta local,
worktree Git, remoto origin coincidente y acceso GitHub read-only. La evidencia
queda en
`D:/.agents/codex/evals/results/all_repo_github_alignment_latest.json` y el
readback en
`D:/.agents/codex/readbacks/2026-06-02_all_repositories_alignment_readback.md`.
Se detectan carriles repo-nativos pendientes: `ORGANIZACION` PRs #40/#39,
`TORRE_GEMELA_ESCRIBANIA` PR #70 bloqueado, `CDF_SOLUCIONES` PR #23 draft,
`SESHAT_BOOTSTRAP` PR #4 draft y 5 cambios locales. La raiz no absorbe ni
versiona esos cambios.

Actualizacion Microsoft Agents governed lab 2026-06-02: por aprobacion expresa
del operador, `universo-rey/microsoft-agents-governed-lab` queda clonado y
registrado como repo gobernado TGE bajo
`D:/10_UNIVERSOS/ESCRIBANIA/10_REPOS/02_ACTIVE/microsoft-agents-governed-lab`.
El repo raiz pasa a indexar 13 repos en `GITHUB_BASE_WORK_MATRIX.csv`. `origin`
apunta al repo privado `universo-rey/microsoft-agents-governed-lab` y
`upstream` apunta a `https://github.com/microsoft/Agents.git` con push
deshabilitado localmente. La alineacion no ejecuta Microsoft live, tenant
writes, produccion, permisos, secretos ni push a upstream. La evidencia queda
en
`D:/.agents/codex/readbacks/2026-06-02_microsoft_agents_governed_lab_alignment_readback.md`.

Actualizacion capacidades 2026-06-01: el repo raiz de cabina adopta en local
las capacidades declarativas necesarias desde repos fuente sin absorberlos:
perfiles de subnivel, source registries, skills, recipes, tools, evals,
plugins y templates bajo `.agents/codex`. La matriz rectora local queda en
`D:/.agents/codex/matrices/CAPABILITY_IMPORT_DECISION_MATRIX.csv` y el
inventario fuente en
`D:/.agents/codex/matrices/CAPABILITY_SOURCE_INVENTORY.csv`.

Actualizacion GitHub base 2026-06-01: GitHub queda declarado como base
obligatoria de trabajo, revision y trazabilidad para el universo de
repositorios. El remoto raiz `universo-rey/cabina-universal-d` gobierna la
cabina como base transversal e indice; cada repo anidado conserva su propio
remoto y debe avanzar por rama, commit, push y PR draft en GitHub. La politica
queda en `D:/02_AUTHORITY_CANON/GITHUB_BASE_WORK_POLICY.md` y la matriz de
repos en `D:/01_GOVERNANCE_REGISTRY/GITHUB_BASE_WORK_MATRIX.csv`.

Actualizacion runtime alineacion 2026-06-01: el runtime local sintetico de
alineacion queda activo para la cabina. No ejecuta OpenAI API, Microsoft live,
produccion, permisos, secretos ni agentes remotos persistentes. Alinea 14
agentes y 12 repos mediante
`D:/.agents/codex/matrices/AGENT_DEFAULT_SKILL_ASSIGNMENT_MATRIX.csv`,
`D:/.agents/codex/matrices/REPO_RUNTIME_ALIGNMENT_MATRIX.csv`,
`D:/.agents/codex/matrices/CABINA_UNIVERSAL_REPO_ALIGNMENT_MATRIX.csv` y
`D:/.agents/codex/tools/local_run_repo_alignment_runtime.ps1`. El ultimo
resultado queda en
`D:/.agents/codex/evals/results/repo_alignment_runtime_latest.json`.

Actualizacion alineacion universal 2026-06-01: los 12 repos registrados quedan
alineados a `universo-rey/cabina-universal-d` como base transversal de
gobierno e indice. Esta alineacion no absorbe repos nativos. Los agentes
GitHub/Copilot quedan aprobados para issues, ramas, commits, push y PR
repo-scoped. Runtime productivo, Microsoft live, OpenAI API live, produccion,
permisos, secretos, costos externos o datos regulados no quedan incluidos.

Actualizacion agentes GitHub 2026-06-01: la cabina aprueba superficies nativas
GitHub para agentes mediante `.github/copilot-instructions.md`, issue forms de
tareas/aprobaciones y pull request template. Los agentes GitHub/Copilot pueden
operar issues, ramas, commits, pushes y PRs repo-scoped. Produccion, Microsoft
live, OpenAI API live, permisos, secretos, costos externos o datos regulados no
quedan incluidos en esta aprobacion.

Actualizacion GitHub Actions 2026-06-01: la cabina aprueba
`.github/workflows/cabina-validation.yml` como workflow de validacion
repo-scoped con permisos `contents: read`. Ejecuta los validadores locales de
runtime, capa de agentes y politica de workflows. No habilita secretos,
produccion, Microsoft live, OpenAI API live, permisos ni agentes externos fuera
de GitHub.

Actualizacion receta GitHub lifecycle 2026-06-01: la cabina adopta
`recipe.github_pr_lifecycle_governed` para operar GitHub live repo-scoped como
un ciclo unico cuando el operador aprueba repo y alcance: branch `codex/*`,
stage explicito, commit, push, PR draft/update, comentarios/checks y fixes en
alcance. Esta receta reduce aprobaciones repetitivas dentro del mismo ciclo,
e incorpora merge automatizable cuando el operador aprueba el ciclo o el merge
y el PR cumple preflight, HEAD fijo, base `main`, rama `codex/*`, checks verdes
y evidencia. No habilita merge sin aprobacion y precheck, ni force push,
permisos, secrets, produccion, Microsoft live, OpenAI API live o datos
regulados.

Actualizacion workpapers GitHub 2026-06-01: los workpapers saneados bajo
`.agents/codex/workpapers` quedan incluidos en la allowlist del repo raiz para
que GitHub Actions pueda validar la capa de agentes sin leer repos externos ni
sistemas live.

Actualizacion preflight automatizacion GitHub 2026-06-01: antes de iterar por
repos registrados, la cabina ejecuta un preflight local de automatizacion
GitHub mediante
`D:/.agents/codex/matrices/GITHUB_AUTOMATION_PREFLIGHT_MATRIX.csv` y
`D:/.agents/codex/tools/local_validate_github_automation_preflight.ps1`. Este
preflight verifica templates GitHub, workflow read-only, ordenes gobernadas,
frontera Agents SDK local y bloqueo de API live, secretos, produccion,
Microsoft live, merge y force push. Agents SDK queda aprobado solo como import
local, diseno, prompts y eval sintetico sin llamada API; Agents SDK live sigue
requiriendo orden gobernada completa.

Actualizacion operacion paralela 2026-06-01: la cabina adopta
`PARALLEL_OPERATION_CRITERIA_MATRIX.csv`,
`ORDER_PREPARATION_ASSIGNMENT_MATRIX.csv`, la skill
`parallel-order-governance` y recetas de operacion paralela, preparacion de
ordenes y diseno OpenAI local. Todo agente puede preparar o revisar carriles,
pero solo dentro de alcance disjunto, owner, evidencia, validador y stop
condition. OpenAI queda habilitado como diseno local y eval sintetico; API live,
costos, vector stores externos o agentes remotos persistentes requieren orden
gobernada completa.

Actualizacion endurecimiento paralelo/ordenes 2026-06-01: las matrices
`SUBAGENT_CAPABILITY_ASSIGNMENT_MATRIX.csv`, `SUBSKILL_USAGE_MATRIX.csv`,
`SUBRECIPE_INDEX.csv`, `PLUGIN_SKILL_BOUNDARY_MATRIX.csv`,
`SOURCE_CAPABILITY_ADOPTION_GAP_MATRIX.csv` y
`ORDER_CLASS_CAPABILITY_MATRIX.csv` declaran subagentes, subskills,
subrecetas, fronteras de plugin y clases de orden. Los validadores
`local_validate_parallel_order_governance.ps1` y
`local_validate_order_packets.ps1` bloquean carriles sin scopes/locks,
ordenes incompletas, tools sin governance y contradicciones con
`D:/AGENTS.md`.

Actualizacion uso endurecido de capacidades 2026-06-02: la cabina adopta
`D:/.agents/codex/matrices/CAPABILITY_USE_HARDENING_MATRIX.csv` y
`D:/.agents/codex/tools/local_validate_capability_use_hardening.ps1` para
exigir desde la entrada, asignacion, derivacion, lectura, escritura, dispatch
paralelo y cierre la declaracion de agente, skill, receta, plugin, tool,
superficie, evidencia, validador y stop condition. Si una capacidad, plugin,
tool, ruta o stop condition no resuelve, la accion se detiene con
`capability_use_preflight_missing` antes de ejecutar.

Actualizacion autonomia gobernada 2026-06-02: la cabina propaga
`D:/.agents/skills/tcu-descubridor-capacidades/SKILL.md` como skill
obligatoria de descubrimiento/asignacion para todos los agentes y repos
registrados. La matriz
`D:/.agents/codex/matrices/AUTONOMOUS_AGENT_EXECUTION_MATRIX_20260602.csv` y
el validador
`D:/.agents/codex/tools/local_validate_autonomous_agent_execution.ps1`
habilitan preparacion de agentes locales task-scoped y Codex Cloud repo-scoped
solo con owner, reviewer, preflight, evidencia, rollback, postcheck y stop
condition. Dentro de la base D:\ quedan `ACTIVE_CODEX_CLOUD_READY`
`universo-rey/cabina-universal-d`, `universo-rey/organizacion`,
`SeshatSgin/torre-gemela-escribania`,
`SeshatSgin/tge-agentic-runtime-control-escribania`,
`SeshatSgin/sgin-cumplimiento`, `SeshatSgin/cdf-soluciones`,
`SeshatSgin/jara-consultores`, `SeshatSgin/seshat-bootstrap-sdu-cn`,
`universo-rey/Sgin`, `SeshatSgin/tcu-agentic-runtime-control` y
`universo-rey/microsoft-agents-governed-lab`; los repos sin environment
visible quedan `BLOCKED_NO_CODEX_CLOUD_ENVIRONMENT`. Los environments visibles
fuera de la base (`SeshatSgin/sgin-cloud`, `SeshatSgin/tcu-control-plane` y
`SeshatSgin/SGIN_Canonico_Puro`) quedan como
`ACTIVE_CODEX_CLOUD_READY_OUT_OF_BASE_MATRIX`, sin absorberlos ni habilitar
Microsoft live, OpenAI API live, produccion, permisos, secretos, datos
regulados ni agentes remotos persistentes.

Actualizacion cola paralela por issue 2026-06-01: la cabina adopta
`D:/.agents/codex/matrices/PARALLEL_ISSUE_LANE_QUEUE.csv` para materializar
carriles por issue con `base_sha`, rama `codex/*`, agentes lead/owner/reviewer,
file set exacto, `lock_key`, dependencia, `max_parallel`, rollback, postcheck,
evidencia, validador y stop condition. El validador
`D:/.agents/codex/tools/local_validate_parallel_issue_queue.ps1` bloquea locks
duplicados y solapamiento de `write_scope`. Los indices compartidos se integran
por carril serial.

Actualizacion cadena operativa global 2026-06-01: la cabina adopta
`OPERATIONAL_CHAIN_GOVERNANCE_MATRIX.csv` y
`local_validate_operational_chain.ps1` como control transversal. Todo cierre,
cambio repo, automatizacion GitHub, runtime o carril paralelo debe declarar
agente, skill, receta, tool, evidencia, validador y stop condition. Si falta
un componente y no hay `NO_APLICA` justificado, se detiene con
`operational_chain_missing`.

Actualizacion skills repo-locales 2026-06-01: la cabina declara
`D:/.agents/skills` como raiz durable y portable para skills propias del repo
envoltorio. `D:/.agents/codex/skills` queda como catalogo de gobierno,
referencias fuente, matriz de uso y subskills. Las instalaciones globales de
usuario pueden ejecutar skills localmente, pero no sustituyen la fuente durable
versionada por GitHub.

Actualizacion metadata de skills 2026-06-01: las skills repo-locales bajo
`D:/.agents/skills` deben exponer description activable, trigger boundary,
allowed actions, blocked actions, validator, evidencia y stop condition. La
matriz rectora queda en
`D:/.agents/codex/skills/SKILL_METADATA_QUALITY_MATRIX.csv` y el validador en
`D:/.agents/codex/tools/local_validate_skill_metadata.ps1`.

Actualizacion carril documental 2026-06-01: la cabina adopta
`D:/.agents/codex/matrices/DOCUMENT_SKILL_LANE_MATRIX.csv` para enrutar DOCX,
spreadsheets, presentaciones y PDF a skills locales/gobernadas con owner,
reviewer, storage, evidencia, validador y stop conditions. El validador queda
en `D:/.agents/codex/tools/local_validate_document_skill_lane.ps1`. No habilita
Microsoft live, Google import live, produccion, secretos ni datos regulados
amplios sin orden gobernada separada.

Actualizacion runtime y Agents SDK local 2026-06-01: el runtime local puede
probar alineacion sin escribir resultados con
`local_run_repo_alignment_runtime.ps1 -NoWrite`. El preflight local de Agents
SDK se prueba con `local_validate_github_automation_preflight.ps1 -CheckLocalSdk`
y debe producir `smoke=OK_NO_API_CALL`; no ejecuta OpenAI API live ni habilita
Agents SDK live, Agent Builder, costos, secretos o agentes remotos persistentes.

Actualizacion merge automatizado 2026-06-01: el merge GitHub repo-scoped puede
automatizarse mediante `gh pr merge --match-head-commit` solo dentro de una
orden aprobada y con prechecks verificables: PR no draft, base `main`, rama
`codex/*`, `mergeStateStatus=CLEAN`, checks requeridos en verde, HEAD igual al
commit validado, validadores locales aplicables y postcheck. Si falla alguna
condicion se detiene con `automated_merge_precheck_failed`.

Actualizacion jerarquia AGENTS.md 2026-06-01: `D:/AGENTS.md` queda declarado
como fuente rectora local de mayor precedencia. Las instrucciones anidadas de
`.agents/codex`, perfiles de agentes, skills repo-locales, plugins y runtimes
globales solo pueden acotar dentro de esa frontera. La matriz
`D:/.agents/codex/matrices/AGENTS_INSTRUCTION_SURFACE_MATRIX.csv` y el
validador
`D:/.agents/codex/tools/local_validate_agents_instruction_hierarchy.ps1`
controlan precedencia, superficies anidadas y preservacion de repos
independientes.

Actualizacion Codex Cloud gobernado 2026-06-02: Codex Cloud queda declarado
como carril remoto repo-scoped activo y gobernado mediante
`D:/.agents/codex/maps/CODEX_CLOUD_GOVERNED_LANE.md`,
`D:/.agents/codex/matrices/CODEX_CLOUD_GOVERNED_LANE_MATRIX.csv`,
`D:/.agents/codex/matrices/CODEX_CLOUD_REPO_DISCOVERY_MATRIX_20260602.csv` y
`D:/.agents/codex/tools/local_validate_codex_cloud_governed_lane.ps1`.
`SeshatSgin/sgin-cloud` queda reconocido y verificado como environment Codex
Cloud remoto para smoke/CI read-only o no sensible. El smoke read-only
`task_e_6a1f19895190832ebd427cf6b955bc31` y el smoke CI mock
`task_e_6a1f1b60bc04832e855fe676e91c9ea7` cerraron `READY`, `files_changed=0`
y sin diff. La matriz
`D:/.agents/codex/matrices/CODEX_CLOUD_ENVIRONMENT_INVENTORY_20260602.csv`
registra environments visibles: `SeshatSgin/tcu-control-plane`,
`SeshatSgin/sgin-cloud`, `Sgin` (`universo-rey/Sgin`),
`SGIN_Canonico_Puro` y `universo-rey/cabina-universal-d`. El smoke read-only
`task_e_6a1f119843d4832e9ed821834222c003` fue iniciado sobre
`universo-rey/cabina-universal-d` y cerro `READY` con `files_changed=0` y sin
diff. El
carril no habilita secretos, Microsoft live, SharePoint real, produccion,
permisos, OpenAI API live, costos ni agentes remotos persistentes.
El clon canonico local para `sgin-cloud` es
`C:/Users/enzo1/Documents/GitHub/sgin-cloud` en `67f04f9` coincidente con
`origin/main`; el clon OneDrive
`C:/Users/enzo1/OneDrive - ESCRIBANIA BITSCH/Repos/sgin-cloud` queda limpio
pero atrasado en `194d4db` y no se mueve ni se borra sin orden gobernada
separada.
Segunda ola aprobada por el operador: smokes read-only sobre
`SeshatSgin/tcu-control-plane`, `SGIN_Canonico_Puro` y `Sgin` cerraron
`READY`, `files_changed=0`, `no diff`.

Actualizacion entornos Codex 2026-06-02: la cabina crea entorno Codex app
local/worktree repo-visible en `D:/.codex/environments/environment.toml` para
`universo-rey/cabina-universal-d`. La matriz
`D:/.agents/codex/matrices/CODEX_APP_LOCAL_ENVIRONMENT_MATRIX_20260602.csv`,
la cola `D:/.agents/codex/matrices/CODEX_ENVIRONMENT_CREATION_QUEUE_20260602.csv`,
la orden `D:/.agents/codex/orders/ORDER_CODEX_ENVIRONMENT_CREATION_20260602.md`
y el validador
`D:/.agents/codex/tools/local_validate_codex_app_environments.ps1` separan
entornos Codex app, environments Cloud visibles y repos que requieren creacion
por UI/settings. En esta sesion el CLI real disponible no expone creacion de
Codex Cloud environment, por lo que los faltantes quedan
`NEEDS_CODEX_CLOUD_UI_CREATE` y `codex_environment_creation_tool_unavailable`.
No se habilitan secretos, OpenAI API live, Microsoft live, produccion,
permisos, tenant writes ni `codex cloud apply` sin revision.

Actualizacion asignacion environments Codex Cloud 2026-06-02: tras indicacion
del operador de que los faltantes ya fueron realizados, la cabina verifico y
asigno nueve environments adicionales mediante smokes read-only que cerraron
`READY`, `files_changed=0` y sin diff: `universo-rey/organizacion`,
`SeshatSgin/torre-gemela-escribania`,
`SeshatSgin/tge-agentic-runtime-control-escribania`,
`SeshatSgin/sgin-cumplimiento`, `SeshatSgin/cdf-soluciones`,
`SeshatSgin/jara-consultores`, `SeshatSgin/seshat-bootstrap-sdu-cn`,
`SeshatSgin/tcu-agentic-runtime-control` y
`universo-rey/microsoft-agents-governed-lab`. La cola queda con 11
environments visibles dentro de base, 3 referencias visibles fuera de base y
2 pendientes por resolucion de label/environment en CLI:
`SeshatSgin/modo-on-foundation` y `SeshatSgin/sdu-canon`. Esto
no ejecuto `codex cloud apply`, no escribio en repos Cloud y no habilita
secretos, Microsoft live, OpenAI API live, produccion, permisos, costos ni
agentes remotos persistentes.

Actualizacion carriles live Codex Cloud 2026-06-02: por orden expresa del
operador, se finalizaron solo los carriles objetivo `cdf-soluciones`,
`cabina-universal-d`, `torre-gemela-escribania`, `tcu-control-plane` como
referencia fuera de base, `seshat-bootstrap-sdu-cn`,
`tcu-agentic-runtime-control`, `tge-agentic-runtime-control-escribania` y
`organizacion`. La clave `OPENAI_API_KEY` fue creada para `Modo On/SYS-SDU`
y guardada unicamente en `D:/.env.local`, ignorado por Git; no se versiona ni
se imprime el secreto. El smoke OpenAI API cerro `PASS_HTTP_200_NO_BODY_PRINTED`.
La evidencia queda en
`D:/.agents/codex/matrices/CODEX_CLOUD_LIVE_LANE_FINALIZATION_20260602.csv`
y
`D:/.agents/codex/readbacks/2026-06-02_codex_cloud_live_lane_finalization_readback.md`.
El resto de repos queda `PENDING_BY_SCOPE`. Esta actualizacion no habilita
`codex cloud apply`, Microsoft live, produccion, tenant writes, permisos,
costos abiertos, datos regulados ni uso amplio de OpenAI API sin orden
gobernada separada.

Actualizacion performance validadores 2026-06-02: tras leer los analisis
adjuntos del operador, la cabina implementa mejoras de bajo riesgo en los
validadores locales y el workflow. `local_validate_agent_layer.ps1`,
`local_run_repo_alignment_runtime.ps1`,
`local_validate_operational_chain.ps1` y
`local_validate_capability_use_hardening.ps1` cachean lecturas CSV/JSON por
proceso donde aplica. `local_validate_agent_layer.ps1` agrega
`-SkipWorkflowNestedValidators` para CI, usado solo por
`.github/workflows/cabina-validation.yml` para no relanzar validadores que el
workflow ya ejecuta como pasos propios; niveles y workpapers siguen cubiertos.
El escaneo de secretos del validador paraguas lee cada archivo una vez y
conserva evidencia `path`, `line` y `pattern`. La matriz queda en
`D:/.agents/codex/matrices/VALIDATOR_PERFORMANCE_IMPROVEMENT_MATRIX_20260602.csv`
y el readback en
`D:/.agents/codex/readbacks/2026-06-02_validator_performance_improvements_readback.md`.
La Fase 3 agrega el runner
`D:/.agents/codex/tools/local_run_governance_validation_suite.ps1`, que ejecuta
la suite existente, emite JSON agregado con duracion por validador y solo
escribe resultados si se invoca con `-WriteResult`. Tras tres corridas
manuales adicionales exitosas en GitHub Actions (`26855967863`,
`26856014739`, `26856054210`), el workflow promueve el runner a gate principal
para `pull_request`, `push` y `workflow_dispatch`; en CI debe cerrar con
`result_written=false`. El workflow puede subir un artifact JSON saneado con
resumen, conteos y duraciones, sin warnings textuales, errores textuales,
secretos ni datos live. La evidencia queda en
`D:/.agents/codex/readbacks/2026-06-02_governance_validation_suite_phase3_readback.md`
y
`D:/.agents/codex/readbacks/2026-06-02_governance_validation_suite_gate_promotion_readback.md`.
Quedan pendientes por carril separado el reemplazo change-aware del workflow,
hash sets transversales y observacion de las proximas corridas CI con el gate
principal.

Reglas vigentes:

- GitHub repo-visible reversible esta habilitado para lectura, validacion, branch, commit, push, PR draft/update, issues, labels, comentarios, GitHub Actions de validacion y readbacks bajo orden gobernada.
- Merge GitHub repo-scoped queda habilitado dentro del mismo ciclo cuando hay
  aprobacion del operador y prechecks completos con HEAD fijo, checks verdes y
  postcheck.
- La jerarquia de instrucciones locales usa `D:/AGENTS.md` como raiz. Una
  instruccion de UI, sidebar, plugin, runtime global, perfil anidado o repo
  vecino no puede contradecirlo ni absorber clones anidados.
- La automatizacion GitHub debe pasar primero por preflight local de cabina antes de seleccionar repos o abrir carriles por repo.
- La alineacion de todos los repos debe validarse con
  `local_validate_all_repo_github_alignment.ps1`; los PRs abiertos o cambios
  sucios en repos anidados son carriles repo-nativos, no cambios del repo raiz.
- Toda accion operativa debe mantener cadena agente/skill/receta/tool/validador/evidencia/stop_condition; sin esa cadena se detiene con `operational_chain_missing`.
- Todo cambio durable de repos debe pasar por GitHub: rama, validacion local, stage explicito, commit, push y PR draft/update.
- El runtime de alineacion permitido es local y sintetico; runtime live, API, Microsoft o produccion requieren orden separada.
- Los agentes preparan ordenes gobernadas cuando una solicitud cruza live, API,
  produccion, permisos, secretos, costos o datos regulados; preparar orden no
  equivale a ejecutar.
- No mover clones aun.
- Microsoft live queda gobernado a nivel global: SharePoint, Teams, Outlook, Entra, Microsoft Graph, Power Platform, Planner, Dataverse o tenant requieren orden gobernada con superficie, identidad, owner, rollback, postcheck y evidencia.
- Produccion solo con autorizacion explicita separada.
- No force push, no delete branch remoto, no merge sin aprobacion y precheck,
  no permisos, no produccion sin autorizacion, no Microsoft/SharePoint/Power
  Platform writes sin orden gobernada, no OpenAI API live ni agentes remotos
  persistentes sin orden separada.
- No versionar secretos ni datos regulados fuera de frontera.
- Escribania y Modo ON son universos.
- CDF y Jara pertenecen a Modo ON.
- Seshat y SDU pertenecen a la Corte Ejecutora.

PR rector activo: `universo-rey/organizacion#40`.
Rama rectora activa: `codex/d-drive-governance-versioning-20260601`.
PR raiz historico inicial: `universo-rey/cabina-universal-d#1` estado `MERGED`.
PR raiz historico prompt UI: `universo-rey/cabina-universal-d#2` estado `MERGED`.
PR raiz runtime/cola paralela: `universo-rey/cabina-universal-d#22` estado `MERGED`.
PR raiz readback canon: `universo-rey/cabina-universal-d#23` estado `MERGED`.
PR raiz merge automatizado: `universo-rey/cabina-universal-d#24` estado `MERGED`.
PR raiz biblioteca referencias: `universo-rey/cabina-universal-d#25` estado `MERGED`.
PR raiz frontend design: `universo-rey/cabina-universal-d#26` estado `MERGED`.
PR raiz integracion indices compartidos: `universo-rey/cabina-universal-d#27` estado `MERGED`.
Rama raiz base: `main`.
Ultima rama raiz mergeada: `codex/shared-index-integration-issues-12-15-20260602`.
Ultimo merge commit raiz: `96d378e539018d8bf2fb139e3041888bba8a5b0e`.
