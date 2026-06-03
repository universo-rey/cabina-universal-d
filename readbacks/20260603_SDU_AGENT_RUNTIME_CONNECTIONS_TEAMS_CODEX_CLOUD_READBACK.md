# SDU Agent Runtime Connections Teams Codex Cloud Readback 20260603

## Estado

`SDU_AGENTS_RUNTIME_CONNECTIONS_TEAMS_CHAT_CODEX_CLOUD_DEV_READY_FOR_REVIEW`

## PR

Pendiente de apertura despues del commit de esta rama.

## Scope materializado

- Capability discovery y assignment matrix.
- MCP registry y policy DEV.
- Teams chat identity model y Teams App/Bot scaffold.
- Local agent bridge mock con contrato, rutas, politica y test.
- Codex Cloud repo-scoped DEV pack con cinco task templates.
- Matriz unificada Teams -> MCP -> Codex Cloud.
- Contrato de variables sin material sensible.
- Modelo de evidencia y esquemas.
- Validadores y workflow repo-scoped.

## Checks

Ejecutados localmente:

- `sdu_agent_capability_assignment_validator.py`: PASS.
- `mcp_connection_registry_validator.py`: PASS.
- `sdu_teams_chat_identity_validator.py`: PASS.
- `local_agent_bridge_validator.py`: PASS.
- `sdu_codex_cloud_assignment_validator.py`: PASS.
- `sdu_agent_connection_secrets_contract_validator.py`: PASS.
- `sdu_agent_runtime_evidence_validator.py`: PASS.
- `npm test --prefix local-agent-bridge`: PASS.
- `npm test --prefix teams-app/sdu-agent-chat/bot`: PASS.
- `simulate_sdu_agent_chat_to_tool_to_readback.py`: PASS.
- Structured JSON/CSV/profile parse: PASS.
- Sensitive pattern scan: PASS.
- `local_validate_agent_layer.ps1 -SkipWorkflowNestedValidators`: PASS after
  recreating local ignored `80_REFERENCIAS_TECNICAS` in the auxiliary
  worktree.
- `git diff --check`: PASS.

## Decision rectora

Seshat canoniza agentes; la cabina prepara conexiones DEV y evidencia. TGE no
se usa como fuente madre. No se crea septimo agente.

## No live

- No Teams live install.
- No Teams live message.
- No Graph write.
- No OpenAI live.
- No Codex Cloud apply.
- No production.
- No permisos.
- No material sensible.

## rollback

Revertir el commit de la rama o cerrar el PR elimina los artefactos DEV. No hay
rollback tenant porque no se ejecuto tenant write.

## proximo gate

Revision humana del PR. Cualquier live posterior requiere orden separada con
identidad, target exacto, owner, rollback, postcheck, evidencia y stop
condition.
