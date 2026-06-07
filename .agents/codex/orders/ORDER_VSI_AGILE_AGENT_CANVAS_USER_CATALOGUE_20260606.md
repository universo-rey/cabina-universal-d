# Governed Order Preparation Packet: VSI Agile Agent Canvas User Catalogue

- order_class: skill_methodology_adoption
- preparer_agent: court.openai_dispatcher
- reviewer_agent: codex.workspace_guardian
- approver_role: operator
- canon_as_of: 2026-06-07
- source_authority: AGENTS.md|VSCODE_INSIDERS_AGENT_TASK_QUEUE_20260606.csv|VSCODE_INSIDERS_AGILE_AGENT_CANVAS_GOVERNANCE_20260606.csv
- surface: VS Code Insiders Agile Agent Canvas workspace settings
- identity: local Codex cabina workspace at C:\Users\enzo1\Documents\GitHub\cabina-universal-d
- owner: codex.workspace_guardian
- data_boundary: repo-local skill metadata under .agents/skills only; no secret files; no external repositories
- cost_boundary: no cost; local metadata only
- secret_boundary: no tokens, API keys, Jira tokens, OpenAI keys, Microsoft credentials or private user settings
- allowed_actions: prepare local userCataloguePath mapping; apply workspace-only setting agileagentcanvas.userCataloguePath=.agents/skills; review .agents/skills catalogue; run local validators
- blocked_actions: clone external skill repositories; write global VS Code user settings; store secrets; call live providers; publish canvas artifacts; change agent ids or status values
- rollback: delete this packet before merge, or if a later approved workspace setting is applied run git restore -- .vscode/settings.json
- postcheck: confirm .vscode/settings.json remains workspace-scoped, agileagentcanvas.autoSync=false, no agileagentcanvas.skillRepos external clone configured, and .agents/skills metadata validates
- evidence: .agents/skills directory exists; .vscode/settings.json is workspace-scoped and sets agileagentcanvas.userCataloguePath=.agents/skills; no agileagentcanvas.skillRepos external clone configured
- validator: .agents/codex/tools/local_validate_order_packets.ps1|.agents/codex/tools/local_validate_skill_metadata.ps1|git diff --check
- expiration_rule: expires_when_Agile_Agent_Canvas_setting_schema_or_skill_catalogue_path_changes
- stop_condition: skill_without_catalog_or_assignment

## Prepared Target

- local_catalogue_path: .agents/skills
- proposed_workspace_setting: agileagentcanvas.userCataloguePath
- proposed_workspace_setting_value: .agents/skills
- apply_now: yes
- applied_setting: .vscode/settings.json::agileagentcanvas.userCataloguePath=.agents/skills

## Execution Boundary

This packet applies a local workspace-scoped mapping only. It does not write
global user settings, clone external skill repositories, call Jira, call OpenAI,
call Microsoft, execute production, store secrets or mutate Git metadata.
