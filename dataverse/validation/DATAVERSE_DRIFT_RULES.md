# Dataverse Drift Rules

## Blocking drift

- Schema YAML changed without solution manifest coverage.
- DEV workflow target contains `prod`, `production` or `default`.
- Publisher or solution identity changes without readback.
- Apply log missing after an import/export action.
- Atomic live or tenant-controlled segment bypasses Dataverse metadata resolver
  when a matching `mon_sdu_*` row exists.

## Warning drift

- Seed matrix hash no longer matches the local source matrix.
- Duplicate matrix families are detected by normalized filename.

## Non-drift

- Historical PR markers remain valid when preserved as lineage.
- GitHub remains technical canon; Dataverse registry lag is an evidence gap,
  not authority replacement.
- GitHub repo-local canon can document lineage while Dataverse resolves
  operational target metadata for atomic execution.
