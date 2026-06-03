# Agents SDK Agent Registry

## sdu-triage-agent

- `agent_id`: `sdu-triage-agent`
- `runtime_path`: `apps/sdu-agent-runtime`
- `owner_agent`: `court.openai_dispatcher`
- `reviewer_agent`: `rey.frontier_guardian`
- `mode`: `local_no_live`
- `purpose`: classify cabina governance requests into local next gates.
- `output_schema`: `structured_json_triage_v1`
- `tools_allowed`: standard library local helpers only.
- `tools_forbidden`: OpenAI API live, Agents SDK live, Microsoft live,
  production, permission changes, external writes and secrets.
- `validator`: `python -m unittest discover -s apps/sdu-agent-runtime/tests`
- `stop_condition`: `openai_api_live_requested_without_order|microsoft_live_requested_without_governed_order|production_requested_without_explicit_authorization|secret_detected`

## Registry Boundary

This registry does not create a deployed remote agent. It records the local
baseline contract that future repo-native work may adopt after this cabina gate
is merged.
