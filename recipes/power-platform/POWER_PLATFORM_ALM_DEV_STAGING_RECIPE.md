# Power Platform ALM DEV/STAGING Recipe

Estado: `POWER_PLATFORM_ALM_DEV_STAGING_READY_WITH_EXPLICIT_NONPROD_ALLOWLIST_GATE`

## Objetivo

Ejecutar ALM no productivo para soluciones Power Platform desde GitHub Actions
o PAC CLI: install, whoami, export, unpack, pack, check, import DEV opcional,
publish DEV opcional, artifacts y summary.

## Alcance

- DEV/STAGING solamente.
- Service principal con GitHub Secrets o variables locales.
- Sin produccion, reset, restore, delete ni secretos hardcodeados.

## Entradas

- `environment_url`
- `environment_stage` (`DEV` o `STAGING`)
- `solution_name`
- `solution_type`
- `solution_folder`
- `checker_geo`
- `import_to_dev`
- `publish_after_import`
- `confirm_non_production`
- GitHub Variable: `POWERPLATFORM_DEV_STAGING_ENVIRONMENT_URLS`
- GitHub Secrets: `POWERPLATFORM_APP_ID`,
  `POWERPLATFORM_CLIENT_SECRET`, `POWERPLATFORM_TENANT_ID`

## Salidas

- Solution zip.
- Solution source unpacked.
- Checker logs.
- Workflow summary.
- Readback.

## Prechecks

1. `environment_stage` es `DEV` o `STAGING`.
2. `environment_url` es `https` y se normaliza a esquema + host.
3. `POWERPLATFORM_DEV_STAGING_ENVIRONMENT_URLS` contiene la URL DEV/STAGING
   aprobada cuando `import_to_dev` o `publish_after_import` son true.
4. `confirm_non_production == true` antes de import/publish.
5. `solution_name` y folder no vacios.
6. `who-am-i` exitoso.
7. GitHub permissions se mantienen en `contents: read`.

## Ejecucion

1. Instalar Power Platform Actions.
2. Validar inputs, stage y allowlist DEV/STAGING.
3. Ejecutar `who-am-i`.
4. Exportar solution.
5. Unpack a carpeta versionable.
6. Pack desde carpeta.
7. Check solution.
8. Import DEV solo con gates true.
9. Publish DEV solo con gates true.
10. Subir artifacts.

## Postchecks

- Artifacts existen.
- Checker no reporta fallo de analisis.
- Import/publish quedan omitidos si gates son false.
- Import/publish fallan antes de ejecutar si la URL no coincide con allowlist
  DEV/STAGING.
- Summary declara proximo paso exacto.

## Rollback

- No hay write si import/publish gates son false.
- Si DEV import falla: reimportar zip anterior solo con gate DEV.
- Si publish falla: pausar despliegue, revisar checker y readback.

## Evidencias

- Workflow run.
- Zip artifact.
- Checker artifact.
- GitHub summary.
- Readback local.

## Criterio de cierre

`ALM_DEV_STAGING_READY_WITH_EXPLICIT_NONPROD_ALLOWLIST_GATE` cuando los
workflows y scripts existen, validan sintaxis basica, no contienen secretos
hardcodeados y el validador `validate-power-platform-alm-gates.ps1` confirma
stage DEV/STAGING mas allowlist explicita para pasos mutables.
