# Power Automate GitHub Scouting

Fecha: 2026-06-03
Estado: `SCOUTING_CLASSIFIED_NO_CODE_ADOPTION`
Regla: no adoptar codigo externo automaticamente; extraer patrones.

## Repos evaluados

| repo | owner | purpose | stars | updated_at | source_type | reusable_pattern | adoption_recommendation | risk | status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| microsoft/PowerPlatformConnectors | microsoft | Conectores para Power Automate, Power Apps y Azure Logic Apps | 1259 | 2026-06-03T03:14:55Z | Microsoft repo | custom connectors, governance de conectores | usar como referencia primaria para conectores; no copiar conectores sin revision | medium | active |
| pnp/powerplatform-samples | pnp | Galeria de samples Power Platform | 417 | 2026-06-03T14:07:40Z | PnP sample | patrones de apps/flows y packaging | extraer ideas de solution-aware samples; no canonizar | medium | active |
| pnp/powerautomate-samples | pnp | Samples curados de Power Automate | 344 | 2026-06-01T07:36:30Z | PnP sample | flows reutilizables y patrones de aprobacion | revisar patrones de approvals/adaptive cards antes de construir flows SGIN | medium | active |
| pnp/powerplatform-snippets | pnp | Snippets de Power Platform | 223 | 2026-05-26T12:43:46Z | PnP snippet | fragmentos Power Apps/Automate/Desktop/Pages | usar solo como referencia puntual, no como dependency | medium | active |
| pnp/provision-assist-m365 | pnp | Provisioning solution para Teams, Groups, SPO Sites y Viva Engage | 116 | 2026-05-28T03:01:40Z | PnP solution | request/provision/approval model para Teams | adoptar patron de solicitud + aprobacion + evidencia para Teams governance | medium | active |
| OfficeDev/microsoft-teams-apps-requestateam | OfficeDev | Power Platform app para request-a-team | 238 | 2026-05-12T06:35:10Z | legacy Microsoft sample | solicitud de Teams con Power Platform | no adoptar; usar solo como referencia historica porque el repo indica no mantenido y recomienda Provision Assist | high | superseded |

## Clasificacion por jerarquia

- Canon tecnico: Microsoft Learn y `microsoft/powerplatform-actions`.
- Patrones reutilizables: Microsoft/PnP repos activos.
- Scouting no canon: GitHub topic `powerautomate`.
- [INFERENCIA] Para SGIN conviene priorizar ALM de soluciones y colas
  gobernadas antes que copiar samples de flows.

## Patrones recomendados para SGIN

1. Solution-aware flows con connection references y environment variables.
2. Request/approval/evidence loop para cualquier automatizacion Teams.
3. Cola SharePoint/Dataverse para mensajes programados.
4. Power Platform Actions para export/unpack/pack/check/import DEV/STAGING.
5. Graph solo como extension gated cuando Teams Connector no alcance.

## No adoptado

No se copio codigo externo. No se agregaron dependencias externas. No se
crearon conexiones live.
