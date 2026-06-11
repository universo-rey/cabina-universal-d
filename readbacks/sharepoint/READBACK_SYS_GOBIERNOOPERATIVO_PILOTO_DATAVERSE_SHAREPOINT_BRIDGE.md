# Readback: SYS Gobierno Operativo PILOTO Dataverse-SharePoint Bridge

## Status
DATAVERSE_SHAREPOINT_BRIDGE_PUBLISHED_AND_VALIDATED

## What Is Now Connected
- Dataverse is the metadata registry.
- SharePoint is the operational and documentary surface.
- GitHub remains the technical canon.

## Site Anchor Confirmed
- Site: `SYS-GobiernoOperativo-PILOTO`
- Display name: `Soporte de Sistemas - Gobierno Declarativo`
- Anchor libraries confirmed by live site read:
  - `LIB_GobiernoSistemas`
  - `LIB_PuenteDocumental_SGIN`
  - `LIB_DiccionarioCanonico`
  - `LIB_Runbooks`
  - `LIB_AgentPrompts`
  - `LIB_EvidenciaTecnica`
  - `EvidenciasCarga`

## Bridge Logic
1. `LIB_GobiernoSistemas` is the main operating base.
2. `LIB_PuenteDocumental_SGIN` is the crosswalk layer for connecting registries.
3. `LIB_DiccionarioCanonico` holds canonical definitions and environment naming.
4. `LIB_Runbooks` holds procedures and repeatable operations.
5. `LIB_AgentPrompts` holds reusable operator prompts and skill text.
6. `LIB_EvidenciaTecnica` and `EvidenciasCarga` hold proof and load evidence.

## Dataverse Entities Mapped
- `sdu_environment` -> `LIB_DiccionarioCanonico`
- `sdu_matrix` -> `LIB_GobiernoSistemas`
- `sdu_readback` -> `LIB_EvidenciaTecnica`
- `sdu_evidence` -> `LIB_EvidenciaTecnica`
- `sdu_recipe` -> `LIB_Runbooks`
- `sdu_skill` -> `LIB_AgentPrompts`
- `sdu_tool` -> `LIB_GobiernoSistemas`
- `sdu_agent` -> `LIB_GobiernoSistemas`
- `sdu_capability` -> `LIB_DiccionarioCanonico`
- `sdu_capability_mapping` -> `LIB_PuenteDocumental_SGIN`
- `sdu_validation_gate` -> `LIB_GobiernoSistemas`
- `sdu_apply_log` -> `EvidenciasCarga`
- `sdu_matrix_version` -> `LIB_ExportacionesControladas`

## What Is Not Done Yet
- No additional live write is pending for this bridge.
- The bridge was published into the site library folder:
  - `LIB_PuenteDocumental_SGIN/BRIDGE_DATAVERSE_SHAREPOINT`
- The folder and files were re-fetched after upload.

## Evidence Used
- `dataverse/schema/sdu_environment.yml`
- `dataverse/schema/sdu_matrix.yml`
- `dataverse/schema/sdu_readback.yml`
- `dataverse/schema/sdu_evidence.yml`
- `dataverse/schema/sdu_recipe.yml`
- `dataverse/schema/sdu_skill.yml`
- `dataverse/schema/sdu_tool.yml`
- `dataverse/schema/sdu_agent.yml`
- `dataverse/schema/sdu_capability.yml`
- `dataverse/schema/sdu_capability_mapping.yml`
- `dataverse/schema/sdu_validation_gate.yml`
- `dataverse/schema/sdu_apply_log.yml`
- `dataverse/schema/sdu_matrix_version.yml`
- `readbacks/sharepoint/READBACK_SYS_GOBIERNOOPERATIVO_PILOTO_OPERATIONAL_BASE.md`

## Next Step
- If we later want to broaden coverage, add a dedicated live list inventory pass with a connector that can reach SharePoint list surfaces directly.
