# SDU Teams First Internal Message Execution Gate 20260603

Estado: `FIRST_INTERNAL_MESSAGE_LIVE_GATE_RESOLVED_BLOCKED_BY_CHAT_SCOPE`

## Mandato Entendido

El operador autorizo live y luego cambio el destino preferido a `efigueroa`.
Para esta cabina, el destino se toma como `efigueroa@registronotarial8tdf.com.ar`
en el tenant Escribania, no como chats visibles de otro contexto.

## Identidad Y Tenant

- identidad Azure/Graph verificada: `efigueroa@registronotarial8tdf.com.ar`
- tenant: `858a0852...97d6`
- usuario destino exacto: `efigueroa@registronotarial8tdf.com.ar`
- usuario destino resuelto: `55016a48...245b`
- usuario Seshat tambien resuelto para opciones futuras: `23a58589...1659`

## App Existente

- app: `SDU-CN Seshat Teams Connector Pilot`
- appId saneado: `a3f03eac...e34f`
- service principal saneado: `3dc326f8...0e9f`
- estado: existente y habilitada
- tipo: public client single-tenant
- secretos creados: no
- scopes delegados declarados:
  - `User.Read`
  - `User.ReadBasic.All`
  - `Chat.Read`
  - `Chat.ReadWrite`
  - `ChatMessage.Send`
  - `Team.ReadBasic.All`
  - `Channel.ReadBasic.All`
  - `ChannelMessage.Send`

## Mensaje Aprobado Para La Prueba

`Seshat SDU Agent activo en modo DEV. Prueba controlada de identidad, ruteo y evidencia. No ejecutar acciones productivas.`

## Resultado De Resolucion

- Azure/Graph resolvio usuario Enzo Escribania exacto.
- Azure/Graph resolvio usuario Seshat exacto.
- Azure CLI actual no pudo listar chats porque le faltan `Chat.Read`, `Chat.ReadWrite` o `Chat.ReadBasic`.
- La solicitud de token Azure CLI con `Chat.ReadWrite` y `ChatMessage.Send`
  quedo bloqueada por preautorizacion/consentimiento requerido.
- El conector Teams generico visible expuso chats de otro contexto y no debe usarse para este envio Escribania.
- No se encontro `ChatId`, `TeamId` + `ChannelId` exacto para Escribania en esta pasada.
- CDF aporta candidatos funcionales y patron de `Collaboration-Notifier`, pero
  no un destino tecnico exacto para enviar.

## Decision

No se envio el mensaje en esta pasada.

La ruta viable siguiente es autenticar la app `SDU-CN Seshat Teams Connector Pilot`
por flujo delegated/device-code y enviar solo si devuelve un `ChatId` o canal
exacto, o si una orden separada autoriza crear chat con rollback y postcheck.

## Rollback

No hay mensaje para eliminar ni tenant mutation para revertir en esta pasada.
Si luego se envia, el rollback operativo sera registrar el `messageId`, no
repetir el envio y dejar la correccion o cierre del thread como accion humana.

## Postcheck

Antes de cualquier envio futuro:

- confirmar identidad de app y usuario;
- confirmar `ChatId` o `TeamId` + `ChannelId`;
- confirmar que el mensaje contiene solo texto DEV sintetico;
- registrar `messageId` o bloqueo exacto;
- verificar que no se creo secreto ni permiso nuevo.

## Stop Conditions

`CHAT_SCOPE_MISSING`, `APP_DEVICE_AUTH_REQUIRED`, `TARGET_CHAT_MISSING`,
`TENANT_CONTEXT_MISMATCH`, `PERMISSION_CHANGE_WITHOUT_ORDER`,
`PREAUTHORIZATION_OR_CONSENT_MISSING`,
`CDF_REFERENCE_WITHOUT_EXACT_DESTINATION`, `SECRET_DETECTED`,
`SECOND_MESSAGE_ATTEMPTED`.
