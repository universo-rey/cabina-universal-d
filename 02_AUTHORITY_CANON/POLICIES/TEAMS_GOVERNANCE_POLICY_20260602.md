# Teams Governance Policy

Estado: `TEAMS_GOVERNANCE_LOCAL_PREP_ACTIVE`.

Fuente rectora: `D:\AGENTS.md` y
`D:\02_AUTHORITY_CANON\POLICIES\GLOBAL_MICROSOFT_LIVE_PRODUCTION_POLICY_20260601.md`.

Teams queda gobernado como superficie Microsoft live. Esta politica prepara
gobierno local, matrices, ordenes y evidencia saneada. No autoriza lectura live,
escritura live, permisos, conectores, bots, webhooks, Graph, Planner, Outlook,
SharePoint ni produccion.

## Superficies Teams

- Chat 1:1 y grupal.
- Canales y mensajes de canal.
- Teams, canales, tabs y configuracion visible.
- Membresias, owners, invitados y permisos.
- Apps, bots, conectores y webhooks.
- Archivos y tabs conectados a SharePoint.
- Planner y tareas vinculadas a Teams.
- Reuniones, calendario y contexto Outlook vinculado.
- Notificaciones, menciones y actividad.
- Microsoft Graph como ruta tecnica cuando el conector directo no alcanza.

## Permitido sin nueva orden

- Preparar politica local, matrices, readbacks y ordenes gobernadas.
- Clasificar superficies Teams por universo, owner, agente y riesgo.
- Preparar prompts, recetas, papeles de trabajo y evidencia saneada.
- Preparar drafts de acciones, mensajes o inventarios sin enviarlos ni leer
  datos live.

## Requiere orden gobernada explicita

- Leer Teams live, incluso si es read-only, cuando incluya mensajes, canales,
  miembros, archivos, Planner, reuniones, Graph o tenant.
- Enviar mensajes, responder, crear canales, crear Teams, instalar apps,
  crear webhooks, cambiar tabs, modificar Planner o tocar Outlook.
- Cambiar miembros, owners, invitados, permisos, politicas, conectores,
  identidades o configuracion tenant.
- Copiar contenido regulado, historial amplio, adjuntos o cuerpos completos de
  mensajes a repo, prompt, log o readback.

## Produccion

Produccion queda cerrada salvo autorizacion humana explicita y separada para la
superficie concreta. Una orden de lectura Teams no habilita escritura ni
produccion.

## Evidencia

La evidencia repo-visible debe ser saneada: alcance, fecha, superficie, ids
publicables, conteos, rutas logicas, resultado de validador, riesgos y stop
condition. No se versionan secretos, cuerpos de mensajes, adjuntos regulados ni
datos personales amplios.

## Agentes

- `rey.frontier_guardian`: clasifica frontera live, permisos, produccion y datos.
- `court.sdu_gate`: revisa orden, gate, identidad, owner y stop condition.
- `court.seshat_evidence`: registra evidencia saneada y readback.
- `court.thot_schema`: mantiene matrices, campos y validador.
- `universe.escribania_tower`: gobierna Teams del universo Escribania/TGE.
- `universe.modo_on_tower`: gobierna Teams de Modo ON/CDF/Jara.
- `tech.reference_librarian`: separa referencia tecnica Microsoft de canon.

## Rollback

Para esta preparacion local, rollback es revertir los archivos versionados de
politica, matrices, orden y readback. No hay estado externo que revertir porque
no se ejecuta Teams live.

## Stop condition

Detener ante `microsoft_live_requested_without_governed_order`,
`production_requested_without_explicit_authorization`,
`regulated_data_boundary_unclear`, `secret_detected`,
`order_packet_missing_required_fields`, `tool_without_surface_boundary` o
`operational_chain_missing`.
