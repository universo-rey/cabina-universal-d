# VSI Function Utilization No-PS Readback

estado: EXECUTED_LOCAL_VALIDATED

superficie: VS Code Insiders repo-local no-PS

acciones:
- Captura visual revisada: Memory y Memory Log aparecen sin actividad visual.
- Estado VSI revisado con `code-insiders --status`.
- Extensiones VSI revisadas con `code-insiders --list-extensions --show-versions`.
- Matriz creada para separar funciones instaladas, activas, subutilizadas, no deseadas y con drift.
- Tarea VSI `Cabina: Validate VSI function utilization` registrada como `type=process`.
- Memory/Memory Log activados como evidencia gobernada repo-local mediante workpaper `EVIDENCE_LOG.csv`.

evidencia:
- Screenshot local: `C:\Users\enzo1\CodexLocal\OPTIMIZACION_PC\vsi-screen-20260607-194445.png`.
- Matriz: `.agents/codex/matrices/VSI_FUNCTION_UTILIZATION_MATRIX_20260607.csv`.
- Validator: `scripts/validators/vsi_function_utilization_validator.py`.
- Workpaper evidence ids: `EVD-VSI-FUNCTION-UTILIZATION-20260607`.

validadores:
- `python scripts/validators/vsi_function_utilization_validator.py`: PASS
- `python scripts/validators/vsi_usage_expansion_validator.py`: PASS
- `python scripts/validators/no_ps_validator_prep_validator.py`: PASS
- `python scripts/validators/vsi_memory_log_no_ps_validator.py`: PASS
- `python scripts/validators/readonly_task_preparation_validator.py`: PASS
- `git diff --check`: PASS con avisos de fin de linea en archivos Python existentes.

tasks_ui:
- `.vscode/tasks.json` registra `Cabina: Validate VSI function utilization` como `type=process`.
- `code-insiders --help` no expone ejecucion directa de task por label desde CLI.
- La ejecucion local se hizo con el mismo comando declarado por la task: `python scripts/validators/vsi_function_utilization_validator.py`.

riesgo:
- Bajo. No se ejecutaron writes live, secretos, tenant, produccion ni metadata Git critica.

gate:
- Ninguno.

rollback:
- `git restore -- .agents/codex/matrices/VSI_FUNCTION_UTILIZATION_MATRIX_20260607.csv scripts/validators/vsi_function_utilization_validator.py .vscode/tasks.json scripts/validators/vsi_usage_expansion_validator.py scripts/validators/no_ps_validator_prep_validator.py .agents/codex/matrices/VSI_USAGE_EXPANSION_MATRIX_20260607.csv .agents/codex/matrices/NO_PS_VALIDATOR_PREP_MATRIX_20260607.csv .agents/codex/matrices/VALIDATION_COVERAGE_MATRIX.csv .agents/codex/matrices/MATRIX_INDEX.csv .agents/codex/matrices/VSCODE_INSIDERS_AGENT_TASK_QUEUE_20260606.csv C:\Users\enzo1\.codex\workpapers/codex.workspace_guardian/EVIDENCE_LOG.csv C:\Users\enzo1\.codex\workpapers/court.seshat_evidence/EVIDENCE_LOG.csv .agents/codex/readbacks/2026-06-07_vsi_function_utilization_no_ps_readback.md`

stop_condition:
- `vsi_function_utilization_invalid`
