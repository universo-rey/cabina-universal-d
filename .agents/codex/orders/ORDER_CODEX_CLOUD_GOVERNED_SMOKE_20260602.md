# Order: Codex Cloud Governed Smoke

Fecha: 2026-06-02

## Orden

Preparar uso gobernado de Codex Cloud para la Cabina Universal del Rey y dejar
un primer carril smoke/CI read-only sobre `SeshatSgin/sgin-cloud`, sin
secretos, sin Microsoft live real y sin produccion. El smoke de
`universo-rey/cabina-universal-d` queda preparado en paralelo hasta resolver
environment id confiable.

## Superficie

- Codex Cloud CLI.
- GitHub repo `SeshatSgin/sgin-cloud`.
- GitHub repo `universo-rey/cabina-universal-d`.
- Clon local `D:\`.

## Owner

- lead_agent: `court.openai_dispatcher`
- owner_agent: `rey.frontier_guardian`
- reviewer_agent: `court.seshat_evidence`

## Identidad

Cuenta Codex autenticada localmente. No se imprimen tokens, secretos ni
credenciales.

## Canon As Of

`D:\AGENTS.md` vigente al 2026-06-02.

## Acciones Permitidas

- `codex cloud list --json`
- `codex cloud status <task_id>`
- `codex cloud diff <task_id>`
- preparar o ejecutar prompt smoke read-only cuando repo y rama esten fijados
- preparar smoke CI remoto no sensible sobre `sgin-cloud`
- documentar environment id faltante cuando aplique

## Acciones Bloqueadas

- `codex cloud exec` con environment o repo ambiguo
- `codex cloud apply` hasta branch `codex/*`, diff revisado y validators
- secretos o environment secrets
- Microsoft live, tenant, SharePoint, Teams, Graph, Planner, Dataverse o Power
  Platform
- produccion
- permisos
- OpenAI API live, Agents SDK live, Agent Builder, vector stores o costos
- datos regulados amplios o crudos
- engine real `sharepoint-connector` en `sgin-cloud` sin orden Microsoft live

## Data Boundary

Solo metadata de repo, `AGENTS.md`, `README.md`, `runtime-local`, `skills`,
`tests`, workflow de CI y salida de comandos no sensibles. No incluir datos
tenant, expedientes, secretos ni contenido regulado.

## Prompt Smoke Preparado

```text
Read-only smoke for SeshatSgin/sgin-cloud on main.
Do not edit files, do not open PRs, do not use secrets, do not access Microsoft
live or production. Read AGENTS.md, README.md, runtime-local, skills, tests and
.github/workflows/validate-runtime-local.yml. Report the expected validators,
the live-write boundary, and the safest next Codex Cloud CI smoke. Finish with
files_changed=0.
```

## Rollback

No hay mutacion remota ni local prevista para el smoke read-only. Si luego se
usa `apply`, el rollback sera Git local: revertir el branch `codex/*` o
descartar el patch antes de commit.

## Postcheck

- `codex cloud status <task_id>` when task exists
- `codex cloud diff <task_id>` when task exists
- `git status --short --branch`
- `D:\.agents\codex\tools\local_validate_codex_cloud_governed_lane.ps1`

## Evidencia

- Matriz: `D:\.agents\codex\matrices\CODEX_CLOUD_GOVERNED_LANE_MATRIX.csv`
- Discovery: `D:\.agents\codex\matrices\CODEX_CLOUD_REPO_DISCOVERY_MATRIX_20260602.csv`
- Mapa: `D:\.agents\codex\maps\CODEX_CLOUD_GOVERNED_LANE.md`
- Validador: `D:\.agents\codex\tools\local_validate_codex_cloud_governed_lane.ps1`

## Stop Condition

`source_uncertain|api_or_remote_agent_requested|secret_detected|regulated_data_boundary_unclear|github_order_missing_checks|microsoft_live_requested_without_governed_order|production_requested_without_explicit_authorization`
