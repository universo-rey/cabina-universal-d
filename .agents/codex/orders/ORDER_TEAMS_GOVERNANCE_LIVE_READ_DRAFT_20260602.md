# Governed Order Preparation Packet - Teams Live Read Draft

- order_class: microsoft_live_or_permission
- preparer_agent: rey.frontier_guardian
- reviewer_agent: court.sdu_gate
- approver_role: operator
- canon_as_of: 2026-06-02
- source_authority: D:\AGENTS.md; D:\02_AUTHORITY_CANON\POLICIES\GLOBAL_MICROSOFT_LIVE_PRODUCTION_POLICY_20260601.md; D:\02_AUTHORITY_CANON\POLICIES\TEAMS_GOVERNANCE_POLICY_20260602.md
- surface: Microsoft Teams live read only, selected scope to be supplied by operator before execution
- owner: surface owner must be assigned per universe: universe.escribania_tower for Escribania/TGE, universe.modo_on_tower for Modo ON/CDF/Jara, court.sdu_gate for SDU/Corte gate review
- identity: not authorized yet; must name tenant, account, delegated mailbox/app context if any, and connector before live read
- data_boundary: selected team/channel/chat/window only; no tenant-wide sweep, no raw message dump, no secrets, no broad regulated data, no attachments unless separately selected and governed
- allowed_actions: prepare local order; classify Teams surface; prepare sanitized evidence fields; after separate approval only perform read-only selected inventory or selected message/context read
- blocked_actions: send message; reply; edit; delete; create team; create channel; add or remove member; change owner; install app; create webhook; change tab; change Planner task; change Outlook calendar; Graph tenant write; production; secrets; broad export
- rollback: for this draft revert local governance artifacts; for any later live read rollback is no external mutation plus evidence deletion/redaction plan for local artifacts if data boundary is breached
- postcheck: record connector used, selected scope, timestamp, actor identity, sanitized counts/ids, no-write confirmation, validator result and open stop conditions
- evidence: D:\.agents\codex\matrices\TEAMS_GOVERNANCE_SURFACE_MATRIX.csv; D:\.agents\codex\matrices\TEAMS_AGENT_CAPABILITY_MATRIX.csv; D:\.agents\codex\readbacks\2026-06-02_teams_governance_readback.md
- validator: D:/.agents/codex/tools/local_validate_teams_governance.ps1
- stop_condition: microsoft_live_requested_without_governed_order|production_requested_without_explicit_authorization|regulated_data_boundary_unclear|secret_detected|order_packet_missing_required_fields
- expiration_rule: expires when tenant, identity, surface, selected data window, connector, owner or production boundary changes

## Execution Boundary

This packet is not execution approval. It is the draft that must be completed
before Teams live read. Live Teams remains stopped until the operator supplies
the exact tenant, identity, selected Teams surface, data window, owner,
rollback, postcheck and evidence target.

## Minimal Live Read Fields Still Missing

- tenant:
- identity:
- selected team/channel/chat:
- selected time window or object ids:
- approved connector/tool:
- owner human:
- evidence storage target:
- postcheck owner:

## Stop

Current state: `STOP_BEFORE_TEAMS_LIVE_READ`.
