# MATRIZ_SKILLS_EQUIVALENCIAS

No se eliminan duplicados. Se registran equivalencias por capability, no solo por nombre.

| tipo | handle | canonical_or_equivalent | capability_id | riesgo | decision |
|---|---|---|---|---|---|
| ALIAS | rey-modo-gobernador-capacidades | rey-modo-gobierno-capacidades | capability_governance | MEDIO | conservar alias y canonizar `gobierno` |
| ALIAS | tcu-normalizador-estado-cabinas | tcu-cabina-state-normalizer | cabina_state_normalization | MEDIO | conservar alias operativo |
| ALIAS | rey-modo-recuperador-codigo-repos | rey-modo-repo-code-recovery | repo_code_recovery | MEDIO | canonizar ingles fisico |
| ALIAS | rey-modo-auditor-vscode-insiders | rey-modo-vscode-insiders-auditor | vscode_workspace_audit | BAJO | conservar alias |
| ALIAS | rey-modo-evidencia-riesgo-handoff | rey-modo-evidence-risk-handoff | evidence_risk_handoff | BAJO | conservar alias |
| ALIAS | rey-modo-auditor-sharepoint-seguro | rey-modo-sharepoint-safety-auditor | sharepoint_safety_audit | ALTO | bloquear live SharePoint |
| ALIAS | tcu-readback-handoff-sys | tcu-sys-readback-handoff-normalizer | sys_readback_handoff | BAJO | canonizar si se propaga |
| ALIAS | tcu-publicador-documental-sys | tcu-sys-documental-publisher | documental_publication_plan | MEDIO | no publicar sin gate |
| ALIAS | tcu-despacho-agentes-paralelos | dispatching-parallel-agents | parallel_agent_dispatch | MEDIO | usar solo con autorizacion |
| ALIAS | rey-modo-mapa-documental-escenarios | rey-modo-docset-scenario-mapper | docset_scenario_mapping | BAJO | conservar alias |
| EQUIVALENTE | tcu-normalizador-sistema-modo-on | tcu-modo-e-system-normalizer | mode_on_system_normalization | MEDIO | unificar denominacion |
| EQUIVALENTE | rey-modo-traductor-reino-tecnico | rey-modo-reino-technical-translator | reino_to_technical_translation | BAJO | unificar denominacion |
| EQUIVALENTE | rey-modo-auditor-taxonomia-contenttypes | rey-modo-taxonomy-contenttype-auditor | taxonomy_contenttype_audit | ALTO | gate SharePoint/taxonomia |
| EQUIVALENTE | rey-modo-auditor-flujos-cola | rey-modo-flow-workqueue-auditor | flow_workqueue_audit | ALTO | gate Power Platform |
| ALIAS | tcu-gate-api-no-sensible | tcu-openai-api-non-sensitive-gate | api_non_sensitive_gate | ALTO | no habilita API |
| EQUIVALENTE | rey-modo-handoff-continuidad | rey-modo-continuidad-sesion | session_continuity | BAJO | unificar con continuidad-sesion |
| EQUIVALENTE | rey-modo-carril-codex-cloud-api | rey-modo-codex-routing | codex_cloud_api_routing | ALTO | Codex Cloud bloqueado |
| POSIBLE_COLISION | rey-modo-auditor-taxonomy-contenttype | rey-modo-taxonomy-contenttype-auditor | taxonomy_contenttype_audit | ALTO | resolver variante mixta |
| ALIAS | circleci-cli | circleci:cli | circleci_cli | ALTO | registrar carpeta fisica `cli`; conector bloqueado |
| ALIAS | circleci-config | circleci:config | circleci_config | ALTO | registrar carpeta fisica `config`; conector bloqueado |
| DUPLICADO_FUNCIONAL | sdu-gate-executor | sdu-gate-executor | sdu_gate_execution | ALTO | no eliminar; no ejecutar |
| DUPLICADO_FUNCIONAL | sdu-live-sharepoint-audit | sdu-live-sharepoint-audit | sdu_sharepoint_audit | ALTO | no eliminar; no ejecutar live |
| WRAPPER | skill.sharepoint.inventory | rey-modo-sharepoint-safety-auditor | sharepoint_inventory | ALTO | wrapper documental, live bloqueado |
| WRAPPER | skill.sharepoint.contenttypes | rey-modo-taxonomy-contenttype-auditor | sharepoint_contenttypes | ALTO | wrapper documental, live bloqueado |
| WRAPPER | skill.powerautomate.inspect | rey-modo-flow-workqueue-auditor | powerautomate_inspection | ALTO | wrapper documental, Power Platform bloqueado |
| WRAPPER | skill.github.repo-hygiene | github plugin skills | github_repo_hygiene | ALTO | wrapper documental, Git remoto bloqueado |
| WRAPPER | skill.evidence.package | rey-modo-evidence-risk-handoff | evidence_package | BAJO | wrapper documental reutilizable |
| WRAPPER | skill.taxonomy.reconcile | rey-modo-taxonomy-contenttype-auditor | taxonomy_reconciliation | ALTO | wrapper documental, live bloqueado |
| WRAPPER | skill.workspace.vscode | rey-modo-vscode-insiders-auditor | workspace_vscode | BAJO | wrapper documental reutilizable |
| WRAPPER | skill.rey-torre-translator | rey-modo-reino-technical-translator | rey_torre_translation | BAJO | wrapper documental reutilizable |
| WRAPPER | skill.frontier-continuity | rey-modo-frontier-continuity-planner | frontier_continuity | BAJO | wrapper documental reutilizable |
| INCOMPLETO | skill.ready-for-agent-tcu | none | ready_for_agent_tcu | MEDIO | requiere decision de owner |

## Path drift detectado

| fuente | valor historico | evidencia actual | decision |
|---|---|---|---|
| GitHub skill cache | `7955f1db` | `dc902811` | actualizar metadata; no tocar remoto |
