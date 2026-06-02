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
  sobre SharePoint piloto.
- `.github/workflows/validate-runtime-local.yml` ejecuta pytest, skill pack,
  runtime-local, readonly evidence, handoff, promotion-gate y live-write con
  engine `mock`.
- `codex cloud exec --env SeshatSgin/sgin-cloud --branch main` fue probado con
  prompt read-only y devolvio `environment 'SeshatSgin/sgin-cloud' not found`.
  No hubo diff ni apply.

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

## Decision

Codex Cloud queda como carril remoto gobernado activo para tareas repo-scoped
no sensibles. `SeshatSgin/sgin-cloud` queda registrado como candidato activo de
smoke/CI remoto, pero requiere environment Cloud. `universo-rey/cabina-universal-d`
queda validado como environment aceptado por CLI mediante smoke read-only. No
sustituye Codex local ni GitHub PR lifecycle. El uso seguro es:

`list -> status -> diff -> review -> apply local gated -> validators -> PR`.

## Stop

No se ejecuta SharePoint real, produccion, permisos, secretos ni OpenAI API
live desde este carril. Como el environment remoto de `sgin-cloud` no existe
para la CLI, se detiene con `source_uncertain` y se prepara carril de
registro de environment o clone/register repo-nativo.
