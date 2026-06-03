# Agents SDK Baseline Policy

## Estado

This policy defines the root cabina baseline for OpenAI Agents SDK design work.
It is now `FULL_LIVE_GOVERNED_READY` for PR #56.

The default package path remains deterministic and local-first. The governed
live gate has separately validated OpenAI API live, Responses API live and
Agents SDK `Runner` live with synthetic payloads, no body dump, no secrets and
no external writes.

Current states:

- `OPENAI_API_LIVE_GOVERNED_READY`
- `RESPONSES_API_LIVE_GOVERNED_READY`
- `AGENTS_SDK_RUNTIME_LIVE_GOVERNED_READY`
- `MICROSOFT_LIVE_GOVERNED_GATED`
- `PRODUCTION_GOVERNED_GATED`
- `PROPAGATION_PREPARED_NOT_EXECUTED`

## Allowed

- Design local agent contracts.
- Run deterministic local smoke tests.
- Validate structured JSON outputs.
- Prepare synthetic eval fixtures.
- Prepare governed order packets for later live work.
- Run governed OpenAI API `models.list` smoke without printing the response
  body.
- Run governed Responses API smoke with synthetic non-sensitive input.
- Run governed Agents SDK `Agent` + `Runner` smoke with synthetic
  non-sensitive input.

## Blocked

- Ungoverned OpenAI API live.
- Ungoverned Agents SDK live.
- Agent Builder live outside this PR gate.
- SDK tools, SDK handoffs, SDK tracing, remote agents or persistent runtime
  outside a separate governed order.
- External vector stores.
- Open-ended costs.
- Secrets or secret materialization.
- Microsoft live writes without exact object, owner, rollback and postcheck.
- Tenant writes.
- Production without exact target, rollback and postcheck.
- Permission changes.
- Remote persistent agents.

## First Agent

- `agent_id`: `sdu-triage-agent`
- `mode`: `full_live_governed`
- `default_path`: `local_no_live`
- `output`: `structured_json`
- `external_writes`: `forbidden`

## Gate

OpenAI live is authorized only for this PR #56 smoke gate and sanitized runtime
verification. Microsoft live, production writes, permission changes,
propagation and persistent remote agents still require exact target, owner,
rollback, postcheck, evidence and stop condition before execution.
