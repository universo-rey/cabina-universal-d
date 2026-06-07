# READBACK_AGENTS_GLOBAL_IMPROVEMENT_20260605

## Estado

HECHO_VERIFICADO:

- Root efectivo usado: `C:\Users\enzo1\Documents\GitHub\cabina-universal-d`.
- Rama local creada: `codex/agents-global-improvement-20260605`.
- HEAD base: `b0e30cb`.
- Orden ejecutada en superficie local repo-scoped allowlisted.
- No se hizo push, PR, merge, force push, live write, produccion, secretos, costos, Microsoft live, OpenAI API live, Responses API live, Agents SDK live, tenant write ni propagacion multi-repo.
- El worktree de consola `C:\Users\enzo1\.codex\worktrees\2aa1\cabina-universal-d` estaba sucio y no fue usado como raiz efectiva; cualquier cambio aplicado alli por error fue retirado, preservando sus 6 cambios preexistentes.

## Sistemas tocados

- Filesystem local repo-scoped en `C:\Users\enzo1\Documents\GitHub\cabina-universal-d`.
- Git local: solo creacion de rama local `codex/agents-global-improvement-20260605`.

## Sistemas no tocados

- GitHub remoto: no push, no PR, no checks remotos, no merge.
- Microsoft 365, SharePoint, Teams, Planner, Graph, Power Platform y Dataverse: no tocados.
- OpenAI API, Responses API y Agents SDK live: no tocados.
- Produccion, tenants, permisos, secretos, costos externos y propagacion multi-repo: no tocados.
- Repos anidados y sus `.git`: no tocados.
- `D:\`: no tocado.

## Archivos leidos

- `AGENTS.md`
- `MANIFEST.yaml`
- `MAPA_HUMANO.md`
- `00_CONTROL_PLANE_INGRESS\ROUTING.json`
- `01_GOVERNANCE_REGISTRY\README.md`
- `02_AUTHORITY_CANON\CURRENT_STATE.md`
- `.agents\codex\README.md`
- `.agents\codex\agents.json`
- `.agents\codex\routing.json`
- `.agents\codex\matrices\AGENT_DEFAULT_SKILL_ASSIGNMENT_MATRIX.csv`
- `.agents\codex\matrices\AGENT_GOVERNANCE_MATRIX.csv`
- `.agents\codex\matrices\REPO_AGENT_TOOL_GOVERNANCE_MATRIX.csv`
- `.agents\codex\matrices\OPERATIONAL_CHAIN_GOVERNANCE_MATRIX.csv`
- `.agents\codex\matrices\CAPABILITY_USE_HARDENING_MATRIX.csv`
- `.agents\codex\matrices\PARALLEL_OPERATION_CRITERIA_MATRIX.csv`
- `.agents\codex\matrices\PARALLEL_ISSUE_LANE_QUEUE.csv`
- `.agents\codex\matrices\SUBAGENT_CAPABILITY_ASSIGNMENT_MATRIX.csv`
- `.agents\codex\matrices\ORDER_CLASS_CAPABILITY_MATRIX.csv`
- `.agents\codex\matrices\MATRIX_INDEX.csv`
- `.agents\codex\matrices\VALIDATION_COVERAGE_MATRIX.csv`
- `.agents\codex\matrices\STOP_CONDITION_GLOSSARY.csv`
- `.agents\codex\skills\SKILL_USAGE_MATRIX.csv`
- `.agents\codex\skills\SKILL_METADATA_QUALITY_MATRIX.csv`
- `.agents\codex\recipes\RECIPE_INDEX.csv`
- `.agents\codex\tools\TOOL_INDEX.csv`
- `02_AUTHORITY_CANON\SDU_CN_CANONICAL_AGENT_UNIVERSE_REPO_MATRIX_20260604.csv`
- `02_AUTHORITY_CANON\SDU_CN_CANONICAL_TO_OPERATIONAL_AGENT_MAPPING_20260604.csv`
- `.agents\skills\tcu-descubridor-capacidades\SKILL.md`
- `.agents\skills\repo-agent-tool-governance\SKILL.md`
- `.agents\skills\governed-readback-closeout\SKILL.md`
- `.agents\skills\cabina-naming-analyzer\SKILL.md`
- `.agents\skills\matrix-recipe-skill-sync\SKILL.md`
- `.agents\skills\cabina-agent-md-refactor\SKILL.md`

## Archivos modificados

- `.agents\codex\matrices\AGENTS_GLOBAL_OPERABILITY_INVENTORY_20260605.csv`
- `.agents\codex\matrices\MATRIX_INDEX.csv`
- `.agents\codex\matrices\VALIDATION_COVERAGE_MATRIX.csv`
- `.agents\codex\matrices\PARALLEL_OPERATION_CRITERIA_MATRIX.csv`
- `.agents\codex\matrices\ORDER_CLASS_CAPABILITY_MATRIX.csv`
- `.agents\codex\routing.json`
- `AGENTS.md`
- `governance\canon\CABINA_OPERATING_SYSTEM_CONSTITUTION.md`
- `.agents\codex\matrices\CABINA_OPERATING_SYSTEM_RECONCILIATION_20260605.csv`
- `.agents\codex\readbacks\2026-06-05_agents_global_improvement_readback.md`

## Agentes mejorados

- 14 agentes operativos inventariados con skill, recipe, tool, validator, evidencia, stop condition, estado y brecha.
- 6 agentes canonicos SDU-CN mapeados contra agentes operativos sin reemplazarlos.
- 1 runtime agent referenciado (`sdu-triage-agent`) documentado como runtime/tool, no autoridad.
- 5 clases de subagentes documentadas como templates locales task-scoped, no agentes persistentes remotos.

## Brechas cerradas

- Falta de vista unica de agente canonico -> agente operativo -> runtime -> superficie -> skill -> recipe -> tool -> validator -> evidencia -> stop condition.
- Falta de ruta explicita para ordenes de mejora global de agentes: agregada `agent_global_improvement` en `.agents\codex\routing.json`.
- Falta de contrato de capacidad para esa clase de orden: agregado en `ORDER_CLASS_CAPABILITY_MATRIX.csv`.
- Falta de carriles paralelos especificos para auditoria global de agentes: agregados `parallel_agent_global_inventory_audit` y `serial_agent_global_improvement_integration`.
- Falta de coverage/index para el nuevo inventario: agregados `MATRIX_INDEX.csv` y `VALIDATION_COVERAGE_MATRIX.csv`.
- Falta de regla rectora explicita de no duplicacion antes de crear agentes,
  perfiles, skills, recetas, matrices, rutas, contratos o validadores. Se
  agrego en `AGENTS.md` sin crear componente nuevo, porque existen capacidades
  parciales de reutilizacion, naming, sync y overlap que deben reconciliarse.
- Falta de regla rectora explicita de diff minimo antes de modificar archivos
  y de cierre por archivo con clasificacion, rollback exacto y confirmacion de
  superficies no tocadas. Se agrego en `AGENTS.md` como conducta obligatoria
  sin tocar workflows, politica Git, secretos, produccion, permisos ni live
  gates.
- Falta de una constitucion operativa unica que conecte el sistema ya existente
  sin redisenarlo. Se creo
  `governance\canon\CABINA_OPERATING_SYSTEM_CONSTITUTION.md` como indice
  institucional y se creo
  `.agents\codex\matrices\CABINA_OPERATING_SYSTEM_RECONCILIATION_20260605.csv`
  para demostrar equivalentes funcionales, brechas y proximos carriles.

## Brechas pendientes

- `sdu-triage-agent` sigue como runtime referenciado, no como perfil operativo repo-local. Estado activo: `PENDING_TARGET_ONLY` hasta que exista orden para perfilar runtime sin tratar Agents SDK/OpenAI como autoridad.
- Falta un validator especifico de no-duplicacion multi-componente. No se creo
  en este paso porque la regla nueva exige primero reconciliar capacidades
  existentes (`cabina-naming-analyzer`, `matrix-recipe-skill-sync`,
  `local_validate_agent_layer.ps1` y validadores de overlap) antes de agregar
  herramienta nueva.
- Falta un validator especifico de diff-minimo/cierre-por-archivo. No se creo
  en este paso porque la orden fue una mejora de instruccion, y agregar un
  validador nuevo ampliaria el alcance a tooling.
- No se crearon los 15 documentos `CABINA_*.md` solicitados originalmente
  porque el preflight encontro equivalentes funcionales dispersos y crear todos
  duplicaria el sistema. Quedan como proximos carriles solo los modelos con
  gap real: maquina de estados, fan-in formal y observabilidad unificada.
- No se ejecutaron push, PR ni checks remotos por restriccion explicita de la orden.
- `local_run_governance_validation_suite.ps1` fallo 19/20 por dirty state en repos hermanos, fuera del scope de esta orden:
  - `ORGANIZACION`: `M MANIFEST.sha256`, `?? docs/service-design/`
  - `TORRE_GEMELA_ESCRIBANIA`: `?? 08_READBACKS/READBACK_TGE_CANON_REVIEW_20260605_DRAFT.md`
  - `SESHAT_BOOTSTRAP`: `?? audit/ACTA_APERTURA_DOCUMENTAL_SDU_CN_20260605_DRAFT.md`

## Validacion

PASS:

- Preflight de no duplicacion por busqueda `rg` sobre `AGENTS.md`,
  `.agents\codex`, `.agents\skills`, `02_AUTHORITY_CANON` y
  `01_GOVERNANCE_REGISTRY`: equivalentes parciales encontrados; no se creo
  componente nuevo.
- Preflight de diff minimo: archivos candidatos declarados antes de editar
  (`AGENTS.md` y este readback), ambos dentro de allowlist de canon/evidencia;
  no se tocaron archivos no relacionados.
- Reconciliacion del sistema operativo: los 15 artefactos `CABINA_*` no existen
  como archivos exactos; se mapearon equivalentes existentes y gaps reales en
  `CABINA_OPERATING_SYSTEM_RECONCILIATION_20260605.csv`.
- `.agents\codex\tools\local_validate_agents_instruction_hierarchy.ps1`
- `.agents\codex\tools\local_validate_capability_use_hardening.ps1`
- `.agents\codex\tools\local_validate_operational_chain.ps1`
- `.agents\codex\tools\local_validate_autonomous_agent_execution.ps1`
- `.agents\codex\tools\local_validate_skill_metadata.ps1`
- `.agents\codex\tools\local_validate_parallel_issue_queue.ps1`
- `.agents\codex\tools\local_validate_parallel_order_governance.ps1`
- `.agents\codex\tools\local_validate_order_packets.ps1`
- `.agents\codex\tools\local_validate_agent_layer.ps1`
- `git diff --check`

FAIL actionable:

- `.agents\codex\tools\local_run_governance_validation_suite.ps1`: 19/20 PASS, 1 FAIL por dirty state de repos hermanos detectado por `local_validate_repo_topology_windows_default.ps1`.

## Riesgos

- Bajo para los cambios aplicados: son matrices/routing/readback locales.
- Medio para cerrar el gate global completo hasta clasificar dirty state de repos hermanos.
- Bloqueo absoluto no detectado dentro de la capa local de agentes.

## Rollback

Revertir estos archivos en la rama local:

```powershell
git restore -- .agents/codex/matrices/AGENTS_GLOBAL_OPERABILITY_INVENTORY_20260605.csv .agents/codex/matrices/MATRIX_INDEX.csv .agents/codex/matrices/VALIDATION_COVERAGE_MATRIX.csv .agents/codex/matrices/PARALLEL_OPERATION_CRITERIA_MATRIX.csv .agents/codex/matrices/ORDER_CLASS_CAPABILITY_MATRIX.csv .agents/codex/routing.json .agents/codex/readbacks/2026-06-05_agents_global_improvement_readback.md
```

Si el archivo nuevo queda untracked:

```powershell
Remove-Item -LiteralPath .agents/codex/matrices/AGENTS_GLOBAL_OPERABILITY_INVENTORY_20260605.csv
Remove-Item -LiteralPath .agents/codex/readbacks/2026-06-05_agents_global_improvement_readback.md
```

## Proximos carriles

1. Clasificar dirty state de repos hermanos para recuperar `local_run_governance_validation_suite.ps1` PASS 20/20.
2. Revisar si `sdu-triage-agent` necesita perfil repo-local o si debe permanecer solo como runtime referenciado.
3. Si el operador autoriza GitHub, stagear rutas explicitas, commitear localmente y recien despues preparar push/PR.
