# Readback: SYS Gobierno Operativo PILOTO Live List Confirmation

## Status
SYS_GOBIERNOOPERATIVO_PILOTO_LIST_LIVE_CONFIRMATION_READY

## Live Surface Used
- Browser automation over a cloned Edge profile
- Engine: `playwright-core`
- Purpose: confirm real SharePoint list presence or absence, not just document-library visibility

## List Presence Results
- `OPS_Tickets`: absent
- `WB_RevisionSemanal`: present
- `WB_Decisiones`: present
- `CMP_Controles`: absent
- `SYS_EstadoOperativo`: present
- `WB_AprendizajesOperativos`: present
- `WB_CapacidadesOperativas`: present

## What We Confirmed
- The earlier modeled list names `OPS_Tickets` and `CMP_Controles` are retired aliases and are not live list URLs in this site.
- The weekly review surface exists under the actual live name `WB_RevisionSemanal`; the underscore form `WB_Revision_Semanal` is stale.
- The site does have live SharePoint lists, but under the actual names:
  - `WB_Decisiones`
  - `WB_RevisionSemanal`
  - `SYS_EstadoOperativo`
  - `WB_AprendizajesOperativos`
  - `WB_CapacidadesOperativas`

## WB_Decisiones Detail
- This list opens as a real modern SharePoint list page.
- Visible columns include:
  - `TituloDecision`
  - `FechaDecision`
  - `Frente`
  - `TipoDecision`
  - `EstadoDecision`
  - `Responsable`
  - `Motivo`
  - `Alcance`
  - `RiesgoCerrado`
  - `RiesgoPendiente`
  - `DocumentoRelacionado`
  - `Observaciones`

## Why This Matters
- The site already has a live decision/governance surface.
- The modeled minimum list set needs renaming or translation before we treat it as physically present.
- The bridge should use the live list names above as the actual SharePoint targets.

## Evidence
- `matrices/sharepoint/SYS_GOBIERNOOPERATIVO_PILOTO_LIST_LIVE_CONFIRMATION.csv`
- Browser session against cloned Edge profile
- 404 results on direct URLs for `OPS_Tickets`, `WB_Revision_Semanal`, and `CMP_Controles`; the live weekly-review URL resolves as `WB_RevisionSemanal`

## Next Step
- Reconcile the modeled Dataverse bridge against the actual live list names, then update the site map and bridge matrix so the names line up one-to-one.
