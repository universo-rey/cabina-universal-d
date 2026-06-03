# Agents SDK Baseline Policy

## Estado

This policy defines the root cabina baseline for OpenAI Agents SDK design work.
It is local/no-live only.

## Allowed

- Design local agent contracts.
- Run deterministic local smoke tests.
- Validate structured JSON outputs.
- Prepare synthetic eval fixtures.
- Prepare governed order packets for later live work.

## Blocked

- OpenAI API live.
- Agents SDK live.
- Agent Builder live.
- External vector stores.
- Costs.
- Secrets or secret materialization.
- Microsoft live.
- Tenant writes.
- Production.
- Permission changes.
- Remote persistent agents.

## First Agent

- `agent_id`: `sdu-triage-agent`
- `mode`: `local_no_live`
- `output`: `structured_json`
- `external_writes`: `forbidden`

## Gate

Any move from local/no-live to API-backed runtime requires a separate governed
order with identity, data boundary, rollback, postcheck, evidence and stop
condition.
