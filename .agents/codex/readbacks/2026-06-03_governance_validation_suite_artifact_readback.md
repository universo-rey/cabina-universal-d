# Governance Validation Suite Artifact Readback

## Estado

HECHO_VERIFICADO: `SANITIZED_ARTIFACT_LOCAL_VALIDATED`

## Sistemas tocados

- Repo raiz `universo-rey/cabina-universal-d`
- Workflow `.github/workflows/cabina-validation.yml`
- Matriz `D:\.agents\codex\matrices\GITHUB_ACTIONS_WORKFLOW_MATRIX.csv`
- Matriz
  `D:\.agents\codex\matrices\VALIDATOR_PERFORMANCE_IMPROVEMENT_MATRIX_20260602.csv`
- Canon/manifest/README de la cabina

## Sistemas no tocados

- Microsoft live
- OpenAI API live
- Produccion
- Permisos, secretos, tenant writes y datos regulados
- Repos anidados

## Cambios

- El paso `Governance validation suite` mantiene el runner sin `-WriteResult`.
- El workflow crea `governance-validation-suite-summary.json` en
  `RUNNER_TEMP`.
- El JSON subido contiene solo resumen, conteos, duraciones y estado por
  subvalidador.
- No incluye warnings textuales, errores textuales, payloads completos,
  secretos ni datos live.
- El artifact se sube con `actions/upload-artifact@v7` y retencion de 14 dias.

## Validacion

Validadores locales ejecutados:

- `local_run_governance_validation_suite.ps1 -SkipWorkflowNestedValidators`:
  `PASS`, 18/18, `mode=MAIN_GOVERNANCE_GATE`, `duration_ms=14158`,
  `result_written=false`
- `local_validate_github_automation_preflight.ps1`: `PASS`
- `local_validate_operational_chain.ps1`: `PASS`
- `git diff --check`: `PASS`

Pendiente de cierre remoto: check del PR con artifact creado.

## Riesgos

- `actions/upload-artifact@v7` agrega una dependencia de action externa oficial
  dentro de GitHub Actions.
- Si no se crea el archivo temporal, el paso de artifact falla con
  `if-no-files-found: error`.

## Rollback

Revertir el commit del artifact o eliminar el paso
`Upload governance suite summary` y la escritura del resumen en
`RUNNER_TEMP`.

## Proximos carriles

- Verificar que el PR y el push a `main` publiquen artifact.
- Mantener `changed-files runner` y hash sets transversales en carril separado.

## Cierre

- agente: `court.thot_schema`
- orden: `aprobado`
- superficie: `D:\` repo raiz GitHub repo-scoped
- skill: `tcu-descubridor-capacidades|cabina-github-actions-templates|cabina-commit-work|governed-readback-closeout`
- receta: `recipe.github_pr_lifecycle_governed`
- tool: `tool.local_run_governance_validation_suite|actions_upload_artifact`
- estado: `SANITIZED_ARTIFACT_LOCAL_VALIDATED`
- evidencia: `workflow artifact summary planned|contents_read_preserved|runner_result_written_false`
- validador: `local_run_governance_validation_suite.ps1|local_validate_github_automation_preflight.ps1`
- riesgo: `artifact_action_dependency`
- rollback: `remove upload-artifact step and summary generation block`
- stop_condition: `github_order_missing_checks|secret_detected|capability_use_preflight_missing`
- proximos_carriles: `verify_pr_artifact|verify_main_push_artifact|changed_files_runner_later`
