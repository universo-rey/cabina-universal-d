# Reconciliación de lanes — 2026-09-16

> Classification: `OPERATIONAL_CONTINUITY_EVIDENCE`.
> Consume this artifact when its object, lane, owner, binding, correlation, pending action or rollback matches the current task.
> It is not global authority by itself, but it may carry the active workpaper context needed to continue without rediscovery.
> Re-resolve only fields that are missing, contradicted, or materially changed.


Estado: catálogo derivado aplicado y verificado; reconciliación semántica completa pendiente.

- Agente: Codex coordinador; responsable registrado rey.control_plane_orchestrator.
- Orden: reconciliar workspaces, lanes, asignaciones y catálogo conservando capacidades.
- Superficie: C:/CEO/sdu-control-plane/12_WORKSPACES.
- Skill: matrix-recipe-skill-sync.
- Receta: procedimiento de reconciliación acordado en conversación; no se creó una receta sustitutiva.
- Tool/validador: ../reconcile_workspace_lanes_20260916.py y comprobación de hashes antes/después.
- Evidencia: audit.json, catálogo candidato y catalog.before.json en este directorio.
- Riesgo: cambio de resumen derivado; ninguna modificación de permisos o filas CSV.
- Rollback: restaurar catalog.before.json únicamente si el catálogo instalado sigue coincidiendo con la candidata preservada.
- Stop condition: cambio concurrente de fuentes, identidad ambigua o asignación no resuelta.

## Resultado

110 lanes únicos, todos con workspace y campos poblados. Catálogo actualizado de 85 a 110 y tipos sincronizados. Subtotales calculados por workspace_type: 35 front, 46 repo, 10 institutional_sync_*, 19 otros. Hay 14 workspaces front y 20 repo. La fecha original del documento se conserva como procedencia; reconciliation registra la comprobación actual.

La instalación coincide por hash con la candidata. Los cuatro CSV fuente mantienen sus hashes. Las 19 asignaciones de capacidades usan predicados applies_to, no una relación uno-a-uno con lanes; no se interpretaron como cobertura exhaustiva. Los consumidores BONTEMPS, MCP y SNS consultan el CSV que no cambió.

Dataverse respondió LIVE_READ_OK, sin coincidencias para WORKSPACE_LANE en source_artifacts. No equivale a ausencia global. Los readbacks anteriores conservan sus recuentos como registro de aquella operación.

## Relaciones por resolver

PERSONAL_ONEDRIVE_ROOT y MODO_ON_ONEDRIVE_ROOT no tienen fila exacta en WORKSPACE_AGENT_CHAIN. Sus lanes sí contienen propietarios, reviewers, validadores y fronteras; ONEDRIVE_LOCAL_SCOPE_BINDING conserva relaciones adicionales. El resolver selecciona la cadena por workspace_id (línea 5139). No se inventaron cadenas ni se declaró ausencia de capacidad.

Próximos carriles: resolver esas dos cadenas con sus propietarios y bindings; contrastar semánticamente permisos/recetas vigentes por operación. Este ajuste no certifica que todos los contratos de las 110 filas estén actualizados ni completa un inventario global de capacidades.
