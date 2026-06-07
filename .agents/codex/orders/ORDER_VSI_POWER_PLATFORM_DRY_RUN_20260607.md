# Governed Order Preparation Packet: VSI Power Platform Dry Run

- order_class: microsoft_live_or_permission
- preparer_agent: rey.frontier_guardian
- reviewer_agent: court.sdu_gate
- approver_role: operator
- canon_as_of: 2026-06-07
- source_authority: AGENTS.md|VSCODE_INSIDERS_AGENT_TASK_QUEUE_20260606.csv|VSCODE_INSIDERS_AGILE_AGENT_CANVAS_GOVERNANCE_20260606.csv
- surface: VS Code Insiders Power Platform dry-run or mock lane
- identity: PENDING_IDENTITY_ONLY
- owner: PENDING_OWNER_ONLY
- data_boundary: PENDING_TARGET_ONLY; no tenant, environment, solution, flow, connector or Dataverse table selected
- cost_boundary: no cost approved; premium connector, solution check or capacity impact remains gated
- secret_boundary: PENDING_SECRET_ONLY; no PAC auth token, connection reference, client secret or certificate may be stored or printed
- allowed_actions: prepare mock solution fixture; prepare dry-run command plan; document target environment request; validate packet locally
- blocked_actions: pac_auth_change; power_platform_apply; solution_import; flow_enable_disable; connector_auth; dataverse_write; tenant_permission_change; production
- rollback: delete this packet before merge or use environment-specific solution rollback from a later separately approved order
- postcheck: confirm no Power Platform command wrote live, no connector auth changed, no environment was selected, and packet remains pending until exact target exists
- evidence: this packet, structured local action review and local order packet validator output
- validator: .agents/codex/tools/local_validate_order_packets.ps1|git diff --check
- expiration_rule: expires_when_tenant_environment_solution_flow_connector_or_identity_changes
- stop_condition: microsoft_live_requested_without_governed_order

## Execution Boundary

This packet prepares the gate only. It does not call PAC, does not authenticate
Power Platform, does not import a solution, does not enable or disable flows,
does not write Dataverse and does not touch production.
