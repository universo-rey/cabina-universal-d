# MCP_ACTIVE_EXECUTION_POLICY_20260603

Estado: `MCP_ACTIVE_EXECUTION_POLICY_READY`

## Regla

MCP read-only y mock se ejecutan por defecto cuando el registry y el contrato existen. MCP write queda `EXECUTE_LIVE_WRITE_GATED_NOW` solo cuando el tool, objeto, identidad, rollback, postcheck y evidencia estan completos.

## Ejecutar ahora

- Probe MCP DEV: `python scripts/validators/sdu_mcp_dev_activation_validator.py`.
- Bridge local mock: `node local-agent-bridge/tests/mock_bridge_flow.mjs`.
- Secret contract: `python scripts/validators/sdu_dev_activation_secret_contract_validator.py`.

## Pendientes exactos

- MCP write DEV: `PENDING_TARGET_ONLY` hasta seleccionar servidor/tool/objeto.
- MCP remoto con secreto: `PENDING_SECRET_ONLY` hasta que el secreto exista en store gobernado externo y no se materialice en repo.

## Stop conditions

stop_condition:

`MCP_REMOTE_WRITE_ATTEMPTED`, `MCP_WRITE_TARGET_MISSING`, `SECRET_DETECTED`, `BLOCKED_TENANT_AMBIGUOUS`.
