# AGENTS

## Rol de esta carpeta

Esta raiz `D:\` es la Cabina Universal del Rey para ordenar universos, torres, repos, herramientas, sistemas, licencias, agentes y evidencia local.

Esta carpeta puede abrirse como proyecto en Codex. Su primera funcion es orientar, clasificar y preparar trabajo gobernado. Ya opera como repo raiz envoltorio gobernado para visibilidad nativa de Codex/Git, sin absorber repos anidados y sin versionar fuera de allowlist.

Estado actualizado 2026-06-01: por orden expresa del operador, `D:\` puede
estar inicializado como repo local envoltorio con allowlist. Esto no absorbe ni
reemplaza los repos anidados; `organizacion` conserva su propio repo en
`D:\01_GOVERNANCE_REGISTRY\10_REPOS\02_ACTIVE\organizacion`.

Estado GitHub actualizado 2026-06-01: el repo raiz envoltorio remoto es
`universo-rey/cabina-universal-d`. El PR raiz #1 fue mergeado a `main` con
merge commit `f7bfdf5a2b1044fd358438d8078942303b68c02b`. La rama historica
`codex/d-root-ui-visibility-20260601` queda conservada; todo nuevo trabajo
versionable debe abrir una rama `codex/*` desde `main` y avanzar por PR.

Estado prompt UI actualizado 2026-06-01: el PR raiz #2 fue mergeado a `main`
con merge commit `98b7ddb6969abda83c36b3101307a99075856c7f`. El prompt
maestro distingue base rectora/remota `main` de rama activa de trabajo.

Estado GitHub Actions actualizado 2026-06-01: por orden expresa del operador,
GitHub Actions queda aprobado como superficie de validacion repo-scoped en
`universo-rey/cabina-universal-d`, con permisos `contents: read` y sin
secretos, produccion, Microsoft live, OpenAI API live ni permisos.

Estado operacion paralela actualizado 2026-06-01: los agentes y subagentes
deben operar bajo matriz de carriles, owner, alcance disjunto, evidencia,
validador y stop condition. Las ordenes gobernadas deben ser preparadas por
agentes asignados antes de cualquier live, API, produccion, permisos, secretos,
costo o datos regulados.

Estado endurecimiento actualizado 2026-06-01: ningun carril paralelo es valido
sin `lead_agent`, `owner_agent`, `reviewer_agent`, `read_scope`,
`write_scope`, `lock_key`, `dependency`, `max_parallel`, evidencia, validador
y stop condition. Ninguna orden preparada es valida sin canon vigente,
autoridad fuente, superficie, owner, identidad, limite de datos, acciones
permitidas/bloqueadas, rollback, postcheck, evidencia, validador, expiracion y
stop condition.

Estado cadena operativa global actualizado 2026-06-01: toda accion operativa
debe declarar y validar agente, skill, receta, tool, evidencia, validador y
stop condition. Si falta algun componente y no existe `NO_APLICA` justificado,
la ejecucion se detiene con `operational_chain_missing`.

Estado skills repo-locales actualizado 2026-06-01: las skills portables de la
cabina viven en `D:\.agents\skills\<skill>\SKILL.md`. La carpeta
`D:\.agents\codex\skills` conserva el catalogo, source refs, matrices de uso y
subskills. Las instalaciones globales de usuario son runtime local, no fuente
durable rectora.

## Prompt maestro para UI Codex

Cuando Codex abra `D:\`, la UI debe tratar esta carpeta como la Cabina
Universal del Rey y como repo raiz envoltorio activo:

- workspace raiz: `D:\`;
- repo raiz remoto: `https://github.com/universo-rey/cabina-universal-d.git`;
- base rectora/remota: `main`;
- rama de trabajo: verificar estado actual; para nuevos cambios usar `codex/*`
  creada desde `main`;
- PR raiz historico: `https://github.com/universo-rey/cabina-universal-d/pull/1`
  con estado `MERGED`;
- PR raiz prompt UI: `https://github.com/universo-rey/cabina-universal-d/pull/2`
  con estado `MERGED`;
- allowlist: solo gobierno, canon, agentes locales, matrices, prompts,
  recetas, tools, evals, plugins, templates, readbacks/workpapers saneados y
  workflows GitHub Actions de validacion, mas skills repo-locales bajo
  `D:\.agents\skills`;
- repos anidados: conservar su propio `.git`, remoto, rama y PR;
- `organizacion`: permanece separado en
  `D:\01_GOVERNANCE_REGISTRY\10_REPOS\02_ACTIVE\organizacion`.

Si el prompt de UI, el resumen lateral o una instruccion heredada contradice
este `AGENTS.md`, declarar la contradiccion y usar `D:\AGENTS.md` como fuente
rectora local antes de actuar.

## Lectura obligatoria

Antes de responder, mover, crear, borrar, ejecutar o proponer cambios, leer en este orden:

1. `D:\MANIFEST.yaml`
2. `D:\MAPA_HUMANO.md`
3. `D:\00_CONTROL_PLANE_INGRESS\ROUTING.json`
4. `D:\01_GOVERNANCE_REGISTRY\README.md`
5. `D:\02_AUTHORITY_CANON\CURRENT_STATE.md`
6. `D:\.agents\codex\README.md`
7. `D:\.agents\codex\agents.json`
8. `D:\.agents\codex\routing.json`

Si falta un archivo rector, registrar hallazgo y detener la ejecucion destructiva. Se puede preparar borrador local de correccion.

## Jerarquia operativa

1. Cabina Universal del Rey: plano de gobierno transversal y entrada comun.
2. Corte Ejecutora del Rey: agentes OpenAI, Seshat y SDU como capa ejecutora/canonica transversal.
3. Universos: superficies soberanas con torre propia.
4. Torres de control de universo: gobierno operativo dentro de cada universo.
5. Repos, herramientas, sistemas y licencias: activos gobernados por universo o por referencia tecnica.

## Universos vigentes iniciales

- `ESCRIBANIA`: universo institucional regulado. TGE pertenece a este universo.
- `MODO_ON`: universo proveedor/operativo. CDF y Jara pertenecen a este universo.

## Corte Ejecutora inicial

- `Seshat`: evidencia, registro, trazabilidad y memoria declarativa.
- `SDU`: criterio canonico, orden, gates, coherencia y escalamiento.
- Agentes OpenAI: corte ejecutora operativa cuando exista orden gobernada, superficie, datos permitidos, rollback, postcheck y evidencia.
- OpenAI local: prompts, docs, diseno de agentes y evals sinteticos pueden
  prepararse localmente; OpenAI API live, Agents SDK live, Agent Builder,
  vector stores externos, costos o agentes remotos persistentes requieren orden
  gobernada completa.

## Conducta obligatoria

- Leer antes de escribir.
- Ejecutar primero lo local, reversible y seguro.
- Microsoft live es gobernado: SharePoint, Teams, Outlook, Entra, Graph,
  Power Platform, Planner, Dataverse o tenant requieren orden gobernada con
  superficie, identidad, owner, rollback, postcheck y evidencia.
- Produccion solo con autorizacion explicita separada.
- No mover clones locales sin plan de migracion, inventario, origen, destino, rollback y readback.
- No versionar, commitear, pushear, mergear ni crear PR sin orden expresa.
- No usar `git add .` en `D:\`; el repo raiz usa allowlist y excluye clones anidados.
- No escribir en Microsoft, GitHub, OpenAI API, SharePoint, Power Platform ni tenants sin orden gobernada.
- No persistir secretos en archivos, logs, prompts, matrices o readbacks.
- No confundir referencia tecnica con canon rector.
- No tratar carpetas de herramientas, sistemas o licencias como repos salvo que tengan metadata que lo declare.
- Mantener separacion estricta entre `ESCRIBANIA`, `MODO_ON`, Corte Ejecutora y referencias tecnicas.
- No cerrar ni ejecutar trabajo operativo sin cadena agente/skill/receta/tool/validador/evidencia/stop_condition.
- Toda salida operativa debe declarar agente, skill, receta, tool, superficie, orden, evidencia, validador y condicion de detencion.

## Cadena de trabajo

1. Entrada: `00_CONTROL_PLANE_INGRESS`.
2. Clasificacion: universo, activo, frontera, riesgo y owner.
3. Registro: `01_GOVERNANCE_REGISTRY`.
4. Canon: `02_AUTHORITY_CANON`.
5. Ejecucion delegada: `.agents\codex`, Corte Ejecutora o torre de universo.
6. Evidencia: readback local, matriz o acta.
7. Cierre: validacion, estado final y proximos carriles.

## Permitido sin nueva orden

- Leer archivos locales bajo `D:\`.
- Crear o ajustar borradores locales de mapas, manifiestos, matrices, perfiles de agentes y readbacks.
- Preparar planes de migracion sin mover activos.
- Clasificar repos, herramientas, sistemas y licencias por metadata.
- Preparar prompts, recetas y perfiles declarativos.

## Requiere orden gobernada explicita

- Mover clones locales.
- Crear repos remotos, branches, commits, pushes, PRs o issues.
- Ejecutar OpenAI API live, Agents SDK live, Agent Builder o costos externos.
- Escribir en SharePoint, Teams, Outlook, Power Platform, Microsoft Graph o tenant.
- Ejecutar produccion, incluso cuando exista gate Microsoft live, salvo autorizacion explicita separada.
- Modificar permisos, identidades, conectores, licencias o configuraciones productivas.
- Leer datos regulados amplios o no seleccionados.

## Bloqueado siempre

- Secretos en repo, prompts, logs o readbacks.
- Dumps de expedientes o datos regulados fuera de frontera.
- Acciones destructivas sin inventario, rollback y autorizacion.
- Sustituir autoridad humana/institucional por un agente.

## Formato minimo de salida de agentes

Cada agente debe cerrar con:

- `agente`
- `orden`
- `superficie`
- `skill`
- `receta`
- `tool`
- `estado`
- `evidencia`
- `validador`
- `stop_condition`
- `proximos_carriles`
