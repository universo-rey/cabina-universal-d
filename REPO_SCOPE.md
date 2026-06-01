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
- Remoto configurado: `https://github.com/universo-rey/cabina-universal-d.git`.
- Visibilidad remota: privada.
- No hay PR de este repo raiz todavia.

## Bloqueos

- No `git add .` sobre `D:\`.
- No versionar `.secrets`, caches, clones completos, dumps, credenciales,
  expedientes o datos regulados.
- No mover clones.
- No reemplazar el repo `universo-rey/organizacion`.

## Proximo carril

Crear un branch gobernado y PR propio si se quiere revisar cambios futuros
fuera de `main`.
