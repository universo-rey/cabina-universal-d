# Governed Order Preparation Packet: VSI External Queue Gate

Status: `PENDING_TARGET_ONLY`

- order_class: parallel_agent_work
- preparer_agent: rey.control_plane_orchestrator
- reviewer_agent: rey.frontier_guardian
- approver_role: operator
- canon_as_of: 2026-06-08
- source_authority: AGENTS.md|EPIC-6|S-6.5|VSCODE_INSIDERS_AGENT_TASK_QUEUE_20260606.csv
- surface: external queue gate packet for web site queue, OpenAI live queue and Microsoft live queue separated from VSI mother board
- identity: local Codex workspace only; external identities remain PENDING_IDENTITY_ONLY until exact target is selected
- owner: rey.frontier_guardian for packet; external target owners remain PENDING_OWNER_ONLY until selected
- data_boundary: selected local board artifacts only; web site, OpenAI and Microsoft payloads remain PENDING_TARGET_ONLY
- cost_boundary: no external cost approved; OpenAI live requires bounded cost before execution
- secret_boundary: no secret use; OpenAI and Microsoft credentials remain gated and must never be printed or persisted
- lane_id: vsi_external_queue_gate_packet_20260608
- lead_agent: rey.control_plane_orchestrator
- owner_agent: rey.frontier_guardian
- reviewer_agent: court.sdu_gate
- read_scope: .agileagentcanvas-context/planning/epics.json|.agileagentcanvas-context/bmm/sprint-status.json|.agents/codex/orders
- write_scope: this packet only until exact external target owner identity rollback and postcheck exist
- lock_key: lock.vsi.external_queue_gate_packet_20260608
- dependency: vsi.agent.task.045
- max_parallel: 1
- allowed_actions: prepare local gate packet; separate VSI mother board, Control de Agentes de Cabina and web site queue; record pending external fields; run local validators
- blocked_actions: website write, OpenAI API live, Agents SDK live with external tools, Microsoft Graph mutation, SharePoint write, Teams write, Dataverse write, Power Platform apply, production, secret materialization, cost open-ended
- rollback: `git restore -- .agents/codex/orders/ORDER_VSI_EXTERNAL_QUEUE_GATE_20260608.md .agileagentcanvas-context/planning/epics.json .agileagentcanvas-context/bmm/sprint-status.json .agents/codex/matrices/VSCODE_INSIDERS_AGENT_TASK_QUEUE_20260606.csv`
- postcheck: run `.agents/codex/tools/local_validate_order_packets.ps1`, `.agents/codex/tools/local_validate_operational_chain.ps1`, `python scripts/validators/agile_canvas_task_ops_validator.py`, `git diff --check`
- evidence: S-6.5 subagent readback; existing OpenAI and Microsoft order packets read; web site queue remains unselected
- validator: .agents/codex/tools/local_validate_order_packets.ps1|.agents/codex/tools/local_validate_operational_chain.ps1|git diff --check
- expiration_rule: expires_when_external_target_owner_identity_data_limit_rollback_or_postcheck_changes
- stop_condition: PENDING_TARGET_ONLY

## Execution Boundary

This packet is local only. VSI / Agile Agent Canvas remains the mother board.
Control de Agentes de Cabina remains an auxiliary local execution board. The
web site queue, OpenAI live queue and Microsoft live queue are separate
external surfaces and are not executed until each has exact target, owner,
identity, rollback, postcheck, evidence, cost or secret gate when applicable
and a fresh human gate.
