# Niveles y Subniveles

## Regla

Toda carpeta gobernada debe poder leerse en una cadena de niveles:

`raiz -> plano -> dominio -> ciclo de vida -> activo -> estructura interna`

## Nivel 0

`C:\Users\enzo1\Documents\GitHub\cabina-universal-d`

Cabina Universal del Rey. No es un repo por defecto; por orden expresa puede
operar como repo local envoltorio con allowlist, sin absorber clones anidados.

## Nivel 1

Planos principales:

- `00_CONTROL_PLANE_INGRESS`
- `01_GOVERNANCE_REGISTRY`
- `02_AUTHORITY_CANON`
- `03_CORTE_EJECUTORA_DEL_REY`
- `10_UNIVERSOS`
- `80_REFERENCIAS_TECNICAS`
- `90_ARCHIVO_DEL_REINO`

## Nivel 2

Dominios internos del plano. Ejemplos:

- `01_GOVERNANCE_REGISTRY\10_REPOS`
- `02_AUTHORITY_CANON\03_ORDENES_GOBERNADAS`
- `03_CORTE_EJECUTORA_DEL_REY\07_EVALS`
- `10_UNIVERSOS\ESCRIBANIA\03_TORRE_DE_CONTROL_DEL_UNIVERSO`

## Nivel 3

Ciclo de vida estandar:

- `00_INBOX`: pendiente de clasificacion.
- `01_PLANNED`: planificado o reservado.
- `02_ACTIVE`: activo vigente.
- `03_WORKTREES`: worktrees o ramas locales separadas.
- `08_READBACKS`: evidencia de cierre.
- `90_ARCHIVO`: historico o retirado.

## Nivel 4

Activo concreto:

- repo
- herramienta
- sistema
- licencia
- paquete de evidencia
- orden gobernada
- prompt pack
- receta
- validador

## Nivel 5

Estructura interna del activo. Si el activo es un repo, manda su propio `AGENTS.md`, README y canon interno.

## Regla de destino de repos

Los repos no van colgados directo de `10_REPOS`. Deben vivir bajo un subnivel de ciclo:

- Planeado: `10_REPOS\01_PLANNED\<repo>`
- Activo: `10_REPOS\02_ACTIVE\<repo>`
- Worktree: `10_REPOS\03_WORKTREES\<repo-or-branch>`
- Archivo: `10_REPOS\90_ARCHIVO\<repo>`

## Stop condition

No mover activos existentes hasta tener orden gobernada con origen, destino, precheck, rollback, postcheck y readback.
