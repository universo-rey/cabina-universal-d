# Readback: SDU Master Environment and Solution List

## Status
SDU_MASTER_ENVIRONMENT_SOLUTION_LIST_V1_READY

## Summary
- Unique environments reconciled: `20`
- Codex Cloud repo environments: `14`
- Power Platform visible environments: `6`
- Confirmed solution mapping: `HUBDesarrollo -> SDUCapabilityControlPlane`
- Incomplete local inventory mapping: `ESCRIBANIA BITSCH default`

## Master List Rule
- If the same environment appears in more than one source, the list collapses it to one row and preserves all source refs.
- Repo-based Codex Cloud environments keep the repository full name as the solution reference.
- Power Platform entries keep `UNKNOWN_*` when the repo has no confirmed local solution roster.

## Confirmed Rows

### HUBDesarrollo
- Environment ID: `7f65fc04-c27a-ea0d-bd2d-266aa9203c1e`
- URL: `https://org084965d9.crm.dynamics.com`
- Tenant ID: `858a0852-44a1-413e-a0fe-f053949797d6`
- Solution: `SDUCapabilityControlPlane`
- Inventory state: `FULL_LOCAL_INVENTORY`
- Evidence: [SDU_MASTER_ENVIRONMENT_SOLUTION_MATRIX.csv](/C:/Users/enzo1/Documents/GitHub/cabina-universal-d/matrices/sdu/SDU_MASTER_ENVIRONMENT_SOLUTION_MATRIX.csv)

### ESCRIBANIA BITSCH default
- Solution: `UNKNOWN_NO_LOCAL_INVENTORY`
- Inventory state: `PARTIAL_LOCAL_INVENTORY`
- Evidence: [SDU_MASTER_ENVIRONMENT_SOLUTION_MATRIX.csv](/C:/Users/enzo1/Documents/GitHub/cabina-universal-d/matrices/sdu/SDU_MASTER_ENVIRONMENT_SOLUTION_MATRIX.csv)

## Visibility-Only Rows
- `SGIN_CANON_DEV_20260418`
- `Microsoft 365`
- `RUC-KYC-Prod`
- `Kit Copilot Studio`

## Codex Cloud Rows
- `SeshatSgin/tcu-control-plane`
- `Sgin`
- `SGIN_Canonico_Puro`
- `universo-rey/cabina-universal-d`
- `SeshatSgin/sgin-cloud`
- `SeshatSgin/torre-gemela-escribania`
- `SeshatSgin/tge-agentic-runtime-control-escribania`
- `SeshatSgin/cdf-soluciones`
- `SeshatSgin/jara-consultores`
- `SeshatSgin/seshat-bootstrap-sdu-cn`
- `SeshatSgin/tcu-agentic-runtime-control`
- `universo-rey/organizacion`
- `SeshatSgin/sgin-cumplimiento`
- `universo-rey/microsoft-agents-governed-lab`

## Evidence
- [SDU_MASTER_ENVIRONMENT_SOLUTION_MATRIX.csv](/C:/Users/enzo1/Documents/GitHub/cabina-universal-d/matrices/sdu/SDU_MASTER_ENVIRONMENT_SOLUTION_MATRIX.csv)
- [CODEX_CLOUD_ENVIRONMENT_INVENTORY_20260602.csv](/C:/Users/enzo1/Documents/GitHub/cabina-universal-d/.agents/codex/matrices/CODEX_CLOUD_ENVIRONMENT_INVENTORY_20260602.csv)
- [DATAVERSE_DEV_ENVIRONMENT_BINDING_MATRIX.csv](/C:/Users/enzo1/Documents/GitHub/cabina-universal-d/matrices/dataverse/DATAVERSE_DEV_ENVIRONMENT_BINDING_MATRIX.csv)
- [CONNECTION_STATUS_MATRIX_20260608.csv](/C:/Users/enzo1/Documents/GitHub/cabina-universal-d/.agents/codex/workpapers/target_resolution_live_gate_20260608/CONNECTION_STATUS_MATRIX_20260608.csv)
- [READBACK_SDU_COMPLETE_ENVIRONMENT_MAP.md](/C:/Users/enzo1/Documents/GitHub/cabina-universal-d/readbacks/sdu/READBACK_SDU_COMPLETE_ENVIRONMENT_MAP.md)

## Next Gate
- If the user wants solution names for the visibility-only rows, run a governed live read only for the exact target environment and exact entity set or org list item.
