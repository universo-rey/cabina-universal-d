---
name: governed-readback-closeout
description: Use when closing .agents\codex local work, especially after changing matrices, recipes, skills, tools, agents, maps, validators, or Codex routing.
---

# Governed Readback Closeout

## Core Rule

Do not claim closure until the local evidence and validator result are written down.

## Minimum Readback

Use this structure:

```markdown
# READBACK_<FRONT>_<YYYYMMDD>

## Estado
HECHO_VERIFICADO:

## Sistemas tocados

## Sistemas no tocados

## Cambios

## Validacion

## Riesgos

## Proximos carriles
```

## Validation Order

1. Run the most specific local validator.
2. Run `local_validate_agent_layer.ps1` when the agent layer changed.
3. Run a secret-pattern scan over touched local files.
4. Check that no Git, Microsoft, OpenAI live, SharePoint, Power Platform, tenant, or secret surface was touched unless explicitly ordered.

## Stop Conditions

- Validator not run.
- Readback omits touched systems.
- Secret-like content is present.
- External surface was touched without an order and postcheck.
