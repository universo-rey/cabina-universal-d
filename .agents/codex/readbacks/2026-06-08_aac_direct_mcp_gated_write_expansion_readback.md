# AAC Direct MCP Gated Write Expansion Readback - 2026-06-08

## Orden

Usar `aac-direct` desde el cliente MCP del workspace y ampliar a writes solo
con `target`, `owner`, `rollback`, `postcheck` y `gate`.

## Alcance

- Workspace: `C:\Users\enzo1\Documents\GitHub\cabina-universal-d`
- Superficie: repo-local MCP stdio
- Servidor: `.vscode/mcp.json` -> `aac-direct`
- Runtime: `node ${workspaceFolder}/aac-mcp-server/src/index.mjs`
- No ejecuta OpenAI API live, Microsoft live, produccion, secretos, remotos ni
  proveedores externos.

## Resultado

`aac-direct` queda ampliado con `aac_write_artifact_gated`.

La herramienta permite preparar y validar un write sobre artefactos AAC
allowlistados. La escritura repo-local solo se ejecuta cuando:

- `target_path` es exacto y esta en allowlist;
- `owner` esta declarado;
- `rollback` esta declarado;
- `postcheck` contiene al menos una accion concreta;
- `gate.gate_id`, `gate.approval_status` y `gate.approval_ref` estan
  declarados;
- `gate.approval_status=APPROVED_EXPLICIT`;
- `execute=true`.

Con `execute=false`, o sin aprobacion explicita, la herramienta devuelve
`PREPARED_NOT_EXECUTED` o `PENDING_APPROVAL_ONLY` y no escribe.

## Allowlist de write

- `.agileagentcanvas-context/vision.json`
- `.agileagentcanvas-context/discovery/product-brief.json`
- `.agileagentcanvas-context/planning/prd.json`
- `.agileagentcanvas-context/planning/epics.json`
- `.agileagentcanvas-context/bmm/sprint-status.json`

## Evidencia

- `npm test --prefix aac-mcp-server` -> `AAC_MCP_SERVER_MOCK_FLOW_PASS`
- `python scripts\validators\aac_mcp_server_validator.py` ->
  `AAC_MCP_SERVER_VALIDATOR=PASS`

## Stop condition

`aac_direct_mcp_gated_write_ready_no_artifact_write_executed`

No se ejecuto write real sobre artefactos AAC en este carril porque no hubo
target/content de negocio aprobado para mutar el tablero. Queda listo para
ejecucion repo-local gated con la orden completa.
