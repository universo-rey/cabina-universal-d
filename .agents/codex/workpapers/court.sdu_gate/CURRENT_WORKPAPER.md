# Current Workpaper - court.sdu_gate

- orden: actualizar capa local agentica con papeles de trabajo versionables y dejar trazado el estado Inventory SDU-CN queue state.
- estado: LOCAL_GOVERNED_WORKPAPERS_ACTIVE
- superficie: D:\03_CORTE_EJECUTORA_DEL_REY|SDU Seshat Corte surfaces
- skill: Superpowers:using-superpowers; Superpowers:dispatching-parallel-agents; repo-agent-tool-governance; governed-readback-closeout.
- receta: recipe.agent_workpaper_operation; recipe.repo_agent_tool_governance; recipe.governed_readback_closeout.
- tool: tool.workpaper_index_check; tool.local_validate_agent_workpapers; tool.local_validate_agent_layer; tool.local_validate_operational_chain.
- plugin: Superpowers.
- agentes: court.sdu_gate (owner); rey.control_plane_orchestrator (routing fan-in only); court.seshat_evidence (evidence fan-in if needed).
- evidencia: agents.json, WORKPAPER_INDEX.csv, AGENT_WORKPAPERS_MATRIX, PURPOSE_SURFACE_CAPABILITY_MATRIX, current state, open items, and Inventory SDU-CN queue readback from 2026-06-11.
- validador: tool.local_validate_agent_workpapers; tool.local_validate_agent_layer; tool.local_validate_operational_chain.
- riesgo: live write accidental, stale workpaper index, or queue inventory/backlog mixup.
- rollback: revertir cambios de carpeta workpapers, matrices y snapshot repo-visible antes de merge.
- stop_condition: microsoft_live_requested_without_governed_order.
- proximos_carriles: keep Inventory SDU-CN queue state as local evidence, then continue backlog split or live gate only if explicit.
