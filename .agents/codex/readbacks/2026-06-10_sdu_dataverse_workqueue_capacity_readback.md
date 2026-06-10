# Readback: Ajuste de capacidad y prioridades de colas de trabajo SDU en Dataverse

## Identidad operativa
- **Fecha/hora:** 2026-06-10
- **Usuario:** enzo1
- **Entorno Dataverse:** `Default-858a0852-44a1-413e-a0fe-f053949797d6`
- **Tenant:** `858a0852-44a1-413e-a0fe-f053949797d6`
- **Agente objetivo:** SDU / Flujos de trabajo (`workqueue`)
- **Estado:** Ejecutado con aprobación explícita del operador.

## Evidencia de ejecución
- Se realizó preflight del repo y contexto Git:
  - root: `C:/Users/enzo1/Documents/GitHub/cabina-universal-d`
  - branch: `main`
  - head: `640071e`
  - remotos: `origin -> https://github.com/universo-rey/cabina-universal-d.git`
  - core.worktree: `C:/Users/enzo1/Documents/GitHub/cabina-universal-d`
- Se inspeccionó metadata de Dataverse y tabla `workqueue` para confirmar campos disponibles:
  - `defaultitemtimetoliveinminutes`
  - `itemmaxretrycount`
  - `itemmaxrequeuecount`
  - `slathresholdinpercentage`
  - `prioritytype`
- Se aplicó actualización por lote a todas las colas cuyo nombre inicia con `SDU.` (8 colas).
- Se realizó postcheck y validación de estado con filtro por ID y nombre.

## Resultado aplicado
Valores objetivo confirmados en todas las colas SDU:
- `defaultitemtimetoliveinminutes = 50`
- `itemmaxretrycount = 25`
- `itemmaxrequeuecount = 25`
- `slathresholdinpercentage = 50`
- `prioritytype = 0`
- `workqueuetype = 0`

## Colas afectadas
1. `SDU.Matrix.Intake.Queue` — `573721e6-4964-f111-ab0d-002248df1063`
2. `SDU.Connection.Seed.Queue` — `383721e6-4964-f111-ab0d-002248df1063`
3. `SDU.Agent.Dispatch.Queue` — `3c3721e6-4964-f111-ab0d-002248df1063`
4. `SDU.Gate.Review.Queue` — `403721e6-4964-f111-ab0d-002248df1063`
5. `SDU.Evidence.Publish.Queue` — `443721e6-4964-f111-ab0d-002248df1063`
6. `SDU.Dataverse.Apply.Queue` — `483721e6-4964-f111-ab0d-002248df1063`
7. `SDU.Exception.Remediation.Queue` — `4c3721e6-4964-f111-ab0d-002248df1063`
8. `SDU.Drift.Detection.Queue` — `503721e6-4964-f111-ab0d-002248df1063`

## Validadores ejecutados (superficie ejecutable)
- `local_validate_capability_use_hardening.ps1` ✅
- `local_validate_operating_memory_pointers.ps1` ✅
- `git status -sb` (post-operación) mostró estado limpio.

## Observaciones
- No hubo cambios en archivos del repositorio para este despliegue (operación ejecutada en Dataverse).
- No se detectaron errores de ejecución en la actualización ni en el postcheck.

## Rollback (reaplicación reversa)
Para revertir a valores previos, repetir PATCH sobre cada queue del listado con sus valores anteriores guardados en ejecución live (`defaultitemtimetoliveinminutes`, `itemmaxretrycount`, `itemmaxrequeuecount`, `slathresholdinpercentage`, `prioritytype`).

