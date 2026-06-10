# Readback: Rotación de logs del monitor diario SDU

## Contexto
- Fecha: 2026-06-10
- Objetivo: limitar acumulación de logs del monitor SDU para ejecución diaria.
- Tareas involucradas:
  - `SDU-Workqueue-Daily-Monitor`
  - `dataverse/scripts/run-sdu-workqueue-monitor.ps1`

## Cambios aplicados
- Se actualizó `dataverse/scripts/run-sdu-workqueue-monitor.ps1` con política de retención antes de cada ejecución:
  - `MaxLogSizeMB` (default `5`): si `monitor.log` supera este tamaño, se rota a `monitor.log.<timestamp>`.
  - `MaxRetainedFiles` (default `14`): mantiene máximo N archivos de rotación (`monitor.log.<timestamp>`).
  - Se asegura creación de carpeta `dataverse/monitoring` si no existe.
  - En error, se deja fallback de traza en `monitor.log` y se re-lanza la excepción.

## Validación
- Ejecución de prueba del wrapper:
  - `powershell -NoProfile -ExecutionPolicy Bypass -File dataverse/scripts/run-sdu-workqueue-monitor.ps1 -MaxLogSizeMB 1 -MaxRetainedFiles 5`
- Resultado: ejecución correcta, `monitor.log` regenerado/actualizado y sin errores.

## Configuración operacional recomendada
- Mantener tarea diaria existente apuntando al wrapper:
  - `powershell -NoProfile -ExecutionPolicy Bypass -File "...\\dataverse\\scripts\\run-sdu-workqueue-monitor.ps1"`
- Ajustar retención si hace falta en la tarea con parámetros:
  - `-MaxLogSizeMB 5 -MaxRetainedFiles 14` (valores por defecto).

## Rollback
- Reemplazar script por versión anterior (sin retención) o cambiar parámetros de retención a valores altos para desactivar rotación efectiva.
