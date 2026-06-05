# Cabina Universal D — Configuración canónica de raíz Git

Estado:

CABINA_REPO_ROOT_CANONICAL_CONFIG_UPDATED

Fecha:

2026-06-05

Gate:

GATE_CABINA_REPO_ROOT_CANONICAL_CONFIG_UPDATE

## Decisión

La raíz Git activa de `cabina-universal-d` queda fijada en:

```text
repo_git_root = C:/Users/enzo1/Documents/GitHub/cabina-universal-d
```

La superficie `D:/` queda declarada como superficie gobernada externa/local:

```text
governed_surface_root = D:/
repo_scoped_reference_plane = C:/Users/enzo1/Documents/GitHub/cabina-universal-d/80_REFERENCIAS_TECNICAS
legacy_reference_plane = 80_REFERENCIAS_TECNICAS
```

## Estado anterior

```text
old_git_root = D:/
old_git_metadata_retained = true
```

## Regla operativa

Toda operación Git activa de `cabina-universal-d` debe ejecutarse desde:

```bash
cd C:/Users/enzo1/Documents/GitHub/cabina-universal-d
```

No debe ejecutarse desde:

```bash
cd D:/
```

## Frontera vigente

Este cierre no modifica:

```text
D:/.git
core.worktree=D:/
ramas
remotos
producción
live surfaces
secretos
```

La decisión sobre la metadata Git retenida en `D:/` queda separada en el carril:

```text
GATE_CABINA_D_ROOT_GIT_METADATA_RETENTION_DECISION
```

## Configuración rectora

```text
repo_git_root = C:/Users/enzo1/Documents/GitHub/cabina-universal-d
governed_surface_root = D:/
old_git_root = D:/
old_git_metadata_retained = true
active_git_operations_must_use_new_root = true
tool_reference_classifier_must_use_repo_scoped_reference_plane = true
legacy_reference_plane_read_only = true
```

## Criterio de cierre

El cierre queda aceptado si:

* el repo activo se valida desde `C:/Users/enzo1/Documents/GitHub/cabina-universal-d`;
* `git rev-parse --show-toplevel` apunta al nuevo root;
* `core.worktree` está vacío o no configurado;
* `D:/` queda tratado solo como superficie gobernada;
* no se toca `D:/.git`;
* no se ejecutan live, push, merge ni cambios de ramas.
