# Readback: backlog convertido a secuencia de ejecucion por lista

- Source backlog: `matrices/sharepoint/SYS_GOBIERNOOPERATIVO_PILOTO_BACKLOG_PRIORIZADO_POR_LISTA.csv`
- Derived sequence: `matrices/sharepoint/SYS_GOBIERNOOPERATIVO_PILOTO_SECUENCIA_EJECUCION_PRIORIZADA_POR_LISTA.csv`
- Scope: local only
- VSI: excluded from active sequence

## Resultado

- Se conservan los 11 items del backlog.
- La secuencia queda agrupada por `list_batch_order`:
  - `1`: `WB_Decisiones`
  - `2`: `SYS_EstadoOperativo`
  - `3`: `WB_Riesgos`
  - `4`: `WB_AprendizajesOperativos`
  - `5`: `WB_CapacidadesOperativas`

## Criterio

- Prioridad operativa de lista: `P0` -> `P1` -> `P2` -> `P3` -> `P4`
- Orden interno: se conserva el orden de backlog origen por `source_backlog_order`

## Evidencia esperada

- El CSV derivado debe importar 11 filas.
- Ninguna fila debe contener `VSI`.
