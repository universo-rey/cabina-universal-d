# Power Automate Teams Compatibility Matrix

Estado: `POWER_AUTOMATE_TEAMS_COMPATIBILITY_READY`
Fecha: 2026-06-03

| componente | responde mensajes | programa mensajes | publica en canales | chats 1:1 | requiere Graph | connector estandar alcanza | debe vivir en Solution | versionable | configuracion manual | automatizable desde GitHub | gate humano |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Teams Connector | si, como bot/flow controlado | si, con trigger programado | si | limitado | no por defecto | si para escenarios simples | si, si el flow es solution-aware | si, si esta en Solution | connection reference | export/unpack/pack/import | aprobacion de contenido y destino |
| Microsoft Graph | si | si | si | si, si permisos lo habilitan | si | no | no necesariamente, pero app/flow puede referenciarlo | parcial | app registration y permisos | no sin gate de app/permiso | obligatorio |
| Power Automate cloud flows | si | si | si | limitado por connector/Graph | depende | si para canales y aprobaciones | si | si | connection references y env vars | si via ALM | para writes y mensajes |
| Power Automate desktop flows | no recomendado | no recomendado | no | no | no | no | puede referenciarse | limitado | maquina/runner | no para Teams ALM | obligatorio si se usa |
| Solution-aware flows | si | si | si | depende | depende | si | si | si | connections/env vars | si | import/publish DEV/STAGING |
| Canvas apps | asistencia humana | programacion indirecta | no directo | no directo | no | no directo | si | si | connectors | si | publicacion |
| Model-driven apps | aprobacion/operacion | cola indirecta | no directo | no directo | no | no directo | si | si | Dataverse | si | cambios de app |
| Dataverse | cola y evidencia | si | no directo | no directo | no | no | si | si | tabla, seguridad, variables | si | writes de datos |
| SharePoint Lists | cola y evidencia | si | no directo | no directo | no | si con connector | no obligatorio | esquema versionable por docs | sitio/lista exactos | parcial | writes de lista |
| Planner | organiza trabajo | recordatorios indirectos | no directo | no directo | Graph puede ser necesario | con connector para basico | no | docs/matrices | plan/bucket exactos | parcial | cambios de tareas |
| Adaptive Cards | respuesta/aprobacion | si con flow | si | si, segun canal | no siempre | si para aprobaciones | parte de flow | si como JSON/spec | schema y destino | si | decision humana |
| GitHub Actions | no | agenda ALM, no mensajes | no | no | no | no | no | si | secrets/vars | si | workflow_dispatch |
| PAC CLI | no | no | no | no | no | no | no | scripts versionables | auth profile/env | si en runner/local | tenant target |
| Power Platform Actions | no | no | no | no | no | no | no | workflows versionables | secrets/inputs | si | workflow_dispatch |
| Service principal | no | no | no | no | no | no | no | referencia no secreta | app id/tenant/secret externo | si | creacion/permisos |
| GitHub Secrets | no | no | no | no | no | no | no | no se versiona | repo settings | usado por workflows | alta/rotacion |
| Environment variables | parametriza destinos | parametriza fechas/colas | parametriza canal | parametriza chat | depende | si | si para Power Platform | si | valores por environment | si | cambio de valores live |
| Connection references | habilita flows | habilita flows | si | si | depende | si | si | si | binding por ambiente | si con deployment settings | binding DEV/STAGING |
| Manual approval gates | controla envio | controla programacion | controla publicacion | controla chat | no | si | no | docs/policy | aprobadores | GitHub environment/manual input | obligatorio para produccion |
| Evidence logging | registra resultado | registra cola/proceso | registra post | registra post | no | SharePoint/Dataverse | puede estar en Solution | si | destino exacto | parcial | writes de evidencia |

## Lectura operativa

- Para responder mensajes sin bloquear Teams humano: usar respuesta asistida
  o flow controlado con aprobacion.
- Para programar mensajes: usar cola SharePoint/Dataverse y flow programado.
- Para canales: Teams Connector suele alcanzar en DEV/STAGING.
- Para chats 1:1: Graph puede ser necesario; queda `order_required`.
- Para versionar: flows deben ser solution-aware y usar connection references
  y environment variables.
- Para automatizar desde GitHub: usar Power Platform Actions y PAC CLI con
  service principal, nunca con secretos hardcodeados.
- Para produccion: otro workflow protegido con aprobacion humana, no creado
  ni ejecutado en este carril.
