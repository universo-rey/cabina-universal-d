# VSI OpenAI Live Smoke Readback - 2026-06-07

- agente: court.openai_dispatcher
- orden: execute_governed_openai_live_smoke
- superficie: VSI/Agile Agent Canvas/OpenAI governed live smoke
- estado: EXECUTED_LIVE_VALIDATED
- branch: codex/vsi-openai-live-smoke-executed
- head_base: 1aae091
- packet: .agents/codex/orders/ORDER_VSI_OPENAI_LIVE_20260606.md
- task: vsi.agent.task.037
- secret_source: D:\.env.local, ignored by Git, value not printed
- data_boundary: synthetic non-sensitive payload only
- model_used: gpt-5.5
- openai_version: 2.36.0
- openai_agents_version: 0.17.0
- openai_models_list: PASS
- responses_api: PASS
- responses_marker_verified: true
- agents_sdk_runner: PASS
- agents_marker_verified: true
- response_bodies_printed: false
- agent_output_printed: false
- secrets_printed: false
- microsoft_live_executed: false
- production_executed: false
- propagation_executed: false
- vector_store_created: false
- persistent_remote_agent_created: false

## Validators

- python -m unittest discover -s apps/sdu-agent-runtime/tests: PASS
- .agents/codex/scripts/agents_sdk_functional_lifecycle_smoke.py: PASS
- npm test --prefix local-agent-bridge: PASS after dashboard status reconciliation
- python scripts/validators/local_agent_bridge_validator.py: PASS
- .agents/codex/tools/local_validate_order_packets.ps1: PASS
- .agents/codex/tools/local_validate_parallel_order_governance.ps1: PASS
- .agents/codex/tools/local_validate_agent_layer.ps1: PASS
- .agents/codex/tools/local_validate_capability_use_hardening.ps1: PASS
- .agents/codex/tools/local_validate_operational_chain.ps1: PASS
- git diff --check: PASS with line-ending warnings only

## Stop Condition

openai_agents_sdk_live_smoke_executed_validated

## Rollback

Revert the evidence commit if the recorded state is wrong. Revoke or rotate the
local OpenAI key from provider settings if exposure is suspected. No secret was
printed or committed in this run.
