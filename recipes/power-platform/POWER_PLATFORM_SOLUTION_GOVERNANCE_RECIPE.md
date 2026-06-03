# Power Platform Solution Governance Recipe

Estado: `POWER_PLATFORM_SOLUTION_GOVERNANCE_READY`

## Objetivo

Gobernar soluciones Power Platform como artefactos versionables con export,
unpack, pack, checker, connection references, environment variables y gates
humanos.

## Alcance

- Soluciones DEV/STAGING.
- Flows solution-aware.
- Connection references y environment variables documentadas.
- Produccion fuera de alcance hasta gate separado.

## Entradas

- Solution unique name.
- Environment URL DEV/STAGING.
- Solution folder.
- Deployment settings file opcional.
- Checker geo.
- Owner y reviewer.

## Salidas

- Solution zip.
- Source folder.
- Checker logs.
- Decision de import/publish.
- Evidencia de rollback.

## Prechecks

1. Solution existe en ambiente DEV/STAGING.
2. Dataverse environment tiene database.
3. Service principal puede hacer `who-am-i`.
4. No hay tenant hardcodeado en repo.
5. No hay connection secrets en archivos.

## Ejecucion

1. Exportar unmanaged desde DEV/STAGING.
2. Unpack a carpeta destino.
3. Revisar diffs.
4. Pack para validar reversibilidad.
5. Ejecutar solution checker.
6. Preparar import DEV si corresponde.
7. Publicar solo con `publish_after_import == true`.

## Postchecks

- `git diff` muestra solo artefactos esperados.
- Checker logs archivados.
- Import/publish tienen summary y gate.
- Readback registra target, owner, rollback y stop condition.

## Rollback

- Conservar zip previo.
- Revertir commit si el cambio fue solo de repo.
- En DEV/STAGING, reimportar version previa solo con gate.
- No tocar produccion.

## Evidencias

- Zip exportado.
- Carpeta unpack.
- Checker logs.
- Workflow summary.
- Readback.

## Criterio de cierre

`SOLUTION_GOVERNANCE_DEV_STAGING_READY`.
