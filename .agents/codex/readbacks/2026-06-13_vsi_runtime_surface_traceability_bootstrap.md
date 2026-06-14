# READBACK_VSI_RUNTIME_SURFACE_TRACEABILITY_BOOTSTRAP_20260613

agente: Codex
orden: define_runtime_surface_traceability_header_for_vsi_governed_work
superficie: repo local + VSI task queue + surface maps
repo: universo-rey/cabina-universal-d
workspace: C:\Users\enzo1\Documents\GitHub\cabina-universal-d
estado: HECHO_VERIFICADO_LOCAL

## Cambios

- Se reforzo `vsi-superficie-viva-task-runner` para que el runtime arranque
  con una cabecera trazable antes de cualquier ejecucion.
- Se reforzo `cabina-session-handoff` para exigir header de runtime o
  trazabilidad cuando la superficie sea viva o gobernada.
- La cabecera ahora queda amarrada a `surface`, `target`, `owner`, `identity`,
  `data_boundary`, `branch`, `lock_key`, `rollback`, `postcheck`, `validator`,
  `evidence` y `stop_condition`.

## Evidencia

- `python .agents/codex/tools/local_validate_skill_metadata.ps1`: PASS
- `git diff --check`: sin errores nuevos; solo persiste el warning previo de
  CRLF en `scripts/validators/cabina_startup_contract_validator.py`

## Riesgos

- No se inicio ningun provider live.
- El target exacto de superficie viva sigue siendo `PENDING_TARGET_ONLY` hasta
  que se declare el caso concreto.

## Stop Condition

`PENDING_TARGET_ONLY`

## Proximos carriles

1. Asignar el runtime o fila exacta antes de cualquier execution live.
2. Mantener el readback como ancla de trazabilidad para gobernanza.
