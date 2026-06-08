# Codex Dataverse Sync Contract

## Inputs

- Versioned matrices.
- Schema YAML.
- Solution manifest.
- Deployment settings.
- DEV target environment.
- Dataverse `mon_sdu_*` metadata rows for atomic segment resolution when they exist.

## Outputs

- Local validation JSON.
- Dataverse snapshot JSON.
- Apply log entry.
- Readback.

## Guarantees

- No secrets printed or persisted.
- No PROD apply from DEV workflow.
- No Default environment apply.
- No replacement of GitHub technical canon.
- No sensitive payload seed.
- No repo-local target inference when Dataverse has an exact metadata row.
- No live write unless Dataverse resolution returns exactly one candidate with
  target, owner, rollback, postcheck, evidence and stop condition.
