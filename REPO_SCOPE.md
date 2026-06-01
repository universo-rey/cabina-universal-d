# Repo Scope

Estado: `D_ROOT_WRAPPER_REPO_LOCAL`

Este repo nuevo gobierna la raiz `D:\` como Cabina Universal del Rey sin
absorber los repos anidados.

## Regla

- `D:\` es repo local envoltorio para que Codex y Git vean una raiz nativa.
- `organizacion` conserva su propio repo en
  `D:\01_GOVERNANCE_REGISTRY\10_REPOS\02_ACTIVE\organizacion`.
- Los demas clones bajo `10_REPOS\02_ACTIVE` conservan sus propios repos.
- El repo raiz usa allowlist: ignora todo por defecto y solo versiona archivos
  rectores seleccionados.
- No hay remoto configurado todavia.
- No hay PR de este repo raiz todavia.

## Bloqueos

- No `git add .` sobre `D:\`.
- No versionar `.secrets`, caches, clones completos, dumps, credenciales,
  expedientes o datos regulados.
- No mover clones.
- No reemplazar el repo `universo-rey/organizacion`.

## Proximo carril

Definir owner/nombre del remoto nuevo si se quiere publicar este repo raiz en
GitHub y abrir PR propio.
