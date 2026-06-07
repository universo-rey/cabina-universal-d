# Governed Order Preparation Packet: VSI OpenAI Live

- order_class: openai_api_or_remote_agent
- preparer_agent: rey.frontier_guardian
- reviewer_agent: court.sdu_gate
- approver_role: operator
- canon_as_of: 2026-06-07
- source_authority: AGENTS.md|VSCODE_INSIDERS_AGENT_TASK_QUEUE_20260606.csv|VSCODE_INSIDERS_AGILE_AGENT_CANVAS_GOVERNANCE_20260606.csv
- surface: Agile Agent Canvas OpenAI or Copilot-adjacent live agent flow
- identity: PENDING_IDENTITY_ONLY
- owner: court.openai_dispatcher
- data_boundary: PENDING_TARGET_ONLY; no payload approved for live model call
- cost_boundary: PENDING_COST_BOUNDARY_ONLY
- secret_boundary: PENDING_SECRET_ONLY; no OpenAI API key may be read, stored or printed
- allowed_actions: prepare prompt and eval locally; prepare synthetic fixture; define model/data/cost gate; validate packet locally
- blocked_actions: OpenAI API live; Agents SDK live with external tools; vector store external; cost-incurring eval; secret materialization; sensitive payload submission
- rollback: delete this packet before merge or revoke any later live key from provider settings if a separate approved order uses one
- postcheck: confirm no OpenAI live call was made, no key was printed, no new vector store or external agent was created, and local mock tests still pass
- evidence: this packet and local order packet validator output
- validator: .agents/codex/tools/local_validate_order_packets.ps1|git diff --check
- expiration_rule: expires_when_model_cost_data_boundary_or_secret_source_changes
- stop_condition: openai_api_live_requested_without_order

## Execution Boundary

This packet prepares the gate only. It does not call OpenAI, does not use
secrets, does not incur cost and does not create persistent remote agents.
