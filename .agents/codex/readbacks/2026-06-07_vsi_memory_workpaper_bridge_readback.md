# VSI Memory Workpaper Bridge Readback

estado: EXECUTED_LOCAL_VALIDATED

superficie: VS Code Insiders Agent Memory / repo-local workpaper bridge

acciones:
- Intented to run `Cabina: Validate VSI function utilization` through VS Code
  command URI `workbench.action.tasks.runTask`.
- Captured screenshot after the attempt:
  `C:\Users\enzo1\CodexLocal\OPTIMIZACION_PC\vsi-task_run-20260607-function-utilization.png`.
- Confirmed the command URI did not produce visible task output in VSI.
- Inspected `digitarald.agent-memory@0.1.66` package metadata.
- Confirmed Agent Memory exposes:
  - views: `agentMemory.files`, `agentMemory.activityLog`
  - commands: `agentMemory.refresh`, `agentMemory.clearLogs`, `agentMemory.saveAsMarkdown`
  - language model tool: `memory`
  - settings: `agentMemory.storageBackend`, `agentMemory.autoSyncToFile`
- Configured repo-local bridge in `.vscode/settings.json`:
  - `agentMemory.storageBackend=disk`
  - `agentMemory.autoSyncToFile=.vscode/memory/AGENT_MEMORY_SYNC.md`
  - `agentMemory.tldr.enabled=false`
- Resolved PR review feedback by keeping auto-synced raw memory in the ignored
  `.vscode/memory/` local buffer and reserving the tracked workpaper for
  sanitized manual exports only.

resultado:
- Memory/Memory Log visual panel can connect to a local ignored memory buffer
  through the extension auto-sync setting.
- Workpapers can receive only sanitized manual exports from that buffer.
- The actual memory write operation still requires a VSI agent/model turn that
  invokes the VS Code language model tool `memory`.
- That `memory` tool is not callable from this Codex tool runtime in this
  session, so the panel remains a VSI-extension runtime gap until invoked from
  inside VSI.

validadores:
- `python scripts/validators/vsi_function_utilization_validator.py`
- `python scripts/validators/vsi_usage_expansion_validator.py`
- `python scripts/validators/no_ps_validator_prep_validator.py`
- `git diff --check`

riesgo:
- Bajo. Raw memory stays ignored/local-only; no secrets, no live writes, no
  production, no tenant mutation.

rollback:
- `git restore -- .gitignore .vscode/settings.json C:\Users\enzo1\.codex\workpapers/codex.workspace_guardian/AGENT_MEMORY_SYNC.md .agents/codex/readbacks/2026-06-07_vsi_memory_workpaper_bridge_readback.md scripts/validators/vsi_function_utilization_validator.py .agents/codex/matrices/VSI_FUNCTION_UTILIZATION_MATRIX_20260607.csv`

stop_condition:
- `vsi_memory_tool_not_callable_from_codex_runtime`
