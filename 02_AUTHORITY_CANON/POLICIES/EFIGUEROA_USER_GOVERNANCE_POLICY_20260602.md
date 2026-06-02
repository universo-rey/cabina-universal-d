# User Governance Policy - efigueroa

Estado: `EFIGUEROA_USER_GOVERNANCE_LOCAL_PREP_ACTIVE`.

Sujeto gobernado: `efigueroa@registronotarial8tdf.com.ar`.

Fuente rectora: `D:\AGENTS.md` y
`D:\02_AUTHORITY_CANON\POLICIES\GLOBAL_MICROSOFT_LIVE_PRODUCTION_POLICY_20260601.md`.

Esta politica prepara gobierno local para una identidad de usuario Microsoft
asociada al dominio `registronotarial8tdf.com.ar`. El dominio se enruta al
universo `ESCRIBANIA` para preparacion local, pero no se confirma existencia,
rol, licencia, estado, permisos, membresias ni actividad en tenant sin una
orden Microsoft live completa.

## Permitido sin nueva orden

- Registrar la identidad como sujeto gobernado local.
- Preparar matriz de superficies, orden gobernada, readback y validator.
- Definir agentes, skills, recipes, tools, plugins, evidencia y stop condition.
- Preparar campos de evidencia saneada para una futura lectura read-only.

## Requiere orden gobernada explicita

- Verificar existencia del usuario en Entra ID o Microsoft Graph.
- Leer perfil, licencias, MFA, grupos, roles, equipos, sitios, mailbox,
  calendario, OneDrive, actividad, dispositivos o auditoria.
- Cambiar clave, MFA, cuenta habilitada, licencias, grupos, roles, permisos,
  mailbox, Teams, SharePoint, Planner, Outlook, dispositivos o politicas.
- Usar Microsoft Graph, Teams, SharePoint, Outlook, Entra, Planner, Power
  Platform o tenant con credenciales reales.

## Produccion

Produccion queda cerrada salvo autorizacion humana explicita y separada para la
accion concreta. Gobernar esta identidad no autoriza cambios de cuenta,
permisos, licencias ni acceso productivo.

## Evidencia

La evidencia repo-visible debe ser saneada: UPN, dominio, universo, superficie,
alcance solicitado, owner, validator, resultado, riesgos y stop condition. No se
versionan secretos, tokens, cuerpos de mensajes, adjuntos, contenidos de
mailbox, archivos, datos personales amplios ni dumps de permisos.

## Agentes

- `universe.escribania_tower`: owner de universo para esta identidad.
- `rey.frontier_guardian`: frontera Microsoft live, permisos y produccion.
- `court.sdu_gate`: gate y coherencia de orden.
- `court.seshat_evidence`: evidencia saneada y readback.
- `court.thot_schema`: matriz y validador.
- `tech.reference_librarian`: referencia tecnica Microsoft sin canonizarla.

## Rollback

Revertir los artefactos locales de politica, matriz, orden, readback, validator
e indices. No hay estado externo que revertir porque esta preparacion no toca
Microsoft live.

## Stop condition

Detener ante `microsoft_live_requested_without_governed_order`,
`production_requested_without_explicit_authorization`,
`regulated_data_boundary_unclear`, `secret_detected`,
`order_packet_missing_required_fields`, `tool_without_surface_boundary` o
`operational_chain_missing`.
