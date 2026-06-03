# Dataverse Connection Seed Prechecks

## Estado
`DATAVERSE_CONNECTION_SEED_PRECHECKS_PASS`

## Seed metadata-only preparado

- `dataverse/data/seed_connection_surfaces.csv`: 15 filas.
- `dataverse/data/seed_connection_instances.csv`: 5222 filas.
- `dataverse/data/seed_connection_gates.csv`: 6 filas.
- `dataverse/data/seed_connection_secret_boundaries.csv`: 5222 filas.
- `dataverse/data/seed_agent_connection_mapping.csv`: 11 filas.
- `dataverse/data/seed_connection_risks.csv`: 5222 filas.
- `dataverse/data/seed_connection_evidence.csv`: 5222 filas.

## Decision de seed

- `seed_now`: 5222.
- `blocked_missing_repo`: 1.
- `blocked_pending_gate`: 398.
- `reference_only`: 876.
- `exclude_false_positive`: 799.
- `seed_later`: 0.

## Prechecks obligatorios antes de aplicar

1. Ambiente Dataverse DEV explicito y distinto de `Default`.
2. Solution/publisher DEV definidos.
3. Identidad operadora declarada.
4. Rollback y postcheck definidos.
5. Import metadata-only sin secretos.
6. Ninguna fila `blocked`, `duplicate`, `false_positive` o `reference_only`
   incluida como instancia seed.
7. `SGIN_CANONICO` sin raiz local queda fuera del seed de instancias.

## Resultado actual

`READY_FOR_DEV_APPLY_GATE_NOT_EXECUTED`

No se ejecuto Dataverse apply.

## Validacion local 2026-06-03

- Seed metadata-only parseable: PASS.
- Seed instances duplicadas: PASS, 0.
- Filas bloqueadas en seed instances: PASS, 0.
- Falsos positivos en seed instances: PASS, 0.
- Secretos materiales en seed/docs/connections: PASS, 0.
- DEV apply: NOT_EXECUTED_BY_SCOPE.
