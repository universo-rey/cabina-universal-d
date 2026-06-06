# SDU Local Agent Bridge DEV

Local mock bridge for SDU agent runtime connection tests. It accepts synthetic
Teams-like activity, resolves the route, checks the MCP registry mode and emits
sanitized evidence.

It also serves a local read-only agent control dashboard from the existing
governance matrices.

## Boundary

- Bind to `127.0.0.1` only.
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
