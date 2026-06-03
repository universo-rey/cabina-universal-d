# Agents SDK Agent Registry

## sdu-triage-agent

- `agent_id`: `sdu-triage-agent`
- `runtime_path`: `apps/sdu-agent-runtime`
- `owner_agent`: `court.openai_dispatcher`
- `reviewer_agent`: `rey.frontier_guardian`
- `mode`: `full_live_governed`
- `default_path`: `local_no_live`
- `implementation`: `local_no_live`
- `live_runtime_validation`: `external_governed_smoke`
- `chain_status`: `STANDARD_AGENT_CHAIN_ACTIVE`
- `lead_agent`: `rey.control_plane_orchestrator`
- `delegated_agent`: `court.openai_dispatcher`
- `gate_agent`: `court.sdu_gate`
- `evidence_agent`: `court.seshat_evidence`
- `runtime_status`: `AGENTS_SDK_FUNCTIONAL_AGENT_ACTIVE_GOVERNED`
- `cloud_chain_status`: `CODEX_CLOUD_TASK_EXECUTION_CHAIN_ACTIVE`
- `openai_api_live_status`: `OPENAI_API_LIVE_GOVERNED_READY`
- `responses_api_live_status`: `RESPONSES_API_LIVE_GOVERNED_READY`
- `agents_sdk_runtime_live_status`: `AGENTS_SDK_RUNTIME_LIVE_GOVERNED_READY`
- `microsoft_live_status`: `MICROSOFT_LIVE_GOVERNED_GATED`
- `production_status`: `PRODUCTION_GOVERNED_GATED`
- `propagation_status`: `PROPAGATION_PREPARED_NOT_EXECUTED`
- `sdk_imports`: available for governed live smoke only.
- `setup_script`: `.agents/codex/scripts/codex_cloud_full_live_governed_setup.sh`
- `maintenance_script`: `.agents/codex/scripts/codex_cloud_full_live_governed_maintenance.sh`
- `SETUP_SCRIPT_VERSIONED`: `yes`
- `MAINTENANCE_SCRIPT_VERSIONED`: `yes`
- `SETUP_SCRIPT_SELF_SUFFICIENT`: `yes`
- `DEPENDENCY_INSTALL`: `openai|openai-agents`
- `PWSH_PRECHECK`: `yes`
- `purpose`: classify cabina governance requests into local next gates.
- `output_schema`: `structured_json_triage_v1`
- `tools_allowed`: standard library local helpers, OpenAI `models.list`
  governed smoke, Responses API governed smoke and Agents SDK `Agent` +
  `Runner` governed smoke.
- `tools_forbidden`: ungoverned OpenAI API live, ungoverned Agents SDK live,
  Microsoft write without exact target, production write without exact target,
  SDK tools, SDK handoffs, SDK tracing, permission changes, external writes,
  broad tenant reads, regulated-data reads and secrets.
- `validator`: `python -m unittest discover -s apps/sdu-agent-runtime/tests`
- `live_validator`: `models.list smoke|responses.create synthetic smoke|Agent Runner synthetic smoke`
- `stop_condition`: `secret_detected|microsoft_live_target_missing|production_target_missing|regulated_data_boundary_unclear|propagation_requested_before_cabina_closeout`

## Registry Boundary

This registry does not create a deployed remote agent and does not propagate to
other repos. It records the root cabina full-live governed gate for PR #56.
Persistent agents, SDK tools, SDK handoffs, Microsoft writes and production
writes require separate object-specific governed orders.

Precision markers:

- `SDU_TRIAGE_AGENT_IMPLEMENTATION=local_no_live`
- `LIVE_RUNTIME_VALIDATION=external_governed_smoke`
- `SETUP_SCRIPT_VERSIONED=yes`
- `MAINTENANCE_SCRIPT_VERSIONED=yes`
- `SETUP_SCRIPT_SELF_SUFFICIENT=yes`
- `DEPENDENCY_INSTALL=openai|openai-agents`
- `PWSH_PRECHECK=yes`
