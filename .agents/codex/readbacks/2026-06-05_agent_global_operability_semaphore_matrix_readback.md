# Readback - Agent Global Operability Semaphore Matrix

agente: codex.workspace_guardian + rey.frontier_guardian + court.seshat_evidence
orden: recuperar y versionar la matriz semaforo de agent_global_operability
superficie: repo-scoped local governance matrix
repo: universo-rey/cabina-universal-d
workspace: C:\Users\enzo1\.codex\worktrees\2aa1\cabina-universal-d
branch: codex/agent-global-operability-semaphore-matrix-20260605
base: origin/main 32de5fe44210466119be4269a0d2454e9f974d2b

## Estado

AGENT_GLOBAL_OPERABILITY_SEMAPHORE_MATRIX_ROUTED

## Preflight de no duplicacion

Se busco matriz existente por nombre y funcion:

- `semaforo`
- `semáforo`
- `traffic`
- `RAG`
- `red`
- `yellow`
- `green`
- `verde`
- `amarillo`
- `rojo`
- `status matrix`
- `decision matrix`
- `gate matrix`
- `backlog`

Resultado: no se encontro una matriz semaforo explicita. Se reutilizo como fuente la matriz de backlog gated ya mergeada por PR #104.

## Regla semaforo

| Color | Significado operativo |
| --- | --- |
| GREEN | Frontera local satisfecha; no requiere accion nueva. |
| YELLOW | Guardrail activo; puede avanzar solo dentro de scope explicito. |
| RED | Gate real pendiente; no ejecutar sin orden humana/gate requerido. |

## Conteo

- GREEN: 4
- YELLOW: 1
- RED: 4

## Acciones ejecutadas

- Se creo `.agents/codex/matrices/AGENTS_SDK_LIVE_AGENT_GLOBAL_OPERABILITY_SEMAPHORE_MATRIX_20260605.csv`.
- Se registro la matriz en `MATRIX_INDEX.csv`.
- Se agrego cobertura especifica en `VALIDATION_COVERAGE_MATRIX.csv`.
- Se agrego `.agents/codex/tools/local_validate_agent_global_operability_semaphore.ps1` para validar columnas, colores, estados y consistencia contra backlog.
- Se agrego `.agents/codex/tools/local_validate_agent_global_operability_package.ps1` para validar todos los artefactos del paquete no analizados semanticamente: findings, decisiones, RACI, workflow, org chart, SDU plan, framework, backlog, semaforo y mapas.
- Se actualizo la cobertura de las matrices/mapas `agents_sdk_live_agent_global_operability_*` para usar el validador especifico de paquete donde antes dependian solo de `local_validate_agent_layer.ps1`.
- Se agregaron los validators `agent_global_operability_package` y `agent_global_operability_semaphore` a `CHANGE_AWARE_TEST_MANIFEST.csv`.
- Se agregaron reglas de impacto para matrices, mapas y validators `agent_global_operability` en `CHANGE_AWARE_IMPACT_GRAPH.csv`.
- Se actualizo `MANIFEST.yaml` a `change_aware_required_test_count: 22`.
- Se agrego allowlist exacta del readback en `.gitignore`.

## Coverage

- Kernel semaforo: `.agents/codex/tools/local_validate_agent_global_operability_semaphore.ps1`.
- Kernel paquete: `.agents/codex/tools/local_validate_agent_global_operability_package.ps1`.
- Indexado de tools: `.agents/codex/tools/TOOL_INDEX.csv`.
- Metadata de tools: `.agents/codex/matrices/TOOL_GOVERNANCE_MATRIX.csv`.
- Coverage declarativa: `.agents/codex/matrices/VALIDATION_COVERAGE_MATRIX.csv`.
- Gate productivo: `.agents/codex/matrices/CHANGE_AWARE_TEST_MANIFEST.csv`.
- Enrutamiento change-aware: `.agents/codex/matrices/CHANGE_AWARE_IMPACT_GRAPH.csv`.

Validacion local ejecutada:

- `local_validate_agent_global_operability_semaphore.ps1`: PASS.
- `local_validate_agent_global_operability_package.ps1`: PASS.
- `local_validate_change_aware_full_coverage_orchestrator.ps1`: PASS, 22/22 tests planificados.
- `local_run_change_aware_full_coverage_orchestrator.ps1`: PASS, 22/22 tests ejecutados, `coverage_equivalence=true`.
- No se ejecuto OpenAI API live.
- No se ejecuto Microsoft live.
- No se toco produccion.
- No se tocaron secretos.
- No se tocaron repos externos ni repos anidados.

## Riesgo

bajo. Es una vista operacional derivada de decisiones ya versionadas y backlog ya mergeado.

## Rollback

Revertir el commit del carril o eliminar la matriz semaforo, su fila de indice, su fila de cobertura, la allowlist exacta y este readback.

## Stop condition

AGENT_GLOBAL_OPERABILITY_SEMAPHORE_MATRIX_ROUTED
