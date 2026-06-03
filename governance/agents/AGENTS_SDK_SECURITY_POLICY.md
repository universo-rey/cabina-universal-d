# Agents SDK Security Policy

## Data Boundary

The baseline may process only synthetic strings, repo metadata and sanitized
governance labels. It must not process raw regulated data or secrets.

## Secret Boundary

The baseline must not read `.env`, prompt for keys, print keys, persist tokens
or infer credentials from the environment.

## External Boundary

The baseline must not call OpenAI, Microsoft Graph, SharePoint, Teams, Planner,
Power Platform, external HTTP services or production systems.

It must not import `openai-agents`, instantiate `Agent`, use `Runner`, bind
`OpenAIResponsesModel`, run SDK tools, run SDK handoffs or enable SDK tracing
without a separate governed order.

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
- `openai_api_live_requested_without_order`
- `microsoft_live_requested_without_governed_order`
- `production_requested_without_explicit_authorization`
- `permission_change_requested_without_order`
