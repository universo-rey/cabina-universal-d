# SKILLS_INDEX

Estado: indice humano para paquete documental de skills. No autoriza instalacion, runtime ni publicacion remota.

## Resumen

- Registros normalizados: 78.
- Registros con `SKILL.md` directo o equivalente: 76.
- Registros listos para GitHub como metadata: 76.
- Referencias sin implementacion fisica: 2.
- Skills o wrappers bloqueados para ejecucion/runtime: 34.
- Conflictos de naming: 1.

## Indice

| id | handle | status | capability_id | risk | source/evidence | next_gate |
|---:|---|---|---|---|---|---|
| 1 | tcu-normalizador-estado-cabinas | REUSABLE | cabina_state_normalization | MEDIO | AGENTS_SKILLS/tcu-cabina-state-normalizer/SKILL.md | GATE_SKILLS_SYS_MODEON_ALIAS_CANONICALIZATION_NO_RUNTIME |
| 2 | rey-modo-gobernador-capacidades | REUSABLE | capability_governance | MEDIO | AGENTS_SKILLS/rey-modo-gobierno-capacidades/SKILL.md | GATE_SKILLS_SYS_MODEON_ALIAS_CANONICALIZATION_NO_RUNTIME |
| 3 | rey-modo-recuperador-codigo-repos | REUSABLE | repo_code_recovery | MEDIO | AGENTS_SKILLS/rey-modo-repo-code-recovery/SKILL.md | GATE_SKILLS_SYS_MODEON_ALIAS_CANONICALIZATION_NO_RUNTIME |
| 4 | rey-modo-auditor-vscode-insiders | REUSABLE | vscode_workspace_audit | BAJO | AGENTS_SKILLS/rey-modo-vscode-insiders-auditor/SKILL.md | GATE_SKILLS_SYS_MODEON_ALIAS_CANONICALIZATION_NO_RUNTIME |
| 5 | rey-modo-verificacion-previa-cierre | REUSABLE | closure_verification | BAJO | AGENTS_SKILLS/rey-modo-verificacion-previa-cierre/SKILL.md | GATE_SKILLS_DOCUMENTAL_PACKAGE |
| 6 | rey-modo-continuidad-sesion | REUSABLE | session_continuity | BAJO | CODEX_SKILLS/rey-modo-continuidad-sesion/SKILL.md | GATE_SKILLS_DOCUMENTAL_PACKAGE |
| 7 | rey-modo-evidencia-riesgo-handoff | REUSABLE | evidence_risk_handoff | BAJO | AGENTS_SKILLS/rey-modo-evidence-risk-handoff/SKILL.md | GATE_SKILLS_SYS_MODEON_ALIAS_CANONICALIZATION_NO_RUNTIME |
| 8 | tcu-modo-e-system-normalizer | REUSABLE | mode_on_system_normalization | MEDIO | AGENTS_SKILLS/tcu-modo-e-system-normalizer/SKILL.md | GATE_SKILLS_DOCUMENTAL_PACKAGE |
| 9 | rey-modo-salida-breve | REUSABLE | concise_status_response | BAJO | CODEX_SKILLS/rey-modo-salida-breve/SKILL.md | GATE_SKILLS_DOCUMENTAL_PACKAGE |
| 10 | rey-modo-auditor-sharepoint-seguro | BLOQUEADA | sharepoint_safety_audit | ALTO | AGENTS_SKILLS/rey-modo-sharepoint-safety-auditor/SKILL.md | GATE_LIVE_M365_APPROVAL |
| 11 | tcu-readback-handoff-sys | REUSABLE | sys_readback_handoff | BAJO | AGENTS_SKILLS/tcu-sys-readback-handoff-normalizer/SKILL.md | GATE_SKILLS_SYS_MODEON_ALIAS_CANONICALIZATION_NO_RUNTIME |
| 12 | tcu-publicador-documental-sys | CANDIDATA | documental_publication_plan | MEDIO | AGENTS_SKILLS/tcu-sys-documental-publisher/SKILL.md | GATE_GIT_REMOTE_PUBLICATION_REVIEW |
| 13 | tcu-despacho-agentes-paralelos | CANDIDATA | parallel_agent_dispatch | MEDIO | AGENTS_SKILLS/dispatching-parallel-agents/SKILL.md | GATE_SUBAGENT_AUTHORIZATION |
| 14 | skill-judge | REUSABLE | skill_quality_review | BAJO | CODEX_SKILLS/skill-judge/SKILL.md | GATE_SKILLS_DOCUMENTAL_PACKAGE |
| 15 | rey-modo-mapa-documental-escenarios | REUSABLE | docset_scenario_mapping | BAJO | AGENTS_SKILLS/rey-modo-docset-scenario-mapper/SKILL.md | GATE_SKILLS_SYS_MODEON_ALIAS_CANONICALIZATION_NO_RUNTIME |
| 16 | github | BLOQUEADA | github_triage | ALTO | PLUGIN_CACHE/github/dc902811/skills/github/SKILL.md | GATE_GIT_REMOTE_PUBLICATION_REVIEW |
| 17 | gh-address-comments | BLOQUEADA | github_pr_review_feedback | ALTO | PLUGIN_CACHE/github/dc902811/skills/gh-address-comments/SKILL.md | GATE_GIT_REMOTE_PUBLICATION_REVIEW |
| 18 | gh-fix-ci | BLOQUEADA | github_ci_debug | ALTO | PLUGIN_CACHE/github/dc902811/skills/gh-fix-ci/SKILL.md | GATE_GIT_REMOTE_PUBLICATION_REVIEW |
| 19 | yeet | BLOQUEADA | github_publish | ALTO | PLUGIN_CACHE/github/dc902811/skills/yeet/SKILL.md | GATE_GIT_REMOTE_PUBLICATION_REVIEW |
| 20 | mcp-builder | BLOQUEADA | mcp_server_build | ALTO | CODEX_SKILLS/mcp-builder/SKILL.md | GATE_MCP_DESIGN |
| 21 | agentation | CANDIDATA | frontend_feedback_toolbar | MEDIO | CODEX_SKILLS/agentation/SKILL.md | GATE_FRONTEND_PROJECT_SCOPE |
| 22 | tcu-normalizador-sistema-modo-on | REUSABLE | mode_on_system_normalization | MEDIO | AGENTS_SKILLS/tcu-modo-e-system-normalizer/SKILL.md | GATE_SKILLS_SYS_MODEON_ALIAS_CANONICALIZATION_NO_RUNTIME |
| 23 | rey-modo-traductor-reino-tecnico | REUSABLE | reino_to_technical_translation | BAJO | AGENTS_SKILLS/rey-modo-reino-technical-translator/SKILL.md | GATE_SKILLS_SYS_MODEON_ALIAS_CANONICALIZATION_NO_RUNTIME |
| 24 | rey-modo-auditor-taxonomia-contenttypes | BLOQUEADA | taxonomy_contenttype_audit | ALTO | AGENTS_SKILLS/rey-modo-taxonomy-contenttype-auditor/SKILL.md | GATE_LIVE_M365_APPROVAL |
| 25 | rey-modo-auditor-flujos-cola | BLOQUEADA | flow_workqueue_audit | ALTO | AGENTS_SKILLS/rey-modo-flow-workqueue-auditor/SKILL.md | GATE_POWER_PLATFORM_APPROVAL |
| 26 | tcu-harness-evals-agentes | BLOQUEADA | agent_eval_harness | ALTO | AGENTS_SKILLS/tcu-agent-eval-harness/SKILL.md | GATE_EVAL_RUNTIME_APPROVAL |
| 27 | tcu-gate-api-no-sensible | BLOQUEADA | api_non_sensitive_gate | ALTO | AGENTS_SKILLS/tcu-openai-api-non-sensitive-gate/SKILL.md | GATE_OPENAI_API_SECRET_REVIEW |
| 28 | rey-modo-codex-routing | BLOQUEADA | codex_routing | ALTO | AGENTS_SKILLS/rey-modo-codex-routing/SKILL.md | GATE_CODEX_CLOUD_APPROVAL |
| 29 | rey-modo-docset-scenario-mapper | REUSABLE | docset_scenario_mapping | BAJO | AGENTS_SKILLS/rey-modo-docset-scenario-mapper/SKILL.md | GATE_SKILLS_DOCUMENTAL_PACKAGE |
| 30 | rey-modo-evidence-risk-handoff | REUSABLE | evidence_risk_handoff | BAJO | AGENTS_SKILLS/rey-modo-evidence-risk-handoff/SKILL.md | GATE_SKILLS_DOCUMENTAL_PACKAGE |
| 31 | rey-modo-flow-workqueue-auditor | BLOQUEADA | flow_workqueue_audit | ALTO | AGENTS_SKILLS/rey-modo-flow-workqueue-auditor/SKILL.md | GATE_POWER_PLATFORM_APPROVAL |
| 32 | rey-modo-frontier-continuity-planner | REUSABLE | frontier_continuity | BAJO | AGENTS_SKILLS/rey-modo-frontier-continuity-planner/SKILL.md | GATE_SKILLS_DOCUMENTAL_PACKAGE |
| 33 | rey-modo-gobierno-capacidades | REUSABLE | capability_governance | BAJO | AGENTS_SKILLS/rey-modo-gobierno-capacidades/SKILL.md | GATE_SKILLS_DOCUMENTAL_PACKAGE |
| 34 | rey-modo-reino-technical-translator | REUSABLE | reino_to_technical_translation | BAJO | AGENTS_SKILLS/rey-modo-reino-technical-translator/SKILL.md | GATE_SKILLS_DOCUMENTAL_PACKAGE |
| 35 | rey-modo-repo-code-recovery | REUSABLE | repo_code_recovery | MEDIO | AGENTS_SKILLS/rey-modo-repo-code-recovery/SKILL.md | GATE_SKILLS_DOCUMENTAL_PACKAGE |
| 36 | rey-modo-report-pack-generator | REUSABLE | report_pack_generation | MEDIO | AGENTS_SKILLS/rey-modo-report-pack-generator/SKILL.md | GATE_SKILLS_DOCUMENTAL_PACKAGE |
| 37 | rey-modo-sharepoint-safety-auditor | BLOQUEADA | sharepoint_safety_audit | ALTO | AGENTS_SKILLS/rey-modo-sharepoint-safety-auditor/SKILL.md | GATE_LIVE_M365_APPROVAL |
| 38 | rey-modo-taxonomy-contenttype-auditor | BLOQUEADA | taxonomy_contenttype_audit | ALTO | AGENTS_SKILLS/rey-modo-taxonomy-contenttype-auditor/SKILL.md | GATE_LIVE_M365_APPROVAL |
| 39 | rey-modo-vscode-insiders-auditor | REUSABLE | vscode_workspace_audit | BAJO | AGENTS_SKILLS/rey-modo-vscode-insiders-auditor/SKILL.md | GATE_SKILLS_DOCUMENTAL_PACKAGE |
| 40 | tcu-cabina-state-normalizer | REUSABLE | cabina_state_normalization | MEDIO | AGENTS_SKILLS/tcu-cabina-state-normalizer/SKILL.md | GATE_SKILLS_DOCUMENTAL_PACKAGE |
| 41 | tcu-openai-api-non-sensitive-gate | BLOQUEADA | api_non_sensitive_gate | ALTO | AGENTS_SKILLS/tcu-openai-api-non-sensitive-gate/SKILL.md | GATE_OPENAI_API_SECRET_REVIEW |
| 42 | tcu-sys-readback-handoff-normalizer | REUSABLE | sys_readback_handoff | BAJO | AGENTS_SKILLS/tcu-sys-readback-handoff-normalizer/SKILL.md | GATE_SKILLS_DOCUMENTAL_PACKAGE |
| 43 | doc | REUSABLE | document_processing | MEDIO | CODEX_SKILLS/doc/SKILL.md | GATE_DOCUMENT_SOURCE_APPROVAL |
| 44 | pdf | REUSABLE | pdf_processing | MEDIO | CODEX_SKILLS/pdf/SKILL.md | GATE_DOCUMENT_SOURCE_APPROVAL |
| 45 | sdu-gate-executor | BLOQUEADA | sdu_gate_execution | ALTO | CODEX_SKILLS/sdu-gate-executor/SKILL.md | GATE_SDU_RUNTIME_APPROVAL |
| 46 | sdu-live-sharepoint-audit | BLOQUEADA | sdu_sharepoint_audit | ALTO | CODEX_SKILLS/sdu-live-sharepoint-audit/SKILL.md | GATE_LIVE_M365_APPROVAL |
| 47 | chunk | BLOQUEADA | circleci_chunk | ALTO | PLUGIN_CACHE/circleci/dc902811/skills/chunk/SKILL.md | GATE_CONNECTOR_APPROVAL |
| 48 | circleci-cli | BLOQUEADA | circleci_cli | ALTO | PLUGIN_CACHE/circleci/dc902811/skills/cli/SKILL.md | GATE_CONNECTOR_APPROVAL |
| 49 | circleci-config | BLOQUEADA | circleci_config | ALTO | PLUGIN_CACHE/circleci/dc902811/skills/config/SKILL.md | GATE_CONNECTOR_APPROVAL |
| 50 | fix-finding | CANDIDATA | security_fix_finding | MEDIO | PLUGIN_CACHE/codex-security/dc902811/skills/fix-finding/SKILL.md | GATE_SECURITY_FIX_SCOPE |
| 51 | openai-platform-api-key | BLOQUEADA | openai_api_key_setup | CRITICO | PLUGIN_CACHE/openai-developers/dc902811/skills/openai-platform-api-key/SKILL.md | GATE_OPENAI_API_SECRET_REVIEW |
| 52 | outlook-calendar | BLOQUEADA | outlook_calendar | ALTO | PLUGIN_CACHE/outlook-calendar/dc902811/skills/outlook-calendar/SKILL.md | GATE_CONNECTOR_APPROVAL |
| 53 | outlook-calendar-free-up-time | BLOQUEADA | outlook_calendar_planning | ALTO | PLUGIN_CACHE/outlook-calendar/dc902811/skills/outlook-calendar-free-up-time/SKILL.md | GATE_CONNECTOR_APPROVAL |
| 54 | outlook-email | BLOQUEADA | outlook_email | ALTO | PLUGIN_CACHE/outlook-email/dc902811/skills/outlook-email/SKILL.md | GATE_CONNECTOR_APPROVAL |
| 55 | sharepoint | BLOQUEADA | sharepoint_inspection | ALTO | PLUGIN_CACHE/sharepoint/dc902811/skills/sharepoint/SKILL.md | GATE_LIVE_M365_APPROVAL |
| 56 | sharepoint-spreadsheet-formula-builder | BLOQUEADA | sharepoint_spreadsheet_formula | ALTO | PLUGIN_CACHE/sharepoint/dc902811/skills/sharepoint-spreadsheet-formula-builder/SKILL.md | GATE_LIVE_M365_APPROVAL |
| 57 | slack-outgoing-message | BLOQUEADA | slack_message_draft | ALTO | PLUGIN_CACHE/slack/dc902811/skills/slack-outgoing-message/SKILL.md | GATE_CONNECTOR_APPROVAL |
| 58 | teams-planner-task-management | BLOQUEADA | teams_planner_tasks | ALTO | PLUGIN_CACHE/teams/dc902811/skills/teams-planner-task-management/SKILL.md | GATE_CONNECTOR_APPROVAL |
| 59 | skill.sdu.validate | REFERENCIADA_NO_IMPLEMENTADA | sdu_validation | MEDIO | SYS_REPO/15_SDU.../SKILLS_INDEX.yaml only | GATE_SKILL_PHYSICALIZATION_DECISION |
| 60 | skill.sharepoint.inventory | BLOQUEADA | sharepoint_inventory | ALTO | wrapper of rey-modo-sharepoint-safety-auditor | GATE_LIVE_M365_APPROVAL |
| 61 | skill.sharepoint.contenttypes | BLOQUEADA | sharepoint_contenttypes | ALTO | wrapper of rey-modo-taxonomy-contenttype-auditor | GATE_LIVE_M365_APPROVAL |
| 62 | skill.powerautomate.inspect | BLOQUEADA | powerautomate_inspection | ALTO | wrapper of rey-modo-flow-workqueue-auditor | GATE_POWER_PLATFORM_APPROVAL |
| 63 | skill.github.repo-hygiene | BLOQUEADA | github_repo_hygiene | ALTO | wrapper of GitHub plugin skills | GATE_GIT_REMOTE_PUBLICATION_REVIEW |
| 64 | skill.evidence.package | REUSABLE | evidence_package | BAJO | wrapper of rey-modo-evidence-risk-handoff | GATE_SKILLS_SYS_MODEON_ALIAS_CANONICALIZATION_NO_RUNTIME |
| 65 | skill.taxonomy.reconcile | BLOQUEADA | taxonomy_reconciliation | ALTO | wrapper of rey-modo-taxonomy-contenttype-auditor | GATE_LIVE_M365_APPROVAL |
| 66 | skill.workspace.vscode | REUSABLE | workspace_vscode | BAJO | wrapper of rey-modo-vscode-insiders-auditor | GATE_SKILLS_SYS_MODEON_ALIAS_CANONICALIZATION_NO_RUNTIME |
| 67 | skill.ready-for-agent-tcu | REFERENCIADA_NO_IMPLEMENTADA | ready_for_agent_tcu | MEDIO | SYS_REPO/15_SDU.../SKILLS_INDEX.yaml only | GATE_SKILL_PHYSICALIZATION_DECISION |
| 68 | skill.rey-torre-translator | REUSABLE | rey_torre_translation | BAJO | wrapper of rey-modo-reino-technical-translator | GATE_SKILLS_SYS_MODEON_ALIAS_CANONICALIZATION_NO_RUNTIME |
| 69 | skill.frontier-continuity | REUSABLE | frontier_continuity | BAJO | wrapper of rey-modo-frontier-continuity-planner | GATE_SKILLS_SYS_MODEON_ALIAS_CANONICALIZATION_NO_RUNTIME |
| 70 | tcu-builder-paquetes-factory | CANDIDATA | factory_package_build | MEDIO | AGENTS_SKILLS/tcu-factory-package-builder/SKILL.md | GATE_PACKAGE_BUILD_SCOPE |
| 71 | tcu-descubridor-capacidades | REUSABLE | capability_discovery | BAJO | AGENTS_SKILLS/find-skills/SKILL.md | GATE_SKILLS_DOCUMENTAL_PACKAGE |
| 72 | tcu-redactor-planes-operativos | REUSABLE | operational_plan_writing | BAJO | AGENTS_SKILLS/writing-plans/SKILL.md | GATE_SKILLS_DOCUMENTAL_PACKAGE |
| 73 | tcu-desarrollo-con-subagentes | CANDIDATA | subagent_development | MEDIO | AGENTS_SKILLS/subagent-driven-development/SKILL.md | GATE_SUBAGENT_AUTHORIZATION |
| 74 | tcu-planificador-con-archivos | REUSABLE | file_based_planning | BAJO | AGENTS_SKILLS/planning-with-files/SKILL.md | GATE_SKILLS_DOCUMENTAL_PACKAGE |
| 75 | rey-modo-handoff-continuidad | REUSABLE | session_continuity | BAJO | CODEX_SKILLS/rey-modo-continuidad-sesion/SKILL.md | GATE_SKILLS_SYS_MODEON_ALIAS_CANONICALIZATION_NO_RUNTIME |
| 76 | rey-modo-carril-codex-cloud-api | BLOQUEADA | codex_cloud_api_routing | ALTO | AGENTS_SKILLS/rey-modo-codex-routing/SKILL.md | GATE_CODEX_CLOUD_APPROVAL |
| 77 | rey-modo-auditor-taxonomy-contenttype | CONFLICTIVA | taxonomy_contenttype_audit | ALTO | naming collision; equivalent physical skill detected | GATE_SKILLS_SYS_MODEON_ALIAS_CANONICALIZATION_NO_RUNTIME |
| 78 | rey-modo-generador-paquetes-informe | CANDIDATA | report_pack_generation | MEDIO | AGENTS_SKILLS/rey-modo-report-pack-generator/SKILL.md | GATE_PACKAGE_BUILD_SCOPE |

## Nota de empaquetado

Este indice versiona metadata. No copia ni recrea cuerpos de skills. La materializacion de `skills/<handle>/SKILL.md` queda pendiente de gate humano por skill o lote.
