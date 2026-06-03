# Dataverse DEV Prechecks

Required before any DEV apply:

- PAC CLI available.
- DEV environment explicit by URL, ID or protected PAC profile.
- Target is not PROD-like and not Default.
- Tenant is explicit.
- Publisher unique name is explicit.
- Solution unique name is explicit.
- No secrets in manifests or settings.
- Rollback is defined through solution export and snapshot export.
- Postcheck is defined through manifest validation and snapshot export.
- Operator authorization for DEV apply is present.

Current local state: package prepared; DEV apply blocked until exact target is
defined.
