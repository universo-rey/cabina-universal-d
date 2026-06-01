# Repo Scope

Estado: `D_ROOT_WRAPPER_REPO_LOCAL`

Este repo nuevo gobierna la raiz `D:\` como Cabina Universal del Rey sin
absorber los repos anidados.

## Regla

- `D:\` es repo local envoltorio para que Codex y Git vean una raiz nativa.
- `organizacion` conserva su propio repo en
  `D:\01_GOVERNANCE_REGISTRY\10_REPOS\02_ACTIVE\organizacion`.
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
- Ultimo merge commit raiz:
  `98b7ddb6969abda83c36b3101307a99075856c7f`.
- GitHub es la base de trabajo para todo cambio durable del universo de
  repositorios: cada cambio debe ir por rama, validacion, commit, push y PR.
- GitHub Actions queda aprobado para validacion repo-scoped con permisos
  `contents: read`; no habilita secretos, produccion, permisos ni live externo.

## Bloqueos

- No `git add .` sobre `D:\`.
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
- objetivo: hacer visible el repo raiz `D:\`, su arbol, ramas y PRs en la UI
  nativa de Codex.
- alcance: documental y capacidades locales saneadas; no absorbe clones ni
  reemplaza `organizacion`.

## Capacidades locales versionables

La cabina raiz versiona perfiles de agentes, skills, recipes, tools, evals,
plugins y templates locales bajo `.agents\codex` cuando son declarativos,
saneados y necesarios para operar la cabina. Las fuentes de otros repos quedan
como copias `SOURCE_*` trazadas en
`.agents\codex\matrices\CAPABILITY_IMPORT_DECISION_MATRIX.csv`.

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
