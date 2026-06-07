# Governed Order Preparation Packet: VSI OpenAI Live

Status: `EXECUTED_LIVE_VALIDATED`

- order_class: openai_api_or_remote_agent
- preparer_agent: rey.frontier_guardian
- reviewer_agent: court.sdu_gate
- approver_role: operator
- canon_as_of: 2026-06-07
- source_authority: AGENTS.md|VSCODE_INSIDERS_AGENT_TASK_QUEUE_20260606.csv|VSCODE_INSIDERS_AGILE_AGENT_CANVAS_GOVERNANCE_20260606.csv
- surface: Agile Agent Canvas OpenAI or Copilot-adjacent live agent flow
- identity: local ignored `D:\.env.local` OpenAI key source for `Modo On/SYS-SDU`; value not printed
- owner: court.openai_dispatcher
- data_boundary: synthetic non-sensitive smoke payload only; no regulated or user data submitted
- cost_boundary: bounded smoke only; model `gpt-5.5`; no open-ended eval or loop
- secret_boundary: key read from local ignored env into process env only; value not printed, persisted or committed
- allowed_actions: execute governed synthetic OpenAI models list, Responses API and Agents SDK runner smoke; validate locally; record sanitized evidence
- blocked_actions: Agents SDK live with external tools; vector store external; cost-incurring eval; secret materialization; sensitive payload submission; persistent remote agent creation
- rollback: revoke local OpenAI key from provider settings if exposure is suspected; revert this evidence commit if recorded state is wrong
- postcheck: confirm no key was printed, no response or agent output body was printed, no Microsoft live or production ran, no vector store or persistent remote agent was created, and local mock tests still pass
- evidence: `agents_sdk_functional_lifecycle_smoke` PASS; model `gpt-5.5`; OpenAI `2.36.0`; openai-agents `0.17.0`; response bodies printed false; agent output printed false; secrets printed false
- validator: .agents/codex/tools/local_validate_order_packets.ps1|git diff --check
- expiration_rule: expires_when_model_cost_data_boundary_or_secret_source_changes
- stop_condition: openai_agents_sdk_live_smoke_executed_validated

## Execution Boundary

This packet records an executed governed OpenAI live smoke. It used only
synthetic non-sensitive payloads, did not print response bodies or secrets,
did not use external tools, did not create vector stores or persistent remote
agents, and did not execute Microsoft live, production or propagation.
