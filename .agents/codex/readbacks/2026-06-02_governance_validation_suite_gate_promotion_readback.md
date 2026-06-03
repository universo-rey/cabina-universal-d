# Governance Validation Suite Gate Promotion Readback

## Orden

Medir 2-3 corridas manuales mas y decidir si el runner pasa de experimental a
gate principal.

## Estado

HECHO_VERIFICADO: `PROMOTED_MAIN_GATE_LOCAL_VALIDATED`

Decision: promover
`D:\.agents\codex\tools\local_run_governance_validation_suite.ps1` de runner
experimental a gate principal de `cabina-validation.yml`.

## Sistemas tocados

- Repo raiz `universo-rey/cabina-universal-d`
- Workflow `.github/workflows/cabina-validation.yml`
- Matrices y canon de la cabina bajo `D:\.agents\codex`, `D:\MANIFEST.yaml`,
  `D:\AGENTS.md` y `D:\02_AUTHORITY_CANON\CURRENT_STATE.md`

## Sistemas no tocados

- Microsoft live
- OpenAI API live
- Produccion
- Permisos, secretos, tenant writes y datos regulados
- Repos anidados

## Corridas manuales medidas

| run_id | conclusion | aggregate_status | validators | duration_ms | result_written |
| --- | --- | --- | --- | ---: | --- |
| 26855967863 | success | PASS | 18/18 | 25365 | false |
| 26856014739 | success | PASS | 18/18 | 14739 | false |
| 26856054210 | success | PASS | 18/18 | 13930 | false |

Todas corrieron sobre `main` en HEAD
`255692f3a30e7041a24cf82145d3cab5a0162a74`, con `failed_count=0`,
`error_count=0` y `warning_count=28` en el paso agregado.

## Cambios

- `cabina-validation.yml` usa `Governance validation suite` como gate principal
  para `pull_request`, `push` y `workflow_dispatch`.
- El workflow mantiene permisos `contents: read` y `persist-credentials: false`.
- El runner emite `mode=MAIN_GOVERNANCE_GATE`.
- La matriz de GitHub Actions declara
  `governance_validation_suite_main_gate`.
- El manifiesto, canon y README reflejan la promocion.

## Validacion

Validadores locales ejecutados antes del commit:

- `local_run_governance_validation_suite.ps1 -SkipWorkflowNestedValidators`:
  `PASS`, 18/18, `mode=MAIN_GOVERNANCE_GATE`, `duration_ms=13488`,
  `result_written=false`
- `local_validate_github_automation_preflight.ps1`: `PASS`
- `local_validate_operational_chain.ps1`: `PASS`
- `git diff --check`: `PASS`

Pendiente de cierre remoto: check del PR con el nuevo gate principal.

## Riesgos

- La UI de GitHub muestra menos pasos individuales; el diagnostico se apoya en
  el JSON del runner.
- Si un subvalidador falla, el rollback mas rapido es volver al workflow
  anterior con pasos individuales.

## Rollback

Revertir el commit de promocion o restaurar:

- el workflow con pasos individuales;
- `mode=OPTIONAL_AGGREGATE_RUNNER`;
- filas de matrices/canon a estado opcional experimental.

## Proximos carriles

- Observar las proximas corridas PR/push con el gate principal.
- Evaluar artifact JSON saneado si hace falta mejor diagnostico de fallas.
- Mantener aparte los carriles de change-aware routing y hash sets
  transversales.

## Cierre

- agente: `court.thot_schema`
- orden: `medir 2-3 corridas manuales mas y decidir si el runner pasa de experimental a gate principal`
- superficie: `D:\` repo raiz GitHub repo-scoped
- skill: `tcu-descubridor-capacidades|cabina-github-actions-templates|cabina-commit-work|governed-readback-closeout`
- receta: `recipe.github_pr_lifecycle_governed`
- tool: `tool.local_run_governance_validation_suite|tool.github_versioning_flow`
- estado: `PROMOTED_MAIN_GATE_LOCAL_VALIDATED`
- evidencia: `GitHub Actions runs 26855967863 26856014739 26856054210|18_validators_passed|result_written_false`
- validador: `local_run_governance_validation_suite.ps1|local_validate_github_automation_preflight.ps1|local_validate_operational_chain.ps1`
- riesgo: `single_step_failure_debugging_depends_on_json_payload`
- rollback: `revertir commit de promocion o restaurar workflow anterior`
- stop_condition: `capability_use_preflight_missing|github_order_missing_checks|secret_detected`
- proximos_carriles: `watch_pr_push_gate|optional_sanitized_artifact|changed_files_runner_later`
