# Readback: SYS Gobierno Operativo PILOTO Gap Map

## Status
SYS_GOBIERNOOPERATIVO_PILOTO_GAP_MAP_REVIEWED

## What Is Clearly Live
- Site root and site id confirmed.
- 16 document libraries visible.
- `LIB_GobiernoSistemas` is the operative control bundle.
- `Frentes/Cumplimiento Normativo` is a visible front branch.

## What Is Documentary
- `MW-MAQUINA-CABINA-OPERATIVA-SHAREPOINT-V1`
- `TGE_Control_20260514`
- `TGE_SDU_CN_MICROSOFT_EXECUTION_20260531`
- Their child files are documentation, matrices, readbacks, gates, runbooks, orders, and manifests.

## What Is Duplicated Or Mirrored
- `TGE_Control_20260514` and `TGE_SDU_CN_MICROSOFT_EXECUTION_20260531` both act like governed execution packages.
- `readbacks` inside the execution bundle mirror the control package readback pattern.
- `manifests`, `orders`, and `context` are execution-scoped mirrors of the same lifecycle.

## Missing Metadata
- File bodies for markdown files were not extracted by the connector.
- YAML manifest bodies were not extracted; they were exposed only as metadata.
- Required/optional flags and internal list names are still not visible from this pass.

## Deeper Probes Needed
- Read the individual markdown files inside `MW-MAQUINA-CABINA-OPERATIVA-SHAREPOINT-V1`.
- Read `00_READBACK_SYS_TGE_20260514.md` and `02_MATRIZ_LISTAS_REQUERIDAS_VS_CAPACIDAD_ACTUAL_20260514.csv`.
- Read `TGE_SDU_CN_AGENT_ACTIVATION_MATRIX_20260531.csv` and the execution readbacks.

## Next Safe Probes
- Safe read-only folder probes inside `LIB_GobiernoSistemas`.
- Metadata-only file reads for the markdown/csv items.
- No live write gate is required for the next read-only pass.

## Evidence
- [READBACK_SYS_GOBIERNOOPERATIVO_PILOTO_SURFACE.md](/C:/Users/enzo1/Documents/GitHub/cabina-universal-d/readbacks/sharepoint/READBACK_SYS_GOBIERNOOPERATIVO_PILOTO_SURFACE.md)
- [READBACK_SYS_GOBIERNOOPERATIVO_PILOTO_GOVERNANCE_PACKAGE.md](/C:/Users/enzo1/Documents/GitHub/cabina-universal-d/readbacks/sharepoint/READBACK_SYS_GOBIERNOOPERATIVO_PILOTO_GOVERNANCE_PACKAGE.md)
