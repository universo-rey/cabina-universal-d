# SDU Teams MCP Codex Cloud DEV Live Smoke Readback 20260603

Estado: `SDU_TEAMS_MCP_CODEX_CLOUD_DEV_LIVE_SMOKE_PARTIAL_READY_FOR_REVIEW`

## Resumen

El carril paso de scaffold a resolucion live gobernada. La evidencia de TGE
demuestra ejecucion previa para `Seshat Normativa`, la app Entra existe, los
usuarios Enzo y Seshat se resolvieron en Escribania, y el bridge local corrio
un smoke real DEV local sin live external.

## Ejecuciones Y Evidencia

- PR #78 mergeado previamente a `main`.
- Copilot `Seshat Normativa`: ejecucion previa verificada por TGE.
- Entra app `SDU-CN Seshat Teams Connector Pilot`: lectura live confirmada.
- Usuario `efigueroa@registronotarial8tdf.com.ar`: resuelto exacto.
- Usuario `seshat@registronotarial8tdf.com.ar`: resuelto exacto.
- Local bridge DEV smoke: PASS.
- Agents SDK import smoke: `openai-agents=0.17.0`, `openai=2.36.0`,
  `Runner=True`, `OK_NO_API_CALL`.
- Codex Cloud: historial read-only `READY`, `no diff`; nueva tarea no creada.
- CDF: matriz de permisos/canales revisada; aporta patron y candidatos, no
  `ChatId`, `TeamId` ni `ChannelId` exacto.

## Teams Message

Destino actualizado por el operador: `efigueroa@registronotarial8tdf.com.ar`.

Mensaje aprobado:

`Seshat SDU Agent activo en modo DEV. Prueba controlada de identidad, ruteo y evidencia. No ejecutar acciones productivas.`

No se envio en esta pasada porque:

- Azure CLI no tiene `Chat.Read`, `Chat.ReadWrite` ni `ChatMessage.Send`.
- El intento de token para `Chat.ReadWrite` y `ChatMessage.Send` quedo
  bloqueado por preautorizacion/consentimiento requerido.
- La app Seshat tiene los scopes declarados, pero requiere delegated
  device-code/auth antes del envio.
- El conector Teams generico visible pertenece a otro contexto operativo y no
  debe usarse para el envio Escribania.

## No Ejecutado

- no Teams message;
- no create chat;
- no create channel;
- no Teams app install;
- no permission change;
- no client secret;
- no OpenAI live;
- no Codex Cloud apply;
- no produccion.

## Rollback

- local bridge: proceso detenido;
- repo: revertir commit o cerrar PR;
- Teams: no hay mensaje ni chat nuevo para revertir;
- Entra: no hubo cambio nuevo;
- Codex Cloud: no hubo nueva tarea ni apply.

## Proximo Gate Exacto

Ejecutar el script gobernado `Invoke-SduCnSeshatFirstTeamsMessage.ps1` con
`ClientId` de la app existente y destino exacto, o autorizar explicitamente la
creacion de chat con `efigueroa@registronotarial8tdf.com.ar`, rollback y
postcheck. Si el flujo pide consentimiento/permisos nuevos, detener con
`PERMISSION_CHANGE_WITHOUT_ORDER`.

## Cierre Operativo

- agente: `rey.control_plane_orchestrator`
- orden: resolver opciones live DEV y avanzar hasta la frontera segura
- superficie: GitHub, Entra/Graph read-only, Teams gate, runtime local,
  Codex Cloud read-only history
- skill: `tcu-descubridor-capacidades|parallel-order-governance|no-inference-runtime-write-guard|governed-readback-closeout`
- receta: `recipe.parallel_agent_operation|recipe.governed_order_preparation|recipe.github_pr_lifecycle_governed`
- tool: `az|Teams connector read|node local bridge|python validators|codex cloud list|gh`
- estado: `SDU_TEAMS_MCP_CODEX_CLOUD_DEV_LIVE_SMOKE_PARTIAL_READY_FOR_REVIEW`
- evidencia: readbacks de app, gate, MCP, Codex Cloud y Local Bridge
- validador: `sdu_dev_live_smoke_readback_validator.py`
- riesgo: envio Teams requiere app delegated auth o destino exacto con scopes
- rollback: revert commit, detener proceso local, no aplicar Cloud diff
- stop_condition: `CHAT_SCOPE_MISSING|APP_DEVICE_AUTH_REQUIRED|TARGET_CHAT_MISSING|SECRET_DETECTED`
- proximos_carriles: app delegated auth; single Teams DEV message; postcheck
