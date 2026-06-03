# SDU Teams Identity DEV Activation Plan 20260603

Estado: `SDU_TEAMS_IDENTITY_DEV_GATE_PREPARED`

## Mandato

Preparar el carril DEV para que la cadena SDU pueda tener identidad de Teams, paquete de app, bot scaffold y primer mensaje interno de prueba, sin ejecutar instalacion real, envio real ni Graph write.

## Cadena

- agente rector: `rey.control_plane_orchestrator`
- agente delegado: `operador Microsoft`
- agente runtime: `operador runtime`
- gate: `court.sdu_gate`
- evidencia: este plan, matriz de targets, contrato de registro, paquete DEV y readback
- validador: `scripts/validators/sdu_teams_identity_dev_activation_validator.py`

## Targets DEV

- app Teams: `Seshat SDU Agent`
- Teams app id placeholder: `[TEAMS_APP_ID]`
- bot id placeholder: `[BOT_ID]`
- Entra app id placeholder: `[ENTRA_APP_ID]`
- tenant id placeholder: `[TENANT_ID]`
- bot endpoint placeholder: `[BOT_ENDPOINT]`
- host DEV placeholder: `[DEV_TUNNEL_OR_HOST]`

## Acciones Permitidas

- Versionar contrato y manifest DEV template.
- Validar JSON, CSV y frontera documental.
- Preparar checklist de valores requeridos para un store externo gobernado.
- Preparar test de primer mensaje interno como dry-run local.

## Acciones Bloqueadas

- Teams app install.
- Teams message real.
- Microsoft Graph write.
- OpenAI live.
- Codex Cloud apply.
- Produccion.
- Cambio de permisos.
- Persistencia de secretos o material sensible.

## Gate De Activacion

1. Resolver placeholders DEV fuera del repo en un store gobernado.
2. Validar que app id, bot id, Entra id y tenant id no queden hardcodeados.
3. Aprobar identidad, superficie, objeto, accion, rollback y postcheck.
4. Ejecutar instalacion o mensaje real solo con orden separada.
5. Registrar evidencia saneada del postcheck.

## Rollback

Como este paquete no ejecuta live writes, el rollback inmediato es revertir el commit o cerrar el PR. Si una orden futura crea recursos DEV reales, el rollback requerido sera desinstalar la app DEV, revocar la identidad DEV y dejar evidencia del postcheck.

## Stop Conditions

`REAL_TENANT_HARDCODED`, `REAL_APP_ID_HARDCODED`, `TEAMS_APP_INSTALL_ATTEMPTED`, `TEAMS_MESSAGE_SENT`, `GRAPH_WRITE_ATTEMPTED`, `OPENAI_LIVE_ATTEMPTED`, `CODEX_CLOUD_APPLY_ATTEMPTED`, `PRODUCTION_MUTATION_ATTEMPTED`, `SECRET_DETECTED`.
