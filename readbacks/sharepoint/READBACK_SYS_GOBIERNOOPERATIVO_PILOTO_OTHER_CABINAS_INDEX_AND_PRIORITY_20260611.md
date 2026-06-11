# Readback: indice operativo para otras cabinas y priorizacion de ejecucion

- Source matrix: `matrices/sharepoint/SYS_GOBIERNOOPERATIVO_PILOTO_OPERATIONAL_SURFACE_MATRIX.csv`
- Derived index: `matrices/sharepoint/SYS_GOBIERNOOPERATIVO_PILOTO_OTRAS_CABINAS_INDEX.csv`
- Derived priority: `matrices/sharepoint/SYS_GOBIERNOOPERATIVO_PILOTO_PRIORIZACION_EJECUCION_LISTAS_BIBLIOTECAS.csv`

## Resultado

- Indice operativo para otras cabinas: `107` superficies.
- Priorizacion de ejecucion por lista y biblioteca: `95` superficies.
- `VSI` no aparece en los derivados activos.

## Top operativo para otras cabinas

- `P0`: `LIB_GobiernoSistemas`, `SD_BacklogEstrategico`, `SYS_EstadoOperativo`, `WB_Decisiones`
- `P1`: superficies de soporte directo como `EvidenciasCarga`, `LIB_AgentPrompts`, `LIB_DiccionarioCanonico`, `LIB_EvidenciaTecnica`
- `P2`: superficies visibles de comparacion o revision antes de reusar
- `P3`: superficies ocultas o diferidas

## Top de ejecucion

- `1`: `LIB_GobiernoSistemas`
- `2`: `SD_BacklogEstrategico`
- `3`: `WB_Decisiones`
- `4`: `SYS_EstadoOperativo`
- `5`: `WB_Riesgos`
- `6`: `WB_AprendizajesOperativos`
- `7`: `WB_CapacidadesOperativas`
- `8`: `LIB_Runbooks`

## Drift observado

- `WB_RevisionSemanal` sigue apareciendo vivo como nombre sin guion bajo.
- Tratarlo como drift nominal, no como ausencia funcional.

## Evidencia

- `Import-Csv` sobre el indice devolvio `107` filas.
- `Import-Csv` sobre la priorizacion devolvio `95` filas.
- `git diff --check` paso con el aviso conocido de `.gitignore`.
