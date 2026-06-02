# Orden - Microsoft Agents Governed Lab Alignment - 2026-06-02

## Identificacion

- `order_id`: `D_MICROSOFT_AGENTS_GOVERNED_LAB_ALIGNMENT_20260602`
- `date`: `2026-06-02`
- `status`: `APPROVED_EXECUTED_LOCAL_GITHUB_GOVERNANCE_ONLY`
- `owner`: `operador`
- `source_authority`: `aprobado proximos carriles`
- `repo`: `universo-rey/microsoft-agents-governed-lab`
- `local_path`: `D:\10_UNIVERSOS\ESCRIBANIA\10_REPOS\02_ACTIVE\microsoft-agents-governed-lab`

## Alcance aprobado

- Registrar el repo en la cabina raiz `D:\`.
- Clonar el repo bajo el universo `ESCRIBANIA` y torre `TGE`.
- Validar `origin` contra `universo-rey/microsoft-agents-governed-lab`.
- Registrar `upstream` tecnico `https://github.com/microsoft/Agents.git`.
- Mantener `upstream` como referencia de lectura local con push deshabilitado.
- Crear readback y PR de alineacion en `universo-rey/cabina-universal-d`.

## Fuera de alcance

- Microsoft live.
- Tenant writes.
- Produccion.
- Cambios de permisos.
- Secrets.
- Lectura amplia de datos regulados.
- Push a `microsoft/Agents`.
- Merge automatico de PRs del lab.

## Cadena operativa

- `agente`: `rey.repo_cartographer`; `rey.frontier_guardian`; `universe.escribania_tower`
- `skill`: `cabina-commit-work`; `github`
- `receta`: `recipe.repo_universe_alignment_runtime`
- `tool`: `tool.repo_alignment_runtime`; `tool.gh_remote_readonly`; `git clone`; `gh`
- `evidencia`: matrices de cabina; readback de alineacion; PR raiz
- `validador`: `local_validate_all_repo_github_alignment.ps1`; `local_run_repo_alignment_runtime.ps1`

## Stop condition

`microsoft_live_or_productive_agent_without_order`

La aprobacion de este carril no habilita ejecucion live de Microsoft Agents,
tenant writes, produccion, permisos ni despliegue de agentes persistentes.
