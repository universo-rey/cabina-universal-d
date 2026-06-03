# SDU Teams App Bot DEV Activation Readback 20260603

Estado: `SDU_TEAMS_APP_BOT_DEV_LIVE_OPTIONS_RESOLVED`

## Que Se Verifico

- TGE contiene evidencia de ejecucion real previa para `Seshat Normativa`.
- El Copilot `Seshat Normativa` fue creado y enriquecido en TGE segun actas
  `ACTA_TGE_SDU_CN_COPILOT_SHELL_SESHAT_NORMATIVA_20260531.md` y
  `ACTA_TGE_SDU_CN_COPILOT_SESHAT_NORMATIVA_EN_US_DRAFT_TEXT_ENRICHMENT_20260531.md`.
- Entra contiene la app existente `SDU-CN Seshat Teams Connector Pilot`.
- La app esta habilitada como public client single-tenant.
- El service principal existe y esta habilitado.
- No se creo secreto en este carril.

## Evidencia Saneada

- appId: `a3f03eac...e34f`
- application object id: `3f285e5b...dbcd`
- service principal object id: `3dc326f8...0e9f`
- usuario Enzo Escribania: `55016a48...245b`
- usuario Seshat Escribania: `23a58589...1659`
- tenant Escribania: `858a0852...97d6`

## Scopes Declarados En La App

- `User.Read`
- `User.ReadBasic.All`
- `Chat.Read`
- `Chat.ReadWrite`
- `ChatMessage.Send`
- `Team.ReadBasic.All`
- `Channel.ReadBasic.All`
- `ChannelMessage.Send`

## No Ejecutado

- no se envio mensaje Teams;
- no se creo chat;
- no se creo canal;
- no se instalo Teams app;
- no se creo client secret;
- no se modificaron permisos;
- no se ejecuto produccion.

## Referencia CDF

Se reviso CDF como referencia de conexiones. Aporta dos pistas utiles:

- `CDF_SGSD_TC_SUFFICIENT_PERMISSION_MATRIX.csv` define el patron
  `SGSD-TC-Collaboration-Notifier` para Teams/Outlook con `ChannelMessage.Send`
  y `Chat.ReadWrite` bajo gate.
- `CDF_AREA_PROCESS_CHANNEL_MATRIX.csv` lista candidatos funcionales como
  `Escrituracion y Protocolo / General`.

No aporta `ChatId`, `TeamId` ni `ChannelId` exacto para Seshat/Enzo. Por eso
queda como `REFERENCE_PATTERN_ONLY`, no como autorizacion de envio.

## Decision

La app ya no debe tratarse como mero scaffold. Queda registrada como
`APP_EXISTS_ENABLED`, con envio pendiente de autenticacion delegated de la app
o de destino Teams exacto ya resuelto.

## Rollback

Si se ordena rollback futuro sobre la app, debe ser una orden separada de
permisos/Entra con owner, impacto, postcheck y evidencia. En esta pasada no
hay mutacion nueva que revertir.

## Proximo Gate

Autenticar la app `SDU-CN Seshat Teams Connector Pilot` por device-code o
resolver un chat/canal exacto en Escribania. Enviar una sola prueba DEV solo
si el destino queda probado y se registra `messageId`.
