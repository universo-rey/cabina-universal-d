# VSI usage expansion no-PS readback

- agente: codex.workspace_guardian
- orden: ampliar uso de Visual Studio Insiders
- superficie: VS Code Insiders repo-local tasks and validators
- repo: universo-rey/cabina-universal-d
- branch: codex/vsi-usage-expansion-no-ps-20260607
- estado: EXECUTED_LOCAL_VALIDATED

## Acciones

- Se agrega `.vscode/tasks.json` con tareas `type=process` para uso directo desde VSI.
- Se agregan tareas para validadores Python, `git diff --check` y `code-insiders --status`.
- Se agrega `.agents/codex/matrices/VSI_USAGE_EXPANSION_MATRIX_20260607.csv`.
- Se agrega `scripts/validators/vsi_usage_expansion_validator.py`.
- Se bloquean comandos PowerShell, pwsh, `.ps1`, encoded command y Start-Process para el carril nuevo.

## Evidencia esperada

```text
python scripts/validators/vsi_usage_expansion_validator.py
python scripts/validators/vsi_memory_log_no_ps_validator.py
python scripts/validators/no_ps_validator_prep_validator.py
python scripts/validators/readonly_task_preparation_validator.py
python -m py_compile scripts/validators/vsi_usage_expansion_validator.py scripts/validators/vsi_memory_log_no_ps_validator.py scripts/validators/no_ps_validator_prep_validator.py scripts/validators/readonly_task_preparation_validator.py
git diff --check
code-insiders --version
```

## Evidencia ejecutada

- `python scripts/validators/vsi_usage_expansion_validator.py`: PASS
- `python scripts/validators/vsi_memory_log_no_ps_validator.py`: PASS
- `python scripts/validators/no_ps_validator_prep_validator.py`: PASS
- `python scripts/validators/readonly_task_preparation_validator.py`: PASS
- `python -m py_compile scripts/validators/vsi_usage_expansion_validator.py scripts/validators/vsi_memory_log_no_ps_validator.py scripts/validators/no_ps_validator_prep_validator.py scripts/validators/readonly_task_preparation_validator.py`: PASS
- `git diff --check`: PASS
- `code-insiders --version`: `1.124.0-insider`, commit `0035c783eccf8a2efbdb972dfe62becb51f11fc6`, `x64`
- `code-insiders --status`: VSI activo en `Agile Agent Canvas - cabina-universal-d - Visual Studio Code - Insiders`.
- `git check-ignore -v .vscode/tasks.json`: allowlist por `.gitignore` para versionar solo tasks.
- `git check-ignore -v .vscode/settings.json`: sigue ignorado; settings permanecen locales.

## Rollback

```text
git restore -- .gitignore .vscode/tasks.json .agents/codex/matrices/VSI_USAGE_EXPANSION_MATRIX_20260607.csv scripts/validators/vsi_usage_expansion_validator.py scripts/validators/no_ps_validator_prep_validator.py .agents/codex/matrices/NO_PS_VALIDATOR_PREP_MATRIX_20260607.csv .agents/codex/matrices/VALIDATION_COVERAGE_MATRIX.csv .agents/codex/matrices/MATRIX_INDEX.csv .agents/codex/matrices/VSCODE_INSIDERS_AGENT_TASK_QUEUE_20260606.csv .agents/codex/readbacks/2026-06-07_vsi_usage_expansion_no_ps_readback.md
```

## Stop condition

`vsi_usage_expansion_invalid`
`vsi_usage_task_missing`
`ps_runtime_requested`
`secret_detected`
