# Current Workpaper - court.sdu_gate

- orden: actualizar capa local agentica con papeles de trabajo versionables.
- estado: LOCAL_GOVERNED_WORKPAPERS_ACTIVE
- superficie: D:\03_CORTE_EJECUTORA_DEL_REY|SDU Seshat Corte surfaces
- evidencia: agents.json, AGENT_WORKPAPERS_MATRIX, PURPOSE_SURFACE_CAPABILITY_MATRIX, SURFACE_ROUTING.csv.
- validador: tool.local_validate_agent_workpapers; tool.local_validate_agent_layer.
- riesgo: ejecucion live accidental o matriz sin validador.
- rollback: revertir cambios de carpeta workpapers, matrices y snapshot repo-visible antes de merge.
- stop_condition: microsoft_live_requested_without_governed_order.
- proximos_carriles: TGE, SDU/Seshat y CDF nativos, cada uno en su PR.
