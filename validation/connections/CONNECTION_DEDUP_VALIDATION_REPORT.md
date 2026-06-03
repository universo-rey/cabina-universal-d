# Connection Dedup Validation Report

## Estado
`CONNECTION_DEDUP_VALIDATION_PASS`

## Alcance

Deduplicacion metadata-only de `matrices/connections/CONNECTION_INSTANCE_INVENTORY.csv`.

No se borro ni redujo la evidencia cruda. La matriz raw permanece como fuente
pesada y los resultados canónicos viven en matrices derivadas.

## Conteos

- Raw instances: 28751.
- Canonical instances: 7296.
- Duplicate raw rows: 21455.
- Overlap canonical rows: 243.
- False positives: 799.
- Templates: 633.
- Pattern references: 3672.
- Real connections: 181.
- Evidence-only references: 1369.

## Reglas aplicadas

- `canonical_key`: source system, source path, repo, surface, connector type,
  target scope y secret boundary.
- `duplicate`: misma clave canonica, conserva raw como evidencia.
- `overlap`: evidencia de repo anidado o path compartido que no debe sembrarse
  como instancia primaria.
- `false_positive`: referencia documental, ejemplo, template o patron sin
  identidad operativa suficiente.
- `blocked`: secreto, produccion, target faltante o repo local sin resolver.
- `seed_now`: permite solo `real_connection`, `evidence_only` y
  `pattern_reference` metadata-only.

## Resultado

- `CONNECTION_CANONICAL_INSTANCE_MATRIX.csv` contiene 7296 instancias canonicas.
- `CONNECTION_DEDUP_RESULT_MATRIX.csv` conserva trazabilidad de las 28751 filas raw.
- `CONNECTION_FALSE_POSITIVE_MATRIX.csv` separa 799 filas no sembrables.
- `CONNECTION_DEDUP_RULES.csv` registra 7 reglas de deduplicacion.

## Validacion local 2026-06-03

- CSV parse: PASS, 13 archivos.
- Canonical ids unicos: PASS.
- Seed instance ids unicos: PASS.
- Seed instance rows: PASS, 5222 filas.
- Clases permitidas en seed: `real_connection`, `evidence_only`,
  `pattern_reference`.
- Duplicados/falsos positivos/bloqueados/reference-only en seed: PASS, 0.
- SGIN_CANONICO remote-only: PASS.
- Material secret pattern hits: PASS, 0.
- `.env` versionado: PASS, 0.

## Criterios de bloqueo

- Falla si un `canonical_id` se repite en la matriz canonica.
- Falla si una fila `duplicate`, `false_positive`, `blocked`, `overlap`,
  `template_only` o `reference_only` entra al seed de instancias.
- Falla si aparece material secreto o `.env` versionado.
- Falla si `SGIN_CANONICO` se trata como local sin raiz confirmada.
