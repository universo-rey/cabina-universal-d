# MCP Teams Canon Pointer 20260603

Estado: `MCP_TEAMS_CANON_POINTER_ACTIVE`

## Regla

`mcp_TeamsServer` ya existe en el canon de conexiones. Cabina, TGE y SDU deben consumir los IDs existentes y no pueden crear un nuevo canonical ID para esta misma conexion.

Companion auth viene de `conn_canon_003503` y `conn_canon_004172`. Todo live probe debe declarar esos IDs. Todo write/send requiere target exacto, owner, rollback, postcheck y evidencia.

## Operational Pointer

| connection_role | canonical_id | status | surface | evidence | active_next_step |
| --------------- | ------------ | ------ | ------- | -------- | ---------------- |
| Teams MCP pattern | `conn_canon_003504` | `PATTERN_REFERENCE_CANON` | Teams | TGE Work IQ Mail/Teams probe | Use as non-live pattern reference |
| Teams MCP live read candidate | `conn_canon_003505` | `LIVE_READ_PROBE_ALLOWED_IF_AUTH_READY` | Teams | TGE Work IQ Mail/Teams probe | Run `python scripts/connections/mcp_teams_live_read_probe.py --dry-run --handshake --list-tools --target-tenant-label ESCRIBANIA --connection-id conn_canon_003505 --auth-companion-id conn_canon_003503 --no-body-print --evidence-out readbacks/20260603_MCP_TEAMS_LIVE_READ_PROBE_EVIDENCE.json` |
| Agent365 MCP frontier evidence | `conn_canon_003736` | `EVIDENCE_REFERENCE_CANON` | Teams | TGE Agent365 MCP frontier acta | Keep as evidence pointer |
| Work IQ Mail/Teams readback evidence | `conn_canon_004173` | `EVIDENCE_REFERENCE_CANON` | Teams | TGE Work IQ Mail/Teams readback | Keep as evidence pointer |
| Entra auth companion | `conn_canon_003503` | `AUTH_COMPANION_CANON` | Entra ID | TGE Work IQ Mail/Teams probe | Use for first auth companion |
| Entra readback auth companion | `conn_canon_004172` | `AUTH_COMPANION_CANON` | Entra ID | TGE Work IQ Mail/Teams readback | Use as alternate auth companion |

## Write Gate

Any Teams message or Graph write must provide all fields:

- identity;
- tenant;
- exact chat/channel/team/thread target;
- owner;
- approved message text;
- rollback;
- postcheck;
- evidence destination.

If any field is missing, the command remains prepared and the status is:

`FIRST_MESSAGE_PENDING_TARGET_OR_APPROVAL`

## Blocked by this Pointer

- `NEW_CANONICAL_ID_FOR_EXISTING_MCP_TEAMS`
- `TEAMS_MESSAGE_WITHOUT_TARGET`
- `GRAPH_WRITE_ATTEMPTED`
- `SECRET_DETECTED`
- `TOKEN_PRINT_ATTEMPTED`
