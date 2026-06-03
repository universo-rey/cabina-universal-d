# SDU Agent Runtime Evidence Model 20260603

## Evidence principles

- Evidence is sanitized.
- Evidence is bounded.
- Evidence records whether live execution happened.
- Evidence links route, agent, gate, validator and rollback.
- Evidence must not store raw Teams content, attachments or sensitive material.

## Schemas

- `runtime-event.schema.json`
- `tool-call.schema.json`
- `gate-decision.schema.json`
- `readback-evidence.schema.json`

## Required fields

Every evidence packet must include `evidence_id`, `timestamp_utc`,
`assigned_agent`, `gate_agent`, `live_executed=false`, `validator` and
`stop_condition`.

## State

`SDU_AGENT_RUNTIME_EVIDENCE_MODEL_ACTIVE_DEV`
