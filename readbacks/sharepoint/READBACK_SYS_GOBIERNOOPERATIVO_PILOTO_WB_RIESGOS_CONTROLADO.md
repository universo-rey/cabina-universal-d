# Readback: SYS Gobierno Operativo PILOTO WB Riesgos Controlado

## Status
WB_RIESGOS_13_14_UPDATED_TO_CONTROLADO

## Live Surface Used
- Site: `https://escribaniabitsch.sharepoint.com/sites/SYS-GobiernoOperativo-PILOTO`
- List: `WB_Riesgos`
- List ID: `2e94eb3b-3ac7-47f9-a3d1-016c774ffb28`
- Connection path: `PnP.PowerShell` token cache with `Connect-PnPOnline -Interactive`

## Item Updates
- Item 13: `eb_sharedsharepointonline_dc0c4 usada por CORE_EjecutarComando` -> `Controlado`
- Item 14: `eb_sharedcommondataserviceforapps_aae4d usada por CORE_EjecutarComando y CORE_ProcesarEventoCanonico` -> `Controlado`

## Validation
- `Get-PnPListItem` readback confirmed both items now show `EstadoRiesgo = Controlado`.

## Dataverse Prerequisite
- The two legacy `eb_*` solution components were removed from `SGIN_FlujosCanonicos`.
- Post-removal export/settings verification returned no `eb_*` matches.

## Next Step
- If needed, reconcile this live list closure into the bridge matrix or the acta draft.
