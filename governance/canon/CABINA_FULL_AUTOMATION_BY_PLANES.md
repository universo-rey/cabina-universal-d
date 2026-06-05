# Cabina Full Automation By Operating Planes

estado: `CABINA_FULL_AUTOMATION_BY_PLANES_ACTIVE`
fecha: `2026-06-05`
base: `origin/main 3b2c42df914b31901fecca5772271e82db5bccaa`
repo: `universo-rey/cabina-universal-d`

## Proposito

Este contrato no crea una Cabina nueva. Convierte la Cabina existente en un
ciclo ejecutable por planos operativos.

La automatizacion reutiliza:

- `AGENTS.md` como instruccion rectora.
- `MANIFEST.yaml` como manifest operacional.
- `governance/canon/CABINA_OPERATING_SYSTEM_CONSTITUTION.md` como contrato de
  salud y evolucion.
- `.agents/codex/matrices/OPERATIONAL_CHAIN_GOVERNANCE_MATRIX.csv` como cadena
  agente/skill/recipe/tool/validador/evidencia/stop condition.
- `.agents/codex/recipes/recipe.github_pr_lifecycle_governed.md` como ciclo
  GitHub repo-scoped.
- `.agents/codex/matrices/CODEX_CLOUD_GOVERNED_LANE_MATRIX.csv` como frontera
  Codex Cloud.
- `.agents/codex/tools/local_run_change_aware_full_coverage_orchestrator.ps1`
  como gate productivo de validacion.

## Regla De Ejecucion

Cada orden debe avanzar por la matriz:

`.agents/codex/matrices/CABINA_FULL_AUTOMATION_PLANE_MATRIX_20260605.csv`

Cada plano declara proposito, input, output, owner, skill, recipe, tool,
validador, evidencia, stop condition y plano siguiente.

La automatizacion puede ejecutar planos locales, repo-scoped, GitHub PR,
checks, fixes, readbacks y Codex Cloud read-only/no-apply cuando el plano lo
declara `auto_executable=true`.

La automatizacion debe detenerse o preparar gate cuando el plano declara
`human_gate_required` distinto de `none` o cuando aparecen superficies criticas:
produccion, secretos, permisos, tenants, Microsoft live write, OpenAI API live
con costo/secreto/dato sensible, force push, branch deletion, cambio de remotos,
`core.worktree`, `codex_cloud_apply` o merge sin precheck.

## Ciclo Estandar

```text
orden
-> intake
-> clasificacion
-> agente
-> skill
-> receta
-> Codex Cloud o local
-> rama
-> cambios
-> validacion
-> commit
-> push
-> PR
-> checks
-> fixes
-> ready
-> merge precheck
-> merge con HEAD fijo si hay autorizacion
-> postcheck
-> readback
```

## Planos Operativos

| Plano | Responsabilidad | Owner | Validador | Siguiente |
| --- | --- | --- | --- | --- |
| `P01_INTAKE` | Recibir orden y formar paquete de intake. | `rey.control_plane_orchestrator` | `local_validate_capability_use_hardening.ps1` | `P02_CLASSIFICATION` |
| `P02_CLASSIFICATION` | Clasificar superficie, repo, universo, riesgo y frontera. | `rey.frontier_guardian` | `local_validate_capability_use_hardening.ps1` | `P03_AGENTS` |
| `P03_AGENTS` | Asignar agente owner, reviewer y evidence agent. | `rey.control_plane_orchestrator` | `local_validate_operational_chain.ps1` | `P04_SKILLS` |
| `P04_SKILLS` | Resolver skills reales o marcar `NO_DISPONIBLE`. | `court.thot_schema` | `local_validate_skill_metadata.ps1` | `P05_RECIPES` |
| `P05_RECIPES` | Seleccionar receta existente y evitar duplicacion. | `court.openai_dispatcher` | `local_validate_agent_layer.ps1` | `P06_CODEX_CLOUD` |
| `P06_CODEX_CLOUD` | Decidir local, Codex Cloud read-only/no-apply o gate. | `court.openai_dispatcher` | `local_validate_codex_cloud_governed_lane.ps1` | `P07_GIT_LOCAL` |
| `P07_GIT_LOCAL` | Resolver root, rama `codex/*`, diff y stage explicito. | `rey.repo_cartographer` | `local_validate_github_automation_preflight.ps1` | `P08_GITHUB` |
| `P08_GITHUB` | Push, PR, checks, comments y ready/merge precheck. | `rey.repo_cartographer` | `local_validate_github_automation_preflight.ps1` | `P09_VALIDATION` |
| `P09_VALIDATION` | Ejecutar validadores y change-aware full coverage. | `court.thot_schema` | `local_run_change_aware_full_coverage_orchestrator.ps1` | `P10_FAN_IN` |
| `P10_FAN_IN` | Reconciliar cambios, indices, canon y estado. | `rey.authority_canonist` | `local_validate_agent_layer.ps1` | `P11_GATES` |
| `P11_GATES` | Decidir si hay frontera critica y gate humano. | `rey.frontier_guardian` | `local_validate_order_packets.ps1` | `P12_EVIDENCE` |
| `P12_EVIDENCE` | Registrar evidencia saneada y verificable. | `court.seshat_evidence` | `local_validate_agent_layer.ps1` | `P13_READBACK` |
| `P13_READBACK` | Emitir cierre accionable con rollback y stop condition. | `court.seshat_evidence` | `local_validate_operational_chain.ps1` | `P14_OBSERVABILITY` |
| `P14_OBSERVABILITY` | Confirmar salud local/remota y bloqueos externos. | `court.thot_schema` | `local_run_governance_validation_suite.ps1` | `P15_EVOLUTION` |
| `P15_EVOLUTION` | Producir proximo carril o finalizar sin deuda implicita. | `rey.authority_canonist` | `local_validate_cabina_full_automation_planes.ps1` | `END` |

## Inventario Por Plano

| Plano | Artefactos existentes reutilizados |
| --- | --- |
| `P01_INTAKE` | `00_CONTROL_PLANE_INGRESS/ROUTING.json`, `.agents/codex/routing.json`, `CAPABILITY_USE_HARDENING_MATRIX.csv` |
| `P02_CLASSIFICATION` | `SURFACE_BOUNDARY_MAP.csv`, `LIVE_SURFACE_GATE_MATRIX_20260603.csv`, `REPO_AGENT_TOOL_GOVERNANCE_MATRIX.csv` |
| `P03_AGENTS` | `.agents/codex/agents.json`, `AGENT_DEFAULT_SKILL_ASSIGNMENT_MATRIX.csv`, `AGENTS_INDEX.csv` |
| `P04_SKILLS` | `.agents/skills/*/SKILL.md`, `SKILL_USAGE_MATRIX.csv`, `SKILL_METADATA_QUALITY_MATRIX.csv` |
| `P05_RECIPES` | `RECIPE_INDEX.csv`, `SUBRECIPE_INDEX.csv`, `recipe.github_pr_lifecycle_governed.md` |
| `P06_CODEX_CLOUD` | `CODEX_CLOUD_GOVERNED_LANE_MATRIX.csv`, `CODEX_CLOUD_ENVIRONMENT_INVENTORY_20260602.csv`, `CODEX_APP_LOCAL_ENVIRONMENT_MATRIX_20260602.csv` |
| `P07_GIT_LOCAL` | `GITHUB_BASE_WORK_POLICY.md`, `REPO_SCOPE.md`, `TOOL_INDEX.csv` |
| `P08_GITHUB` | `GITHUB_AUTOMATION_PREFLIGHT_MATRIX.csv`, `.github/PULL_REQUEST_TEMPLATE.md`, `.github/workflows/cabina-validation.yml` |
| `P09_VALIDATION` | `CHANGE_AWARE_TEST_MANIFEST.csv`, `CHANGE_AWARE_RISK_POLICY.csv`, `CHANGE_AWARE_IMPACT_GRAPH.csv` |
| `P10_FAN_IN` | `MATRIX_INDEX.csv`, `EVIDENCE_AND_VALIDATION_MATRIX.csv`, `CANONICAL_STATE_SUPERSESSION_20260603.csv` |
| `P11_GATES` | `GATES_INDEX.csv`, `ORDER_PREPARATION_ASSIGNMENT_MATRIX.csv`, `ORDER_CLASS_CAPABILITY_MATRIX.csv` |
| `P12_EVIDENCE` | `EVIDENCE_READBACK_REGISTRY_20260603.csv`, `governance/observability/*.schema.json` |
| `P13_READBACK` | `.agents/codex/readbacks`, `recipe.governed_readback_closeout.md` |
| `P14_OBSERVABILITY` | `CABINA_OPERATING_SYSTEM_CONSTITUTION.md`, `local_run_governance_validation_suite.ps1`, GitHub checks |
| `P15_EVOLUTION` | `RETROSPECTIVE_MATRIX_UPDATE_PLAN.csv`, `CANONICAL_STATE_SUPERSESSION_20260603.csv`, `CABINA_FULL_AUTOMATION_PLANE_MATRIX_20260605.csv` |

## Estados

- `PLANE_READY`: el plano tiene owner, tool, validator, evidencia y stop
  condition.
- `PLANE_EXECUTED`: el plano ejecuto una accion permitida y produjo evidencia.
- `PLANE_GATED`: el plano detecto superficie critica y preparo gate humano.
- `PLANE_BLOCKED`: el plano encontro secreto, produccion, permiso, tenant,
  live write o accion destructiva sin gate.
- `PLANE_SKIPPED_NOT_APPLICABLE`: el plano no aplica y lo justifica con
  evidencia.

## Criterio De Cierre

El ciclo completo queda listo cuando:

1. La matriz tiene los 15 planos.
2. Cada plano resuelve agente, skill, recipe, tool, validator, evidencia y stop
   condition reales.
3. El validador `local_validate_cabina_full_automation_planes.ps1` cierra PASS.
4. El gate change-aware ejecuta ese validador en PR.
5. No hay superficies criticas ejecutadas sin gate.
