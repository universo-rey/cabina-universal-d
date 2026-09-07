# Codex Agents Registry

Esta carpeta define los agentes locales que Codex debe usar cuando
`C:\Users\enzo1\Documents\GitHub\cabina-universal-d` sea abierto como
proyecto.

Los archivos son declarativos y operativos locales: cada agente tiene papeles de trabajo versionables. No crean agentes remotos persistentes, no ejecutan llamadas externas y no autorizan writes live por si mismos.
Microsoft live queda gobernado por riesgo: READ es directo y LOW no requiere
orden; solo HIGH requiere autorizacion explicita. Produccion sigue siendo HIGH.

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
- `.agents\skills\`: raiz repo-local portable para `SKILL.md` propios de
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
- `.codex\`: entorno Codex app local/worktree versionable para la cabina
  raiz. Cloud environments se gobiernan por matriz/orden y no se inventan si
  no existe tool real de creacion.

## Regla de uso

1. Leer `AGENTS.md`.
2. Leer este README.
3. Leer `agents\LEVELS.yaml`.
4. Seleccionar subnivel y agente desde `routing.json`.
5. Confirmar perfil en `agents.json`.
6. Usar `.agents\skills\tcu-descubridor-capacidades\SKILL.md` sólo si una
   capacidad es desconocida, ambigua o se propone crear/asignar una nueva.
7. Para efectos materiales o externos, declarar la cadena aplicable desde
   `matrices\CAPABILITY_USE_HARDENING_MATRIX.csv`. READ y LOW simples usan
   únicamente los componentes pertinentes y no se bloquean por piezas
   `NO_APLICA`.
8. Abrir solo el README del subnivel y el perfil asignado.
9. Consumir la receta conocida si aplica; resolverla en el indice de recetas
   cuando falte. No crear una receta para una lectura o cambio simple.
10. Usar plugin si la operacion lo requiere; resolverlo en la matriz de plugins
    cuando sea necesario.
11. Usar la tool disponible y pertinente; consultar el indice de tools si hay
    una duda material sobre su contrato.
12. Revisar primero si existe un `SOURCE_*` aplicable.
13. Ejecutar READ o LOW con la capability, identidad y binding requeridos,
    tambien en Microsoft live y Cloud. Aplicar controles de write cuando haya
    write; preparar orden solo ante un trigger HIGH positivo.
14. Si se configura o cambia un carril de agentes autonomos, Codex Cloud o task agents, declarar
    fila en `matrices\AUTONOMOUS_AGENT_EXECUTION_MATRIX_20260602.csv` y
    validar con `tools\\local_validate_autonomous_agent_execution.ps1`.
14.b. Si se configura o cambia un entorno Codex app/worktree o Cloud environment,
    validar `matrices\CODEX_APP_LOCAL_ENVIRONMENT_MATRIX_20260602.csv` y
    `matrices\CODEX_ENVIRONMENT_CREATION_QUEUE_20260602.csv` con
    `tools\\local_validate_codex_app_environments.ps1`.
15. Si se modifican catalogos, contratos o matrices, ejecutar los validadores
    afectados: `tools\\local_validate_agent_levels.ps1`, `tools\\local_validate_agent_workpapers.ps1`, `tools\\local_validate_capability_use_hardening.ps1`, `tools\\local_validate_operational_chain.ps1` y `tools\\local_validate_agent_layer.ps1`.
    La CI conserva su cobertura de integridad; no se exige ejecutar toda la suite
    antes de cada operacion.
16. Para cambios de contratos paralelos u ordenes HIGH, validar tambien con
    `tools\\local_validate_parallel_order_governance.ps1` y
    `tools\\local_validate_order_packets.ps1`.
16.b. Para carriles paralelos por issue, declarar primero la fila en
    `matrices\\PARALLEL_ISSUE_LANE_QUEUE.csv` y validar con
    `tools\\local_validate_parallel_issue_queue.ps1`.
17. Cerrar con evidencia, validacion y condicion de detencion proporcionales al
    efecto. Un componente material ausente produce `RESOLUTION_REQUIRED` sobre
    el subpaso afectado; no eleva el riesgo ni bloquea capacidades independientes.

## Estado

Estado actual: `LOCAL_GOVERNED_WORKPAPERS_ACTIVE`.

Versionado GitHub repo-visible reversible habilitado dentro del scope
autorizado. Microsoft live READ es directo y los writes LOW exactos requieren
precheck, rollback o compensacion, postcheck y evidencia, sin orden previa.
Produccion y los restantes triggers HIGH requieren autorizacion explicita.

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

Actualizacion runtime no mutante 2026-06-01: para comprobar alineacion sin
actualizar evidencia, usar `tools\local_run_repo_alignment_runtime.ps1 -NoWrite`.
La activacion local Agents SDK se prueba con
`tools\local_validate_github_automation_preflight.ps1 -CheckLocalSdk` y debe
cerrar sin API call.

Contrato vigente de cadena y capacidades: consumir asignaciones y bindings
conocidos; discovery solo para capacidades desconocidas, ambiguas o nuevas.
Las matrices `matrices/OPERATIONAL_CHAIN_GOVERNANCE_MATRIX.csv` y
`matrices/CAPABILITY_USE_HARDENING_MATRIX.csv` usan `ACTIVE_PROPORTIONAL`.
Sus IDs historicos con sufijo `global` y sus columnas `required_*_source`
identifican catalogos de referencia; no obligan a invocar cada componente.
`chain_policy=APPLICABLE_COMPONENTS_ONLY` permite omitir o marcar `NO_APLICA`
una skill, recipe, plugin o validator que no intervenga en la operacion.

La matriz `matrices/AUTONOMOUS_AGENT_EXECUTION_MATRIX_20260602.csv` usa
`discovery_skill_when_needed` y las mismas politicas proporcionales. Sus estados
de entorno conservan el significado de disponibilidad registrada; no acreditan
acceso live actual. Un agente ejecuta solo sus capacidades asignadas y disponibles.
READ/LOW no requieren orden por usar Cloud, abrir un PR o ser Microsoft/OpenAI.
La autenticacion normal con una credencial ya resuelta mediante el binding no
activa HIGH. El trigger de secretos es `secret_exposure_materialization_or_rotation`;
`secret_detected` detiene la exposicion o persistencia en artefactos o salidas,
no la autenticacion legitima que mantiene el secreto fuera de esas superficies.

READ/LOW no requieren orden, discovery repetido ni expediente de evidencia
global. READ devuelve resultado o fuente; LOW agrega precheck, reversibilidad
o compensacion y postcheck. La evidencia es el resultado tecnico pertinente,
no una auditoria o proceso probatorio salvo que ese sea el objeto solicitado.
Solo un trigger HIGH requiere autoridad explicita. Una carencia material
detiene la operacion afectada con `RESOLUTION_REQUIRED`, preserva su tier y
permite continuar trabajo independiente. Los alias legacy de stop conditions
se interpretan con esta semantica en `matrices/STOP_CONDITION_GLOSSARY.csv`.

Los validadores `tools/local_validate_operational_chain.ps1` y
`tools/local_validate_capability_use_hardening.ps1` conservan integridad de
referencias y ejecutan `scripts/validators/capability_chain_contract_validator.py`
para detectar regresiones de gateo global. El segundo ejecuta tambien sus casos
negativos offline. Su PASS no acredita permisos ni ejecucion Microsoft live.

Actualizacion cola paralela 2026-06-01: los work units por issue viven en
`matrices\PARALLEL_ISSUE_LANE_QUEUE.csv`. La cola exige `base_sha`, rama
`codex/*`, file set exacto, lock unico y dependencias antes de despachar
workers. Los indices compartidos se integran en carril serial.

Actualizacion skills repo-locales 2026-06-01: las skills cabina que deben
viajar con el repo se guardan en `.agents\skills\<skill>\SKILL.md`. La
carpeta `.agents\codex\skills` no instala por si misma: registra uso,
subskills y source refs.

Actualizacion autonomia gobernada 2026-06-02: `tcu-descubridor-capacidades`
se usa ante capacidad desconocida, ambigua o nueva. La matriz
`matrices\AUTONOMOUS_AGENT_EXECUTION_MATRIX_20260602.csv` y el validador
`tools\local_validate_autonomous_agent_execution.ps1` preparan agentes locales
task-scoped y Codex Cloud repo-scoped con owner, reviewer, evidencia,
rollback, postcheck y stop condition. Los repos sin environment visible quedan
`BLOCKED_NO_CODEX_CLOUD_ENVIRONMENT`; los environments fuera de la raiz C se
marcan como candidatos, no como repos absorbidos.

Actualizacion entornos Codex 2026-06-02: `.codex\environments\environment.toml`
queda creado para setup local/worktree de la raiz C con validadores de cabina. La
matriz `matrices\CODEX_APP_LOCAL_ENVIRONMENT_MATRIX_20260602.csv`, la cola
`matrices\CODEX_ENVIRONMENT_CREATION_QUEUE_20260602.csv`, la orden
`orders\ORDER_CODEX_ENVIRONMENT_CREATION_20260602.md` y el validador
`tools\local_validate_codex_app_environments.ps1` gobiernan Codex app y Cloud
environments. La creacion Cloud directa queda `NO_DISPONIBLE_CLI_CREATE_ENV`
si no aparece tool/API real de administracion.

Actualizacion asignacion Cloud 2026-06-02: por verificacion posterior a la
creacion informada por el operador, nueve environments adicionales quedaron
`CODEX_CLOUD_ENV_VISIBLE` con smoke read-only `READY_NO_DIFF`:
`universo-rey/organizacion`,
`SeshatSgin/torre-gemela-escribania`,
`SeshatSgin/tge-agentic-runtime-control-escribania`,
`SeshatSgin/sgin-cumplimiento`, `SeshatSgin/cdf-soluciones`,
`SeshatSgin/jara-consultores`, `SeshatSgin/seshat-bootstrap-sdu-cn`,
`SeshatSgin/tcu-agentic-runtime-control` y
`universo-rey/microsoft-agents-governed-lab`. Permanecen en cola por label no
resuelto en CLI: `SeshatSgin/modo-on-foundation` y `SeshatSgin/sdu-canon`.

Actualizacion runner agregado 2026-06-02: la Fase 3 de performance agrega
`tools\local_run_governance_validation_suite.ps1` como runner agregado. Tras
tres corridas manuales adicionales exitosas en GitHub Actions, el runner fue
promovido a gate principal inicial de PR/push/manual en
`cabina-validation.yml`. Desde el PR #53, el gate productivo vigente es el
Change-Aware Full-Coverage Orchestrator; el runner agregado queda retenido como
conjunto completo de validadores y evidencia diagnostica. El runner compone los
validadores actuales, informa duracion por subvalidador y no escribe evidencia
salvo que se use `-WriteResult`.

Actualizacion hash sets validadores 2026-06-03: los validadores principales de
la capa de agentes reemplazan chequeos repetidos de membresia contra arrays por
`HashSet[string]` case-insensitive en ids, columnas y stop conditions. El cambio
mantiene cobertura y no modifica workflow, permisos, superficies live ni salida
funcional esperada.

Actualizacion Change-Aware Full-Coverage Orchestrator 2026-06-03:
`tools\local_run_change_aware_full_coverage_orchestrator.ps1` queda como gate
productivo de CI. Usa `matrices\CHANGE_AWARE_TEST_MANIFEST.csv`,
`matrices\CHANGE_AWARE_RISK_POLICY.csv` y
`matrices\CHANGE_AWARE_IMPACT_GRAPH.csv` para ordenar y diagnosticar riesgo,
pero ejecuta todos los tests obligatorios y bloquea si falta manifiesto, grafo,
test obligatorio, equivalencia de cobertura o evidencia de fallos visibles. El
artefacto local vive en
`evals\results\change_aware_full_coverage_audit_latest.json`. En `main`, el
PR #53 cerro con merge commit `d21aad4280180328c41e4ca91c61e033a63551b6` y la
corrida GitHub Actions `26859024863` cerro `success` con el artifact saneado
`change-aware-full-coverage-26859024863`.

## Olas de agentes

Ola 1: orquestacion, fronteras, registro, canon, repos, corte OpenAI y torres Escribania/Modo ON.

Ola 2: evidencia Seshat, gate SDU, schemas Thot, migracion a D, referencias tecnicas y guardian del workspace Codex.
