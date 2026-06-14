# Workpaper: Codex Cloud Governed Lane

Fecha: 2026-06-02

## Superficie

Codex Cloud CLI y repos GitHub.

## Lectura

- Documentacion oficial Codex: Cloud environments, CLI reference,
  authentication y Codex web.
- Estado local `D:\AGENTS.md`.
- `codex cloud list --json`.
- `codex cloud status` sobre tarea read-only existente.
- GitHub read-only de `SeshatSgin/sgin-cloud`.
- Snapshot UI Codex Cloud provisto por el operador.

## Evidencia GitHub

- `SeshatSgin/sgin-cloud` es repo privado con default branch `main`.
- Descripcion remota: `SGIN cloud documentary foundation and federation package`.
- `AGENTS.md` declara canon documental federado y prohibe promover a
  produccion sin gate superior.
- `README.md` declara `CONSOLIDADO_DOCUMENTAL`, produccion bloqueada,
  runtime local sandbox, skill pack pre-productivo y live-write controlado
  sobre SharePoint como superficie completa gobernada.
- `.github/workflows/validate-runtime-local.yml` ejecuta pytest, skill pack,
  runtime-local, readonly evidence, handoff, promotion-gate y live-write con
  engine `mock`.
- `codex cloud exec --env SeshatSgin/sgin-cloud --branch main` fue probado con
  prompt read-only y devolvio `task_e_6a1f19895190832ebd427cf6b955bc31`,
  `READY`, `files_changed=0`, `no diff`.
- `codex cloud exec --env SeshatSgin/sgin-cloud --branch main` fue probado con
  prompt CI/mock y devolvio `task_e_6a1f1b60bc04832e855fe676e91c9ea7`,
  `READY`, `files_changed=0`, `no diff`.
- `codex cloud exec --env sgin-cloud --branch main` no resolvio environment;
  la etiqueta operativa valida es `SeshatSgin/sgin-cloud`.
- Clone canonico para `sgin-cloud`: `C:\Users\enzo1\Documents\GitHub\sgin-cloud`,
  branch `main`, `HEAD=67f04f9`, limpio y alineado con `origin/main`.
- Clone OneDrive obsoleto: `C:\Users\enzo1\OneDrive - ESCRIBANIA BITSCH\Repos\sgin-cloud`,
  branch `main`, `HEAD=194d4db`, limpio pero no alineado con `origin/main`;
  queda fuera de CI Cloud hasta orden gobernada de refresh/migracion.

## Evidencia Codex Cloud

- `SeshatSgin/tcu-control-plane`: environment visible UI, 125 tareas, creado
  el 2026-05-13 por `enzo.181292@gmail.com`.
- `Sgin`: environment visible UI y CLI para repo `universo-rey/Sgin`, 45
  tareas, creado el 2026-04-21 por `enzo.181292@gmail.com`.
- `SGIN_Canonico_Puro`: environment visible UI para repo
  `SeshatSgin/SGIN_Canonico_Puro`, 6 tareas, creado el 2026-04-21 por
  `enzo.181292@gmail.com`.
- `universo-rey/cabina-universal-d`: environment visible UI, 0 tareas antes
  del smoke, creado el 2026-06-02 por `enzo.181292@gmail.com`.
- Smoke iniciado: `task_e_6a1f119843d4832e9ed821834222c003`, environment
  `universo-rey/cabina-universal-d`, branch `main`, estado verificado
  `READY`, `files_changed=0`, `no diff`.
- Segunda ola aprobada por operador y ejecutada read-only:
  `task_e_6a1f144c06cc832e9ae317ce8ca0f1e0` sobre
  `SeshatSgin/tcu-control-plane`, `READY`, `files_changed=0`, `no diff`;
  `task_e_6a1f144c189c832ead0762cd5016078e` sobre
  `SGIN_Canonico_Puro`, `READY`, `files_changed=0`, `no diff`;
  `task_e_6a1f144bfee4832ebe5523def080f921` sobre `Sgin`, `READY`,
  `files_changed=0`, `no diff`.
- Tercera ola aprobada por operador y ejecutada sobre `SeshatSgin/sgin-cloud`:
  `task_e_6a1f19895190832ebd427cf6b955bc31` smoke read-only, `READY`,
  `files_changed=0`, `no diff`; `task_e_6a1f1b60bc04832e855fe676e91c9ea7`
  smoke CI/mock, `READY`, `files_changed=0`, `no diff`.

## Decision

Codex Cloud queda como carril remoto gobernado activo para tareas repo-scoped
no sensibles. `SeshatSgin/sgin-cloud` queda validado como environment aceptado
por CLI mediante smoke read-only y smoke CI/mock sin diff. El clon canonico de
trabajo queda en `C:\Users\enzo1\Documents\GitHub\sgin-cloud`; el clon
OneDrive obsoleto requiere orden gobernada separada antes de refrescarse o
moverse. `universo-rey/cabina-universal-d` queda validado como environment
aceptado por CLI mediante smoke read-only. Codex Cloud no sustituye Codex local
ni GitHub PR lifecycle. El uso seguro es:

`list -> status -> diff -> review -> apply local gated -> validators -> PR`.

## Stop

No se ejecuta SharePoint real, produccion, permisos, secretos ni OpenAI API
live desde este carril. La etiqueta corta `sgin-cloud` queda descartada por
`source_uncertain`; la etiqueta completa `SeshatSgin/sgin-cloud` queda
habilitada solo para tareas repo-scoped no sensibles. Cualquier refresh del
clon OneDrive, apply de diff Cloud, Microsoft live o produccion requiere orden
gobernada separada y postcheck.
