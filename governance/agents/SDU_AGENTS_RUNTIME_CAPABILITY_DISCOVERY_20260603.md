# SDU Agents Runtime Capability Discovery 20260603

## Decision rectora

Seshat canoniza agentes. TGE consume canon. Esta cabina opera el plano DEV de
conexiones y no convierte TGE ni la cabina en fuente madre de agentes.

## Cadena activa descubierta

La operacion usa la cadena estandar vigente:

1. `rey.control_plane_orchestrator`
2. `court.openai_dispatcher`
3. `sdu-triage-agent`
4. `court.sdu_gate`
5. `court.seshat_evidence`

No se crea un septimo agente. La identidad Teams `sdu-agent-chat` es una
superficie de conversacion y enrutamiento, no un agente nuevo.

## Capacidades materiales DEV

- `teams_chat_intake`: recepcion sintetica de actividad Teams por plantilla.
- `mcp_connection_resolution`: resolucion de herramienta por registro MCP.
- `local_bridge_mock_execution`: ejecucion local mock con payload saneado.
- `codex_cloud_repo_scoped_delegation`: plantillas de tareas repo-scoped sin
  apply.
- `evidence_readback`: evidencia sintetica y readback versionable.

## Superficies no ejecutadas

- Microsoft Teams real.
- Microsoft Graph real.
- OpenAI API live.
- Responses API live.
- Codex Cloud live write/apply.
- Produccion.
- Permisos.
- Material sensible.

## Resultado

`SDU_RUNTIME_CAPABILITY_DISCOVERY_COMPLETE_DEV_ONLY`
