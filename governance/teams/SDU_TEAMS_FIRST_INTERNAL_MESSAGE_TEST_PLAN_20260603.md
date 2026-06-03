# SDU Teams First Internal Message Test Plan 20260603

Estado: `FIRST_INTERNAL_MESSAGE_DRY_RUN_READY`

## Objetivo

Preparar la primera prueba interna de mensaje Teams para `Seshat SDU Agent` sin enviar ningun mensaje real.

## Mensaje Sintetico

`SDU DEV dry run: registrar evidencia, seleccionar ruta MCP y devolver readback sin live write.`

## Ejecucion Permitida Ahora

- Ejecutar simulacion local con fixture sintetico.
- Validar routing, matriz MCP y contrato de bridge.
- Registrar readback sin transcript real.

## Ejecucion Bloqueada Ahora

- Send chat message.
- Send channel message.
- Reply to message.
- Install app.
- Graph write.
- Tenant write.
- Production mutation.

## Gate Futuro

Una orden futura debe indicar identidad, tenant, equipo o chat, canal o thread, texto exacto, rollback, postcheck y evidencia. Si falta cualquiera de esos campos, la prueba queda preparada y no ejecutada.

## Evidencia

- `tests/sdu-agent-runtime/test_dev_activation_contract.py`
- `governance/teams/SDU_TEAMS_IDENTITY_DEV_TARGET_MATRIX_20260603.csv`
- `readbacks/20260603_SDU_TEAMS_MCP_CODEX_CLOUD_DEV_ACTIVATION_READY_READBACK.md`
