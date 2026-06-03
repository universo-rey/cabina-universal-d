# SDU Agent Runtime Baseline

Full-live governed baseline for the cabina Agents SDK gate.

This package is intentionally deterministic. It does not call OpenAI, Microsoft,
SharePoint, Teams, Planner, Graph, Power Platform or production systems.

## Full Live Governed Boundary

The default package path remains `local_no_live` and deterministic. PR #56 also
has a governed live smoke gate:

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

## Smoke

```powershell
python -m unittest discover -s apps/sdu-agent-runtime/tests
```

## First Agent

- `agent_id`: `sdu-triage-agent`
- `mode`: `full_live_governed`
- `default_path`: `local_no_live`
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
