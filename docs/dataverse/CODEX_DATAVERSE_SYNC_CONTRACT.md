# Codex Dataverse Sync Contract

## Inputs

- Versioned matrices.
- Schema YAML.
- Solution manifest.
- Deployment settings.
- DEV target environment.

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
