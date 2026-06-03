# Power Platform Teams Governance Policy

Estado: `POWER_PLATFORM_TEAMS_GOVERNANCE_POLICY_READY`
Fecha: 2026-06-03

## Regla central

SYS / SharePoint registra evidencia. Planner organiza trabajo. Teams comunica.
Power Automate ejecuta automatizacion. GitHub gobierna canon tecnico. Codex
prepara cambios. Humano aprueba produccion.

## Permitido

- Exportar, desempaquetar, empaquetar y validar soluciones DEV/STAGING desde
  GitHub Actions o PAC CLI.
- Ejecutar `who-am-i` contra un Dataverse DEV/STAGING exacto con service
  principal autorizado.
- Preparar import y publish DEV/STAGING con input manual, confirmacion
  explicita de no produccion, `environment_stage` DEV/STAGING y match contra
  `POWERPLATFORM_DEV_STAGING_ENVIRONMENT_URLS`.
- Diseñar colas de mensajes programados en SharePoint o Dataverse.
- Registrar evidencia operacional en SharePoint/SYS o Dataverse cuando exista
  target exacto, rollback y postcheck.
- Mantener Teams humano sin bloqueo: el usuario puede seguir usando Teams
  aunque existan automatizaciones.

## Requiere aprobacion gobernada

- Envio automatico de mensajes Teams a canal o chat real.
- Uso de Microsoft Graph para mensajes, permisos o app registrations.
- Import, publish o cambios de Solution fuera de DEV/STAGING o sin allowlist
  explicita de ambiente no productivo.
- Writes en SharePoint, Planner, Dataverse, Power Platform, Teams o tenant.
- Alta, rotacion o modificacion de GitHub Secrets.
- Cambios de permisos, visibilidad, licencias, conectores o identidad.

## Prohibido en este carril

- Borrar, resetear o restaurar ambientes.
- Importar o publicar en produccion o en cualquier URL no aprobada en la
  allowlist DEV/STAGING.
- Hardcodear tenant, usuario, password, client secret o environment URL
  productivo.
- Mezclar tenants Escribania y Modo ON.
- Usar datos regulados amplios o expedientes completos.
- Declarar una accion live como ejecutada si solo fue preparada.

## Gobierno de flows

- Todo flow operativo debe ser solution-aware cuando vaya a ALM.
- Toda conexion debe resolverse mediante connection references.
- Todo valor por ambiente debe vivir en environment variables o deployment
  settings.
- Todo flow que envie comunicaciones debe separar: contenido, destino,
  aprobador, fecha, evidencia, responsable y rollback.
- Todo cambio debe pasar por export, unpack, pack, check y readback.

## Gobierno de mensajes Teams

| modalidad | regla |
| --- | --- |
| Humano directo | siempre permitido fuera del sistema; no se bloquea |
| Humano asistido | Codex/flow propone, humano aprueba y envia |
| Bot/connector | solo con destino exacto, evidencia y gate |
| Graph | solo cuando connector no alcance y permisos esten revisados |
| Adaptive Cards | preferidas para aprobaciones, derivaciones y confirmaciones |

## Planner, SharePoint/SYS y GitHub

- Planner concentra tareas, buckets, responsables y seguimiento operativo.
- SharePoint/SYS conserva evidencia, actas, decisiones y trazabilidad.
- GitHub conserva workflows, scripts, recipes, matrices y versionado ALM.
- Power Automate conecta la cola con Teams, Planner y evidencia.
- Codex prepara cambios y PR; no sustituye aprobacion institucional.

## Incidentes y rollback

1. Pausar el flow o dejar `import_to_dev` / `publish_after_import` en false.
2. Retirar item pendiente de la cola o marcarlo `cancelled`.
3. Revertir PR o workflow si el cambio fue de repo.
4. Reimportar solucion previa solo en DEV/STAGING y con gate.
5. Registrar postcheck y readback.

## Criterio de cierre

`POWER_PLATFORM_TEAMS_ALM_DEV_STAGING_READY_WITH_EXPLICIT_NONPROD_ALLOWLIST_GATE`
cuando existen registry, matriz, policy, recipes, workflows, scripts,
validacion, readback, commit y PR con gate explicito de allowlist DEV/STAGING.
