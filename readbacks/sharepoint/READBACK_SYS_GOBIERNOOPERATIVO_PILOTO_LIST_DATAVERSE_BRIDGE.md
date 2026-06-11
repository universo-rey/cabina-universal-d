# Readback: SYS Gobierno Operativo PILOTO List Bridge

## Status
SYS_GOBIERNOOPERATIVO_PILOTO_LIST_BRIDGE_RECONCILED

## What We Connected
- SharePoint live lists are now mapped to Dataverse entities using the real list names.
- The bridge was published into the site library folder:
  - `LIB_PuenteDocumental_SGIN/BRIDGE_DATAVERSE_SHAREPOINT`
- The live weekly-review list `WB_RevisionSemanal` is confirmed in SharePoint, but no exact Dataverse proxy row has been selected for it yet.

## List Mappings
- `WB_Decisiones` -> `sdu_reconciliation_item` `bridge_proxy`
- `SYS_EstadoOperativo` -> `sdu_matrix` `bridge_proxy`
- `WB_AprendizajesOperativos` -> `sdu_readback` `bridge_exact`
- `WB_CapacidadesOperativas` -> `sdu_capability` `bridge_exact`

## Why These Mappings
- `WB_Decisiones` is the live decision register and lands in the closest existing registry table.
- `SYS_EstadoOperativo` is the live operational-state matrix and lands in the closest existing matrix table.
- `WB_AprendizajesOperativos` matches the readback model closely.
- `WB_CapacidadesOperativas` matches the capability registry closely.

## Site Anchor
- Site: `SYS-GobiernoOperativo-PILOTO`
- Main operating base: `LIB_GobiernoSistemas`
- Bridge/documentation anchor: `LIB_PuenteDocumental_SGIN`

## Evidence Used
- `readbacks/sharepoint/READBACK_SYS_GOBIERNOOPERATIVO_PILOTO_OPERATIONAL_BASE.md`
- `matrices/sharepoint/SYS_GOBIERNOOPERATIVO_PILOTO_DATAVERSE_SHAREPOINT_BRIDGE.csv`
- `dataverse/schema/sdu_reconciliation_item.yml`
- `dataverse/schema/sdu_validation_gate.yml`

## Remaining Gap
- The mapping is reconciled, but the proxy rows still point to the closest existing Dataverse tables rather than dedicated decision/state tables.
- `WB_RevisionSemanal` remains a live SharePoint surface without a selected `mon_sdu_*` target, so the Dataverse apply path stays `PENDING_TARGET_ONLY` until a single exact row is chosen.
- If we later want an exact bridge for the proxy rows, that becomes a schema expansion step.

## Next Step
- If we want a stricter exact bridge, first select a single Dataverse DEV target row by exact canonical id; if the bridge needs dedicated tables, add them and then remap the proxy rows.
