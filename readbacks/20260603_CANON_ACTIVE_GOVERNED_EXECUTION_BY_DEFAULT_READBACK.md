# 20260603 Canon Active Governed Execution By Default Readback

Estado final esperado: `CANON_ACTIVE_GOVERNED_EXECUTION_BY_DEFAULT_READY_FOR_REVIEW`

## Decision canonica

La cabina adopta `ACTIVE_GOVERNED_EXECUTION_BY_DEFAULT`: ejecutar por defecto
lo local, mock, DEV, read-only, smoke y live-gated cuando el subpaso sea seguro,
reversible, trazable y validable. Los cierres pasivos quedan reemplazados por
estados exactos:

- `EXECUTE_LOCAL_NOW`
- `EXECUTE_MOCK_NOW`
- `EXECUTE_DEV_NOW`
- `EXECUTE_LIVE_READ_NOW`
- `EXECUTE_LIVE_WRITE_GATED_NOW`
- `EXECUTE_CODEX_CLOUD_SMOKE_NOW`
- `EXECUTE_MCP_READ_PROBE_NOW`
- `EXECUTE_TEAMS_DEV_TEST_NOW`
- `PENDING_TARGET_ONLY`
- `PENDING_SECRET_ONLY`
- `PENDING_IDENTITY_ONLY`
- `PENDING_OWNER_ONLY`
- `READY_FOR_PROD_HUMAN_GATE`
- `BLOCKED_SECURITY_RISK`
- `BLOCKED_SECRET_EXPOSURE`
- `BLOCKED_TENANT_AMBIGUOUS`
- `BLOCKED_PRODUCTION_UNAPPROVED`

## Artefactos

- Politica madre: `governance/canon/ACTIVE_GOVERNED_EXECUTION_BY_DEFAULT_POLICY_20260603.md`.
- Matriz activa: `governance/canon/ACTIVE_EXECUTION_CAPABILITY_MATRIX_20260603.csv`.
- Auditoria de lenguaje conservador: `governance/canon/CANON_CONSERVATIVE_LANGUAGE_AUDIT_20260603.md`.
- Politica Teams DEV: `governance/teams/TEAMS_ACTIVE_DEV_EXECUTION_POLICY_20260603.md`.
- Politica MCP: `governance/connections/MCP_ACTIVE_EXECUTION_POLICY_20260603.md`.
- Politica Codex Cloud: `governance/codex-cloud/CODEX_CLOUD_ACTIVE_EXECUTION_POLICY_20260603.md`.
- Validadores nuevos en `scripts/validators/`.
- Workflow repo-scoped: `.github/workflows/active-governed-execution-validation.yml`.

## Ejecucion

Se ejecuto evidencia local/mock/DEV y un smoke Codex Cloud read-only. La tarea
Cloud produjo `task_e_6a20a9c306c0832e940f4e416165494c`; el postcheck quedo
registrado como `CLOUD_TASK_CREATED_STATUS_ERROR_NO_DIFF_AVAILABLE`, por lo que
no se la declara como READY.

## No ejecutado

- No Teams install.
- No Teams message.
- No Graph write.
- No SharePoint write.
- No Planner write.
- No Dataverse write.
- No Power Platform apply.
- No OpenAI API live.
- No Codex Cloud apply.
- No produccion.
- No permisos.
- No secretos.

## Validadores esperados

- `ACTIVE_GOVERNED_EXECUTION_POLICY_VALIDATOR=PASS`
- `ACTIVE_EXECUTION_CAPABILITY_MATRIX_VALIDATOR=PASS`
- `NO_PASSIVE_BLOCKING_LANGUAGE_VALIDATOR=PASS`
- `DEV_EXECUTION_ATTEMPT_VALIDATOR=PASS`
- `SDU_TEAMS_IDENTITY_DEV_ACTIVATION_VALIDATOR=PASS`
- `SDU_MCP_DEV_ACTIVATION_VALIDATOR=PASS`
- `SDU_LOCAL_BRIDGE_DEV_ACTIVATION_VALIDATOR=PASS`
- `SDU_CODEX_CLOUD_DEV_ACTIVATION_VALIDATOR=PASS`
- `SDU_DEV_ACTIVATION_SECRET_CONTRACT_VALIDATOR=PASS`
- `SDU_LOCAL_AGENT_BRIDGE_MOCK_FLOW_PASS`
- `SDU_TEAMS_CHAT_BOT_DEV_MOCK_PASS`
- `SDU_DEV_ACTIVATION_CONTRACT_TEST_PASS`
- Synthetic E2E simulation `status=PASS`.
- Structured JSON/CSV parse and `git diff --check`: `PASS`.
- GitHub automation preflight: `PASS`, `smoke=OK_NO_API_CALL`.
- Change-aware full coverage orchestrator: `PASS`,
  `all_required_passed=true`, `coverage_equivalence=true`,
  `manifest_valid=true`, `graph_valid=true`, `no_hidden_flaky=true`,
  `blocked_surfaces_clear=true`, `result_written=true`.

## Rollback

Revertir el commit de este PR o cerrar el PR. No hay rollback tenant ni
produccion porque no hubo mutacion live.

## Proximo gate

Revisar PR y, si corresponde, aprobar merge con HEAD fijo y checks verdes.
Luego abrir carriles live concretos solo con target exacto, identidad, owner,
rollback, postcheck, evidencia y stop condition.

Stop condition: `ACTIVE_EXECUTION_PRECHECK_FAILED`.
