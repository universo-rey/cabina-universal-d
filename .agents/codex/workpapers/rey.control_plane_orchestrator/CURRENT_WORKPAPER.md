# Current Workpaper - rey.control_plane_orchestrator

- orden: actualizar capa local agentica con papeles de trabajo versionables.
- estado: LOCAL_GOVERNED_WORKPAPERS_ACTIVE
- superficie: D:\AGENTS.md|D:\MANIFEST.yaml|D:\00_CONTROL_PLANE_INGRESS\ROUTING.json|D:\01_GOVERNANCE_REGISTRY\RELATIONSHIP_GRAPH.json|D:\.agents\codex\routing.json
- evidencia: agents.json, AGENT_WORKPAPERS_MATRIX, PURPOSE_SURFACE_CAPABILITY_MATRIX, SURFACE_ROUTING.csv.
- validador: tool.local_validate_agent_workpapers; tool.local_validate_agent_layer.
- riesgo: ejecucion live accidental o matriz sin validador.
- rollback: revertir cambios de carpeta workpapers, matrices y snapshot repo-visible antes de merge.
- stop_condition: workpaper_missing_for_agent.
- proximos_carriles: TGE, SDU/Seshat y CDF nativos, cada uno en su PR.
