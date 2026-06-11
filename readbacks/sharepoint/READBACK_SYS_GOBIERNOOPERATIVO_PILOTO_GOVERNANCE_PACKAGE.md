# Readback: SYS Gobierno Operativo PILOTO Governance Package

## Status
SYS_GOBIERNOOPERATIVO_PILOTO_GOVERNANCE_PACKAGE_REVIEWED

## Main Package
- `LIB_GobiernoSistemas`

## Canonical Bundles Found

### Cabina Visible Bundle
- Folder: `MW-MAQUINA-CABINA-OPERATIVA-SHAREPOINT-V1`
- Files:
  - `ARQUITECTURA_CABINA_VISIBLE_SYS.md`
  - `GUIA_OPERATIVA_USO_CABINA_MAQUINA.md`
  - `INFORME_SHAREPOINT_CABINA_OPERATIVA_MAQUINA.md`
  - `MANIFEST_CABINA_OPERATIVA_SHAREPOINT.yml`
  - `MAPA_BLOQUES_PAGINA_MAQUINA.md`
  - `MATRIZ_NAVEGACION_CABINA_MAQUINA.md`
  - `MATRIZ_VISTAS_SHAREPOINT_MAQUINA.md`
  - `PLAN_PLANNER_CABINA_OPERATIVA_MAQUINA.md`
  - `RESUMEN_EJECUTIVO_CABINA_OPERATIVA_SHAREPOINT.md`

### Control Bundle
- Folder: `TGE_Control_20260514`
- Files:
  - `00_READBACK_SYS_TGE_20260514.md`
  - `01_MATRIZ_BIBLIOTECAS_VISIBLES_SYS_TGE_20260514.csv`
  - `02_MATRIZ_LISTAS_REQUERIDAS_VS_CAPACIDAD_ACTUAL_20260514.csv`
  - `03_RUNBOOK_NORMALIZACION_SYS_TGE_20260514.md`
  - `04_ORDENES_AGENTES_REPOS_VECINOS_20260514.md`
  - `05_REGISTRO_SKILLS_RECETAS_SYS_TGE_20260514.md`
  - `06_MATRIZ_SHAREPOINT_GITHUB_SYS_TGE_20260514.csv`
  - `07_GATE_STAGING_DOCUMENTAL_OPS_WB_SYS_20260514.md`
  - `PRUEBA_WRITE_VIVA_SYS_PILOTO_2026-05-14.md`
  - `TGE_REPORTE_ESTADO_FRONTERA_SYS_2026-05-14.md`

### Execution Bundle
- Folder: `TGE_SDU_CN_MICROSOFT_EXECUTION_20260531`
- Subfolders:
  - `context`
  - `evidence`
  - `manifests`
  - `orders`
  - `readbacks`

## Execution Subfolders

### `context`
- `TGE_SDU_CN_AGENT_ACTIVATION_20260531.md`
- `TGE_SDU_CN_AGENT_ACTIVATION_MATRIX_20260531.csv`

### `evidence`
- One evidence file confirmed

### `manifests`
- `anubis_gate.manifest.yaml`
- `horus_riesgo.manifest.yaml`
- `maat_cumplimiento.manifest.yaml`
- `narrador_normativo.manifest.yaml`
- `seshat_normativa.manifest.yaml`
- `thot_tecnico.manifest.yaml`

### `orders`
- `TGE_SDU_CN_AGENT_ACTIVATION_DISPATCH_20260531.md`
- `TGE_SDU_CN_AGENT_ACTIVATION_ORDER_20260531.md`

### `readbacks`
- `ACTA_TGE_SDU_CN_AGENT_ACTIVATION_20260531.md`
- `ACTA_TGE_SDU_CN_COPILOT_SESHAT_NORMATIVA_EN_US_DRAFT_TEXT_ENRICHMENT_20260531.md`
- `ACTA_TGE_SDU_CN_COPILOT_SHELL_SESHAT_NORMATIVA_20260531.md`
- `ACTA_TGE_SDU_CN_MICROSOFT_EXECUTION_20260531.md`

## Reusable Canon
- `MANIFEST_CABINA_OPERATIVA_SHAREPOINT.yml`
- `00_READBACK_SYS_TGE_20260514.md`
- `02_MATRIZ_LISTAS_REQUERIDAS_VS_CAPACIDAD_ACTUAL_20260514.csv`
- `07_GATE_STAGING_DOCUMENTAL_OPS_WB_SYS_20260514.md`
- `06_MATRIZ_SHAREPOINT_GITHUB_SYS_TGE_20260514.csv`
- `RESUMEN_EJECUTIVO_CABINA_OPERATIVA_SHAREPOINT.md`

## Gap Observed
- The connector exposed file metadata and names, but not file bodies for the markdown and yaml items.
- `MANIFEST_CABINA_OPERATIVA_SHAREPOINT.yml` was exposed as metadata only.

## Evidence
- [TGE_Control_20260514](https://escribaniabitsch.sharepoint.com/sites/SYS-GobiernoOperativo-PILOTO/Shared%20Documents/LIB_GobiernoSistemas/TGE_Control_20260514)
- [MW-MAQUINA-CABINA-OPERATIVA-SHAREPOINT-V1](https://escribaniabitsch.sharepoint.com/sites/SYS-GobiernoOperativo-PILOTO/Shared%20Documents/LIB_GobiernoSistemas/MW-MAQUINA-CABINA-OPERATIVA-SHAREPOINT-V1)
- [TGE_SDU_CN_MICROSOFT_EXECUTION_20260531](https://escribaniabitsch.sharepoint.com/sites/SYS-GobiernoOperativo-PILOTO/Shared%20Documents/LIB_GobiernoSistemas/TGE_SDU_CN_MICROSOFT_EXECUTION_20260531)

