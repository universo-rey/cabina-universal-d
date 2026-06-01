# AGENTS

## Rol de esta carpeta

Esta raiz `D:\` es la Cabina Universal del Rey para ordenar universos, torres, repos, herramientas, sistemas, licencias, agentes y evidencia local.

Esta carpeta puede abrirse como proyecto en Codex. Su primera funcion es orientar, clasificar y preparar trabajo gobernado. No es un repositorio por defecto y no debe versionarse sin orden expresa.

Estado actualizado 2026-06-01: por orden expresa del operador, `D:\` puede
estar inicializado como repo local envoltorio con allowlist. Esto no absorbe ni
reemplaza los repos anidados; `organizacion` conserva su propio repo en
`D:\01_GOVERNANCE_REGISTRY\10_REPOS\02_ACTIVE\organizacion`.

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
- Toda salida operativa debe declarar agente, superficie, orden, evidencia, validador y condicion de detencion.

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
- `estado`
- `evidencia`
- `validador`
- `stop_condition`
- `proximos_carriles`
