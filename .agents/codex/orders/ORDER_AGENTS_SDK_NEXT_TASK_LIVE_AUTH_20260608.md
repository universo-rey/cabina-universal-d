# Governed Order Preparation Packet: Agents SDK Next Task Live Authorization

Status: `SUPERSEDED_BY_SDU_AGENTS_NEXT_TASK_NO_MORE_SMOKE`

Operator correction 2026-06-08: the active next-task direction is SDU agents,
not additional SDK smoke. This packet remains only as sanitized evidence of the
one activation smoke that already ran before the correction.

- order_class: openai_api_or_remote_agent
- preparer_agent: court.openai_dispatcher
- reviewer_agent: court.sdu_gate
- approver_role: operator
- canon_as_of: 2026-06-08
- source_authority: AGENTS.md|MANIFEST.yaml|02_AUTHORITY_CANON/CURRENT_STATE.md|operator_live_openai_microsoft_authorization_2026-06-08
- surface: OpenAI Agents SDK live governed runtime for the next concrete VSI/AAC task; Microsoft live gated companion surface only with exact target
- identity: Codex local process using approved local ignored OpenAI credential source; value not printed or persisted; Microsoft effective identity must be confirmed per target before any Microsoft action
- owner: operator for authorization; court.openai_dispatcher for OpenAI runtime; rey.frontier_guardian and court.sdu_gate for gates; court.seshat_evidence for readback
- data_boundary: next task must use selected, minimal, non-secret, non-broad-regulated payloads by default; Microsoft payload must name exact tenant/site/team/channel/chat/list/plan/task/flow/environment before execution
- cost_boundary: OpenAI live ceiling USD 2.00 total for the next task; no open-ended loops, batch jobs, vector stores, persistent remote agents, or unbounded evals
- secret_boundary: no tokens, API keys, OAuth artifacts, cookies, certificates, app secrets, refresh tokens, connection strings, or private keys may be printed, committed, copied to readbacks, or sent as payload
- allowed_actions: preserve sanitized activation evidence only; route the next task through SDU agents first; use Agents SDK only if a concrete SDU-governed task requires it within USD 2.00
- blocked_actions: additional smoke tests; OpenAI cost over USD 2.00; response body dumps; secret materialization; regulated broad reads; external vector store creation; persistent remote agent creation; Microsoft write without exact target; tenant permission change; admin consent; production; destructive action; unattended propagation
- rollback: stop further live calls; revert this order/readback/index changes if recorded state is wrong; rotate or revoke the OpenAI key externally if exposure is suspected; Microsoft rollback must be object-specific and declared before any Microsoft live write
- postcheck: confirm OpenAI smoke or task status, model, SDK versions, no secret printed, response bodies not printed unless explicitly approved, budget stayed below USD 2.00, Microsoft live was either not executed or exact-target postcheck passed
- evidence: 2026-06-08 Agents SDK live smoke PASS with model gpt-4.1-mini, openai 2.36.0, openai-agents 0.17.0, Responses API PASS, Agents SDK runner PASS, synthetic_payload_only true, secrets_printed false, microsoft_live_executed false
- validator: .agents/codex/tools/local_validate_order_packets.ps1|.agents/codex/tools/local_validate_capability_use_hardening.ps1|.agents/codex/tools/local_validate_operational_chain.ps1|git diff --check
- expiration_rule: single_next_task_or_2026-06-09T23:59:59-03:00_or_when_target_model_cost_identity_secret_source_or_data_boundary_changes
- stop_condition: PENDING_TARGET_ONLY|openai_api_live_requested_without_order|microsoft_live_requested_without_governed_order|secret_detected

## Execution Boundary

This packet records a governed Agents SDK activation smoke already executed
before the operator correction. It does not authorize further smoke tests. The
active next-task route is now
`.agents/codex/orders/ORDER_SDU_AGENTS_NEXT_TASK_ACTIVATION_20260608.md`.

Microsoft live is authorized only as a next-task gated surface. It must still
name the exact object target, owner, rollback, postcheck, evidence and validator
before any read/write that can affect a tenant object.
