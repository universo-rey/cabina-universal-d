# SDU Codex Cloud DEV Activation Plan 20260603

Estado: `CODEX_CLOUD_DEV_ACTIVATION_GATE_PREPARED`

## Objetivo

Preparar un probe DEV repo-scoped para Codex Cloud sobre `universo-rey/cabina-universal-d`, usando branch fija y validadores locales, sin apply remoto ni cambios no revisados.

## Superficie Permitida

- repo visible;
- branch `codex/sdu-agents-teams-identity-mcp-codex-cloud-dev-activation-20260603`;
- validadores SDU y cabina;
- readback saneado.

## Acciones Permitidas

- leer `D:/AGENTS.md` o su equivalente checkout;
- leer matrices, manifests y contratos;
- ejecutar validadores repo-scoped;
- devolver evidencia sin secretos.

## Acciones Bloqueadas

- `codex_cloud_apply`;
- Microsoft live;
- OpenAI live;
- produccion;
- permisos;
- secretos;
- datos regulados amplios;
- escritura remota MCP.

## Probe Template

`.codex/cloud/sdu-agents/task_templates/dev_activation_probe.md`

## Rollback

Si el probe futuro no aplica cambios, no hay rollback remoto. Si genera propuesta de diff, cerrar la tarea o descartar el PR. Ningun tenant queda afectado.

## Stop Conditions

`CODEX_CLOUD_APPLY_ATTEMPTED`, `OPENAI_LIVE_ATTEMPTED`, `MICROSOFT_LIVE_WRITE_ATTEMPTED`, `SECRET_DETECTED`, `PRODUCTION_MUTATION_ATTEMPTED`, `MCP_REMOTE_WRITE_ATTEMPTED`.
