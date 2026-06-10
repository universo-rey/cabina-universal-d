# Readback: Monitoreo diario de colas SDU en Dataverse

## Contexto
- Fecha: 2026-06-10
- Entorno: `https://org993e120d.crm2.dynamics.com`
- Ambiente: `ESCRIBANIA BITSCH (default)` (tenant `858a0852-44a1-413e-a0fe-f053949797d6`)
- Colas monitoreadas: filas con prefijo `SDU.`

## Resultado del snapshot (baseline)
- `queues`: 8
- `drift_queues`: 0
- `total_backlog_items`: 0
- `snapshot`: `2026-06-10T01:03:42.3814580-03:00`
- IDs de cola confirmadas en la consulta:
  - SDU.Matrix.Intake.Queue `573521e6-4964-f111-ab0d-002248df1063`
  - SDU.Connection.Seed.Queue `383721e6-4964-f111-ab0d-002248df1063`
  - SDU.Agent.Dispatch.Queue `3c3721e6-4964-f111-ab0d-002248df1063`
  - SDU.Gate.Review.Queue `403721e6-4964-f111-ab0d-002248df1063`
  - SDU.Evidence.Publish.Queue `443721e6-4964-f111-ab0d-002248df1063`
  - SDU.Dataverse.Apply.Queue `483721e6-4964-f111-ab0d-002248df1063`
  - SDU.Exception.Remediation.Queue `4c3721e6-4964-f111-ab0d-002248df1063`
  - SDU.Drift.Detection.Queue `503721e6-4964-f111-ab0d-002248df1063`

## Script operativo agregado
- Script: [dataverse/scripts/monitor-sdu-workqueue-daily.ps1](/C:/Users/enzo1/Documents/GitHub/cabina-universal-d/dataverse/scripts/monitor-sdu-workqueue-daily.ps1)
- Parámetros por defecto:
  - `ExpectedDefaultTtlMinutes=50`
  - `ExpectedRetryLimit=25`
  - `ExpectedRequeueLimit=25`
  - `ExpectedSlaThreshold=50`
  - `ExpectedPriorityType=0`
  - `SummaryOnly` (default: true en modo de prueba)
- Snapshot de referencia generado en:
  - `dataverse/scripts/monitoring/20260610_010342/sdu_workqueue_snapshot_summary_20260610_010342.json`

## Uso diario recomendado
- Monitoreo manual diario (texto):
  - `powershell -NoProfile -ExecutionPolicy Bypass -File dataverse/scripts/monitor-sdu-workqueue-daily.ps1`
- Monitoreo con salida JSON completa:
  - `powershell -NoProfile -ExecutionPolicy Bypass -File dataverse/scripts/monitor-sdu-workqueue-daily.ps1 -Json`
- Monitoreo con CSV por filas:
  - `powershell -NoProfile -ExecutionPolicy Bypass -File dataverse/scripts/monitor-sdu-workqueue-daily.ps1 -SummaryOnly:$false`

## Propuesta de scheduling (Windows Task Scheduler)
- Ejecutar como usuario administrador o usuario autorizado.
- Tarea diaria a las 07:00:
  - `schtasks /Create /TN "SDU-Workqueue-Daily-Monitor" /TR "powershell -NoProfile -ExecutionPolicy Bypass -File \"C:\\Users\\enzo1\\Documents\\GitHub\\cabina-universal-d\\dataverse\\scripts\\monitor-sdu-workqueue-daily.ps1\" -SummaryOnly -Json >> \"C:\\Users\\enzo1\\Documents\\GitHub\\cabina-universal-d\\dataverse\\scripts\\monitoring\\monitor.log\" 2>&1" /SC DAILY /ST 07:00 /RL LIMITED /F`

## Riesgos y pendientes
- Actualmente este script requiere sesión activa de Azure CLI para `az account get-access-token`.
- `backlog_total_items` hoy es 0 en todas las filas; esto no invalida operación si hay picos transaccionales durante el día.
- Pendiente: mover salida a almacenamiento central si necesitás histórico de tendencia >7 días.
