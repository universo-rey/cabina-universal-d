# Connection Surface Registry Decision

Estado: `CONNECTION_SURFACE_REGISTRY_PARTIAL_WITH_BLOCKERS`

## Decision

La cabina mantiene un registro local normalizado de superficies de conexion
para Escribania, Cabina agentic y Microsoft Agents Governed Lab. El registro
es metadata-only: no ejecuta conexiones live, no autentica contra Microsoft,
Graph, PAC, SharePoint, Planner, Power Platform ni Dataverse, y no persiste
secretos.

## Canon

- GitHub sigue siendo canon tecnico versionado.
- SharePoint/readbacks siguen siendo repositorio documental y evidencia.
- Dataverse puede recibir este registro como seed metadata-only cuando exista
  DEV explicito, no Default, con tenant, owner, rollback y postcheck.

## Resultado de reconciliacion

- Repos escaneados localmente: 11.
- Instancias de conexion detectadas: 28751.
- Superficies normalizadas: 15.
- Archivos sensibles omitidos sin lectura de valores: 24.
- Repo `SGIN_CANONICO` queda `[POR DEFINIR]` por falta de raiz local registrada.

## Decision operativa

No se habilita ninguna conexion por deteccion de patron. Toda superficie live
queda `GATED_NOT_EXECUTED`.

## Stop conditions

- `microsoft_live_requested_without_governed_order`
- `dataverse_apply_without_explicit_sandbox_or_default_as_dev`
- `openai_api_live_requested_without_order`
- `secret_detected`
- `repo_local_mapping_missing`
