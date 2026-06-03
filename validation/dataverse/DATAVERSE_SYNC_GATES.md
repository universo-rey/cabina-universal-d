# Dataverse Sync Gates

## Merge gate

- Manifest validates.
- Drift detector has no blocking findings.
- DEV precheck is either pass or explicitly blocked with package-ready state.
- No secrets or connection strings are present.

## DEV apply gate

- All `GATE_DEV_*` rows pass.
- Target environment is DEV and not Default.
- Rollback export path exists.
- Snapshot postcheck path exists.

## TEST and PROD gates

TEST and PROD are manual templates only. They require environment protection,
owner, rollback, postcheck, evidence and a separate order.
