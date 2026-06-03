# SDU DEV Activation Probe

Repo: `universo-rey/cabina-universal-d`

Branch: `codex/sdu-agents-teams-identity-mcp-codex-cloud-dev-activation-20260603`

Estado esperado: `DEV_ACTIVATION_PROBE_READY`

## Mandato

Revisar el paquete DEV de Teams identity, MCP, Codex Cloud y local-agent-bridge. Ejecutar validadores disponibles y devolver readback. No aplicar cambios automaticos.

## Read Scope

- `D:/AGENTS.md` equivalent in checkout;
- `governance/teams/**`;
- `governance/connections/**`;
- `governance/codex-cloud/**`;
- `teams-app/sdu-agent-chat/dev-package/**`;
- `local-agent-bridge/dev.activation.contract.yml`;
- `scripts/validators/sdu_*dev_activation*_validator.py`;
- `readbacks/20260603_SDU_TEAMS_MCP_CODEX_CLOUD_DEV_ACTIVATION_READY_READBACK.md`.

## Allowed Actions

- read repo files;
- run validators;
- report status;
- propose PR comment only if explicitly requested.

## Blocked Actions

- codex cloud apply;
- Teams install;
- Teams message;
- Graph write;
- Microsoft live write;
- OpenAI live;
- production mutation;
- permission change;
- secret materialization.

## Required Output

- checks executed;
- evidence path;
- blocked surfaces confirmed;
- rollback;
- exact next gate.
