# LOCAL_PACKAGE_POST_COMMIT_VALIDATION_REPORT

## Estado
LOCAL_PACKAGE_POST_COMMIT_VALIDATION_PASS

## Alcance
- Rama: codex/dev-dataverse-workqueues-openai-package-20260603
- Base diff: origin/main...HEAD
- Live externo ejecutado en esta validacion: ninguno.
- `.env.local`: no leido; sigue fuera del diff versionado.

## Validadores
- git_status_short_branch: PASS (exit=0, duration_ms=396)
  - summary: ## codex/dev-dataverse-workqueues-openai-package-20260603
- git_log_oneline_12: PASS (exit=0, duration_ms=140)
  - summary: e15a39f feat(openai): add metadata-only assisted classification artifacts | 0105645 feat(powerautomate): bind seeded registry to DEV work queues | 9b101f4 feat(dataverse): add governed DEV metadata-only registry seed | 50714d3 feat(connections): add canonical connection registry dedup and seed prep | 31e903d chore(gitignore): protect local secrets and allow governed metadata artifacts | eb0eaaa Merge PR #63: Canonize extended reconciliation state | 189dd1d Canonize extended reconciliation state | d070e87 Merge PR #62: Activate standard agent chain | e821f51 Activate standard agent chain | 45f261a Merge PR #61: SDK and Codex Cloud full lifecycle evidence
- git_diff_origin_main_stat: PASS (exit=0, duration_ms=764)
  - summary:  .../openai/OPENAI_API_METADATA_ONLY_PREFLIGHT.md   |    20 + |  .../OPENAI_API_METADATA_ONLY_VALIDATION_REPORT.md  |    26 + |  .../powerautomate/PARALLEL_WORK_QUEUE_PREFLIGHT.md |    27 + |  .../WORK_QUEUE_BINDING_VALIDATION_REPORT.md        |    14 + |  .../WORK_QUEUE_ENVIRONMENT_PRECHECK.md             |    31 + |  .../WORK_QUEUE_OPERATIONAL_POSTCHECK.md            |    38 + |  .../LOCAL_PACKAGE_CONTINUATION_PREFLIGHT.md        |    33 + |  .../versioning/LOCAL_PACKAGE_SECRET_SCAN_REPORT.md |    30 + |  .../LOCAL_PACKAGE_VERSIONING_VALIDATION_REPORT.md  |    33 + |  167 files changed, 167064 insertions(+)
- git_diff_origin_main_check: PASS (exit=0, duration_ms=466)
- dataverse_manifest_validator: PASS (exit=0, duration_ms=458)
- csv_versioning_parse_classification: PASS (exit=0, duration_ms=69)
- csv_versioning_parse_commit_groups: PASS (exit=0, duration_ms=125)
- local_validate_agent_layer: PASS (exit=0, duration_ms=7391)
  - summary:   "subagent_capability_count": 5, |   "subskill_count": 27, |   "subrecipe_count": 8, |   "warning_count": 0, |   "warnings": [], |   "error_count": 0, |   "errors": [], |   "secret_hit_count": 0, |   "secret_hits": [] | }
- local_validate_operational_chain: PASS (exit=0, duration_ms=278)
  - summary:   "operational_chain_rows": 10, |   "agents": 14, |   "skills": 49, |   "recipes": 23, |   "tools": 50, |   "warning_count": 0, |   "warnings": [], |   "error_count": 0, |   "errors": [] | }
- local_validate_capability_use_hardening: PASS (exit=0, duration_ms=705)
  - summary:   "recipes": 23, |   "tools": 50, |   "plugins": 9, |   "repo_runtime_rows": 13, |   "mandatory_skill": "tcu-descubridor-capacidades", |   "warning_count": 0, |   "warnings": [], |   "error_count": 0, |   "errors": [] | }
- local_run_governance_validation_suite: PASS (exit=0, duration_ms=31149)
  - summary:       "started_at": "2026-06-03T09:27:31.5131171-03:00", |       "finished_at": "2026-06-03T09:27:31.5148107-03:00", |       "duration_ms": 2, |       "warning_count": 0, |       "error_count": 0, |       "warnings": [], |       "errors": [] |     } |   ] | }
- secret_scan_material_diff_files: PASS (exit=0, duration_ms=0)
  - summary: diff_files=167; findings=0

## Criterio
- Fallos: 0
- Secret material findings: 0
- Estado de cierre: LOCAL_PACKAGE_POST_COMMIT_VALIDATION_PASS
