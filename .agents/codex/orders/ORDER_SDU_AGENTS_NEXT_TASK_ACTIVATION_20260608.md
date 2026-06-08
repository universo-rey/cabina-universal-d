# Governed Order Preparation Packet: SDU Agents Next Task Activation

Status: `SDU_AGENTS_NEXT_TASK_ACTIVE_NO_MORE_SMOKE`

- order_class: parallel_agent_work
- preparer_agent: rey.control_plane_orchestrator
- reviewer_agent: anubis-gate|court.sdu_gate
- approver_role: operator
- canon_as_of: 2026-06-08
- source_authority: AGENTS.md|02_AUTHORITY_CANON/SDU_CN_CANONICAL_AGENT_PANTHEON_20260604.md|02_AUTHORITY_CANON/SDU_CN_MULTI_UNIVERSE_OPERATING_MODEL_20260604.md|operator_correction_sdu_agents_no_more_smoke_2026-06-08
- surface: SDU-CN canonical agents for the next concrete VSI/AAC task
- identity: SDU canonical identities; runtime may use Codex local, Agents SDK, GitHub, MCP or Microsoft connectors only as governed execution media, never as authority
- owner: operator; operational lead rey.control_plane_orchestrator; evidence owner seshat-normativa|court.seshat_evidence; gate owner anubis-gate|court.sdu_gate
- data_boundary: next task selected data only; no broad regulated data; no secrets; no raw Microsoft tenant dump; no response body dump unless explicitly approved for that target
- cost_boundary: no more smoke; OpenAI live remains capped at USD 2.00 only if the next task requires a concrete SDU-governed call
- secret_boundary: no secret printing, persistence, copying to artifacts, connector token export, or env-file mutation
- allowed_actions: route the next task through seshat-normativa, thot-tecnico, anubis-gate, maat-cumplimiento, horus-riesgo and narrador-normativo; assign operational mappings; execute local reads, validators, matrices, orders and readbacks; use Agents SDK only when the SDU-governed task needs it and the USD 2.00 ceiling remains valid; use Microsoft live only with exact target, rollback and postcheck
- blocked_actions: additional smoke tests; OpenAI live without concrete SDU task; treating Agents SDK as authority; creating a seventh SDU canonical agent; Microsoft live without target; production; permission/admin consent changes; broad regulated read; secret materialization; persistent remote agents; vector store creation
- rollback: revert this order/readback/index exception; restore prior order status if SDU activation is withdrawn; stop any future live call that is not tied to a concrete SDU-governed task
- postcheck: confirm next task readback names the SDU canonical agents used, their operational mappings, target, owner, rollback, postcheck, evidence, validator and stop condition; confirm no additional smoke was run
- evidence: SDU-CN canonical pantheon active; mapping matrix active; operator corrected live activation to SDU agents and no more smoke on 2026-06-08
- validator: scripts/validators/sdu_cn_canonical_agent_pantheon_validator.py|scripts/validators/focus_5_repo_contracts_validator.py|.agents/codex/tools/local_validate_order_packets.ps1|git diff --check
- expiration_rule: single_next_task_or_when_operator_changes_agent_roster_target_cost_or_live_boundary
- stop_condition: PENDING_TARGET_ONLY|seventh_agent_created|canonical_agent_treated_as_tool|microsoft_live_without_target|secret_detected

## Active SDU Roster

| SDU agent | Role in next task | Operational mapping |
| --- | --- | --- |
| `seshat-normativa` | evidence, metadata, traceability | `court.seshat_evidence` |
| `thot-tecnico` | schema, tools, events, fields | `court.thot_schema` |
| `anubis-gate` | gate, rollback, postcheck | `rey.frontier_guardian` and `court.sdu_gate` |
| `maat-cumplimiento` | coherence, proportionality, RACI | `court.sdu_gate` |
| `horus-riesgo` | risk and contradiction watch | `rey.frontier_guardian` |
| `narrador-normativo` | narrative after approved evidence | `court.seshat_evidence` |

## Execution Boundary

No more smoke tests are authorized by this packet. The next task must be
handled by the SDU canonical agents first. Agents SDK, OpenAI live and
Microsoft live are only execution media under the SDU chain, never the source
of authority.
