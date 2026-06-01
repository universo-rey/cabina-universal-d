# Codex Agents Registry

Esta carpeta define los agentes locales que Codex debe usar cuando `D:\` sea abierto como proyecto.

Los archivos son declarativos y operativos locales: cada agente tiene papeles de trabajo versionables. No crean agentes remotos persistentes, no ejecutan llamadas externas y no autorizan writes live por si mismos.
Microsoft live queda gobernado por orden; produccion solo puede avanzar con autorizacion explicita separada.

## Regla de reutilizacion

La carpeta debe preferir `copiar/adaptar` antes que inventar. Los archivos `SOURCE_*` son copias locales de fuentes existentes en TCU/TGE/runtime/CDF/Jara y tienen prioridad como material de referencia. Los perfiles locales de agentes son overlays Codex, no fuente canonica primaria.

## Archivos

- `agents.json`: registro estructurado de agentes.
- `routing.json`: derivacion de ordenes hacia agentes.
- `AGENTS_INDEX.csv`: vista tabular para lectura rapida.
- `agents\LEVELS.yaml`: subniveles livianos de lectura.
- `agents\LEVELS.csv`: vista tabular de subniveles.
- `agents\<subnivel>\*.md`: perfil humano/operativo de cada agente.
- `skills\`: matriz de skills aplicables por subnivel.
- `D:\.agents\skills\`: raiz repo-local portable para `SKILL.md` propios de
  la cabina. `skills\` dentro de `.agents\codex` gobierna catalogo y matrices.
- `recipes\`: recetas operativas reutilizables.
- `tools\`: tools locales y validador.
- `matrices\`: matrices rectoras de capacidades, evidencia y contratos.
- `maps\`: mapas de lectura, handoff y fronteras.
- `evals\`: casos sinteticos de ruteo y subniveles.
- `templates\AGENT_PROFILE.md`: plantilla para nuevos agentes.
- `orders\`: ordenes locales preparadas.
- `readbacks\\`: cierres locales de agentes.
- `workpapers\\`: papeles de trabajo por agente, con evidencia, decisiones, pendientes, rutas de superficie y validaciones.
- `plugins\\`: matriz de disponibilidad y frontera de plugins.
- `agents\SUBAGENT_ALIAS_MAP.csv`: aliases de subagentes locales usados en
  carriles delegados.
- `skills\SUBSKILL_USAGE_MATRIX.csv`: subskills asignadas por skill padre.
- `recipes\SUBRECIPE_INDEX.csv`: subrecetas y validadores por receta padre.

## Regla de uso

1. Leer `D:\AGENTS.md`.
2. Leer este README.
3. Leer `agents\LEVELS.yaml`.
4. Seleccionar subnivel y agente desde `routing.json`.
5. Confirmar perfil en `agents.json`.
6. Abrir solo el README del subnivel y el perfil asignado.
7. Elegir receta desde `recipes\RECIPE_INDEX.csv`.
8. Elegir tool desde `tools\TOOL_INDEX.csv`.
9. Revisar primero si existe un `SOURCE_*` aplicable.
10. Ejecutar solo trabajo local permitido o preparar orden gobernada.
11. Validar con `tools\\local_validate_agent_levels.ps1`, `tools\\local_validate_agent_workpapers.ps1`, `tools\\local_validate_operational_chain.ps1` y `tools\\local_validate_agent_layer.ps1`.
12. Para carriles paralelos u ordenes, validar tambien con
    `tools\\local_validate_parallel_order_governance.ps1` y
    `tools\\local_validate_order_packets.ps1`.
13. Cerrar con agente, skill, receta, tool, evidencia, validador y condicion
    de detencion. Si falta algun componente y no existe `NO_APLICA`
    justificado, detener con `operational_chain_missing`.

## Estado

Estado actual: `LOCAL_GOVERNED_WORKPAPERS_ACTIVE`.

Versionado GitHub repo-visible reversible habilitado bajo orden gobernada.
Microsoft live requiere orden gobernada con rollback, postcheck y evidencia.
Produccion requiere autorizacion explicita separada.

Actualizacion 2026-06-01: la cabina raiz adopta como capacidades versionables
los perfiles de subnivel, skills, recipes, tools, evals, plugins y templates
locales bajo `.agents\codex`. La adopcion es declarativa y local: no despliega
agentes remotos, no ejecuta OpenAI API, no escribe en Microsoft y no mueve
repos anidados. Las fuentes copiadas desde otros repos se registran como
`SOURCE_*` y se controlan en `matrices\CAPABILITY_IMPORT_DECISION_MATRIX.csv`.

Actualizacion runtime 2026-06-01: cada agente tiene skills, recipes, tools y
plugins por defecto segun su proposito. La matriz rectora es
`matrices\AGENT_DEFAULT_SKILL_ASSIGNMENT_MATRIX.csv`. El runtime local de
alineacion total de repos se ejecuta con
`tools\local_run_repo_alignment_runtime.ps1` y registra resultado en
`evals\results\repo_alignment_runtime_latest.json`.

Actualizacion cadena operativa global 2026-06-01: la cabina exige cadena
agente/skill/receta/tool/validador/evidencia/stop_condition para cierres,
cambios repo, automatizacion GitHub, runtime y carriles paralelos. La matriz
rectora es `matrices\OPERATIONAL_CHAIN_GOVERNANCE_MATRIX.csv` y el validador
local es `tools\local_validate_operational_chain.ps1`.

Actualizacion skills repo-locales 2026-06-01: las skills cabina que deben
viajar con el repo se guardan en `D:\.agents\skills\<skill>\SKILL.md`. La
carpeta `D:\.agents\codex\skills` no instala por si misma: registra uso,
subskills y source refs.

## Olas de agentes

Ola 1: orquestacion, fronteras, registro, canon, repos, corte OpenAI y torres Escribania/Modo ON.

Ola 2: evidencia Seshat, gate SDU, schemas Thot, migracion a D, referencias tecnicas y guardian del workspace Codex.
