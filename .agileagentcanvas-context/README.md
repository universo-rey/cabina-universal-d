# Control de Agentes de la Cabina Universal

Esta carpeta es la mesa local de Agile Agent Canvas para Visual Studio Code
Insiders.

Jerarquia de tableros:

- `VSI / Agile Agent Canvas` es el tablero principal madre para leer, crear y
  organizar tareas de Cabina antes de matriz, rama, PR o gate live.
- `Control de Agentes de Cabina` es el tablero de cola/control de agentes:
  readiness, gates visibles, postchecks y filas de cola desde
  `local-agent-bridge`; no es el tablero Agile Agent Canvas ni la fuente
  primaria de creacion.
- `Cola del sitio web` es una cola externa/producto y no queda conectada al
  tablero auxiliar sin target, owner, rollback, postcheck y gate live separado.

Separacion de agentes:

- `AAC_NATIVE_AGENTS` son el equipo nativo del tablero Agile Agent Canvas
  provisto por la extension VSI; viven en
  `.agents/codex/matrices/AAC_NATIVE_AGENTS_20260608.csv` como espejo
  gobernado del manifiesto nativo de la extension. Estado operativo:
  `ACTIVE_AAC_NATIVE_TEAM_GOVERNED`. No reemplazan autoridad Cabina y no
  tienen invocacion directa desde Codex en esta sesion.
- `CABINA_GOVERNANCE_AGENTS_FOR_VSI` son nuestros agentes de trabajo
  gobernado: trabajan sobre el tablero Agile Agent Canvas, lo gobiernan,
  preparan ordenes, revisan evidencia, gatean y validan tarjetas. No son
  agentes nativos AAC y no quedan subordinados al equipo nativo.
  Viven en
  `.agents/codex/matrices/CABINA_GOVERNANCE_AGENTS_FOR_VSI_20260608.csv`.

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
