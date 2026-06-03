# PR65 Merge Rollback Plan

## Estado
PR65_ROLLBACK_PLAN_READY

## Merge
- PR: https://github.com/universo-rey/cabina-universal-d/pull/65
- Merge commit: d09a7a5300efcf6738b98c5c0115b2647425b352
- main local SHA al postcheck: d09a7a5300efcf6738b98c5c0115b2647425b352
- origin/main SHA al postcheck: d09a7a5300efcf6738b98c5c0115b2647425b352

## Regla
No usar reset hard sobre main remoto. No force push. No borrar rama remota sin orden posterior.

## Procedimiento revert gobernado
1. Crear rama desde main sincronizado:

`powershell
git checkout main
git pull --ff-only origin main
git checkout -b codex/revert-pr65-20260603
`

2. Revertir el merge commit preservando evidencia:

`powershell
git revert -m 1 d09a7a5300efcf6738b98c5c0115b2647425b352
`

3. Ejecutar validadores proporcionales:

`powershell
git diff --check
pwsh -NoProfile -File D:\.agents\codex\tools\local_run_governance_validation_suite.ps1 -Root D:\.agents\codex -RepoRoot D:\
python D:\dataverse\scripts\detect_dataverse_drift.py
pwsh -NoProfile -File D:\dataverse\scripts\validate_dataverse_manifest.ps1 -Root D:\
`

4. Push normal y PR revert, sin squash/rebase/force push.

## Fronteras
- No ejecutar Dataverse live.
- No ejecutar Power Automate live.
- No ejecutar OpenAI API.
- No enviar Batch API.
- No tocar PROD, TEST ni Default.
- No activar flows.
- No modificar permisos.
- No imprimir secretos.

## Stop condition
Detener si el revert toca secretos, PROD/TEST/Default, activa flows, requiere live externo o no puede validar localmente.
