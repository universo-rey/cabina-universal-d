# Teams Message Orchestration Recipe

Estado: `TEAMS_MESSAGE_ORCHESTRATION_PREPARED`
Frontera: arquitectura y DEV/STAGING; envio live requiere orden gobernada.

## Objetivo

Permitir comunicaciones Teams gobernadas sin bloquear el uso humano normal,
con evidencia, aprobacion y separacion entre humano, bot, Graph y adaptive
cards.

## Diagrama textual

```text
Humano / Codex / GitHub
  -> cola SharePoint o Dataverse
  -> Power Automate scheduled flow
  -> gate de destino y contenido
  -> Teams Connector o Graph gated
  -> evidencia SYS / SharePoint / Dataverse
  -> Planner si genera tarea
  -> readback
```

## Modalidad 1: respuesta humana asistida

- Humano sigue usando Teams normalmente.
- Codex o flow sugiere respuesta en borrador.
- Humano aprueba, edita y envia.
- Evidencia minima: origen, sugerencia, aprobador, decision, timestamp.
- Gate: no envio automatico.

## Modalidad 2: respuesta automatizada controlada

- Power Automate responde con bot/conector solo cuando hay orden.
- Destino exacto: equipo, canal, chat o usuario.
- Evidencia en SharePoint/SYS o Dataverse.
- Trazabilidad por ticket, expediente o item de cola.
- Rollback: pausar flow, cancelar item, publicar rectificacion si aplica.

## Modalidad 3: mensaje programado

Cola requerida en SharePoint o Dataverse:

| campo | descripcion |
| --- | --- |
| destinatario_tipo | `channel`, `chat`, `user`, `group` |
| destinatario_id | id externo o alias gobernado |
| cuerpo | contenido aprobado o referencia a plantilla |
| fecha_programada | fecha/hora de ejecucion |
| estado | draft, approved, scheduled, sent, failed, cancelled |
| evidencia | enlace a registro de evidencia |
| responsable | owner humano |
| origen | GitHub issue, Planner task, expediente o request |

El flow programado procesa solo items `approved` y `scheduled`; no bloquea
Teams humano.

## Modalidad 4: Microsoft Graph

- Usar solo cuando Teams Connector no alcance.
- Requiere app registration, permisos revisados y aprobacion humana.
- Permisos necesarios: `[POR DEFINIR]` hasta que exista app registrada y
  destino exacto.
- Stop condition: `graph_permission_gate_missing`.

## Modalidad 5: Adaptive Cards

- Usar para aprobaciones, derivaciones y confirmaciones.
- Registrar decision humana, payload aprobado y resultado.
- La card no debe contener secretos ni datos regulados amplios.

## Entradas

- Target exacto.
- Owner humano.
- Plantilla o cuerpo.
- Fecha y ventana de ejecucion.
- Rollback.
- Evidencia destino.

## Salidas

- Mensaje enviado o item cancelado.
- Evidencia de decision y postcheck.
- Planner task si corresponde.
- Readback de cierre.

## Prechecks

1. Confirmar tenant/superficie.
2. Confirmar que el destino no es produccion sin gate.
3. Confirmar que no hay secretos ni datos regulados amplios.
4. Confirmar estado de connection references.
5. Confirmar queue schema y owner.

## Ejecucion

1. Crear item de cola.
2. Aprobar item.
3. Ejecutar flow programado o manual DEV/STAGING.
4. Enviar via Teams Connector o Graph gated.
5. Registrar evidencia.

## Postchecks

- Item pasa a `sent` o `failed`.
- Evidencia contiene timestamp, destino, owner y resultado.
- Planner refleja tarea si corresponde.
- No quedan mensajes pendientes sin owner.

## Riesgos

- Mensaje al destino incorrecto.
- Permisos Graph sobredimensionados.
- Flow duplicado por retry.
- Evidencia incompleta.
- Contenido sensible en mensaje o card.

## Gates

- `GATE_TEAMS_MESSAGE_TARGET_EXACT`
- `GATE_GRAPH_PERMISSION_REVIEW`
- `GATE_SHAREPOINT_SYS_EVIDENCE_WRITE`
- `GATE_PRODUCTION_HUMAN_APPROVAL`

## Criterio de cierre

`TEAMS_MESSAGE_ORCHESTRATION_READY_FOR_DEV_STAGING` con cola, flow o workflow
preparado, evidencia definida y live write no ejecutado sin gate.
