# Teams Governance Readback

Fecha: 2026-06-02

Estado: `TEAMS_GOVERNANCE_LOCAL_PREPARED_NO_LIVE_EXECUTION`.

## Alcance

Se preparo gobierno local para Microsoft Teams como superficie Microsoft live.
No se leyo Teams live, no se envio mensaje, no se modifico Planner, Outlook,
SharePoint, Graph, permisos, conectores ni produccion.

## Cadena

- agente: `rey.frontier_guardian`
- orden: `ORDER_TEAMS_GOVERNANCE_LIVE_READ_DRAFT_20260602`
- superficie: `Microsoft Teams live governed`
- skill: `teams:teams`; `teams:teams-channel-summarization`; `teams:teams-messages`; `teams:teams-notification-triage`; `teams:teams-planner-task-management`
- receta: `recipe.governed_order_preparation`; `recipe.gate_decision_packet`; `recipe.evidence_acta_closeout`
- tool: `tool.local_validate_teams_governance`; `tool.local_validate_order_packets`; `tool.boundary_check`; `tool.readback_builder`
- evidencia: politica Teams, matriz de superficies, matriz de capacidades, orden draft y este readback
- validador: `D:\.agents\codex\tools\local_validate_teams_governance.ps1`
- stop_condition: `microsoft_live_requested_without_governed_order`

## Agentes asignados

- `rey.frontier_guardian`: frontera Teams live, permisos, produccion y datos.
- `court.sdu_gate`: gate y orden gobernada.
- `court.seshat_evidence`: evidencia saneada y readbacks.
- `court.thot_schema`: matrices, schema y validador.
- `universe.escribania_tower`: Teams de Escribania/TGE.
- `universe.modo_on_tower`: Teams de Modo ON/CDF/Jara.
- `tech.reference_librarian`: referencias tecnicas y disponibilidad de plugin.

## Riesgo

Teams puede cruzar mensajes personales, datos regulados, archivos SharePoint,
Planner, Outlook, miembros, owners, invitados, apps, conectores y Microsoft
Graph. Por eso el estado queda local-preparado y detenido antes de live.

## Rollback

Revertir los artefactos locales creados para esta preparacion. No hay rollback
externo porque no hubo accion live.

## Proximos carriles

- `teams-live-read-order`: completar tenant, identidad, owner, superficie y
  ventana seleccionada para lectura read-only.
- `teams-evidence-sanitization`: definir campos permitidos de evidencia por
  chats, canales, Planner y reuniones.
- `teams-escribania-surface-map`: mapear Teams de Escribania/TGE sin abrir live.
- `teams-modo-on-surface-map`: mapear Teams de Modo ON/CDF/Jara sin abrir live.
- `teams-connector-gap`: confirmar si el conector Teams disponible alcanza o si
  Graph directo queda `NO_DISPONIBLE` hasta nueva orden.
