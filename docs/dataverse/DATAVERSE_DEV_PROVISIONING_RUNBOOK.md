# Dataverse DEV Provisioning Runbook

1. Set the DEV target explicitly:
   - `DATAVERSE_DEV_ENVIRONMENT_ID`
   - or `DATAVERSE_DEV_ENVIRONMENT_URL`
   - and `PAC_CLI_AUTH_PROFILE`
2. Set `DATAVERSE_TENANT_ID`.
3. Set `POWERPLATFORM_PUBLISHER_UNIQUE_NAME`.
4. Set `DATAVERSE_SOLUTION_UNIQUE_NAME`.
5. Run manifest validation.
6. Run DEV precheck with `-RequireDevReady`.
7. Export rollback snapshot/solution if existing.
8. Apply solution/seed only to DEV.
9. Export postcheck snapshot.
10. Generate readback.

Stop immediately if the target is PROD-like, Default, cross-tenant, or
ambiguous.
