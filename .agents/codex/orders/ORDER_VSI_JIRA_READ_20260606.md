# Governed Order Preparation Packet: VSI Jira Read

Status: `SUSPENDED_BY_OPERATOR`

- order_class: parallel_agent_work
- preparer_agent: rey.frontier_guardian
- reviewer_agent: court.sdu_gate
- approver_role: operator
- canon_as_of: 2026-06-07
- source_authority: AGENTS.md|VSCODE_INSIDERS_AGENT_TASK_QUEUE_20260606.csv|VSCODE_INSIDERS_AGILE_AGENT_CANVAS_GOVERNANCE_20260606.csv
- surface: Agile Agent Canvas Jira integration
- identity: PENDING_IDENTITY_ONLY
- owner: PENDING_OWNER_ONLY
- data_boundary: PENDING_TARGET_ONLY; no Jira project, board, issue key or tenant selected
- cost_boundary: no cost expected for prepared read; live API still gated
- secret_boundary: PENDING_SECRET_ONLY; no Jira token may be stored or printed
- allowed_actions: keep suspended; do not prepare target request until operator reopens Jira; validate packet locally
- blocked_actions: jira_live_read; jira_token_storage; jira_sync; external write; broad regulated data read; secret handling
- rollback: delete this packet before merge or revoke any later token from Jira if a separate approved live order creates one
- postcheck: confirm no Jira token exists in repo, no fetchFromJira executed, and Agile Agent Canvas Jira row remains suspended
- evidence: this packet and local order packet validator output
- validator: .agents/codex/tools/local_validate_order_packets.ps1|git diff --check
- expiration_rule: expires_when_Jira_project_identity_or_token_boundary_changes
- stop_condition: jira_suspended_by_operator

## Execution Boundary

This packet is suspended by operator decision. It does not call Jira, does not
store a token, does not read live issues and does not sync Agile Agent Canvas
with any external project.
