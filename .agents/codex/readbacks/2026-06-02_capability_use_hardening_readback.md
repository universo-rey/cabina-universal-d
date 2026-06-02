# Readback - Capability Use Hardening

Fecha: 2026-06-02

## Orden

Endurecer el uso de recetas, skills, plugins, tools y agentes desde el inicio
de cada ejecucion, incluyendo asignacion, derivacion, lectura, escritura,
dispatch paralelo, gates live/costo/produccion y cierre.

## Agente

- lead_agent: `rey.control_plane_orchestrator`
- owner_agent: `rey.control_plane_orchestrator`
- reviewer_agent: `rey.frontier_guardian`
- schema_owner: `court.thot_schema`
- evidence_owner: `court.seshat_evidence`

## Superficie

- `D:/AGENTS.md`
- `D:/MANIFEST.yaml`
- `D:/.agents/codex`
- `D:/.github`

No se tocaron repos anidados, Microsoft live, OpenAI API live, produccion,
permisos, secretos ni datos regulados.

## Skill

- `matrix-recipe-skill-sync`
- `repo-agent-tool-governance`
- `cabina-naming-analyzer`
- `cabina-commit-work`

## Receta

- `recipe.matrix_recipe_skill_sync`
- `recipe.repo_agent_tool_governance`
- `recipe.github_pr_lifecycle_governed`

## Tool

- `tool.local_validate_capability_use_hardening`
- `tool.local_validate_operational_chain`
- `tool.local_validate_agent_layer`

## Evidencia

- Nueva matriz:
  `D:/.agents/codex/matrices/CAPABILITY_USE_HARDENING_MATRIX.csv`
- Nuevo validador:
  `D:/.agents/codex/tools/local_validate_capability_use_hardening.ps1`
- Indices sincronizados:
  `MATRIX_INDEX.csv`, `TOOL_INDEX.csv`, `TOOL_GOVERNANCE_MATRIX.csv`,
  `VALIDATION_COVERAGE_MATRIX.csv`, `REPO_AGENT_TOOL_GOVERNANCE_MATRIX.csv`,
  `GOVERNED_ASSET_CANONICAL_INVENTORY.csv`,
  `OPERATIONAL_CHAIN_GOVERNANCE_MATRIX.csv`,
  `STOP_CONDITION_GLOSSARY.csv` y `GITHUB_ACTIONS_WORKFLOW_MATRIX.csv`.
- Instrucciones y plantillas actualizadas:
  `AGENTS.md`, `MANIFEST.yaml`, `.agents/codex/README.md`,
  `02_AUTHORITY_CANON/CURRENT_STATE.md`,
  `.github/copilot-instructions.md`,
  `.github/PULL_REQUEST_TEMPLATE.md`,
  `.github/ISSUE_TEMPLATE/agent-task.yml`,
  `.github/ISSUE_TEMPLATE/runtime-approval.yml` y
  `.github/workflows/cabina-validation.yml`.

## Validador

Validador primario:
`D:/.agents/codex/tools/local_validate_capability_use_hardening.ps1`.

Validadores companeros:

- `D:/.agents/codex/tools/local_validate_operational_chain.ps1`
- `D:/.agents/codex/tools/local_validate_agent_layer.ps1`
- `D:/.agents/codex/tools/local_validate_skill_metadata.ps1`
- `git diff --check`

## Riesgo

- Riesgo principal: una matriz, template o workflow podria seguir permitiendo
  ejecucion sin plugin, superficie o validador declarado.
- Mitigacion: CI ejecuta el nuevo validador y las plantillas GitHub piden
  capability-use preflight antes de ejecutar.

## Rollback

Revertir el commit o PR de este carril restaura el contrato anterior. El
rollback no requiere Microsoft live, OpenAI API live, produccion ni permisos.

## Stop Condition

`capability_use_preflight_missing`: si falta agente, skill, receta, plugin,
tool, superficie, evidencia, validador, stop condition o referencia resoluble,
la ejecucion se detiene antes de actuar.

## Proximos Carriles

- Carril 1: propagar la misma regla a repos nativos TGE, SDU-CN y CDF/Jara
  mediante PR propio por repo.
- Carril 2: convertir ordenes Microsoft live ya preparadas en paquetes con
  capability-use preflight explicito antes de cualquier lectura real.
- Carril 3: revisar tareas Codex Cloud para exigir la misma cadena antes de
  ejecutar diffs o aplicar cambios.
