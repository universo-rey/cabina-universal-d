# Readback: SD_BacklogEstrategico poblado

- Site: `SYS-GobiernoOperativo-PILOTO`
- List: `SD_BacklogEstrategico`
- Source local: `matrices/sharepoint/SYS_GOBIERNOOPERATIVO_PILOTO_BACKLOG_PRIORIZADO_POR_LISTA.csv`
- Live write gate: `GATE_MICROSOFT_LIVE_WRITE`
- Outcome: `DELTA_APLICADO`

## Resultado

- Estado previo: `0` items.
- Estado posterior: `11` items.
- Escritura realizada con los 11 registros del backlog local priorizado por lista.
- `VSI` quedó fuera del carril activo.

## Verificación

- Conteo live posterior: `11`
- Primeros ítems verificados:
  - `Id=1` `Title=01 P0 WB_Decisiones 1-7`
  - `Id=2` `Title=02 P0 WB_Decisiones 8-9`
  - `Id=3` `Title=03 P0 WB_Decisiones 10-12`

## Rollback

- Borrar los elementos `Id=1` a `Id=11` de `SD_BacklogEstrategico` en orden inverso si hace falta revertir la carga.

## Evidencia

- `Add-PnPListItem` devolvió IDs `1` a `11`.
- `Get-PnPListItem -List SD_BacklogEstrategico` devolvió `COUNT=11`.
