# SDU Agent Chat Teams App DEV Scaffold

This scaffold defines a Teams App template and local bot skeleton for the
existing SDU chain. It is not installed in a real tenant and does not send real
messages.

## Contents

- `manifest.template.json`: Teams App manifest with placeholders.
- `bot/`: local TypeScript skeleton and mock test entrypoint.
- `contracts/`: activity and readback contracts.
- `schemas/`: JSON schemas used by validators.
- `matrices/`: permission and install-scope matrices.

## Boundary

- Local template only.
- Synthetic payloads only.
- No app registration.
- No Teams install.
- No Graph write.
- No production.

## DEV test

Run `npm test --prefix teams-app/sdu-agent-chat/bot` to execute the local mock
routing smoke.
