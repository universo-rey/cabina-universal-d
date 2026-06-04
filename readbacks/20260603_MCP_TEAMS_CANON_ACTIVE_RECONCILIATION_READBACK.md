# MCP Teams Canon Active Reconciliation Readback 20260603

Estado: `MCP_TEAMS_CANON_RECONCILED_ACTIVE_GATE_READY_PENDING_TARGETS`

## Canon Decision

`mcp_TeamsServer` is already canonized. This branch does not create a new canonical ID. It adds an active pointer, live gate matrix, probe script, validators, workflow, and controlled message gate around existing canonical IDs.

## Existing Canonical IDs

| role | canonical_id |
| --- | --- |
| pattern reference | `conn_canon_003504` |
| live read candidate | `conn_canon_003505` |
| evidence reference | `conn_canon_003736` |
| readback evidence | `conn_canon_004173` |
| auth companion | `conn_canon_003503` |
| auth companion alternate | `conn_canon_004172` |

## Duplicate Handling

No active duplicate `mcp_TeamsServer` artifact was found in PR #80 before this update. Future duplicates must be converted to pointer status `SUPERSEDED_BY_CONNECTION_CANON`.

## Live Probe

| action | status |
| --- | --- |
| handshake | `PENDING_SECRET_ONLY` unless external auth exists at runtime |
| list-tools | `PENDING_SECRET_ONLY` unless external auth exists at runtime |
| Teams message | `FIRST_MESSAGE_PENDING_TARGET_OR_APPROVAL` |
| Graph write | `NOT_EXECUTED` |

## Available Runtime Surface

Tool discovery in this session found a real Microsoft Teams connector with chat/channel read and send actions. It was not used for live message read/send because the Work IQ MCP Teams reconciliation still lacks exact target and approved message target fields. The connector remains available for a later governed target-specific step.

## Evidence

- `governance/connections/MCP_TEAMS_CANON_RECONCILIATION_REPORT_20260603.md`
- `governance/connections/MCP_TEAMS_CANON_POINTER_20260603.md`
- `governance/connections/MCP_TEAMS_ACTIVE_LIVE_GATE_MATRIX_20260603.csv`
- `scripts/connections/mcp_teams_live_read_probe.py`
- `governance/teams/MCP_TEAMS_FIRST_CONTROLLED_MESSAGE_GATE_20260603.md`
- `readbacks/20260603_MCP_TEAMS_LIVE_READ_PROBE_READBACK.md`

## Commands

```powershell
python scripts/connections/mcp_teams_live_read_probe.py --dry-run --handshake --list-tools --target-tenant-label ESCRIBANIA --connection-id conn_canon_003505 --auth-companion-id conn_canon_003503 --no-body-print --evidence-out readbacks/20260603_MCP_TEAMS_LIVE_READ_PROBE_EVIDENCE.json
python scripts/validators/mcp_teams_connection_canon_pointer_validator.py
python scripts/validators/mcp_teams_active_live_gate_validator.py
python scripts/validators/mcp_teams_live_read_probe_validator.py
```

## Stop Conditions

- `NEW_CANONICAL_ID_FOR_EXISTING_MCP_TEAMS`
- `SECRET_DETECTED`
- `TOKEN_PRINT_ATTEMPTED`
- `TEAMS_MESSAGE_WITHOUT_TARGET`
- `GRAPH_WRITE_ATTEMPTED`
- `TARGET_MISSING_FOR_MESSAGE`
- `ROLLBACK_MISSING_FOR_MESSAGE`
- `POSTCHECK_MISSING_FOR_MESSAGE`
