# Readback: matriz operativa completa del sitio

- Site: `SYS-GobiernoOperativo-PILOTO`
- Source live inventory: `Get-PnPList`
- Derived matrix: `matrices/sharepoint/SYS_GOBIERNOOPERATIVO_PILOTO_OPERATIONAL_SURFACE_MATRIX.csv`

## Resultado

- Inventario completo derivado: `107` superficies.
- Clasificación derivada:
  - `19` bibliotecas
  - `76` listas
  - `12` superficies sistema/other
- `SD_BacklogEstrategico` quedó con el backlog visible y la vista expone columnas operativas.

## Backlog visible

- `SD_BacklogEstrategico`: `11` items.
- Columnas visibles en la vista por defecto:
  - `LinkTitle`
  - `Backlog_ID`
  - `SD_Codigo`
  - `Estado`
  - `EjeEstrategico`
  - `Iniciativa`
  - `SD_Dominio`
  - `SD_Macroproceso`
  - `ResultadoEsperado`
  - `EvidenciaDocumentoBase`
- El orden operativo queda visible por los títulos numerados y `SD_Codigo`.

## Drift observado

- `WB_RevisionSemanal` aparece vivo con ese nombre sin guion bajo.
- Eso difiere del nombre modelado en confirmaciones previas y debe tratarse como drift nominal, no como ausencia funcional.

## Evidencia

- `Get-PnPList` exportado a inventario raw local.
- `Import-Csv` sobre la matriz derivada devolvió `107` filas.
- `Get-PnPListItem -List SD_BacklogEstrategico` devolvió `COUNT=11`.

## Nota

- La matriz derivada se usa como snapshot operativo local para listas y bibliotecas del sitio.
