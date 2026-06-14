# CONTROL_PLANE_OBJECTIVE_WINDOW_READBACK_20260613

agente: rey.control_plane_orchestrator
orden: define_control_plane_objective_for_shared_comparison_window
superficie: control plane local + governed workpapers
repo: universo-rey/cabina-universal-d
workspace: C:\Users\enzo1\Documents\GitHub\cabina-universal-d
estado: HECHO_VERIFICADO_LOCAL

## Objetivo

Mantener el control plane como ventana compartida de comparación: recibir
ordenes, clasificar superficie, derivar a canon/registro/corte/torre y medir
cada salida con target, owner, rollback, postcheck, validator y evidencia.

## Novedades

- El workpaper del control plane ya muestra objetivo explícito.
- El estado del workpaper quedó fechado a 2026-06-13.
- La ventana compartida quedó amarrada a `MANIFEST.yaml`,
  `CURRENT_STATE.md`, la activación SDU-CN y el manifiesto por agente.

## Medición

- target exacto: pendiente hasta elegir superficie concreta
- owner: pendiente hasta elegir caso
- rollback: requerido
- postcheck: requerido
- validator: requerido
- evidencia: requerida
- stop condition: `PENDING_TARGET_ONLY`

## Próximo Paso

Elegir la superficie concreta y convertirla en workpaper medible.
