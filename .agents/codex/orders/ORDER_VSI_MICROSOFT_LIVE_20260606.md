# Governed Order Preparation Packet: VSI Microsoft Live

- order_class: microsoft_live_or_permission
- preparer_agent: rey.frontier_guardian
- reviewer_agent: court.sdu_gate
- approver_role: operator
- canon_as_of: 2026-06-07
- source_authority: AGENTS.md|VSCODE_INSIDERS_AGENT_TASK_QUEUE_20260606.csv|VSCODE_INSIDERS_AGILE_AGENT_CANVAS_GOVERNANCE_20260606.csv
- surface: VS Code Insiders Microsoft 365, Graph, Teams, SharePoint or Power Platform extension lane
- identity: PENDING_IDENTITY_ONLY
- owner: PENDING_OWNER_ONLY
- data_boundary: PENDING_TARGET_ONLY; no tenant, site, team, channel, list, flow or Dataverse environment selected
- cost_boundary: no cost approved; any paid or premium connector remains gated
- secret_boundary: PENDING_SECRET_ONLY; no Microsoft token or connector credential may be stored or printed
- allowed_actions: prepare exact target request; document owner, tenant, rollback and postcheck fields; run local validators
- blocked_actions: Microsoft Graph mutation; SharePoint write; Teams write; Power Platform apply; Dataverse write; connector authentication; admin consent; production
- rollback: delete this packet before merge or use Microsoft admin/provider rollback from a later separately approved order
- postcheck: confirm no Microsoft live write occurred, no connector auth was changed, no tenant permission changed, and packet remains pending until exact target exists
- evidence: this packet and local order packet validator output
- validator: .agents/codex/tools/local_validate_order_packets.ps1|git diff --check
- expiration_rule: expires_when_tenant_target_identity_owner_or_environment_changes
- stop_condition: microsoft_live_requested_without_governed_order

## Execution Boundary

This packet prepares the gate only. It does not write Microsoft live, does not
authenticate connectors, does not mutate tenant permissions and does not touch
production.
