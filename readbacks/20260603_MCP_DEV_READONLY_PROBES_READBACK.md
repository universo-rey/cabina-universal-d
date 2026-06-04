# MCP DEV Readonly Probes Readback 20260603

Estado: `MCP_DEV_READONLY_PROBES_PARTIAL_PASS`

## Probes Ejecutados

- `mcp.local.bridge.dev`: ejecutado en loopback local con fixture sintetico.
- `mcp.github.dev`: cubierto por branch, commit y PR gobernado pendiente.
- `mcp.openai.responses.gate`: contrato revisado; no se ejecuto OpenAI live.

## Probes Bloqueados O Pendientes

- `mcp.teams.dev`: bloqueado para envio por falta de chat/canal exacto o app
  delegated auth activa.
- `mcp.codex.cloud.dev`: historial read-only disponible; nueva tarea no
  ejecutada en esta pasada por frontera de costo/env id.

## No Ejecutado

- no Teams message;
- no Graph write;
- no OpenAI live;
- no Codex Cloud apply;
- no MCP remote write;
- no produccion;
- no secretos.

## Rollback

No hay rollback tenant. Para local bridge, detener proceso o revertir commit.
Para cualquier probe remoto futuro, cancelar tarea o no aplicar diff.

## Stop Conditions

`TARGET_CHAT_MISSING`, `APP_DEVICE_AUTH_REQUIRED`, `CODEX_CLOUD_ENV_ID_MISSING`,
`OPENAI_LIVE_WITHOUT_GATE`, `SECRET_DETECTED`.
