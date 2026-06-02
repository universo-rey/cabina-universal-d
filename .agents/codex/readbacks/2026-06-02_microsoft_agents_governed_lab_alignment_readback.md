# Readback - Microsoft Agents Governed Lab Alignment - 2026-06-02

## Orden

El operador aprobo los proximos carriles para `universo-rey/microsoft-agents-governed-lab`.

## Resultado

El repo quedo incorporado a la cabina como activo gobernado de `ESCRIBANIA`
bajo torre `TGE`, sin absorberlo en el repo raiz.

## Evidencia local

- Ruta local: `D:\10_UNIVERSOS\ESCRIBANIA\10_REPOS\02_ACTIVE\microsoft-agents-governed-lab`
- Rama local: `main`
- HEAD local: `ba27bd0`
- `origin`: `https://github.com/universo-rey/microsoft-agents-governed-lab.git`
- `upstream`: `https://github.com/microsoft/Agents.git`
- `upstream push`: `DISABLED`
- Worktree lab: `clean`

## Evidencia GitHub

- Repo privado: `universo-rey/microsoft-agents-governed-lab`
- Base: `main`
- Estado: `TGE_GOVERNED_REPO_ACTIVE`
- PR abierto #1: Dependabot NuGet, `mergeStateStatus=CLEAN`
- PR abierto #2: Dependabot npm, `mergeStateStatus=UNSTABLE`

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
- `local_validate_all_repo_github_alignment.ps1`: `PASS`, 13/13 GitHub accesibles.
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

## Rollback

- Eliminar la fila del lab de las matrices de cabina.
- Remover el clon local si el operador ordena rollback de ubicacion.
- Conservar el repo remoto privado sin cambios.

## Stop condition

`microsoft_live_or_productive_agent_without_order`

## Proximos carriles

- Revisar PR #1 del lab en repo nativo.
- Revisar PR #2 del lab en repo nativo y resolver `UNSTABLE`.
- Definir validador repo-nativo del lab antes de cualquier branch `codex/*`.
- Preparar carril de comparacion controlada con `upstream/main` si se decide sincronizar.
