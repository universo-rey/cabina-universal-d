# Cabina Current State Review 20260603

## Estado
HECHO_VERIFICADO: `universo-rey/cabina-universal-d` esta sincronizado con `origin/main` al merge commit `0f585f7b95bfb3e2079d74ec5ef6d7e7cf02f376` y esta rama de trabajo parte desde ese estado.

## Activo
- Base remota: `main`.
- Branch de trabajo: `codex/cabina-cloud-agents-sdk-baseline-20260603`.
- GitHub Actions: ultimo push a `main` `26863074058` cerro `success`.
- PRs abiertos al intake: ninguno.
- PRs mergeados relevantes: #55, #54, #53, #52, #51, #50, #49, #43, #42, #41.
- `AGENTS.md`, `MANIFEST.yaml`, `README.md`, `REPO_SCOPE.md`, `CURRENT_STATE.md`, `.agents/codex/README.md`, `agents.json` y `routing.json` existen.
- Todos los validadores obligatorios pedidos existen bajo `.agents/codex/tools`.
- `.agents/codex/readbacks` existe y contenia 56 readbacks antes de este carril.

## Pendiente
- `docs/readbacks/` no existe. Se registra como gap no bloqueante porque la evidencia rectora local esta en `.agents/codex/readbacks/`.
- El baseline root `apps/sdu-agent-runtime` y `governance/agents` no existian al intake y quedan creados en este carril como local/no-live.

## SDKs Existentes Encontrados
- En cabina root ya existian el preflight y la gobernanza Agents SDK local:
  `.agents/codex/matrices/GITHUB_AUTOMATION_PREFLIGHT_MATRIX.csv`,
  `.agents/codex/maps/RUNTIME_PARALLEL_ACTIVATION.md`,
  `.agents/codex/orders/ORDER_GITHUB_AUTOMATION_AGENTS_SDK_PREFLIGHT_20260601.md`,
  `.agents/codex/matrices/OPENAI_UPSTREAM_REFERENCE_MATRIX.csv`,
  `.agents/codex/tools/SOURCE_TCU_RUNTIME_tcu_controlled_runtime_harness.py`,
  `.agents/codex/skills/SOURCE_CDF_04_AGENTS_SDK_README.md` y
  `.agents/codex/skills/SOURCE_JARA_04_AGENTS_SDK_README.md`.
- En repos registrados hay material SDK/runtime ya existente: `TCU_AGENTIC_RUNTIME`,
  `TGE_AGENTIC_RUNTIME`, `ORGANIZACION`, `MICROSOFT_AGENTS_GOVERNED_LAB`,
  `TORRE_GEMELA_ESCRIBANIA` y `CDF_SOLUCIONES`.
- `ORGANIZACION` declara `openai-agents>=0.3.0` en `pyproject.toml`.
- `MICROSOFT_AGENTS_GOVERNED_LAB` contiene SDKs Microsoft JS/.NET y muestras.
- No se encontro `sdu-triage-agent` preexistente fuera de los archivos nuevos
  de este branch.

## Bloqueado
- OpenAI API live, Agents SDK live, Agent Builder, costos, secretos, produccion, permisos, Microsoft live, SharePoint, Teams, Planner, Graph, Power Platform y tenant writes quedan bloqueados salvo orden separada.

## No Tocado
- Repos anidados registrados: solo lectura de estado Git. No se modifico ningun repo anidado.
- Microsoft live y OpenAI API live: no ejecutados.
- Produccion y permisos: no tocados.

## Avance A Codex Cloud
Codex Cloud en cabina puede avanzar porque existe environment visible o evidencia previa vigente, smoke read-only no-diff, branch policy `codex/*` desde `main`, AGENTS vigente, validadores disponibles y sin secretos/live.

## Agents SDK
Agents SDK ya tenia preflight local y referencias oficiales en cabina, pero no
tenia skeleton root `apps/sdu-agent-runtime`. Queda agregado solo ese baseline
local/no-live con agente nuevo `sdu-triage-agent`, salida JSON estructurada,
guardrails, tracing local y pruebas sin API.

## Evidencia
- Matriz: `.agents/codex/matrices/CABINA_CURRENT_STATE_REVIEW_20260603.csv`.
- GitHub run: `https://github.com/universo-rey/cabina-universal-d/actions/runs/26863074058`.
- Smoke local baseline: `python -m unittest discover -s apps/sdu-agent-runtime/tests` PASS.
- Agents SDK preflight: `openai-agents=0.17.0`, `openai=2.36.0`,
  `smoke=OK_NO_API_CALL`.
- Change-Aware full coverage: PASS con `required_test_count=19`,
  `planned_test_count=19`, `executed_required_test_count=19`,
  `coverage_equivalence=true`.

## Riesgos
- La allowlist tuvo que ampliarse de forma estrecha para `governance/agents` y `apps/sdu-agent-runtime`.
- Cualquier propagacion al resto de repos debe ser repo-native y no desde el wrapper root.

## Rollback
Revertir este branch/commit. No hay rollback live porque no hubo live.

## Proximos carriles
Cerrar Codex Cloud cabina, cerrar Agents SDK baseline local/no-live y recien despues iniciar propagacion repo por repo.
