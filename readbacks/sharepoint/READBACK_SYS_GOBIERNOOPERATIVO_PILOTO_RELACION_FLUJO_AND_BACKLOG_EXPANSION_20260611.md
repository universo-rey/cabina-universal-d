# Readback: relación-flujo completa y expansión del backlog vivo

## Status
`RELACION_FLUJO_MATRIX_AND_SD_BACKLOGESTRATEGICO_EXPANDED`

## Site vivo
- Site: `https://escribaniabitsch.sharepoint.com/sites/SYS-GobiernoOperativo-PILOTO`
- Conector usado: `PnP.PowerShell` con `Connect-PnPOnline -Interactive`

## Matriz derivada
- Archivo: `matrices/sharepoint/SYS_GOBIERNOOPERATIVO_PILOTO_RELACION_FLUJO_MATRIX.csv`
- Filas: `107`
- Fuente base: `SYS_GOBIERNOOPERATIVO_PILOTO_OPERATIONAL_SURFACE_MATRIX.csv`
- Fuente de rol/acción: `SYS_GOBIERNOOPERATIVO_PILOTO_OTRAS_CABINAS_INDEX.csv`

## Backlog vivo
- Lista: `SD_BacklogEstrategico`
- Conteo final: `95` items
- Muestra confirmada:
  - `01 P0 LIB_GobiernoSistemas`
  - `02 P0 SD_BacklogEstrategico`
  - `03 P0 WB_Decisiones`
  - `94 P3 DO_NOT_DELETE_SPLIST_SITECOLLECTION_AGGREGATED_CONTENTTYPES`
  - `95 P3 TaxonomyHiddenList`

## Expansión aplicada
- Se respaldó el estado previo a la expansión en:
  - `matrices/sharepoint/SD_BACKLOGESTRATEGICO_PRE_EXPANSION_20260611.csv`
- Se respaldaron los duplicados erróneos de títulos sin cero inicial en:
  - `matrices/sharepoint/SD_BACKLOGESTRATEGICO_ERRONEOUS_SINGLE_DIGIT_BACKUP_20260611.csv`
- Se corrigió el drift eliminando `9` ítems duplicados:
  - IDs `13` a `21`
- El backlog quedó con las `95` superficies priorizadas esperadas.

## Validación
- `Import-Csv` sobre la matriz relación-flujo devolvió `107` filas.
- `Get-PnPListItem -List SD_BacklogEstrategico` devolvió `95` ítems.
- `git diff --check` solo mostró el warning conocido de `.gitignore` con LF/CRLF.

## Observación
- Hubo un intento inicial de escritura con títulos sin cero inicial para `1` a `9`; se detectó, se respaldó y se retiró antes de cerrar.
- Las superficies `01` a `95` visibles quedaron intactas y el backlog quedó alineado con la priorización operativa.
