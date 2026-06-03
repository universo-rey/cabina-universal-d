# Dataverse DEV Metadata-Only Postcheck

## Estado
DATAVERSE_DEV_METADATA_ONLY_POSTCHECK_PASS

## Schema
- Tables observed: 22
- Fields observed: 450
- Alternate keys observed: 22
- Required table gates: canonical_id=yes, seed_batch_id=yes, gate_required=yes, audit=yes, change_tracking=yes, alternate_key=yes

## Seed Apply
- Base seed import: rows=15698, batches=36
- Instance seed import: rows=5222, batches=11
- Targeted re-upsert: rows=5243, batches=13
- Evidence re-upsert: rows=5222, batches=11

## Snapshots
- connection_surfaces_snapshot.json: 15 rows
- connection_instances_snapshot.json: 5222 rows
- connection_gates_snapshot.json: 6 rows
- connection_secret_boundaries_snapshot.json: 5222 rows
- connection_risks_snapshot.json: 5222 rows
- agent_connection_mapping_snapshot.json: 11 rows
- connection_evidence_snapshot.json: 5222 rows

## Drift
- Drift checks: 9
- Drift failures: 0
- Drift report: matrices/dataverse/DATAVERSE_DEV_CONNECTION_SEED_DRIFT_REPORT.csv

## Boundaries
- Default environment: not used.
- TEST/PROD: not used.
- Secrets: not printed or persisted.
- Microsoft live outside Dataverse DEV metadata apply: not executed.
- Production: not executed.
- Propagation: not executed.
