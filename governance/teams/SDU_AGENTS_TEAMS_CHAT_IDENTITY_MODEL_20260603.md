# SDU Agents Teams Chat Identity Model 20260603

## Identidad

`sdu-agent-chat` es una identidad conversacional DEV para Microsoft Teams. Es
una puerta de entrada hacia la cadena SDU existente y no es un agente nuevo.

## Cadena que atiende

- Intake: `sdu-triage-agent`.
- Gate: `court.sdu_gate`.
- Evidencia: `court.seshat_evidence`.
- Orquestacion: `rey.control_plane_orchestrator`.

## Frontera DEV

- Manifest template versionado.
- Bot skeleton local.
- Simulacion de actividad Teams con fixture.
- Ninguna app se instala.
- Ningun mensaje real se envia.
- Ningun permiso Graph se solicita como ejecucion live.
- Ningun dato regulado o material sensible se versiona.

## Aprobacion requerida para live

Una futura accion live debe declarar identidad, tenant/equipo/canal exacto,
accion, limite de datos, rollback, postcheck, evidencia y stop condition.

## Estado

`SDU_TEAMS_CHAT_IDENTITY_MODEL_DEV_READY`
