# SHAREPOINT_ESCRITURACION_DEFINITION_20260613

agente: Codex
orden: dejar_definida_surface_escrituracion
repo: universo-rey/cabina-universal-d
workspace: C:\Users\enzo1\Documents\GitHub\cabina-universal-d
estado: DEFINICION_OPERATIVA_BASELINE

## Sitio

- `https://escribaniabitsch.sharepoint.com/sites/escrituracion`

## Lista Exacta

- `native-list`: no confirmada en esta sesion.
- `surface exacta disponible`: `file-export` / workbook vivo `Escrituraciones.xlsx`.
- ubicación: biblioteca `Documentos compartidos`.

## Columnas

- `Id. de tarea`
- `Nombre de la tarea`
- `Nombre del depósito`
- `Progreso`
- `Priority`
- `Asignado a`
- `Creado por`
- `Fecha de creación`
- `Fecha de inicio`
- `Fecha de vencimiento`
- `Es periódica`
- `Con retraso`
- `Fecha de finalización`
- `Completado por`
- `Elementos de la lista de comprobación completados`
- `Elementos de la lista de comprobación`
- `Etiquetas`
- `Descripción`
- `ID Conversación`

## Fuente De Datos

- Confirmada: el workbook `Escrituraciones.xlsx` funciona como cola operativa
  viva dentro del sitio.
- Inferida, no confirmada: carga manual o semimanual desde la operación de
  escrituración, con trazabilidad por `ID Conversación`.

## Regla De Actualización O Alta

- Regla base de alta: una tarea nueva entra como nueva fila cuando no existe
  `Id. de tarea` previo.
- Regla base de actualización: si ya existe `Id. de tarea`, se actualiza la
  misma fila y se preserva la trazabilidad del caso.
- Regla de control: no sobrescribir filas cerradas sin registrar el cambio en
  la descripción o en la evidencia asociada.
- Regla de migración: si más adelante aparece una lista nativa real, esta
  definición se reconcilia contra esa lista antes de habilitar writes.

## Estado Real

- No se confirmó una lista nativa accesible con este conector.
- No se ejecutaron writes.
- El baseline queda preparado para usar el workbook como surface viva hasta
  que aparezca la lista exacta.

## Stop Condition

`native-list-read-unavailable`
