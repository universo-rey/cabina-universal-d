# Readback: prioridad bajada al backlog visible

- Site: `SYS-GobiernoOperativo-PILOTO`
- List: `SD_BacklogEstrategico`
- Goal: lower the derived priority lane into the visible operational backlog
- Source priority matrix: `matrices/sharepoint/SYS_GOBIERNOOPERATIVO_PILOTO_PRIORIZACION_EJECUCION_LISTAS_BIBLIOTECAS.csv`
- Migration map: `matrices/sharepoint/SD_BACKLOGESTRATEGICO_PRIORITY_LANE_MIGRATION_MAP.csv`
- Pre-migration backup: `matrices/sharepoint/SD_BACKLOGESTRATEGICO_PRE_PRIORITY_BACKUP_20260611.csv`

## Result

- Live item count remained `11`.
- The visible backlog now follows the derived operational priority lane.
- `VSI` is not part of the active lane.

## Visible top lane

- `01 P0 LIB_GobiernoSistemas`
- `02 P0 SD_BacklogEstrategico`
- `03 P0 WB_Decisiones`
- `04 P0 SYS_EstadoOperativo`
- `05 P1 WB_Riesgos`
- `06 P1 WB_AprendizajesOperativos`
- `07 P1 WB_CapacidadesOperativas`
- `08 P1 LIB_Runbooks`
- `09 P1 LIB_DiccionarioCanonico`
- `10 P1 LIB_AgentPrompts`
- `11 P1 LIB_EvidenciaTecnica`

## Field pattern applied

- `EjeEstrategico` = live surface name
- `Iniciativa` = cabina role
- `SD_Dominio` = priority band
- `SD_Macroproceso` = item count or summary count
- `ResultadoEsperado` = reuse action by band
- `Dependencias` = source order plus canonical evidence ref

## Rollback

- Restore rows from `SD_BACKLOGESTRATEGICO_PRE_PRIORITY_BACKUP_20260611.csv` back into `SD_BacklogEstrategico` by `Id`.
- This reverses the live prioritization without deleting items.

## Evidence

- `Get-PnPListItem -List SD_BacklogEstrategico` returned `COUNT=11`.
- First rows now reflect the `P0`/`P1` priority sequence.
