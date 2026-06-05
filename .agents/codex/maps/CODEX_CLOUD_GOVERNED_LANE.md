# Codex Cloud Governed Lane

Estado: `CODEX_CLOUD_GOVERNED_LANE_ACTIVE`

## Proposito

Este mapa declara como la Cabina Universal usa Codex Cloud como carril remoto
activo y gobernado para repos GitHub. No es un runtime libre: opera por repo,
rama, prompt acotado, evidencia, diff y validadores. No sube secretos y no
mezcla Codex Cloud con Microsoft live, produccion o datos regulados.

Codex Cloud puede acelerar carriles paralelos cuando el trabajo es repo-scoped,
no sensible, revisable por diff y traible al clon local solo despues de
validacion.

## Activacion

Usar este carril cuando una orden pida delegar trabajo a Codex Cloud, revisar
tareas Cloud existentes, traer un diff de Cloud al clon local o preparar un
smoke remoto sobre un repo GitHub.

Repo remoto reconocido para el primer carril activo:

- `SeshatSgin/sgin-cloud`: repo privado con `AGENTS.md`, `README.md`,
  `runtime-local`, `skills`, `tests` y workflow `validate-runtime-local.yml`.
  Queda como environment Codex Cloud visible por CLI y candidato de smoke/CI
  remoto fuera de la base
  `C:\Users\enzo1\Documents\GitHub\cabina-universal-d` hasta decidir registro
  raiz. Los tasks
  `task_e_6a1f19895190832ebd427cf6b955bc31`,
  `task_e_6a1f1b60bc04832e855fe676e91c9ea7` y
  `task_e_6a1f2488d6d8832ea617a6616876e19c` cerraron `READY`, sin diff. Su
  carril `live-write` conserva SharePoint real bloqueado salvo orden Microsoft
  live separada; en CI solo se acepta engine `mock`.

Environments Codex Cloud visibles al 2026-06-02 por snapshot de UI del
operador:

- `SeshatSgin/tcu-control-plane` -> repo `SeshatSgin/tcu-control-plane`, 125
  tareas.
- `Sgin` -> repo `universo-rey/Sgin`, 45 tareas.
- `SGIN_Canonico_Puro` -> repo `SeshatSgin/SGIN_Canonico_Puro`, 6 tareas.
- `universo-rey/cabina-universal-d` -> repo
  `universo-rey/cabina-universal-d`, 0 tareas antes del smoke.

## Cadena

- lead_agent: `court.openai_dispatcher`
- owner_agent: `rey.frontier_guardian`
- reviewer_agent: `court.seshat_evidence`
- skill: `github:github|openai-docs|rey-modo-carril-codex-cloud-api|superpowers:verification-before-completion`
- receta: `recipe.codex_cloud_governed_lane|recipe.governed_order_preparation`
- tool: `tool.codex_cloud_cli_readonly|tool.local_validate_codex_cloud_governed_lane`
- validador: `.agents\codex\tools\local_validate_codex_cloud_governed_lane.ps1`

## Flujo Gobernado

1. Leer `AGENTS.md` y confirmar repo, branch, remoto y alcance.
2. Usar `codex cloud list --json` para inventario.
3. Usar `codex cloud status <task>` para estado de tareas existentes.
4. Usar `codex cloud diff <task>` para revision; no aplicar todavia.
5. Para `codex cloud exec`, exigir repo o environment confiable, rama
   declarada, prompt read-only o CI-smoke, No secrets y frontera de datos
   acotada.
6. Para `codex cloud apply`, exigir branch `codex/*`, worktree limpio, diff
   revisado, alcance repo-local, validadores definidos y rollback por Git.
7. Despues de `apply`, ejecutar validadores locales, branch/commit/push/PR y
   checks GitHub si el cambio se conserva.

## Smoke Gobernado SGIN Cloud

El primer smoke recomendado es read-only o CI no sensible:

- repo esperado: `SeshatSgin/sgin-cloud`
- rama: `main` para lectura o `codex/*` para cambio versionable
- tarea: leer `AGENTS.md`, `README.md`, `runtime-local` y workflow; reportar
  validadores esperados; no editar archivos
- evidencia esperada: `status=ready`, `files_changed=0` o diff vacio
- alternativa de CI: proponer ejecucion del workflow local de `sgin-cloud` sin
  SharePoint real y con engine `mock`

## Smoke Cabina Raiz

El smoke de `universo-rey/cabina-universal-d` fue iniciado por CLI contra
branch `main` con prompt read-only:

- task: `task_e_6a1f119843d4832e9ed821834222c003`
- estado verificado: `READY`
- diff verificado: `no diff`
- resumen verificado: `files_changed=0`

No se ejecuta `apply` sobre ese task.

## Fronteras

Permitido:

- inventario `codex cloud list`;
- estado `codex cloud status`;
- diff `codex cloud diff`;
- prompts read-only no sensibles;
- smoke remoto repo-scoped cuando repo y rama estan fijados;
- apply local solo despues de revision, branch limpia y validadores.

Requiere orden gobernada completa:

- `codex cloud exec` cuando use un environment remoto que no este
  suficientemente identificado;
- `codex cloud apply`;
- apertura de PR desde resultado Cloud;
- cualquier tarea con datos seleccionados pero sensibles;
- uso de internet del agente fuera de setup;
- secretos de environment;
- costos, Agents SDK live u OpenAI API live.

Bloqueado en este carril:

- secretos;
- Microsoft live, SharePoint, Teams, Graph, Power Platform, Planner,
  Dataverse o tenant;
- produccion;
- cambios de permisos;
- datos regulados amplios o crudos;
- force push, merge sin precheck o borrado de branch remota;
- tratar Codex Cloud como agente remoto persistente.

## Stop Conditions

- `source_uncertain` si no hay repo/environment confiable.
- `api_or_remote_agent_requested` si la orden pide runtime remoto persistente.
- `secret_detected` si el prompt, diff o setup incluye secretos.
- `regulated_data_boundary_unclear` si el dato no esta acotado.
- `github_order_missing_checks` si se intenta aplicar o versionar sin checks.
- `openai_api_live_requested_without_order` si deriva a API live o costo.
- `microsoft_live_requested_without_governed_order` si deriva a SharePoint real.
- `production_requested_without_explicit_authorization` si deriva a produccion.
