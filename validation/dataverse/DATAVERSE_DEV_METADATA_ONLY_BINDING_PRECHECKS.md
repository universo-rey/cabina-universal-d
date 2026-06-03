# Dataverse DEV Metadata-Only Binding Prechecks

## Estado
DATAVERSE_DEV_METADATA_ONLY_BINDING_PRECHECK_PASS

## Target
- Environment URL: https://org084965d9.crm.dynamics.com
- Environment ID: 7f65fc04-c27a-ea0d-bd2d-266aa9203c1e
- Organization ID: f982db28-49e3-f011-aa23-000d3a5ca83f
- Tenant ID: 858a0852-44a1-413e-a0fe-f053949797d6
- PAC profile: SDU-DATAVERSE-DEV
- Publisher: ModoON
- Prefix: mon
- Solution: SDUCapabilityControlPlane
- Apply mode: DEV_SANDBOX_METADATA_ONLY

## Gates
All binding gates in D:\matrices\dataverse\DATAVERSE_DEV_ENVIRONMENT_BINDING_MATRIX.csv are PASS.

## Boundaries
- Default environment: not used.
- TEST/PROD: not used.
- Secrets: not printed or persisted.
- PII / docs / Planner real / SharePoint items / Graph dumps: not used.
- Commit / push / PR: not executed.

## Stop Condition
Stop if PAC profile no longer resolves to the exact DEV sandbox URL, environment ID, organization ID, tenant ID, or if the target is Default, TEST, PROD, production-like, or lacks rollback/postcheck.
