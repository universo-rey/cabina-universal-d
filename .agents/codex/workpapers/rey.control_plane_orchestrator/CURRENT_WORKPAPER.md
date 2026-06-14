# Current Workpaper - rey.control_plane_orchestrator

- orden: actualizar capa local agentica con papeles de trabajo versionables.
- estado: LOCAL_GOVERNED_WORKPAPERS_ACTIVE
- superficie: D:\AGENTS.md|D:\MANIFEST.yaml|D:\00_CONTROL_PLANE_INGRESS\ROUTING.json|D:\01_GOVERNANCE_REGISTRY\RELATIONSHIP_GRAPH.json|D:\.agents\codex\routing.json
- evidencia: agents.json, AGENT_WORKPAPERS_MATRIX, PURPOSE_SURFACE_CAPABILITY_MATRIX, SURFACE_ROUTING.csv.
- validador: tool.local_validate_agent_workpapers; tool.local_validate_agent_layer.
- riesgo: ejecucion live accidental o matriz sin validador.
- rollback: revertir cambios de carpeta workpapers, matrices y snapshot repo-visible antes de merge.
- stop_condition: workpaper_missing_for_agent.
- proximos_carriles: TGE, SDU/Seshat y CDF nativos, cada uno en su PR.

## Objective

Reconstruir el baseline sobre superficie real, trazable, accionable y
medible, para el runtime que debemos resolver para Escribania. El control
plane tiene que servir como punto de comparacion compartido para esta
ventana: recibir ordenes, clasificar superficie, derivar a canon/registro/
corte/torre y publicar evidencia medible sin caer en criterio unilateral.

## Current Window

- Ancla de comparacion: `MANIFEST.yaml` + `02_AUTHORITY_CANON/CURRENT_STATE.md`
  + `ORDER_SDU_AGENTS_NEXT_TASK_ACTIVATION_20260608.md`
  + `2026-06-13_sdu_agents_activation_sync_readback.md`
  + `2026-06-13_sdu_cn_roster_alignment_manifest.md`
  + `2026-06-13_windowed_gov_status_report.md`
- Hallazgo actual: el control plane ya existe como carril local, pero faltaba
  exponerlo como objetivo operativo medible.
- Hallazgo actualizado: el baseline debe aterrizarse en la superficie real de
  Escribania antes de abrir nuevas superficies.
- Medicion minima: target exacto, owner, rollback, postcheck, validator,
  evidencia y stop condition.

## Next Move

Producir el siguiente workpaper/orden para la superficie concreta que el
usuario elija y compararlo contra esta ventana base.

## Delta Decision

La decisión por delta es mantener cerrada la expansión live y tratar el
registro actual como base incompleta pero suficiente para comparar. El control
plane no se sigue empujando hacia nuevas superficies hasta que
`01_GOVERNANCE_REGISTRY` deje de estar en modo declarativo y pase a inventario
medible.

Orden de prioridad:

1. Normalizar el registro local.
2. Completar relaciones y estados.
3. Recién después abrir cualquier nueva superficie o despacho live.

4. Resolver el runtime de Escribania sobre una base real y trazable.
