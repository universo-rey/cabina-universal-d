# SDU Agents Runtime Connections Preflight 20260603

## Mandato entendido

Materializar un plano DEV para que la cadena SDU existente pueda recibir
mensajes por una identidad conversacional de Teams, resolver capacidades por
MCP gobernado, ejecutar una simulacion por puente local, preparar delegacion
repo-scoped para Codex Cloud y producir evidencia versionable.

## Agente interviniente

- Agente rector: `rey.control_plane_orchestrator`.
- Agente delegado: `court.sdu_gate`.
- Agente runtime: `sdu-triage-agent`.
- Agente evidencia: `court.seshat_evidence`.

## Puede hacer

- Crear branch `codex/sdu-agents-runtime-connections-teams-codex-cloud-dev-20260603`.
- Versionar scaffolds DEV, matrices, contratos, validadores y workflow.
- Ejecutar validadores locales, tests mock y simulacion sintetica.
- Abrir PR para revision humana.

## No puede hacer

- Instalar la Teams App en un tenant real.
- Enviar mensajes Teams reales.
- Ejecutar Microsoft Graph write.
- Ejecutar OpenAI API live o Responses API live.
- Ejecutar `codex cloud apply` o mutacion remota.
- Crear un septimo agente o personalidad nueva.
- Tocar Seshat como fuente canonica.
- Guardar material sensible.

## Requiere aprobacion humana separada

- App registration real.
- Teams install real.
- Mensaje real por bot.
- Permisos Graph.
- Tenant write.
- Produccion.
- OpenAI API live.
- Codex Cloud live write/apply.

## Evidencia a producir

- Matrices de capacidades, MCP, Teams y Codex Cloud.
- Scaffolds de Teams App/Bot y puente local mock.
- Contratos de datos saneados y evidencia.
- Validadores locales.
- Workflow repo-scoped.
- Simulacion end-to-end sintetica.
- Readback final.

## Proximo paso exacto

Crear los artefactos DEV, ejecutar validadores locales, pushear la rama y abrir
PR listo para revision.

## Estado

`SDU_AGENTS_RUNTIME_CONNECTIONS_PREFLIGHT_PASS`
