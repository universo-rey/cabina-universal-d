# Current Workpaper - rey.governance_registrar

- orden: actualizar capa local agentica con papeles de trabajo versionables.
- estado: LOCAL_GOVERNED_WORKPAPERS_ACTIVE
- superficie: D:\01_GOVERNANCE_REGISTRY|repo local remote metadata
- evidencia: agents.json, AGENT_WORKPAPERS_MATRIX, PURPOSE_SURFACE_CAPABILITY_MATRIX, SURFACE_ROUTING.csv.
- validador: tool.local_validate_agent_workpapers; tool.local_validate_agent_layer.
- riesgo: ejecucion live accidental o matriz sin validador.
- rollback: revertir cambios de carpeta workpapers, matrices y snapshot repo-visible antes de merge.
- stop_condition: workpaper_missing_for_agent.
- proximos_carriles: TGE, SDU/Seshat y CDF nativos, cada uno en su PR.

## Objective

Mantener sincronizado el registro de universos, torres, repos, activos, owners
y relaciones como base de comparacion del control plane. La meta es reconstruir
el baseline sobre una superficie real, trazable, accionable y medible para el
runtime que debemos resolver para Escribania, con una lectura actual de la
superficie local antes de cualquier orden que intente salir a live.

## Current Window

- Ancla compartida: `MANIFEST.yaml`, `02_AUTHORITY_CANON/CURRENT_STATE.md`,
  `2026-06-13_windowed_gov_status_report.md` y el manifiesto SDU-CN
  alineado por agente.
- Medicion minima: universo, torre, repositorio, owner, relacion, estado,
  validador y stop condition.
- Resultado buscado: un registro que sirva para comparar la siguiente ventana,
  no solo para describir la actual.
- Foco actual: Escribania necesita una base real para runtime, no sólo un
  inventario declarativo.

## Next Move

Cruzar el inventario local de `01_GOVERNANCE_REGISTRY` con `AGENT_WORKPAPERS_MATRIX`
y dejar un readback corto con cualquier delta de owner, surface o relation.

## Delta Decision

El delta detectado es estructural y chico a la vez: hay 2 universos, 4 torres,
13 repos, 4 owners y 9 nodos con 8 relaciones en el graph, pero el inventario
sigue en `ACTIVE_DRAFT`/`LOCAL_DRAFT_REVIEW`. La decisión es no inventar
operación viva sobre esa base.

Siguiente acción obligatoria:

1. Convertir esas filas del registro en inventario medible.
2. Marcar qué relación y qué owner sigue en draft.
3. Emitir un readback de delta real, no de intención.
4. Aterrizar el baseline de Escribania sobre superficie medible.
