# SDU Local Agent Bridge Security Policy

## Defaults

- Bind host: `127.0.0.1`.
- Public listener: blocked.
- Synthetic activity: required.
- External writes: blocked.
- Raw transcript persistence: blocked.
- Material sensitive storage: blocked.

## Required gate for live

Any move from local mock to live operation requires identity, target surface,
object, owner, rollback, postcheck, evidence and stop condition.

## Stop conditions

- `LOCAL_BRIDGE_PUBLIC_WITHOUT_AUTH`
- `TEAMS_MESSAGE_SENT_WITHOUT_GATE`
- `MCP_WRITE_WITHOUT_APPROVAL`
- `CODEX_CLOUD_LIVE_WRITE_ATTEMPTED`
- `SECRET_DETECTED`
