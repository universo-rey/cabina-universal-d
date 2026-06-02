# Skill Reference Library Policy

Estado: `ACTIVE_LOCAL_ONLY`

## Proposito

Este policy define como la cabina guarda y usa referencias de skills,
librerias y documentacion API sin convertir articulos externos o vendor docs en
canon rector.

La fuente rectora local sigue siendo `D:\AGENTS.md`. Las referencias tecnicas
ayudan a disenar skills, recetas, tools, ejemplos y gotchas, pero no sustituyen
autoridad, gates, ordenes gobernadas ni decision humana.

Tokens de control para validacion: `technical reference`, `not authority canon`,
`freshness`.

## Frontera de Autoridad

1. `D:\AGENTS.md` prevalece sobre UI, resumen lateral, perfiles, plugins y
   runtime global.
2. `D:\02_AUTHORITY_CANON` conserva decisiones rectoras y gates.
3. `D:\.agents\skills\<skill>\SKILL.md` contiene skills repo-locales durables.
4. `D:\.agents\codex\skills` contiene catalogos, source refs, matrices de uso
   y politicas de referencia.
5. Fuentes externas como blogs, articulos, docs de vendors o ejemplos publicos
   son `technical_reference`, no `authority_canon`.

Si una referencia externa contradice `D:\AGENTS.md`, se registra el hallazgo y
se detiene con `source_reference_treated_as_canon`.

## Modelo de Almacenamiento

- Skills portables: `D:\.agents\skills\<skill>\SKILL.md`.
- Catalogo y uso: `D:\.agents\codex\skills\*.csv` y
  `D:\.agents\codex\matrices\LOCAL_SKILL_CATALOG.csv`.
- Referencias fuente: `D:\.agents\codex\matrices\SKILL_REFERENCE_SOURCE_MATRIX.csv`.
- Scripts, assets o carpetas `references/` dentro de skills repo-locales
  requieren registro explicito antes de versionarse. Hasta que exista ese
  registro, se documenta la referencia en la matriz y se evita copiar contenido
  amplio.
- Instalaciones globales de usuario y caches de plugins son runtime local. Se
  pueden usar como fuente operativa disponible, pero no son la fuente durable
  rectora del repo.

## Contrato de Referencia

Toda fuente usada para disenar o actualizar una skill debe declarar:

- `source_id` unico.
- `source_locator` local o URL.
- `authority_class` como referencia tecnica, raiz repo-local o runtime local.
- fecha de recuperacion o adopcion.
- alcance permitido.
- nota de licencia o restriccion de copia.
- riesgo de frescura.
- cadencia de revision.
- owner y reviewer.
- usos permitidos y usos bloqueados.
- evidencia, validador y stop condition.

## Frescura

- API docs y librerias vivas son temporalmente inestables: se refrescan antes
  de usarlas para cambios ejecutables o instrucciones actuales.
- Articulos conceptuales pueden mantenerse como referencia metodologica, con
  revision periodica o al cambiar una skill relacionada.
- Snapshots locales solo prueban disponibilidad local al momento de la cabina;
  no prueban estado actual de un vendor.

## Permitido

- Registrar fuente, fecha, owner, limite y decision de adopcion.
- Usar pequenos resumenes propios y referencias puntuales.
- Vincular referencia con skill, receta, tool y agente.
- Preparar policy o matriz local sin ejecucion live.

## Bloqueado

- Tratar referencia tecnica como canon rector.
- Copiar documentacion vendor extensa o con licencia incierta.
- Persistir secretos, tokens, credenciales o datos regulados.
- Ejecutar Microsoft live, OpenAI API live, produccion, permisos o costos por
  el solo hecho de registrar una referencia.
- Sincronizar web automaticamente sin orden gobernada separada.

## Validacion

El control local es
`D:\.agents\codex\tools\local_validate_skill_reference_sources.ps1`.

El cierre minimo del carril debe declarar agente, orden, superficie, skill,
receta, tool, estado, evidencia, validador, stop condition y proximos carriles.
