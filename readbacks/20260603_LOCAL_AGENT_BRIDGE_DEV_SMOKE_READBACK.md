# Local Agent Bridge DEV Smoke Readback 20260603

Estado: `LOCAL_AGENT_BRIDGE_DEV_SMOKE_EXECUTED_PASS`

## Ejecucion

Se ejecuto el bridge local en `127.0.0.1:8787` con header
`x-sdu-bridge-auth` requerido. La prueba uso fixture sintetico de Teams y no
llamo Microsoft, OpenAI, Codex Cloud ni produccion.

## Resultado

- health status: `ok`
- health live_executed: `false`
- route status: `ok`
- route id: `teams.route.codex_cloud`
- assigned agent: `court.openai_dispatcher`
- connection id: `mcp.codex.cloud.repo_scoped`
- route live_executed: `false`
- evidence live_executed: `false`
- evidence sanitized: `true`

## Postcheck

El proceso local fue detenido despues del smoke. No quedo public bind, no se
abrieron puertos externos y no se materializo secreto.

## Rollback

Revertir cambios del bridge o detener proceso local. No hay rollback tenant.

## Stop Conditions

`PUBLIC_LOCAL_BRIDGE_WITHOUT_AUTH`, `MCP_REMOTE_WRITE_ATTEMPTED`,
`SECRET_DETECTED`, `LIVE_SURFACE_EXECUTED`.
