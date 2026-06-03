# LOCAL_PACKAGE_VERSIONING_VALIDATION_REPORT

## Estado
LOCAL_PACKAGE_VERSIONING_VALIDATION_PASS

## Alcance
- Workspace: D:\
- Rama local: codex/dataverse-dev-provisioning-20260603
- Archivos clasificados: 166
- Archivos sin carril: 0
- Secret scan: LOCAL_PACKAGE_SECRET_SCAN_PASS
- Superficies live ejecutadas: ninguna.
- Commit/push/PR/merge ejecutados: no.

## Validadores
- git_diff_check: PASS (exit=0, duration_ms=119)
  - summary: warning: in the working copy of '.agents/codex/matrices/MATRIX_INDEX.csv', CRLF will be replaced by LF the next time Git touches it | warning: in the working copy of '.gitignore', LF will be replaced by CRLF the next time Git touches it
- dataverse_manifest_validator: PASS (exit=0, duration_ms=181)
- versioning_classification_csv_parse: PASS (exit=0, duration_ms=23)
- versioning_commit_group_csv_parse: PASS (exit=0, duration_ms=44)
- local_validate_agent_layer: PASS (exit=0, duration_ms=4689)
  - summary:   "subrecipe_count": 8, |   "warning_count": 0, |   "warnings": [], |   "error_count": 0, |   "errors": [], |   "secret_hit_count": 0, |   "secret_hits": [] | }
- local_validate_operational_chain: PASS (exit=0, duration_ms=188)
  - summary:   "skills": 49, |   "recipes": 23, |   "tools": 50, |   "warning_count": 0, |   "warnings": [], |   "error_count": 0, |   "errors": [] | }
- local_validate_capability_use_hardening: PASS (exit=0, duration_ms=659)
  - summary:   "plugins": 9, |   "repo_runtime_rows": 13, |   "mandatory_skill": "tcu-descubridor-capacidades", |   "warning_count": 0, |   "warnings": [], |   "error_count": 0, |   "errors": [] | }
- local_run_governance_validation_suite: PASS (exit=0, duration_ms=24188)
  - summary:       "duration_ms": 3, |       "warning_count": 0, |       "error_count": 0, |       "warnings": [], |       "errors": [] |     } |   ] | }

## Criterio
- Fallos bloqueantes: 0
- Validadores no disponibles: 0
- Si aparece FAIL en validadores requeridos, cerrar como `LOCAL_PACKAGE_VERSIONING_PARTIAL_WITH_BLOCKERS`.
