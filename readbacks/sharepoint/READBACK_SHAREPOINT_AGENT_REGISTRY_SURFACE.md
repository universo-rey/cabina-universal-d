# Readback: SharePoint Agent Registry Surface

## Status
SHAREPOINT_AGENT_REGISTRY_SURFACE_REVIEWED

## Site Confirmed
- Site: `Innovación y Desarrollo`
- URL: `https://escribaniabitsch.sharepoint.com/sites/soporte`
- Site id: `escribaniabitsch.sharepoint.com,de3a5abc-5bfa-4c3a-8fd0-c87661ee1772,923619dc-79e0-47ea-b18c-453d20575087`

## Usable Surfaces
- Document libraries confirmed: `Documentos`, `Proyectos y Tareas`, `Expedientes`
- These are usable as evidence/document surfaces, not as the structured agent registry itself.

## Registry Tables
- Model-documented tables/lists: `19`
- Live SharePoint lists confirmed from the Excel metadata: `22`
- Tables with explicit column templates recovered from the site documents: `16`
- Tables only mentioned conceptually in the model document: `3`

## Live vs Model Gap
- The SharePoint site includes `3` live lists not described in the `19`-list model document:
  - `Hilos`
  - `Paginas`
  - `Paginas Canonicas`
- That means the site registry is broader than the narrative model and includes extra support/navigation surfaces.

## Live List Evidence
- `Agentes` list id `56cb1117-ac65-4b80-bfae-d81d2f1f1599`, item count `8`
- `Temas` list id `d07c1598-2e80-4cf2-a5aa-c448c43b5e3f`, item count `0`
- `Fuentes de conocimiento` list id `7a3e2aa8-78d3-452b-9c33-4c5e95ba80eb`, item count `0`
- `Herramientas` list id `a3a7dab3-5a5d-4f5d-82e3-6a5dae9fad44`, item count `0`
- `Casos gestionados` list id `1bce5654-2ea0-4de7-ac14-96c66318146e`, item count `0`
- `Acciones generadas` list id `66213ea6-f754-419b-855f-8fecbae4cf69`, item count `0`
- `RACI del agente` list id `4d5b0e21-d412-4dc0-b8c7-6d0d2137e269`, item count `0`
- `KPIs del agente` list id `bf45d12a-9be0-4fea-a29c-5d5b92d788e9`, item count `0`
- `Pruebas del agente` list id `dd732500-9a08-4c34-a447-a090714d3bfd`, item count `0`
- `Bitácora editorial` list id `384c67e1-b766-4c3f-9464-a1b2dd34050c`, item count `0`
- `Política de permisos` list id `88762a2c-6291-4c78-b08a-0d1d6822f5f5`, item count `0`
- `Riesgos del agente` list id `cafaa091-4726-4c5c-bc07-013c0716c8b5`, item count `0`
- `Patrones de Prompt` list id `de6aacfb-c4b1-442f-83e8-2b4b794c914b`, item count `0`
- `Tipos de entrada` list id `1fa1929d-59e7-4aef-824a-4b2a41ebf57d`, item count `0`
- `Versiones del agente` list id `0044c7dc-6246-40a3-831f-0ecd7e982015`, item count `0`

## What Can Be Used Now
- The model document gives the canonical list architecture.
- The Excel model gives live list IDs, container types, item counts and the field map for the registry tables.
- The Excel-ready document gives explicit column templates for most core tables.
- The three document libraries can hold evidence, templates, and working docs.

## What Is Still Missing
- Exact SharePoint list internal names
- Exact SharePoint list IDs
- Exact internal names for each field
- Required vs optional field flags
- Verification that the current live lists still match the document model 1:1

## Partial Tables
- `Capacidades del agente`
- `Patrones de Prompt`
- `Tipos de entrada`

## Core Relationships
- `Agentes` is the root table.
- `Versiones del agente`, `Temas`, `Herramientas`, `RACI`, `KPIs`, `Política de permisos`, `Riesgos`, `Bitácora editorial` all look up to `Agentes`.
- `Tema - Conocimiento` bridges `Temas` with `Fuentes de conocimiento`.
- `Tema - Herramienta` bridges `Temas` with `Herramientas`.
- `Pruebas del agente` looks up to `Agentes` and `Temas`.
- `Capacidades del agente` looks up to `Agentes` and multiple `Temas`.
- `Casos gestionados` looks up to `Agentes`.
- `Acciones generadas` looks up to `Agentes`, `Temas`, and `Casos gestionados`.

## Practical Conclusion
- We can already design the register and its relationship graph.
- We now have live list metadata for the registry tables from the Excel model.
- The remaining gap is a connector read of SharePoint list field metadata to confirm required/optional flags and any drift from the documented model.

## Evidence
- [SHAREPOINT_AGENT_REGISTRY_SURFACE_MATRIX.csv](/C:/Users/enzo1/Documents/GitHub/cabina-universal-d/matrices/sharepoint/SHAREPOINT_AGENT_REGISTRY_SURFACE_MATRIX.csv)
- [MODELO MAESTRO DE AGENTES – DOCUMENTACIÓN FINAL.docx](https://escribaniabitsch.sharepoint.com/sites/soporte/_layouts/15/Doc.aspx?sourcedoc=%7BB745510C-1D72-4B46-9481-07C71695B805%7D&file=MODELO+MAESTRO+DE+AGENTES+%E2%80%93+DOCUMENTACI%C3%93N+FINAL.docx&action=default&mobileredirect=true&web=1)
- [MANUAL PARA USUARIOS FINALES.docx](https://escribaniabitsch.sharepoint.com/sites/soporte/_layouts/15/Doc.aspx?sourcedoc=%7BA6C2D19C-19DA-482C-BDD3-2F10F896EA35%7D&file=MANUAL+PARA+USUARIOS+FINALES.docx&action=default&mobileredirect=true&web=1)
- [Tabla lista para copiar en Excel.docx](https://escribaniabitsch.sharepoint.com/sites/soporte/_layouts/15/Doc.aspx?sourcedoc=%7B2DBD6818-B2EA-4C52-A535-2343A9F0A81B%7D&file=Tabla+lista+para+copiar+en+Excel.docx&action=default&mobileredirect=true&web=1)

## Next Step
- If you want, I can turn this into a clean implementation plan for the site registry, with the exact minimum fields we should register first and the missing metadata probe we need next.
