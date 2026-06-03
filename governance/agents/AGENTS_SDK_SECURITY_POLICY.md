# Agents SDK Security Policy

## Data Boundary

The baseline may process only synthetic strings, repo metadata and sanitized
governance labels. It must not process raw regulated data or secrets.

## Secret Boundary

The baseline must not read `.env`, prompt for keys, print keys, persist tokens
or infer credentials from the environment.

The PR #56 governed live smoke may load `OPENAI_API_KEY` ephemerally from the
process environment or ignored local env file. It must never print, persist,
commit, summarize or echo the secret value.

## External Boundary

The default local path must not call OpenAI, Microsoft Graph, SharePoint, Teams,
Planner, Power Platform, external HTTP services or production systems.

The governed live gate may call:

- OpenAI API `models.list` without printing the response body.
- Responses API with synthetic non-sensitive input.
- Agents SDK `Agent` + `Runner` with synthetic non-sensitive input.

The governed live gate must not run SDK tools, SDK handoffs, SDK tracing,
Microsoft writes, production writes, permission changes, broad tenant reads,
regulated-data reads or propagation without a separate object-specific order.

## Output Boundary

Outputs must be structured JSON with:

- `agent_id`
- `mode`
- `decision`
- `blocked_surfaces`
- `next_action`
- `evidence`

## Stop Conditions

- `secret_detected`
- `openai_api_live_requested_without_governed_gate`
- `microsoft_live_requested_without_governed_order`
- `production_requested_without_explicit_authorization`
- `permission_change_requested_without_order`
- `regulated_data_boundary_unclear`
- `propagation_requested_before_cabina_closeout`
