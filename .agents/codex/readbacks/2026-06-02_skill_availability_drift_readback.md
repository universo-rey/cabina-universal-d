# Skill Availability Drift Readback - 2026-06-02

## Estado

HECHO_VERIFICADO: la deriva de skills declaradas queda cerrada en el repo raiz
envoltorio. Cinco skills que existian solo como catalogo en
`D:\.agents\codex\skills` fueron promovidas a paquetes portables activables en
`D:\.agents\skills`.

## Sistemas tocados

- `D:\.agents\skills`
- `D:\.agents\codex\matrices\LOCAL_SKILL_CATALOG.csv`
- `D:\.agents\codex\skills\SKILL_USAGE_MATRIX.csv`
- `D:\.agents\codex\skills\SKILL_METADATA_QUALITY_MATRIX.csv`
- `D:\MANIFEST.yaml`
- `D:\.gitignore`

## Sistemas no tocados

- No se tocaron repos anidados.
- No se guardaron previews o mensajes de Teams.
- No se descargaron ni versionaron documentos SharePoint.
- No se ejecutaron Microsoft writes, OpenAI API live, produccion, permisos ni
  secretos.

## Cambios

- `d-drive-agent-layer-enrichment` queda disponible como skill portable.
- `governed-readback-closeout` queda disponible como skill portable.
- `matrix-recipe-skill-sync` queda disponible como skill portable.
- `parallel-order-governance` queda disponible como skill portable.
- `repo-agent-tool-governance` queda disponible como skill portable.
- Las matrices pasan esas cinco skills de `d_drive_local` a
  `d_drive_repo_local`.
- El manifiesto registra disponibilidad completa de skills declaradas.

## Validacion

- `D:\.agents\codex\tools\local_validate_skill_metadata.ps1`: PASS,
  10 repo-local skills, 10 metadata quality rows, 0 errors.
- `D:\.agents\codex\tools\local_validate_agent_layer.ps1`: PASS,
  49 local skills, 44 tools, 23 recipes, 14 governed agents, 0 secret hits.
- `D:\.agents\codex\tools\local_validate_operational_chain.ps1`: PASS,
  6 operational-chain rows, 49 skills, 23 recipes, 44 tools, 0 errors.
- `D:\.agents\codex\tools\local_validate_parallel_order_governance.ps1`:
  PASS, 5 parallel lanes, 0 errors.
- Disponibilidad total: 49 skills declaradas, 49 disponibles; 10 repo-locales
  portables en `D:\.agents\skills`.
- `git diff --check`: PASS.

## Riesgos

- Riesgo bajo: cambio documental y repo-local dentro de allowlist.
- Riesgo residual: las skills instaladas globalmente pueden cambiar fuera del
  repo; la fuente durable para estas cinco queda ahora en `D:\.agents\skills`.

## Rollback

Revertir el commit del PR restaura las rutas previas de catalogo y remueve las
cinco carpetas portables agregadas. No hay estado externo que revertir.

## Stop Condition

`skill_metadata_missing_or_ambiguous` si una skill repo-local no tiene
frontmatter activable, fila de uso, fila de catalogo, fila de calidad,
validador o bloqueo explicito de superficies live.

## Proximos carriles

- Carril Microsoft Teams: seleccionar equipos, canales o chats exactos antes de
  leer mensajes.
- Carril SharePoint SDU-CN: repetir lectura completa solo con sitio,
  bibliotecas y limites de datos declarados.
- Carril CI Modo ON: mantener CDF y Jara con checks remotos verdes y sin
  secretos, live Microsoft, OpenAI API live ni produccion.
