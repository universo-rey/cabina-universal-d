# Readback — GATE_CABINA_REPO_ROOT_MIGRATION_TO_GITHUB_WORKSPACE

Estado:

CABINA_REPO_ROOT_MIGRATED_TO_GITHUB_WORKSPACE

Fecha:

2026-06-05

## Resultado

La migración operativa quedó aceptada y reconciliada contra la raíz efectiva C.

La raíz Git activa de `cabina-universal-d` queda en:

```text
C:/Users/enzo1/Documents/GitHub/cabina-universal-d
```

La superficie `D:/` queda como superficie gobernada externa/local, no como worktree Git activo para operaciones futuras de Cabina Universal D.

## Configuración aceptada

```text
repo_git_root = C:/Users/enzo1/Documents/GitHub/cabina-universal-d
governed_surface_root = D:/
old_git_root = D:/
old_git_metadata_retained = true
active_git_operations_must_use_new_root = true
tool_reference_classifier = 80_REFERENCIAS_TECNICAS
legacy_reference_plane = D:/80_REFERENCIAS_TECNICAS read-only/governed
legacy_d_reference_allowlist = .agents/codex/matrices/C_ROOT_LEGACY_D_REFERENCE_ALLOWLIST_20260605.csv
legacy_d_reference_validator = .agents/codex/tools/local_validate_c_root_reference_reconciliation.ps1
```

## Regla desde ahora

Todas las operaciones Git de `cabina-universal-d` deben ejecutarse desde:

```bash
cd C:/Users/enzo1/Documents/GitHub/cabina-universal-d
```

No deben ejecutarse desde:

```bash
cd D:/
```

## Frontera no tocada

No se modifica todavía:

```text
D:/.git
core.worktree=D:/
```

Esa decisión queda pendiente y separada en:

```text
GATE_CABINA_D_ROOT_GIT_METADATA_RETENTION_DECISION
```

## Validación mínima esperada

```text
show-toplevel = C:/Users/enzo1/Documents/GitHub/cabina-universal-d
core.worktree = vacío o no configurado
status = cambios repo-scoped del carril o limpio despues de PR
```

## Validacion ejecutada

```text
local_validate_c_root_reference_reconciliation.ps1 = PASS
local_validate_agents_instruction_hierarchy.ps1 = PASS
local_validate_capability_use_hardening.ps1 = PASS
local_validate_operational_chain.ps1 = PASS
local_validate_skill_reference_sources.ps1 = PASS
local_validate_order_packets.ps1 = PASS
local_validate_agent_layer.ps1 = PASS
local_validate_frontend_design_lane.ps1 = PASS
local_validate_teams_cross_repo_lane_audit.ps1 = PASS
local_run_governance_validation_suite.ps1 = PASS
git diff --check = PASS
```

## Criterio de cierre

Este readback queda cerrado si:

* la nueva raíz Git queda documentada;
* `D:/` queda declarado como superficie gobernada;
* toda referencia restante a `D:/` o `D:\` queda justificada por allowlist legacy/gobernanza;
* ningun tool, validator, skill, recipe, manifest, prompt ejecutable o cadena operativa depende de `D:/`;
* no se toca `D:/.git`;
* no se toca `core.worktree=D:/`;
* no se hace merge;
* push y PR solo ocurren dentro del scope autorizado `codex/reconcile-c-root-effective-cabina-20260605`;
* no se borran ramas ni se hace force push;
* no se toca live.
* `tool.reference_classifier` valida contra una ruta repo-scoped en C.
