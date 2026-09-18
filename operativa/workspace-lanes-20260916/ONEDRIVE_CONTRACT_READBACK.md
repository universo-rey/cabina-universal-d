# Relaciones recuperadas y contraste de contratos

> Classification: `OPERATIONAL_CONTINUITY_EVIDENCE`.
> Consume this artifact when its object, lane, owner, binding, correlation, pending action or rollback matches the current task.
> It is not global authority by itself, but it may carry the active workpaper context needed to continue without rediscovery.
> Re-resolve only fields that are missing, contradicted, or materially changed.


Fecha: 2026-09-16. Estado: relaciones recuperadas; recuperación de owner aplicada al resolver y comprobada.

## Aplicación posterior

Se aplicó resolver.candidate.ps1 a D:/.agents/codex/tools/local_resolve_bontemps_workspace.ps1 tras verificar que el original coincidía por hash con resolver.before.ps1. Respaldo y candidata están en este directorio. El postcheck ejecutó el resolver instalado para ambas raíces y project-cdx.

Ambas raíces devuelven su owner del lane y owner_binding_source=WORKSPACE_LANE_INDEX.owner_agent, con owner_relation_status=LANE_OWNER_RECOVERED__WORKSPACE_CHAIN_UNRESOLVED. No se asignaron chain_id ni workspace_orchestrator. El fallback solo se aplica a estas raíces, con owner ausente y un único owner no vacío entre lanes seleccionados; varios owners producen LANE_OWNER_AMBIGUOUS. project-cdx conserva owner rey.repo_cartographer, CHAIN-REPO-PROJECT-CDX y orquestador rey.control_plane_orchestrator.

No se modificaron matrices, permisos, sincronización OneDrive ni contenido personal. El código instalado coincide por hash con la candidata. Rollback: resolver.before.ps1, verificando primero que el archivo instalado no tenga cambios posteriores. Las secciones siguientes conservan la evidencia previa que motivó el ajuste.

## Fuentes y resultado

El archivo recovered-onedrive-relations.csv enlaza workspace, lane, binding, responsable, revisor, componente federal, receta y rutas. Fuentes: WORKSPACE_INDEX, WORKSPACE_LANE_INDEX, ONEDRIVE_LOCAL_SCOPE_BINDING en C:/CEO/sdu-control-plane/12_WORKSPACES; GLOBAL_REASONING_COMPONENT_RETURN_20260818.csv y CAPABILITY_SOURCE_INVENTORY.csv en D:/.agents/codex/matrices.

- PERSONAL_ONEDRIVE_ROOT: OD-SCOPE-PERSONAL-ROOT, GRC-016, codex.workspace_guardian. CODEX_ONEDRIVE_ROOT es alias de compatibilidad según CAPABILITY_SOURCE_INVENTORY, no una cadena recuperada.
- MODO_ON_ONEDRIVE_ROOT: OD-SCOPE-MODO-ON-ROOT, GRC-017, universe.modo_on_tower. Rutas declaradas: REPO_MODO_ON_FOUNDATION, REPO_CDF_SOLUCIONES, REPO_JARA_CONSULTORES. La misión MODO-ON-PROVIDER en MESA_EXTENDIDA_MISSION_QUEUE_ROUTING_20260829.csv remite a SDU_MODO_ON; no autoriza importar runtime del proveedor a Escribanía.
- Ambos: receta D:/.agents/codex/recipes/recipe.workspace_reference_audit.md; skill repo-agent-tool-governance; selección de hijo exacto antes de acceso; retorno federal condicionado al alcance exacto.

## Contraste

1. Propósito, owner y frontera de las raíces coinciden entre lane, binding y componentes GRC.
2. NO_DIRECT_PLANNER_ROUTE y NO_DIRECT_DATAVERSE_ROUTE describen estas raíces; no significan ausencia de conexiones o capacidades globales.
3. Los permisos de lectura/ruteo del workspace no amplían write_scope=none de estos lanes.
4. El revisor aparece como rey.frontier.guardian en lanes y rey.frontier_guardian en otras asignaciones. Se conserva la grafía de cada fuente; no se declaró equivalencia global sin consumir su contrato de alias.
5. Ninguna fila exacta de WORKSPACE_AGENT_CHAIN cubre estas dos raíces. Las cadenas de otros dominios no se copiaron por semejanza.

## Comprobación real

Se ejecutó local_resolve_bontemps_workspace.ps1 para las dos raíces, sin lectura de contenido ni escrituras operativas. Ambos resultados: status=RESOLVED, workspace_id exacto y binding presente; owner_agent, workspace_orchestrator y chain_id nulos. El resolver consulta WORKSPACE_AGENT_CHAIN por workspace_id en línea 5139. El defecto está en la composición de relaciones hacia la salida, no en la existencia del owner.

Ancla Dataverse: consulta viva source_artifacts, query ONEDRIVE_ROOT, cero coincidencias sin errores. Alcance limitado a ese selector y familia; no prueba ausencia global.

## Siguiente delta preciso

Consumir los owners y bindings existentes al componer el resultado y resolver la asignación de roles todavía no materializada con los responsables. No identificar automáticamente owner de lane con workspace_orchestrator, ni inventar chain_id. Simular cualquier cambio del consumidor con ambas raíces y un workspace que ya tenga cadena, preservando roles y límites.

Agente: Codex coordinador con revisión codex_workspace_guardian. Orden: recuperar relaciones y contrastar contratos. Skill: matrix-recipe-skill-sync. Tool: resolver BONTEMPS y lectores CSV/Dataverse. Validador: contraste de IDs y lectura real del consumidor. Riesgo: sin mutaciones de fuentes. Rollback: no requerido para runtime; artefactos locales de readback. Stop condition: rol o autoridad no resueltos. Próximo carril: workspace_config/owner routing de cada estancia.
