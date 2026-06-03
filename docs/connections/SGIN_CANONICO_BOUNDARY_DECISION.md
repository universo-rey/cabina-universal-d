# SGIN_CANONICO Boundary Decision

## Estado
`SGIN_CANONICO_REMOTE_ONLY`

## Decision

`SGIN_CANONICO` queda reconocido como referencia remota real, pero no como
repo local sembrable en esta cabina.

## Evidencia local

- `MANIFEST.yaml` conserva referencia a `SGIN_CANONICO_READY_NO_DIFF`.
- `.agents/codex/matrices/CODEX_CLOUD_REPO_DISCOVERY_MATRIX_20260602.csv`
  registra `SeshatSgin/SGIN_Canonico_Puro`.
- `.agents/codex/matrices/CODEX_CLOUD_GOVERNED_LANE_MATRIX.csv` registra el
  carril Cloud gobernado para `SGIN_Canonico_Puro`.
- `.agents/codex/matrices/AUTONOMOUS_AGENT_EXECUTION_MATRIX_20260602.csv`
  lo mantiene fuera de la base local registrada.

## Frontera

- No se clono ningun repo.
- No se creo alias local.
- No se movio ningun directorio.
- No se invento raiz local.
- No se abrio live Microsoft, Power Platform, Dataverse ni produccion.

## Accion de seed

`SGIN_CANONICO` se registra como `reference_only_exclude_from_initial_instance_seed`.

Esto evita bloquear la deduplicacion global, pero impide que se siembre como
instancia Dataverse DEV hasta que exista raiz local registrada o una orden
gobernada que lo mantenga formalmente como remoto-only.

## Stop condition

`repo_local_mapping_missing`
