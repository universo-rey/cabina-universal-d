# Cabina Universal Del Rey

Estado: `D_ROOT_WRAPPER_REPO_MAIN_ACTIVE`

## Estado canonico actual

La Cabina Universal del Rey opera como
`CABINA_FULL_LIVE_GOVERNED_GLOBAL_CANON`.

Ya no queda limitada a repo-only. GitHub sigue siendo canon tecnico, pero la
cabina queda habilitada para gobernar runtime live, OpenAI, Codex Cloud,
Agents SDK, Microsoft 365, produccion y propagacion bajo gates explicitos.
Todo write live requiere target exacto, owner, identidad, rollback, postcheck,
evidencia, stop condition y readback.

Este disco contiene el mapa local objetivo para organizar repos, herramientas, sistemas, licencias, evidencia y archivos por jerarquia.

Por orden expresa del operador, `D:\` puede operar como repo local envoltorio
para visibilidad nativa de Codex/Git. Este repo no absorbe clones anidados:
`organizacion` y los demas repos conservan sus propios `.git`.

Remoto privado del repo raiz: `https://github.com/universo-rey/cabina-universal-d`.

Base rectora/remota visible para Codex/Git: `main`. La rama activa debe
verificarse en cada sesion. El PR raiz #1 esta mergeado; nuevos cambios
versionables deben usar rama `codex/*` desde `main` y PR gobernado.

Alineacion universal local: los repos registrados se alinean a
`universo-rey/cabina-universal-d` como base transversal e indice, sin perder
su remoto nativo. Los agentes GitHub/Copilot y GitHub Actions de validacion
estan aprobados para issues, ramas, commits, push, PR y checks repo-scoped;
runtime productivo y live externo quedan habilitados solo bajo el canon
`CABINA_FULL_LIVE_GOVERNED_GLOBAL_CANON`, con gates explicitos y sin writes
ciegos.

Agentes en GitHub: `.github/copilot-instructions.md`,
`.github/ISSUE_TEMPLATE/agent-task.yml`,
`.github/ISSUE_TEMPLATE/runtime-approval.yml` y `.github/PULL_REQUEST_TEMPLATE.md`
publican la forma GitHub aprobada para operar agentes en issues, ramas, commits
y PRs sin activar produccion. `.github/workflows/cabina-validation.yml` ejecuta
validaciones locales en GitHub Actions con permisos `contents: read`; usa los
workpapers saneados bajo `.agents/codex/workpapers` como evidencia declarativa.

Operacion paralela: `.agents/codex/matrices/PARALLEL_OPERATION_CRITERIA_MATRIX.csv`
define carriles, owners, alcance, evidencia, validador y stop condition.
`.agents/codex/matrices/ORDER_PREPARATION_ASSIGNMENT_MATRIX.csv` asigna que
agente prepara cada orden gobernada antes de cualquier live, API, produccion,
permiso, secreto, costo o dato regulado.

Los carriles paralelos requieren scopes y locks declarados. Las ordenes
gobernadas se preparan como paquetes locales antes de ejecutar cualquier
superficie live, costo, permiso o produccion.

Regla de lectura:

1. `00_CONTROL_PLANE_INGRESS` recibe.
2. `01_GOVERNANCE_REGISTRY` clasifica.
3. `02_AUTHORITY_CANON` gobierna.
4. `03_CORTE_EJECUTORA_DEL_REY` ejecuta con agentes OpenAI, Seshat y SDU.
5. `10_UNIVERSOS` contiene universos operativos como Escribania y Modo ON.

No copiar repos, mover carpetas, ejecutar cambios live ni publicar remoto desde
este mapa sin orden gobernada, target exacto, rollback, postcheck y evidencia.
