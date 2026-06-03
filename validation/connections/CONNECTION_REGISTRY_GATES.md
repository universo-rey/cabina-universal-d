# Connection Registry Gates

## GitHub

- Gate: `GATE_GITHUB_REPO_SCOPED`
- Permitido: inventario, branch, PR y checks bajo orden GitHub.
- Bloqueado: force push, permisos, secretos y merge sin precheck.

## Microsoft / M365 / Graph / SharePoint / Planner / Teams

- Gate: `GATE_MICROSOFT_LIVE_GOVERNED_ORDER`
- Requiere: tenant, identidad, superficie, objeto exacto, accion, limite de
  datos, rollback, postcheck, evidencia y stop condition.
- Bloqueado: live auth nueva, write ciego, produccion, permisos y dumps.

## Power Platform / Dataverse / PAC

- Gate: `GATE_POWER_PLATFORM_DEV_TARGET_EXPLICIT`
- Requiere: ambiente DEV no Default, tenant, solution, publisher, rollback y
  postcheck.
- Bloqueado: Default como DEV, PROD, import/apply sin sandbox explicito.

## OpenAI / Responses / Agents SDK / Azure OpenAI

- Gate: `GATE_OPENAI_LIVE_GOVERNED_ORDER`
- Requiere: payload sintetico, secreto externo, no body completo y evidencia.
- Bloqueado: secretos, datos reales/regulados y costos abiertos.

## MCP / Codex Connector

- Gate: `GATE_CONNECTOR_REGISTRY_NO_SECRET`
- Requiere: scope, owner, allowlist, secret boundary y rollback si escribe.
- Bloqueado: persistir credenciales o simular conector no disponible.
