# Repo Scope

Estado: `C_ROOT_EFFECTIVE_CABINA_REPO_ACTIVE`

Este repo gobierna la raiz efectiva
`C:\Users\enzo1\Documents\GitHub\cabina-universal-d` como Cabina Universal del
Rey sin absorber los repos anidados. `D:\` queda solo como superficie legacy,
read-only y gobernada hasta decision explicita de metadata retention.

## Regla

- `C:\Users\enzo1\Documents\GitHub\cabina-universal-d` es repo local envoltorio
  para que Codex y Git vean una raiz nativa.
- `organizacion` conserva su propio repo en
  `01_GOVERNANCE_REGISTRY\10_REPOS\02_ACTIVE\organizacion`.
- Los demas clones bajo `10_REPOS\02_ACTIVE` conservan sus propios repos.
- El repo raiz usa allowlist: ignora todo por defecto y solo versiona archivos
  rectores seleccionados.
- Remoto configurado: `https://github.com/universo-rey/cabina-universal-d.git`.
- Visibilidad remota: privada.
- Base raiz rectora/remota: `main`.
- PR raiz historico: `https://github.com/universo-rey/cabina-universal-d/pull/1`
  estado `MERGED`.
- PR raiz prompt UI: `https://github.com/universo-rey/cabina-universal-d/pull/2`
  estado `MERGED`.
- PR raiz Change-Aware Full-Coverage Orchestrator:
  `https://github.com/universo-rey/cabina-universal-d/pull/53` estado
  `MERGED`.
- Ultimo merge commit raiz:
  `d21aad4280180328c41e4ca91c61e033a63551b6`.
- GitHub es la base de trabajo para todo cambio durable del universo de
  repositorios: cada cambio debe ir por rama, validacion, commit, push y PR.
- GitHub Actions queda aprobado para validacion repo-scoped con permisos
  `contents: read`; no habilita secretos, produccion, permisos ni live externo.

## Bloqueos

- No `git add .` sobre la raiz efectiva; stagear rutas explicitas.
- No versionar `.secrets`, caches, clones completos, dumps, credenciales,
  expedientes o datos regulados.
- No mover clones.
- No reemplazar el repo `universo-rey/organizacion`.

## Proximo carril

Para nuevos cambios versionables, crear rama `codex/*` desde `main`, validar,
stagear archivos explicitos, commitear, pushear y abrir PR bajo orden
gobernada.

## Rama visible en Codex

- base rectora/remota: `main`
- rama historica mergeada: `codex/d-root-ui-visibility-20260601`
- objetivo: hacer visible el repo raiz efectivo
  `C:\Users\enzo1\Documents\GitHub\cabina-universal-d`, su arbol, ramas y PRs
  en la UI nativa de Codex.
- alcance: documental y capacidades locales saneadas; no absorbe clones ni
  reemplaza `organizacion`.

## Capacidades locales versionables

La cabina raiz versiona perfiles de agentes, skills, recipes, tools, evals,
plugins y templates locales bajo `.agents\codex` cuando son declarativos,
saneados y necesarios para operar la cabina. Las fuentes de otros repos quedan
como copias `SOURCE_*` trazadas en
`.agents\codex\matrices\CAPABILITY_IMPORT_DECISION_MATRIX.csv`.

Los workpapers saneados bajo `.agents\codex\workpapers` tambien son
versionables porque el workflow de GitHub Actions los necesita para validar la
capa de agentes sin abrir repos externos ni superficies live.

Las retrospectivas saneadas y plantillas de orden bajo
`.agents\codex\readbacks` y `.agents\codex\orders` son versionables cuando el
operador abre un carril de cierre, mejora de matriz o preparacion de orden.

## Base GitHub transversal

El repo remoto `universo-rey/cabina-universal-d` es base de trabajo transversal
de la cabina y no reemplaza los repos anidados. Cada repo del universo conserva
su propio remoto GitHub; la cabina raiz registra ruta, frontera y PR esperado
en `01_GOVERNANCE_REGISTRY\GITHUB_BASE_WORK_MATRIX.csv`.

La matriz
`.agents\codex\matrices\CABINA_UNIVERSAL_REPO_ALIGNMENT_MATRIX.csv` declara la
alineacion transversal de todos los repos registrados hacia
`universo-rey/cabina-universal-d`. Esa alineacion aprueba agentes GitHub para
issues, ramas, commits, push y PR repo-scoped. Runtime productivo y live externo
siguen fuera de esa aprobacion.

La matriz `.agents\codex\matrices\GITHUB_ACTIONS_WORKFLOW_MATRIX.csv` declara
el workflow `.github\workflows\cabina-validation.yml` como superficie GitHub
Actions aprobada para validadores locales y policy check de workflows.

El gate productivo vigente de `cabina-validation.yml` es
`.agents\codex\tools\local_run_change_aware_full_coverage_orchestrator.ps1`.
El orquestador puede ordenar, priorizar riesgo, ajustar paralelismo declarado y
emitir evidencia, pero no reduce cobertura obligatoria: todo PR debe conservar
`all_required_passed=true`, `coverage_equivalence=true`, `manifest_valid=true`,
`graph_valid=true`, `no_hidden_flaky=true` y `blocked_surfaces_clear=true`.

Las matrices `.agents\codex\matrices\PARALLEL_OPERATION_CRITERIA_MATRIX.csv`
y `.agents\codex\matrices\ORDER_PREPARATION_ASSIGNMENT_MATRIX.csv` gobiernan
agentes, subagentes, carriles paralelos y preparacion de ordenes.

Los validadores semanticos de paralelo y ordenes forman parte del alcance
repo-scoped y no habilitan agentes remotos persistentes ni conectores live.
