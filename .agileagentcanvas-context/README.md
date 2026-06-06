# Cabina Universal Agent Control

This folder is the local Agile Agent Canvas workspace for Visual Studio Code
Insiders.

Versioned root artifacts:

- `vision.json`
- `discovery/product-brief.json`
- `planning/prd.json`
- `planning/epics.json`

Operational boundary:

- local workspace artifacts only
- no API keys, Jira tokens, tenants, production data, secrets, external writes,
  Git hook installs, skill repo clones, or cloud execution
- live providers require an explicit governed order with target, owner,
  rollback, postcheck, evidence, validator, and stop condition

Rollback:

```powershell
git restore --staged .agileagentcanvas-context/README.md .agileagentcanvas-context/vision.json .agileagentcanvas-context/discovery/product-brief.json .agileagentcanvas-context/planning/prd.json .agileagentcanvas-context/planning/epics.json
git restore .agileagentcanvas-context/README.md .agileagentcanvas-context/vision.json .agileagentcanvas-context/discovery/product-brief.json .agileagentcanvas-context/planning/prd.json .agileagentcanvas-context/planning/epics.json
```
