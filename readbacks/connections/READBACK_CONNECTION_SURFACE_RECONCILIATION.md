# Readback Connection Surface Reconciliation

## Estado
`CONNECTION_SURFACE_REGISTRY_PARTIAL_WITH_BLOCKERS`

## Fecha
2026-06-03

## Repos revisados

- `universo-rey/cabina-universal-d`
- `universo-rey/organizacion`
- `SeshatSgin/torre-gemela-escribania`
- `SeshatSgin/tge-agentic-runtime-control-escribania`
- `SeshatSgin/sgin-cumplimiento`
- `universo-rey/Sgin`
- `SeshatSgin/sdu-canon`
- `SeshatSgin/seshat-bootstrap-sdu-cn`
- `SeshatSgin/tcu-agentic-runtime-control`
- `universo-rey/microsoft-agents-governed-lab`
- `SeshatSgin/seshat-bootstrap-sdu-cn` anidado en TGE como overlap read-only.

## Conexiones detectadas

- Instancias: 28751.
- Superficies: 15.
- Top superficies: SharePoint, Microsoft Graph, Power Platform Admin, Planner,
  OpenAI API, Entra ID, Microsoft 365 Admin, MCP Server, Agents SDK, Teams,
  Azure OpenAI, GitHub Actions y Semantic Kernel.

## Conexiones bloqueadas

- 1077 instancias quedan `BLOCKED_SECURITY_REVIEW` por marcadores de PROD,
  secret, tenant o stop condition que requieren lectura humana antes de uso.
- 1 repo queda `MISSING_LOCAL_OR_NOT_REGISTERED`: `SGIN_CANONICO`.

## Conexiones reutilizables

- 2514 instancias low-risk se pueden reutilizar como referencia local/GitHub
  bajo gate, sin live.
- Cualquier reutilizacion live requiere gate especifico y no se deriva de este
  inventario.

## Conexiones solo patron

- 578 instancias quedan `DETECTED_PATTERN_ONLY`.
- No se convierten en conectores operativos sin target, identidad y evidencia.

## Conexiones reales Escribania

- Tenant scope `ESCRIBANIA`: 23567 instancias locales.
- Incluye TGE, TGE runtime, SGIN cumplimiento, SGIN, Microsoft Agents Lab y
  overlap Seshat anidado.

## Conexiones agentic lab

- `universo-rey/microsoft-agents-governed-lab`: 5879 instancias.
- Principales superficies: Microsoft 365 Admin, Entra ID, Graph, Codex
  Connector, Agents SDK, OpenAI API, Azure OpenAI, SharePoint y Teams.
- Estado: local inventory only, no Microsoft live.

## Duplicados y overlaps

- Overlap rows: 3493.
- El clon Seshat anidado dentro de TGE se registra como overlap, con el clon
  de Corte como autoridad primaria.

## Riesgos

- 1080 critical markers requieren revision antes de cualquier uso.
- 24711 high-risk son superficies Microsoft/Power Platform/secret-required
  o similares y quedan gated.
- 24 archivos sensibles por nombre fueron omitidos sin leer valores.

## Gates pendientes

- Microsoft live governed order para Graph, SharePoint, Planner, Teams, Entra
  y M365.
- Dataverse DEV explicit target antes de cualquier apply.
- OpenAI live governed order para OpenAI API, Responses, Agents SDK o Azure
  OpenAI.
- Repo local mapping para `SGIN_CANONICO`.

## Recomendacion para Dataverse

Sembrar primero `CONNECTION_SURFACE_INVENTORY`, `CONNECTION_GATE_MATRIX`,
`CONNECTION_RISK_MATRIX` y `CONNECTION_SECRET_BOUNDARY_MATRIX`. Mantener
`CONNECTION_INSTANCE_INVENTORY` como evidencia pesada hasta deduplicar por
file/section. No aplicar si el ambiente es Default o DEV sigue `[POR DEFINIR]`.

## Proximo paso exacto

Definir si `SGIN_CANONICO` queda fuera de alcance o se registra con ruta local;
despues deduplicar `CONNECTION_INSTANCE_INVENTORY` por repo/surface/file/section
antes de sembrarlo en Dataverse DEV.
