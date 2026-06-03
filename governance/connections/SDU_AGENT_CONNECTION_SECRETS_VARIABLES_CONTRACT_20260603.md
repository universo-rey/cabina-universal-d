# SDU Agent Connection Variables Contract 20260603

## Purpose

Define variable names and storage rules for future governed live gates without
storing sensitive material in this repository.

## Contract

| variable_name | purpose | dev_value_policy | live_gate_required | storage_policy |
| --- | --- | --- | --- | --- |
| `SDU_BRIDGE_BIND_HOST` | local bridge host | `127.0.0.1` | no | local process only |
| `SDU_BRIDGE_PORT` | local bridge port | `8787` | no | local process only |
| `TEAMS_APP_ID_GUID` | Teams app placeholder | placeholder only | yes | external governed store |
| `BOT_APP_ID_GUID` | Teams bot placeholder | placeholder only | yes | external governed store |
| `OPENAI_API_KEY_OPTIONAL_LIVE_GATE` | future OpenAI live gate reference | absent in DEV | yes | external governed store |
| `CODEX_CLOUD_ENVIRONMENT_NAME` | future Codex Cloud target label | absent in DEV | yes | external governed store |

## Rules

- No variable value with sensitive material may be committed.
- DEV validators check names and absence of materialized values.
- Live use requires a separate order with target, owner, rollback, postcheck and
  evidence.

## Stop condition

`SECRET_DETECTED`
