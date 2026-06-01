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

Actualizacion cadena operativa global 2026-06-01: la cabina adopta
`OPERATIONAL_CHAIN_GOVERNANCE_MATRIX.csv` y
`local_validate_operational_chain.ps1` como control transversal. Todo cierre,
cambio repo, automatizacion GitHub, runtime o carril paralelo debe declarar
agente, skill, receta, tool, evidencia, validador y stop condition. Si falta
un componente y no hay `NO_APLICA` justificado, se detiene con
`operational_chain_missing`.

Reglas vigentes:

- GitHub repo-visible reversible esta habilitado para lectura, validacion, branch, commit, push, PR draft/update, issues, labels, comentarios, GitHub Actions de validacion y readbacks bajo orden gobernada.
- La automatizacion GitHub debe pasar primero por preflight local de cabina antes de seleccionar repos o abrir carriles por repo.
- Toda accion operativa debe mantener cadena agente/skill/receta/tool/validador/evidencia/stop_condition; sin esa cadena se detiene con `operational_chain_missing`.
- Todo cambio durable de repos debe pasar por GitHub: rama, validacion local, stage explicito, commit, push y PR draft/update.
- El runtime de alineacion permitido es local y sintetico; runtime live, API, Microsoft o produccion requieren orden separada.
- Los agentes preparan ordenes gobernadas cuando una solicitud cruza live, API,
  produccion, permisos, secretos, costos o datos regulados; preparar orden no
  equivale a ejecutar.
- No mover clones aun.
- Microsoft live queda gobernado a nivel global: SharePoint, Teams, Outlook, Entra, Microsoft Graph, Power Platform, Planner, Dataverse o tenant requieren orden gobernada con superficie, identidad, owner, rollback, postcheck y evidencia.
- Produccion solo con autorizacion explicita separada.
- No force push, no delete branch remoto, no merge a rama protegida, no permisos, no produccion sin autorizacion, no Microsoft/SharePoint/Power Platform writes sin orden gobernada, no OpenAI API live ni agentes remotos persistentes sin orden separada.
- No versionar secretos ni datos regulados fuera de frontera.
- Escribania y Modo ON son universos.
- CDF y Jara pertenecen a Modo ON.
- Seshat y SDU pertenecen a la Corte Ejecutora.

PR rector activo: `universo-rey/organizacion#40`.
Rama rectora activa: `codex/d-drive-governance-versioning-20260601`.
PR raiz historico inicial: `universo-rey/cabina-universal-d#1` estado `MERGED`.
PR raiz historico prompt UI: `universo-rey/cabina-universal-d#2` estado `MERGED`.
Rama raiz base: `main`.
Ultima rama raiz mergeada: `codex/d-root-ui-master-prompt-20260601`.
