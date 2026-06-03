# Dataverse Connection Seed Gates

## Estado
`DATAVERSE_CONNECTION_SEED_GATES_PASS`

## Gate DEV

- Gate: `GATE_DATAVERSE_DEV_METADATA_ONLY_SEED`.
- Requiere: ambiente DEV explicito no `Default`.
- Requiere: solution y publisher DEV declarados.
- Requiere: rollback y postcheck.
- Bloquea: apply contra Default, TEST, PROD o ambiente no declarado.

## Gate secretos

- Gate: `GATE_NO_SECRET_MATERIAL_IN_SEED`.
- Requiere: referencias a secretos solo como boundary externo.
- Bloquea: claves, tokens, connection strings reales, passwords y `.env`
  versionado.

## Gate duplicados

- Gate: `GATE_NO_DUPLICATE_INSTANCE_SEED`.
- Requiere: seed desde `DATAVERSE_CONNECTION_SEED_DECISION_MATRIX.csv` con
  `seed_decision=seed_now`.
- Bloquea: duplicate, false positive, blocked, overlap o reference-only en
  `seed_connection_instances.csv`.

## Gate Microsoft y produccion

- Gate: `GATE_LIVE_SURFACE_OBJECT_REQUIRED`.
- Requiere: tenant, superficie, objeto exacto, owner, rollback, postcheck y
  evidencia antes de cualquier write.
- Bloquea: Microsoft live write, Graph mutation, SharePoint write, Teams write,
  Planner write, Power Platform mutation y produccion sin orden separada.

## Stop condition

`dataverse_dev_target_missing_or_seed_contains_blocked_rows`
