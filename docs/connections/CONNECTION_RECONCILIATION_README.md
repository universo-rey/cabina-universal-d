# Connection Reconciliation README

Este paquete inventaria conexiones declaradas o detectadas en repos locales
sin ejecutar live.

## Matrices

- `matrices/connections/CONNECTION_SURFACE_INVENTORY.csv`
- `matrices/connections/CONNECTION_INSTANCE_INVENTORY.csv`
- `matrices/connections/CONNECTION_GATE_MATRIX.csv`
- `matrices/connections/AGENT_CONNECTION_MAPPING.csv`
- `matrices/connections/CONNECTION_SECRET_BOUNDARY_MATRIX.csv`
- `matrices/connections/CONNECTION_RISK_MATRIX.csv`
- `matrices/connections/CONNECTION_DUPLICATES_AND_OVERLAPS.csv`

## Lectura segura

El inventario guarda repo, path, linea/seccion y clasificacion. No guarda
valores de variables, IDs reales, URLs reales, tokens, cookies, certificados,
connection strings ni client secrets.

## Alcance de repos

Incluye la cabina raiz, `organizacion`, TGE, TGE runtime, SGIN, SGIN
cumplimiento, Seshat bootstrap, SDU canon, TCU runtime y Microsoft Agents
Governed Lab. El clon Seshat anidado dentro de TGE queda marcado como overlap,
no como autoridad primaria.

## Uso con Dataverse

Sembrar primero superficies, gates, riesgos y boundaries de secreto. No sembrar
lineas completas ni payloads. No aplicar Dataverse si el target es Default o si
DEV no esta fijado por ID/URL/perfil protegido.
