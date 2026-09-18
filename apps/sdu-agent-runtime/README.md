# SDU Agent Runtime Baseline

Full-live governed baseline for the cabina Agents SDK gate.

This package is intentionally governed. Its default runtime path is
`full_live_governed`, while Microsoft, production and broad writes remain
gated.

## Full Live Governed Boundary

The default package path is `full_live_governed`. PR #56 also has a governed
live smoke gate:

- `OPENAI_API_LIVE_GOVERNED_READY`
- `RESPONSES_API_LIVE_GOVERNED_READY`
- `AGENTS_SDK_RUNTIME_LIVE_GOVERNED_READY`
- `MICROSOFT_LIVE_GOVERNED_GATED`
- `PRODUCTION_GOVERNED_GATED`
- `PROPAGATION_PREPARED_NOT_EXECUTED`

The governed live gate may import `openai`, import `agents`, call OpenAI
`models.list`, call Responses API and run an Agents SDK `Agent` + `Runner`
smoke with synthetic non-sensitive input. It must not print response bodies or
secrets.

SDK tools, SDK handoffs, SDK tracing, persistent remote agents, Microsoft live
writes, production writes and repo propagation require separate governed orders
with exact scope, owner, rollback, postcheck and evidence.

Precision markers:

- `SDU_TRIAGE_AGENT_IMPLEMENTATION=full_live_governed`
- `LIVE_RUNTIME_VALIDATION=external_governed_smoke`
- `SETUP_SCRIPT_VERSIONED=yes`
- `MAINTENANCE_SCRIPT_VERSIONED=yes`
- `SETUP_SCRIPT_SELF_SUFFICIENT=yes`
- `DEPENDENCY_INSTALL=openai|openai-agents`
- `PWSH_PRECHECK=yes`

## Codex Cloud Scripts

- `.agents/codex/scripts/codex_cloud_full_live_governed_setup.sh` creates or
  reuses `.venv`, installs `openai` and `openai-agents`, then verifies imports
  and versions. Live OpenAI calls require explicit `--run-openai-smoke`.
- `.agents/codex/scripts/codex_cloud_full_live_governed_maintenance.sh`
  verifies `pwsh` before PowerShell validators and stops with
  `PWSH_MISSING_FOR_VALIDATORS` if it is unavailable.

## Smoke

```powershell
python -m unittest discover -s apps/sdu-agent-runtime/tests
```

## First Agent

- `agent_id`: `sdu-triage-agent`
- `mode`: `full_live_governed`
- `default_path`: `full_live_governed`
- `implementation`: `full_live_governed`
- `live_runtime_validation`: external governed smoke gate
- `output`: structured JSON
- `external_writes`: forbidden

## Stop Conditions

- `secret_detected`
- `openai_api_live_requested_without_governed_gate`
- `microsoft_live_requested_without_governed_order`
- `microsoft_live_target_missing`
- `production_target_missing`
- `regulated_data_boundary_unclear`
- `propagation_requested_before_cabina_closeout`
