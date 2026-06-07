# Control de Agentes de la Cabina Universal

Esta carpeta es la mesa local de Agile Agent Canvas para Visual Studio Code
Insiders.

Artefactos raiz versionados:

- `vision.json`
- `discovery/product-brief.json`
- `planning/prd.json`
- `planning/epics.json`

Carril activo:

- `agile_canvas_programming_lane`
- owner: `codex.workspace_guardian`
- reviewer: `court.seshat_evidence`
- lock: `lock.vsi.aac_programming_lane`
- estado: `ACTIVE_LOCAL_GOVERNED_USE`
- scope: artefactos Agile Agent Canvas, tablero local y cola VSI allowlisted

Frontera operativa:

- solo artefactos locales del workspace
- sin claves API, tokens Jira, tenants, datos productivos, secretos, escrituras
  externas, instalacion de hooks Git, clonacion de repos de skills ni ejecucion
  cloud
- los proveedores live requieren orden gobernada explicita con target, owner,
  rollback, postcheck, evidencia, validador y stop condition

Rollback:

```powershell
git restore --staged .agileagentcanvas-context/README.md .agileagentcanvas-context/vision.json .agileagentcanvas-context/discovery/product-brief.json .agileagentcanvas-context/planning/prd.json .agileagentcanvas-context/planning/epics.json
git restore .agileagentcanvas-context/README.md .agileagentcanvas-context/vision.json .agileagentcanvas-context/discovery/product-brief.json .agileagentcanvas-context/planning/prd.json .agileagentcanvas-context/planning/epics.json
```
