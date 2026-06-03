# LOCAL_PACKAGE_POST_COMMIT_VALIDATION_REPORT

## Estado
LOCAL_PACKAGE_POST_FIX_VALIDATION_PASS

## Alcance
- Rama: codex/dev-dataverse-workqueues-openai-package-20260603
- Base diff: origin/main...HEAD
- Live externo ejecutado en esta validacion: ninguno.
- `.env.local`: no leido; sigue fuera del diff versionado.

## Validadores
- git_status_short_branch: PASS (exit=0, duration_ms=76)
  - summary: ## codex/dev-dataverse-workqueues-openai-package-20260603...origin/codex/dev-dataverse-workqueues-openai-package-20260603 [ahead 1]
- git_diff_origin_main_check: PASS (exit=0, duration_ms=272)
- dataverse_manifest_validator: PASS (exit=0, duration_ms=133)
- csv_versioning_parse_classification: PASS (exit=0, duration_ms=6)
- csv_versioning_parse_commit_groups: PASS (exit=0, duration_ms=1)
- local_validate_agent_layer: PASS (exit=0, duration_ms=2960)
  - summary:   "subagent_capability_count": 5, |   "subskill_count": 27, |   "subrecipe_count": 8, |   "warning_count": 0, |   "warnings": [], |   "error_count": 0, |   "errors": [], |   "secret_hit_count": 0, |   "secret_hits": [] | }
- local_validate_operational_chain: PASS (exit=0, duration_ms=173)
  - summary:   "operational_chain_rows": 10, |   "agents": 14, |   "skills": 49, |   "recipes": 23, |   "tools": 50, |   "warning_count": 0, |   "warnings": [], |   "error_count": 0, |   "errors": [] | }
- local_validate_capability_use_hardening: PASS (exit=0, duration_ms=465)
  - summary:   "recipes": 23, |   "tools": 50, |   "plugins": 9, |   "repo_runtime_rows": 13, |   "mandatory_skill": "tcu-descubridor-capacidades", |   "warning_count": 0, |   "warnings": [], |   "error_count": 0, |   "errors": [] | }
- local_run_governance_validation_suite: PASS (exit=0, duration_ms=16366)
  - summary:       "started_at": "2026-06-03T09:36:16.9723274-03:00", |       "finished_at": "2026-06-03T09:36:16.9738714-03:00", |       "duration_ms": 2, |       "warning_count": 0, |       "error_count": 0, |       "warnings": [], |       "errors": [] |     } |   ] | }
- change_aware_full_coverage_orchestrator: PASS (exit=0, duration_ms=17267)
  - summary:       "started_at": "2026-06-03T09:36:33.5677535-03:00", |       "finished_at": "2026-06-03T09:36:34.2164219-03:00", |       "duration_ms": 649, |       "warning_count": 0, |       "error_count": 0, |       "warnings": [], |       "errors": [] |     } |   ] | }
- secret_scan_material_diff_files: PASS (exit=0, duration_ms=0)
  - summary: diff_files=169; findings=0

## Fixes aplicados
- `fix(ci): allow governed secret-boundary evidence paths`: mantiene bloqueo de secretos materiales y permite solo evidencia gobernada de frontera/secret-scan.

## Criterio
- Fallos: 0
- Secret material findings: 0
- Estado de cierre: LOCAL_PACKAGE_POST_FIX_VALIDATION_PASS
