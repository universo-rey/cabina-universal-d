# Back-Reference Toolchain Discovery Report

## Estado
HECHO_VERIFICADO: BACK_REFERENCE_TOOLCHAIN_DISCOVERY_PASS

## Tools
- pac: AVAILABLE_READONLY and AVAILABLE_DEV_WRITE
- pac version observed: 2.5.1+gab954cf
- pac active profile: SDU-DATAVERSE-DEV
- pac active URL: https://org084965d9.crm.dynamics.com/
- az: AVAILABLE_METADATA_ONLY_TOKEN_ROUTE
- az account user observed: efigueroa@registronotarial8tdf.com.ar

## DEV Confirmation
- Connected user: efigueroa@registronotarial8tdf.com.ar
- Environment name: HUBDesarrollo
- Environment URL: https://org084965d9.crm.dynamics.com/
- Environment ID: 7f65fc04-c27a-ea0d-bd2d-266aa9203c1e
- Organization ID: f982db28-49e3-f011-aa23-000d3a5ca83f
- Solution: SDUCapabilityControlPlane
- Solution managed: false
- Solution version: 0.1.0.0

## Token Handling
- Token route: Azure CLI in-memory process variable only
- Token printed: false
- Token persisted: false
- D:/.env.local read: false

## Capability Classification
- Dataverse metadata read: AVAILABLE_READONLY
- Dataverse metadata-only record write in DEV: AVAILABLE_DEV_WRITE
- Power Automate workflow metadata read via Dataverse workflow table: AVAILABLE_READONLY
- Flow activation in this lane: NOT_EXECUTED
- Work Queue item processing in this lane: NOT_EXECUTED

## Stop Condition
Stop if the active profile changes away from HUBDesarrollo, if org or
environment ids drift, or if token handling would require printing or
persisting a secret.
