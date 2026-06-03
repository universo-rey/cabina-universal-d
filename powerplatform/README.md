# Power Platform Dataverse Package

Estado: `DATAVERSE_DEV_PROVISIONING_READY`

Este paquete prepara una solucion gobernada para registrar matrices vivas del
SDU / Modo ON / Seshat / OpenAI Capability Control Plane en Dataverse DEV.

## Reglas

- GitHub sigue siendo canon tecnico.
- SharePoint/readbacks siguen siendo repositorio documental y evidencia.
- Dataverse actua como registro consultable de metadatos, relaciones, gates y
  logs de aplicacion.
- No se importan datos sensibles ni documentos completos.
- No se aplica a DEV si el ambiente exacto no esta definido por ID, URL o
  perfil PAC protegido.
- TEST y PROD son manuales, protegidos y no ejecutados por este paquete.

## Flujo local seguro

1. `dataverse/scripts/validate_dataverse_manifest.ps1`
2. `dataverse/scripts/precheck_dataverse_environment.ps1`
3. `dataverse/scripts/create_solution_dev.ps1`
4. `dataverse/scripts/import_solution_dev.ps1`
5. `dataverse/scripts/import_seed_data_dev.ps1`
6. `dataverse/scripts/export_dataverse_snapshot.ps1`
7. `dataverse/scripts/generate_readback.py`

Todos los scripts son dry-run o precheck por defecto. Las acciones DEV con
write requieren `-Apply` y gates DEV completos.
