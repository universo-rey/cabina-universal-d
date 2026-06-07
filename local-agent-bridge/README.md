# SDU Local Agent Bridge DEV

Local mock bridge for SDU agent runtime connection tests. It accepts synthetic
Teams-like activity, resolves the route, checks the MCP registry mode and emits
sanitized evidence.

It also serves a local read-only agent control dashboard from the existing
governance matrices.

The local shell connector is status-only. It reports the governed shell surface
and blocks command execution through the bridge unless a separate task scope or
gate opens that action.

## Boundary

- Bind to `127.0.0.1` only.
- Dashboard and shell status data are blocked when the bridge is bound to a
  non-loopback host such as `0.0.0.0`.
- Synthetic payloads only.
- Dashboard reads local CSV matrices only.
- No external writes.
- No Teams live message.
- No Graph write.
- No OpenAI live.
- No Codex Cloud apply.

## Commands

Run the mock flow:

```bash
npm test --prefix local-agent-bridge
```

Run the local bridge manually:

```bash
npm start --prefix local-agent-bridge
```

Open the dashboard:

```text
http://127.0.0.1:8787/
```

Check the governed shell connector:

```text
http://127.0.0.1:8787/api/shell/status
```

Run the guided local validation postcheck from the dashboard:

```text
POST http://127.0.0.1:8787/api/local-actions/run
```

`local.action.review_task_queue` runs a structured no-shell review of the repo
task queue. `local.action.review_live_gate_packets` reviews local gate packets
for Jira, OpenAI, Microsoft and Power Platform without calling providers.
`local.action.prepare_local_validation` runs a fixed postcheck allowlist. The
bridge still does not expose arbitrary shell commands.
