# Readback — GATE_CABINA_REPO_ROOT_MIGRATION_TO_GITHUB_WORKSPACE

Estado:

CABINA_REPO_ROOT_MIGRATED_TO_GITHUB_WORKSPACE

Fecha:

2026-06-05

## Resultado

La migración operativa quedó aceptada.

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
status = limpio o solo cambios documentales del carril
```

## Criterio de cierre

Este readback queda cerrado si:

* la nueva raíz Git queda documentada;
* `D:/` queda declarado como superficie gobernada;
* no se toca `D:/.git`;
* no se toca `core.worktree=D:/`;
* no se hace push;
* no se hace merge;
* no se cambian ramas;
* no se toca live.
