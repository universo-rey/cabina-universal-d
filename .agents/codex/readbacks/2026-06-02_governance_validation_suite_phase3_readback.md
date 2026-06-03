# Governance Validation Suite Phase 3 Readback

## Orden

Cerrar primero `universo-rey/cabina-universal-d#43` y despues ejecutar Fase 3
del plan de performance de validadores.

## Estado

`#43` fue mergeado primero en `main` con merge commit
`d786ff4c0235dd68e413685a2138b6491607a889`.

Fase 3 agrega un runner agregado opcional:

- `D:\.agents\codex\tools\local_run_governance_validation_suite.ps1`

El runner ejecuta los validadores existentes, agrega estado por subvalidador,
duracion, warnings, errores y salida JSON. No reemplaza los pasos actuales del
workflow y no escribe resultados salvo invocacion con `-WriteResult`.

Smoke local:

- comando: `local_run_governance_validation_suite.ps1 -SkipWorkflowNestedValidators`
- estado: `PASS`
- validadores: `18/18`
- duracion: `16812 ms`
- warnings: `3`, todas esperadas por omision de validadores ya cubiertos en
  workflow
- errores: `0`

## Superficie

- Repo raiz: `universo-rey/cabina-universal-d`
- Rama de trabajo: `codex/validator-suite-runner-phase3-20260602`
- Base: `main`
- Microsoft live: no usado
- OpenAI API live: no usado
- Produccion: no usada
- Secretos: no materializados

## Artefactos

- `.agents/codex/tools/local_run_governance_validation_suite.ps1`
- `.github/workflows/cabina-validation.yml`
- `.agents/codex/tools/TOOL_INDEX.csv`
- `.agents/codex/matrices/TOOL_GOVERNANCE_MATRIX.csv`
- `.agents/codex/matrices/VALIDATION_COVERAGE_MATRIX.csv`
- `.agents/codex/matrices/VALIDATOR_PERFORMANCE_IMPROVEMENT_MATRIX_20260602.csv`
- `.agents/codex/matrices/GITHUB_ACTIONS_WORKFLOW_MATRIX.csv`
- `.agents/codex/README.md`
- `02_AUTHORITY_CANON/CURRENT_STATE.md`
- `AGENTS.md`
- `MANIFEST.yaml`

## Workflow

El workflow conserva los validadores individuales como gate principal para
`pull_request` y `push`. El runner agregado solo corre en `workflow_dispatch`
cuando `run_aggregate_suite=true`.

## Validacion esperada

- `local_run_governance_validation_suite.ps1 -SkipWorkflowNestedValidators`
- `local_validate_agent_layer.ps1 -SkipWorkflowNestedValidators`
- `local_validate_operational_chain.ps1`
- `local_validate_capability_use_hardening.ps1`
- `local_validate_github_automation_preflight.ps1`
- `git diff --check`

## Cierre

- agente: `court.thot_schema`
- orden: `cerrar 43 primero y despues fase 3`
- superficie: `D:\` repo raiz GitHub repo-scoped
- skill: `tcu-descubridor-capacidades|superpowers:executing-plans`
- receta: `recipe.repo_universe_alignment_runtime`
- tool: `tool.local_run_governance_validation_suite`
- estado: `implemented_validated`
- evidencia: `runner agregado opcional|workflow_dispatch experimental|18_validators_passed|duration_16812ms`
- validador: `local_run_governance_validation_suite.ps1`
- riesgo: `experimental_runner_must_not_replace_existing_gate`
- rollback: revertir runner, fila de workflow y filas de indices/matrices
- stop_condition: `capability_use_preflight_missing|github_order_missing_checks|secret_detected`
- proximos_carriles: comparar tiempos de workflow manual; luego decidir si reemplaza pasos individuales
