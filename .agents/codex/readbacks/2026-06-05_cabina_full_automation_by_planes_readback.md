# Readback - Cabina Full Automation By Planes

## Estado

`CABINA_FULL_AUTOMATION_BY_PLANES_ACTIVE`

## Orden

Convertir la Cabina existente en un sistema ejecutable por planos operativos,
sin crear arquitectura paralela y sin ampliar superficies criticas.

## Superficie

Repo-scoped local y GitHub PR. No se ejecuto Microsoft live, OpenAI API live,
produccion, permisos, tenants, secretos ni costos externos.

## Descubrimiento

Se reutilizaron los contratos existentes de AGENTS, MANIFEST, Cabina Operating
System, cadena operativa, GitHub lifecycle, Codex Cloud lane, change-aware
orchestrator, validators, matrices, recipes, skills y readbacks. No existia un
artefacto equivalente que organizara el ciclo completo por los 15 planos
operativos solicitados.

## Cambios aplicados

- Se agrego el canon ejecutable
  `governance/canon/CABINA_FULL_AUTOMATION_BY_PLANES.md`.
- Se agrego la matriz ejecutable
  `.agents/codex/matrices/CABINA_FULL_AUTOMATION_PLANE_MATRIX_20260605.csv`.
- Se agrego el validador
  `.agents/codex/tools/local_validate_cabina_full_automation_planes.ps1`.
- Se registraron matriz, tool, cobertura, evidencia y change-aware para que la
  capacidad no quede huerfana.
- Se agrego este readback saneado a la allowlist minima.

## Validacion esperada

- El validador nuevo confirma 15 planos, orden secuencial, recipes existentes,
  tools indexadas, validators existentes y registros en matrices de cobertura.
- La suite local debe seguir evidenciando cualquier bloqueo externo sin
  convertirlo en cambio funcional de este carril.

## Riesgos

Riesgo bajo. La modificacion es repo-scoped, declarativa y validable. El riesgo
principal era crear documentacion sin conexion operativa; se mitiga con matriz,
tool, cobertura, evidencia y change-aware.

## Rollback

Revertir el commit del carril o retirar explicitamente los archivos y filas
agregadas:

- `governance/canon/CABINA_FULL_AUTOMATION_BY_PLANES.md`
- `.agents/codex/matrices/CABINA_FULL_AUTOMATION_PLANE_MATRIX_20260605.csv`
- `.agents/codex/tools/local_validate_cabina_full_automation_planes.ps1`
- filas `cabina_full_automation_planes` y
  `cabina_full_automation_plane_matrix` en matrices de indice/cobertura
- fila `tool.local_validate_cabina_full_automation_planes`
- allowlist del readback en `.gitignore`

## Stop Condition

`PR_OPEN_READY_FOR_REVIEW` cuando el commit este pusheado, el PR este abierto y
los checks remotos queden visibles para revision.
