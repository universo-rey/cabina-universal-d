# Readback - Microsoft Agents Governed Lab Alignment - 2026-06-02

## Orden

El operador aprobo los proximos carriles para `universo-rey/microsoft-agents-governed-lab`.

## Resultado

El repo quedo incorporado a la cabina como activo gobernado de `ESCRIBANIA`
bajo torre `TGE`, sin absorberlo en el repo raiz.

## Evidencia local

- Ruta local: `D:\10_UNIVERSOS\ESCRIBANIA\10_REPOS\02_ACTIVE\microsoft-agents-governed-lab`
- Rama local: `main`
- HEAD local: `70b88a5`
- `origin`: `https://github.com/universo-rey/microsoft-agents-governed-lab.git`
- `upstream`: `https://github.com/microsoft/Agents.git`
- `upstream push`: `DISABLED`
- Worktree lab: `clean`

## Evidencia GitHub

- Repo privado: `universo-rey/microsoft-agents-governed-lab`
- Base: `main`
- Estado: `TGE_GOVERNED_REPO_ACTIVE`
- PR #3: validador/readback upstream, `MERGED`, merge commit `c48b7c4`.
- PR #4: NuGet sample dependency update en rama `codex/*`, `MERGED`, merge commit `2074079`.
- PR #6: npm sample dependency update con fix peer ESLint/neostandard, `MERGED`, merge commit `70b88a5`.
- PR #1: Dependabot NuGet, `CLOSED` como sustituido por #4.
- PR #2: Dependabot npm, `CLOSED` como sustituido por #6.
- PR #5: Dependabot npm duplicado, `CLOSED` como sustituido por #6.
- PRs abiertos del lab: `0`.

## Matrices actualizadas

- `D:\01_GOVERNANCE_REGISTRY\GITHUB_BASE_WORK_MATRIX.csv`
- `D:\01_GOVERNANCE_REGISTRY\REPOSITORIES.csv`
- `D:\.agents\codex\matrices\CABINA_UNIVERSAL_REPO_ALIGNMENT_MATRIX.csv`
- `D:\.agents\codex\matrices\REPO_RUNTIME_ALIGNMENT_MATRIX.csv`
- `D:\.agents\codex\matrices\RUNTIME_ALIGNMENT_STATUS_MATRIX.csv`
- `D:\.agents\codex\matrices\REPO_GOVERNANCE_ASSIGNMENT_MATRIX.csv`
- `D:\.agents\codex\matrices\GOVERNED_ASSET_CANONICAL_INVENTORY.csv`

## Validadores

- `local_run_repo_alignment_runtime.ps1 -NoWrite`: `PASS`, 13 repos.
- `local_validate_all_repo_github_alignment.ps1 -WriteResult`: `PASS`, 13/13 GitHub accesibles, lab `open_pr_count=0`.
- `local_validate_agent_layer.ps1`: `PASS`, 13 repos gobernados.
- `local_validate_order_packets.ps1`: `PASS`.
- `git diff --check`: `PASS`.

## No ejecutado

- No se ejecuto Microsoft live.
- No se ejecuto tenant write.
- No se ejecuto produccion.
- No se cambiaron permisos.
- No se escribio en SharePoint, Teams, Planner, Graph ni Power Platform.
- No se hizo push a `microsoft/Agents`.

## Riesgo

El repo contiene codigo y dependencias de laboratorio tomadas desde upstream
`microsoft/Agents`. Su uso productivo requiere carril separado, revision de
dependencias, validacion repo-nativa y orden de superficie Microsoft exacta.
El carril npm quedo con `npm audit --json` en `total=0` al cierre repo-nativo.

## Rollback

- Eliminar la fila del lab de las matrices de cabina.
- Remover el clon local si el operador ordena rollback de ubicacion.
- Conservar el repo remoto privado sin cambios.

## Stop condition

`microsoft_live_or_productive_agent_without_order`

## Proximos carriles

- Mantener `00_TGE_GOBIERNO/tools/Validate-GovernedLab.ps1` como validador repo-nativo.
- Preparar carril de comparacion controlada con `upstream/main` si se decide sincronizar.
- Abrir carril separado antes de cualquier ejecucion Microsoft live, tenant write o produccion.
