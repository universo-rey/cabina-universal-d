# MCP Teams First Controlled Message Gate 20260603

Estado: `FIRST_MESSAGE_PENDING_TARGET_OR_APPROVAL`

## Canonical Connection

| field | value |
| --- | --- |
| canonical connection ID | `conn_canon_003505` |
| auth companion ID | `conn_canon_003503` |
| server | `mcp_TeamsServer` |
| tenant | `ESCRIBANIA` tenant from TGE evidence |
| identity | `efigueroa@registronotarial8tdf.com.ar` |
| owner | Enzo Figueroa |

## Allowed Message

`Seshat SDU Agent DEV: prueba controlada de identidad MCP Teams. No ejecutar acciones productivas.`

## Required Before Send

| requirement | current_status |
| --- | --- |
| exact Teams chat/channel/team/thread target | `PENDING_TARGET_ONLY` |
| identity | `IDENTITY_DECLARED` |
| owner | `OWNER_DECLARED` |
| explicit approval for this exact target | `PENDING_TARGET_APPROVAL` |
| rollback | `DELETE_SINGLE_TEST_MESSAGE_IF_CONNECTOR_SUPPORTS_DELETE_OR_APPEND_CORRECTION_NOTICE` |
| postcheck | `FETCH_TARGET_THREAD_OR_CHAT_AND_CONFIRM_SINGLE_TEST_MESSAGE_ONLY` |
| evidence destination | `readbacks/20260603_MCP_TEAMS_FIRST_CONTROLLED_MESSAGE_EVIDENCE.json` |

## Prepared Command

The command remains blocked until the exact target is declared:

```text
python scripts/connections/mcp_teams_live_read_probe.py --dry-run --target-tenant-label ESCRIBANIA --connection-id conn_canon_003505 --auth-companion-id conn_canon_003503 --no-body-print --evidence-out readbacks/20260603_MCP_TEAMS_FIRST_MESSAGE_PREFLIGHT_EVIDENCE.json
```

## Not Executed

- No Teams message sent.
- No Graph write.
- No app install.
- No permission change.
- No production action.

## Stop Conditions

- `TARGET_MISSING_FOR_MESSAGE`
- `OWNER_MISSING_FOR_MESSAGE`
- `ROLLBACK_MISSING_FOR_MESSAGE`
- `POSTCHECK_MISSING_FOR_MESSAGE`
- `TEAMS_MESSAGE_WITHOUT_TARGET`
- `GRAPH_WRITE_ATTEMPTED`
- `SECRET_DETECTED`
