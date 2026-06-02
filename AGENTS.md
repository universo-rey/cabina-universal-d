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

Estado receta GitHub lifecycle actualizado 2026-06-01: por orden expresa del
operador, GitHub live repo-scoped puede operar como un solo ciclo gobernado
para branch `codex/*`, stage explicito, commit, push, PR draft/update,
comentarios/checks y fixes en alcance. No pedir aprobacion nueva por cada
subpaso dentro del mismo alcance. Merge queda automatizable dentro del ciclo
cuando el operador aprueba el ciclo o el merge y el PR pasa preflight, HEAD
fijo, base `main`, rama `codex/*`, checks requeridos y evidencia. Force push,
permisos, secrets, produccion, Microsoft live, OpenAI API live o datos
regulados siguen requiriendo orden separada.

Estado merge automatizado actualizado 2026-06-01: Codex puede ejecutar
`gh pr merge --match-head-commit` cuando exista orden aprobada y verificable.
Debe detenerse con `automated_merge_precheck_failed` si el PR no esta limpio,
esta en draft, apunta fuera de `main`, no usa rama `codex/*`, cambio el HEAD,
fallan checks, falta validador o cruza secretos, permisos, produccion,
Microsoft live, OpenAI API live, force push o borrado de rama remota.

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

Estado cola paralela actualizado 2026-06-01: los carriles por issue deben
declararse en
`D:\.agents\codex\matrices\PARALLEL_ISSUE_LANE_QUEUE.csv` con `base_sha`,
rama `codex/*`, file set exacto, `lock_key` unico, dependencias y
`max_parallel`. La cola se valida con
`D:\.agents\codex\tools\local_validate_parallel_issue_queue.ps1`. Los indices
compartidos requieren carril serial de integracion.

Estado merge cola paralela 2026-06-01: el PR raiz #22 fue mergeado a `main`
con merge commit `38c3bd0439e512504d39b97b8cef41144f545f87`. `main` es la
base rectora vigente para runtime no mutante, preflight Agents SDK local y
cola paralela por issue.

Estado biblioteca de referencias actualizado 2026-06-02: el PR raiz #25 fue
mergeado a `main` con merge commit
`c3c44dff12cd4957cbf27bd4dbf09e971497127d`. El issue #12 queda cerrado. La
cabina adopta `SKILL_REFERENCE_LIBRARY_POLICY.md`,
`SKILL_REFERENCE_SOURCE_MATRIX.csv` y
`local_validate_skill_reference_sources.ps1` para separar referencias tecnicas
de canon rector, controlar frescura/licencia y bloquear OpenAI API live,
Microsoft live, produccion, permisos, secretos y datos regulados.

Estado frontend-design actualizado 2026-06-02: el PR raiz #26 fue mergeado a
`main` con merge commit `d72fff9569ffbb5056276f5fb92fcc03e57b4bb8`. El issue
#15 queda cerrado. La cabina adopta `FRONTEND_DESIGN_LANE.md`,
`FRONTEND_DESIGN_LANE_MATRIX.csv` y
`local_validate_frontend_design_lane.ps1` para enrutar UI/apps/sites a
estandares de diseno, assets y verificacion local sin implicar produccion.

Estado integracion indices compartidos actualizado 2026-06-02: el PR raiz #27
fue mergeado a `main` con merge commit
`96d378e539018d8bf2fb139e3041888bba8a5b0e`. La cabina integra los carriles
cerrados #12 y #15 en indices compartidos, GitHub Actions, templates, canon y
manifiesto sin abrir Microsoft live, OpenAI API live ni produccion.

Estado alineacion todos repositorios actualizado 2026-06-02: los 12 repos
registrados quedan verificados localmente y contra GitHub read-only mediante
`D:\.agents\codex\tools\local_validate_all_repo_github_alignment.ps1`. La
evidencia vive en
`D:\.agents\codex\evals\results\all_repo_github_alignment_latest.json` y el
readback en
`D:\.agents\codex\readbacks\2026-06-02_all_repositories_alignment_readback.md`.
La alineacion no absorbe repos anidados; `SESHAT_BOOTSTRAP` conserva cambios
locales propios que requieren carril repo-nativo.

Estado cadena operativa global actualizado 2026-06-01: toda accion operativa
debe declarar y validar agente, skill, receta, tool, evidencia, validador y
stop condition. Si falta algun componente y no existe `NO_APLICA` justificado,
la ejecucion se detiene con `operational_chain_missing`.

Estado skills repo-locales actualizado 2026-06-01: las skills portables de la
cabina viven en `D:\.agents\skills\<skill>\SKILL.md`. La carpeta
`D:\.agents\codex\skills` conserva el catalogo, source refs, matrices de uso y
subskills. Las instalaciones globales de usuario son runtime local, no fuente
durable rectora.

Estado metadata de skills actualizado 2026-06-01: toda skill repo-local debe
declarar description activable, trigger boundary, allowed actions, blocked
actions, validator, evidencia y stop condition. La matriz vive en
`D:\.agents\codex\skills\SKILL_METADATA_QUALITY_MATRIX.csv` y el validador en
`D:\.agents\codex\tools\local_validate_skill_metadata.ps1`.

Estado carril documental actualizado 2026-06-01: los trabajos DOCX, PDF,
spreadsheets y presentaciones se enrutan por
`D:\.agents\codex\matrices\DOCUMENT_SKILL_LANE_MATRIX.csv` y se validan con
`D:\.agents\codex\tools\local_validate_document_skill_lane.ps1`. El carril es
local-only; documentos amplios, regulados, secretos o live requieren orden
gobernada separada.

Estado runtime local actualizado 2026-06-01: el runtime de alineacion se puede
verificar sin escribir evidencia mutable con
`D:\.agents\codex\tools\local_run_repo_alignment_runtime.ps1 -NoWrite`. El
preflight Agents SDK local se valida con
`D:\.agents\codex\tools\local_validate_github_automation_preflight.ps1 -CheckLocalSdk`
y debe cerrar en `smoke=OK_NO_API_CALL`. Esto no habilita OpenAI API live,
Agents SDK live, costos ni agentes remotos persistentes.

Estado Codex Cloud gobernado actualizado 2026-06-02: Codex Cloud queda como
carril remoto repo-scoped activo bajo
`D:\.agents\codex\maps\CODEX_CLOUD_GOVERNED_LANE.md`,
`D:\.agents\codex\matrices\CODEX_CLOUD_GOVERNED_LANE_MATRIX.csv` y
`D:\.agents\codex\tools\local_validate_codex_cloud_governed_lane.ps1`.
`SeshatSgin/sgin-cloud` queda reconocido y verificado como environment Cloud
remoto para smoke/CI read-only o no sensible con branch fija. Quedan
registrados el smoke read-only
`task_e_6a1f19895190832ebd427cf6b955bc31` y el smoke CI mock
`task_e_6a1f1b60bc04832e855fe676e91c9ea7`, ambos `READY`, `files_changed=0`
y sin diff. El clon canonico local para este carril es
`C:\Users\enzo1\Documents\GitHub\sgin-cloud` en `67f04f9` coincidente con
`origin/main`; el clon OneDrive en `194d4db` queda marcado como atrasado y no
debe usarse para Cloud CI sin orden de refresh o higiene. Los environments
visibles quedan registrados en
`D:\.agents\codex\matrices\CODEX_CLOUD_ENVIRONMENT_INVENTORY_20260602.csv`.
`universo-rey/cabina-universal-d` queda probado con smoke read-only
`task_e_6a1f119843d4832e9ed821834222c003`, estado `READY`, sin diff. Esto no
habilita secretos, Microsoft live, SharePoint real, produccion, permisos,
OpenAI API live, costos ni agentes remotos persistentes.
La segunda ola aprobada por el operador ejecuto smokes read-only sobre
`SeshatSgin/tcu-control-plane`, `SGIN_Canonico_Puro` y `Sgin`, todos con estado
`READY`, `files_changed=0` y sin diff.

Estado jerarquia AGENTS.md actualizado 2026-06-01: `D:\AGENTS.md` es la
instruccion rectora local de mayor precedencia. Las instrucciones anidadas,
perfiles de agentes, skills repo-locales, plugins y runtimes globales solo
pueden acotar o ejecutar dentro de esa frontera; nunca pueden debilitarla ni
absorber repos anidados. La matriz verificable vive en
`D:\.agents\codex\matrices\AGENTS_INSTRUCTION_SURFACE_MATRIX.csv` y el
validador en
`D:\.agents\codex\tools\local_validate_agents_instruction_hierarchy.ps1`.

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
- PR raiz cola paralela/runtime:
  `https://github.com/universo-rey/cabina-universal-d/pull/22` con estado
  `MERGED`;
- PR raiz readback canon:
  `https://github.com/universo-rey/cabina-universal-d/pull/23` con estado
  `MERGED`;
- PR raiz biblioteca de referencias:
  `https://github.com/universo-rey/cabina-universal-d/pull/25` con estado
  `MERGED`;
- PR raiz frontend-design:
  `https://github.com/universo-rey/cabina-universal-d/pull/26` con estado
  `MERGED`;
- PR raiz integracion indices compartidos:
  `https://github.com/universo-rey/cabina-universal-d/pull/27` con estado
  `MERGED`;
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

## Jerarquia de instrucciones locales

1. `D:\AGENTS.md`: fuente rectora local y frontera de seguridad.
2. Lectura obligatoria local: manifiesto, mapa humano, routing, registry,
   canon, README de `.agents\codex`, `agents.json` y `routing.json`.
3. Instrucciones anidadas locales: README de subnivel, perfiles de agentes,
   matrices, mapas, recetas, tools, skills repo-locales y templates.
4. Repos anidados: cada repo conserva su propio `.git`, remoto, rama, PR y sus
   instrucciones internas; la cabina raiz no los absorbe.
5. Runtime global o plugins: son herramientas de ejecucion local; no son canon
   durable y no pueden contradecir este archivo.

Si una instruccion de menor precedencia contradice una de mayor precedencia, se
detiene la accion que dependa de esa contradiccion y se registra
`instruction_precedence_missing` o `nested_instruction_surface_unmapped` segun
corresponda.

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
- No versionar, commitear, pushear ni crear PR sin orden expresa. Merge solo
  con orden o ciclo aprobado, HEAD fijo, checks verdes y evidencia.
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
