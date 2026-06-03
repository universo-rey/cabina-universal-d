# Dataverse Queue Back-Reference Postcheck

## Estado
DATAVERSE_QUEUE_BACK_REFERENCE_COLUMNS_PASS

## Target
- DATAVERSE_DEV_ENVIRONMENT_URL=https://org084965d9.crm.dynamics.com
- DATAVERSE_DEV_ENVIRONMENT_ID=7f65fc04-c27a-ea0d-bd2d-266aa9203c1e
- DATAVERSE_ORGANIZATION_ID=f982db28-49e3-f011-aa23-000d3a5ca83f
- SOLUTION_UNIQUE_NAME=SDUCapabilityControlPlane
- Publisher prefix: mon

## Resultado
- Tables covered: 22
- Back-reference columns per table: 13
- Metadata checks: 286
- Created in this continuation: 29
- Already existing from prior live tranche: 257
- Failed postchecks: 0
- Secrets printed: no
- Record dumps: no
- PROD/TEST/Default: not used

## Evidencia
- D:\matrices\dataverse\DATAVERSE_QUEUE_BACK_REFERENCE_COLUMN_PLAN.csv
- D:\matrices\dataverse\DATAVERSE_QUEUE_BACK_REFERENCE_COLUMN_APPLY_RESULT.csv
- D:\matrices\dataverse\DATAVERSE_QUEUE_BACK_REFERENCE_COLUMN_POSTCHECK.csv

## Stop Condition
wrong_environment_or_secret_or_missing_column_or_create_failure
