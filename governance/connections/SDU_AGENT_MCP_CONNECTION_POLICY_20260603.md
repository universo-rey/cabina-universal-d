# SDU Agent MCP Connection Policy 20260603

## Alcance

Esta politica gobierna conexiones MCP y equivalentes tool-surface para el plano
DEV de agentes SDU en `universo-rey/cabina-universal-d`.

## Reglas

- Cada conexion debe existir en
  `governance/connections/MCP_CONNECTION_REGISTRY_20260603.csv`.
- Las herramientas con escritura quedan bloqueadas hasta gate humano explicito.
- Las superficies Microsoft son `ENABLED_GOVERNED_GATED_NOT_EXECUTED`.
- Codex Cloud solo queda preparado como plantilla repo-scoped; no hay apply.
- OpenAI API y Responses API solo quedan como contrato; no hay llamada live.
- El puente local usa loopback y payload sintetico saneado.
- Ninguna conexion puede requerir material sensible versionado.

## Criterio de confianza

`trusted_repo_scope` permite GitHub repo-scoped bajo orden aprobada. Las
superficies Microsoft, OpenAI y Codex Cloud con potencial live quedan
`governed_gated` y requieren identidad, objeto, rollback, postcheck y
evidencia antes de ejecutar.

## Stop conditions

- `MCP_WRITE_WITHOUT_APPROVAL`
- `MCP_SERVER_UNTRUSTED_WITH_WRITE`
- `TEAMS_MESSAGE_SENT_WITHOUT_GATE`
- `CODEX_CLOUD_LIVE_WRITE_ATTEMPTED`
- `OPENAI_LIVE_EXECUTED_WITHOUT_GATE`
- `SECRET_DETECTED`

## Estado

`SDU_AGENT_MCP_CONNECTION_POLICY_ACTIVE_DEV`
