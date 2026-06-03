# TEAMS_ACTIVE_DEV_EXECUTION_POLICY_20260603

Estado: `TEAMS_ACTIVE_DEV_EXECUTION_POLICY_READY`

## Regla

Teams DEV no queda en espera documental cuando existen validadores, manifest, mock activity o dry-run local. Se ejecuta validacion DEV ahora. Instalacion real, mensaje real y Graph write se ejecutan solo con target exacto, identidad, owner, rollback, postcheck y evidencia.

## Ejecutar ahora

- Validar manifest DEV y placeholders: `python scripts/validators/sdu_teams_identity_dev_activation_validator.py`.
- Validar contrato DEV integral: `python tests/sdu-agent-runtime/test_dev_activation_contract.py`.
- Validar bridge local/mock si el flujo requiere activity sintetica: `node local-agent-bridge/tests/mock_bridge_flow.mjs`.

## Pendientes exactos

- App install DEV: `PENDING_TARGET_ONLY` hasta tener equipo/chat/canal, app id, owner y rollback de uninstall.
- First message DEV: `PENDING_TARGET_ONLY` hasta tener chat/canal exacto, texto aprobado, identidad `efigueroa@registronotarial8tdf.com.ar`, rollback de delete message y postcheck de message id.
- Graph write DEV: `PENDING_TARGET_ONLY` hasta tener tenant/object/action y rollback exactos.

## Stop conditions

stop_condition:

`SECRET_DETECTED`, `TEAMS_TARGET_MISSING`, `GRAPH_WRITE_TARGET_MISSING`, `BLOCKED_TENANT_AMBIGUOUS`, `BLOCKED_PRODUCTION_UNAPPROVED`.
