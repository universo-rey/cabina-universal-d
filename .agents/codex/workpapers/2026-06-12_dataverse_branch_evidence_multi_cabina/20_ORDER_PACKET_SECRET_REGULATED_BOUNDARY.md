# Governed Order Packet - Secret / Regulated Data Boundary

- order_class: `production_change`
- preparer_agent: `rey.authority_canonist`
- reviewer_agent: `court.sdu_gate`
- approver_role: `operator`
- canon_as_of: `2026-06-12`
- source_authority: `AGENTS.md`, `CURRENT_STATE.md`, `14_CODEX_EVOLUTIONARY_BLUEPRINT_AGENT_RECONCILIATION_V4_CANONICALIZED.csv`
- surface: `secret_boundary|regulated_data_boundary`
- identity: `NO_SECRET_IDENTITY_REQUESTED`
- owner: `operator|rey.frontier_guardian`
- data_boundary: secret boundary and regulated-data boundary only; no raw regulated export; no secret print
- cost_boundary: `NO_COST_OPENED`
- secret_boundary: `NEVER_PRINT_NEVER_PERSIST`
- allowed_actions: prepare redaction gate, prepare selected data boundary, risk review
- blocked_actions: secret print, broad regulated read, production, permission change, tenant write, external persistence
- rollback: discard packet; no data read or secret handling performed
- postcheck: selected data boundary, redaction status, owner and explicit human gate before any regulated handling
- evidence: `14_CODEX_EVOLUTIONARY_BLUEPRINT_AGENT_RECONCILIATION_V4_CANONICALIZED.csv`
- validator: `local_validate_order_packets.ps1`, `secret_scan`, `stop_condition_check`
- expiration_rule: expires when data scope or owner changes
- stop_condition: `secret_detected|regulated_data_boundary_unclear|production_requested_without_explicit_authorization`

## Blueprint Agents

`risk-arbiter`.

## Estado

`PREPARED_NOT_EXECUTED`

This packet prepares the risk gate only. It does not inspect secrets, export
regulated data, mutate production or approve permission changes.
