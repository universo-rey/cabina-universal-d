# SDU Agent Runtime Baseline

Local/no-live baseline for the cabina Agents SDK gate.

This package is intentionally deterministic. It does not call OpenAI, Microsoft,
SharePoint, Teams, Planner, Graph, Power Platform or production systems.

## SDK Boundary

This skeleton does not import `openai-agents` and does not execute a real
Agents SDK runtime. It is a local/no-live contract before any future Agents SDK
implementation.

Any step to `openai-agents`, `Agent`, `Runner`, `OpenAIResponsesModel`, SDK
tools, SDK handoffs, SDK tracing, live API calls or costs requires a separate
governed order.

## Smoke

```powershell
python -m unittest discover -s apps/sdu-agent-runtime/tests
```

## First Agent

- `agent_id`: `sdu-triage-agent`
- `mode`: `local_no_live`
- `output`: structured JSON
- `external_writes`: forbidden

## Stop Conditions

- `openai_api_live_requested_without_order`
- `microsoft_live_requested_without_governed_order`
- `production_requested_without_explicit_authorization`
- `secret_detected`
