# SDU DEV Activation Sensitive Values Checklist 20260603

Estado: `SENSITIVE_VALUES_CHECKLIST_DEV_READY`

This checklist names required values without storing values in the repository.

## Required Names

| name | storage | repo value |
| --- | --- | --- |
| `TEAMS_APP_ID` | external governed store | placeholder only |
| `BOT_ID` | external governed store | placeholder only |
| `ENTRA_APP_ID` | external governed store | placeholder only |
| `TENANT_ID` | external governed store | placeholder only |
| `BOT_ENDPOINT` | external governed store | placeholder only |
| `DEV_TUNNEL_OR_HOST` | external governed store | placeholder only |
| `LOCAL_BRIDGE_TOKEN_REFERENCE` | external governed store | reference only |
| `CODEX_CLOUD_ENVIRONMENT_NAME` | external governed store | placeholder only |
| `OPENAI_API_KEY_OPTIONAL_LIVE_GATE` | external governed store | not used in this gate |

## Verification Rule

- Verify existence without printing values.
- Never copy values into logs, prompts, matrices or readbacks.
- Keep OpenAI live disabled until a separate governed order approves target, cost, payload, rollback and postcheck.
- Keep Microsoft live writes disabled until a separate governed order approves identity, tenant, object, action, rollback and postcheck.

## Stop Conditions

`SECRET_DETECTED`, `OPENAI_LIVE_ATTEMPTED`, `MICROSOFT_LIVE_WRITE_ATTEMPTED`, `REAL_TENANT_HARDCODED`, `REAL_APP_ID_HARDCODED`.
