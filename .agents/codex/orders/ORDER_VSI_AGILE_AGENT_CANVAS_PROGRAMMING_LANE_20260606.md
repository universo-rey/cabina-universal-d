# Governed Order Preparation Packet: VSI Agile Agent Canvas Programming Lane

- order_class: parallel_agent_work
- preparer_agent: court.thot_schema
- reviewer_agent: court.seshat_evidence
- approver_role: operator
- canon_as_of: 2026-06-07
- source_authority: AGENTS.md|VSCODE_INSIDERS_AGENT_TASK_QUEUE_20260606.csv|VSCODE_INSIDERS_AGILE_AGENT_CANVAS_GOVERNANCE_20260606.csv
- surface: VS Code Insiders Agile Agent Canvas local programming lane
- identity: local Codex cabina workspace at C:\Users\enzo1\Documents\GitHub\cabina-universal-d
- owner: codex.workspace_guardian
- data_boundary: repo-local artifacts and synthetic dashboard data only; no raw VS Code storage; no secrets; no regulated broad data
- cost_boundary: no cost; local repo work only
- secret_boundary: no API keys, tokens, cookies, Jira tokens, Microsoft credentials, OpenAI keys or raw private settings
- allowed_actions: edit declared files only; prepare local canvas artifacts; update local dashboard tests; update task queue status after validation; run local validators; open GitHub PR branch codex/*
- blocked_actions: edit outside allowlist; auto-sync unreviewed artifacts; install Git hooks; mutate Git metadata; run live providers; clone external repositories; execute production; store secrets
- rollback: git restore -- .agileagentcanvas-context/README.md .agileagentcanvas-context/vision.json .agileagentcanvas-context/discovery/product-brief.json .agileagentcanvas-context/planning/prd.json .agileagentcanvas-context/planning/epics.json local-agent-bridge/src/dashboardData.mjs local-agent-bridge/public/index.html local-agent-bridge/tests/mock_bridge_flow.mjs .agents/codex/matrices/VSCODE_INSIDERS_AGENT_TASK_QUEUE_20260606.csv
- postcheck: npm test --prefix local-agent-bridge; .agents/codex/tools/local_validate_parallel_order_governance.ps1; .agents/codex/tools/local_validate_agent_layer.ps1; git diff --check
- evidence: PR diff, task queue status, dashboard smoke, validator output and explicit staged file list
- validator: .agents/codex/tools/local_validate_order_packets.ps1|.agents/codex/tools/local_validate_parallel_order_governance.ps1|git diff --check
- expiration_rule: expires_when_file_allowlist_or_lock_key_changes
- stop_condition: parallel_lane_without_validator

## Lane Contract

- lane_id: agile_canvas_programming_lane
- lead_agent: court.thot_schema
- owner_agent: codex.workspace_guardian
- reviewer_agent: court.seshat_evidence
- lock_key: lock.vsi.aac_programming_lane
- dependency: vsi.agent.task.003
- max_parallel: 1

## Exact Write Allowlist

- .agileagentcanvas-context/README.md
- .agileagentcanvas-context/vision.json
- .agileagentcanvas-context/discovery/product-brief.json
- .agileagentcanvas-context/planning/prd.json
- .agileagentcanvas-context/planning/epics.json
- local-agent-bridge/src/dashboardData.mjs
- local-agent-bridge/public/index.html
- local-agent-bridge/tests/mock_bridge_flow.mjs
- .agents/codex/matrices/VSCODE_INSIDERS_AGENT_TASK_QUEUE_20260606.csv

## Execution Boundary

This packet prepares a local programming lane. It does not authorize Agile Agent
Canvas or any agent to edit outside the allowlist, install hooks, sync Jira,
call OpenAI, call Microsoft, call Google Cloud, mutate production or write
secrets.
