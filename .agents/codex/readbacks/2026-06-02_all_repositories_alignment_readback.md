# Readback - all repositories alignment - 2026-06-02

## Orden

Alinear todos los repositorios registrados bajo la Cabina Universal del Rey.

## Fuente rectora

- `D:\AGENTS.md`
- `D:\01_GOVERNANCE_REGISTRY\GITHUB_BASE_WORK_MATRIX.csv`
- `D:\.agents\codex\matrices\REPO_RUNTIME_ALIGNMENT_MATRIX.csv`
- `D:\.agents\codex\matrices\CABINA_UNIVERSAL_REPO_ALIGNMENT_MATRIX.csv`

## Alcance ejecutado

- Lectura local de 12 repos registrados.
- Lectura GitHub repo-scoped de 12 remotos privados accesibles.
- Refresco de runtime local sintetico.
- Registro de validador local repetible para alineacion repo/GitHub.
- Sin writes en repos anidados.
- Sin mover clones.
- Sin Microsoft live, OpenAI API live, produccion, permisos ni secretos.

## Resultado

| repo_id | remote | branch local | head | worktree | GitHub | PRs abiertos |
| --- | --- | --- | --- | --- | --- | --- |
| D_CABINA_UNIVERSAL_ROOT | universo-rey/cabina-universal-d | codex/all-repositories-alignment-20260602 | 96d378e | dirty por evidencia en rama | ok | 0 |
| ORGANIZACION | universo-rey/organizacion | codex/d-drive-governance-versioning-20260601 | d105d02 | clean | ok | #40 draft clean; #39 ready clean |
| TORRE_GEMELA_ESCRIBANIA | SeshatSgin/torre-gemela-escribania | codex/tge-universal-repo-authority-map-20260601 | 87993ed | clean | ok | #70 draft blocked |
| TGE_AGENTIC_RUNTIME | SeshatSgin/tge-agentic-runtime-control-escribania | codex/tge-court-order-adapter-alignment-20260601 | 130c3ca | clean | ok | 0 |
| SGIN_CUMPLIMIENTO | SeshatSgin/sgin-cumplimiento | main | 443dd4b | clean | ok | 0 |
| CDF_SOLUCIONES | SeshatSgin/cdf-soluciones | codex/cdf-dual-codespace-cabina-prep | 0ded0c8 | clean | ok | #23 draft clean |
| JARA_CONSULTORES | SeshatSgin/jara-consultores | main | ed703e2 | clean | ok | 0 |
| MODO_ON_FOUNDATION | SeshatSgin/modo-on-foundation | main | b14a525 | clean | ok | 0 |
| SDU_CANON | SeshatSgin/sdu-canon | main | e111840 | clean | ok | 0 |
| SESHAT_BOOTSTRAP | SeshatSgin/seshat-bootstrap-sdu-cn | codex/seshat-global-live-governance-20260601 | 29e1de4 | dirty 5 | ok | #4 draft clean |
| SGIN | universo-rey/Sgin | main | cfb494b | clean | ok | 0 |
| TCU_AGENTIC_RUNTIME | SeshatSgin/tcu-agentic-runtime-control | main | da8a87c | clean | ok | 0 |

## Evidencia

- Runtime local: `D:\.agents\codex\evals\results\repo_alignment_runtime_latest.json`
- Alineacion GitHub/local: `D:\.agents\codex\evals\results\all_repo_github_alignment_latest.json`
- Validador: `D:\.agents\codex\tools\local_validate_all_repo_github_alignment.ps1`

## Lectura de estado

- 12/12 repos existen localmente.
- 12/12 rutas locales son worktrees Git.
- 12/12 remotos GitHub son accesibles en lectura.
- 12/12 remotos origin coinciden con `repository_full_name`.
- 5 PRs abiertos detectados en repos anidados o rector separado.
- 1 repo anidado tiene cambios locales: `SESHAT_BOOTSTRAP`.

## Stop conditions

- `root_repo_absorbing_nested_repos`: bloqueado siempre.
- `merge_without_approved_precheck`: bloqueado si falta HEAD fijo/checks verdes.
- `microsoft_live`, `openai_api_live`, `production`, `permissions`, `secrets`: fuera de alcance.
- `nested_repo_dirty_worktree`: requiere carril repo-nativo antes de versionar en ese repo.
- `blocked_pr_merge_state`: requiere resolucion en repo nativo antes de merge.

## Proximos carriles

- `ORGANIZACION`: revisar PR #40 draft y PR #39 ready bajo repo propio.
- `TORRE_GEMELA_ESCRIBANIA`: resolver PR #70 `mergeStateStatus=BLOCKED` en repo propio.
- `CDF_SOLUCIONES`: revisar PR #23 draft en repo propio.
- `SESHAT_BOOTSTRAP`: clasificar 5 cambios locales y PR #4 draft antes de cualquier merge.
- `TGE_AGENTIC_RUNTIME`: decidir si la rama local `codex/tge-court-order-adapter-alignment-20260601` necesita PR repo-nativo o cierre.
