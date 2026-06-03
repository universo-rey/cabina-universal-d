# Dataverse Validation Report

Status: `DATAVERSE_PACKAGE_VALID_WITH_DEV_APPLY_BLOCKED`

Expected local validators:

- `dataverse/scripts/validate_dataverse_manifest.ps1`: PASS.
- `dataverse/scripts/precheck_dataverse_environment.ps1`: BLOCKED as expected because DEV target is [POR DEFINIR].
- `dataverse/scripts/detect_dataverse_drift.py`: PASS.
- PowerShell script parse: PASS.
- Python compile: PASS.
- YAML parse: PASS, 23 files.
- Governance validation suite: PASS, 19/19.
- Dry-run create/import/export/snapshot/seed scripts: PASS, no Dataverse write.
- `git diff --check`: PASS with line-ending warning only.

Expected blocked state before DEV target:

- Package ready.
- DEV apply not executed.
- No Microsoft/Power Platform write.
- No production.
- No secrets.

Evidence files generated locally under `dataverse/validation/` are runtime
artifacts and remain outside the versioned package.
