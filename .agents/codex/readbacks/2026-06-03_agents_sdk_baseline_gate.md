# Agents SDK Baseline Gate 20260603

## Estado
HECHO_VERIFICADO: el repo ya tenia preflight Agents SDK local y referencias
OpenAI SDK gobernadas. No tenia skeleton root `apps/sdu-agent-runtime` ni
`governance/agents` antes de este carril. Se crea baseline local/no-live sin
llamadas API ni writes externos.

## Sistemas Tocados
- `governance/agents/AGENTS_SDK_BASELINE_POLICY.md`
- `governance/agents/AGENTS_SDK_AGENT_REGISTRY.md`
- `governance/agents/AGENTS_SDK_SECURITY_POLICY.md`
- `governance/agents/AGENTS_SDK_ORCHESTRATION_MODEL.md`
- `apps/sdu-agent-runtime/`
- `.agents/codex/matrices/AGENTS_SDK_BASELINE_GATE_20260603.csv`

## Sistemas No Tocados
- OpenAI API live.
- Agents SDK live.
- Agent Builder.
- Vector stores externos.
- Microsoft live.
- Produccion.
- Permisos.
- Repos anidados.

## Baseline Creado
- Agente permitido: `sdu-triage-agent`.
- Modo: `local_no_live`.
- Salida: `structured_json`.
- Tools permitidas: biblioteca estandar local y validacion de schema.
- Writes externos: prohibidos.
- OpenAI API live: prohibido sin orden separada.
- Microsoft live: prohibido.
- Produccion: prohibida.

## SDKs Ya Existentes Reusados
- `GITHUB_AUTOMATION_PREFLIGHT_MATRIX.csv` con `preflight.agents_sdk_local`.
- `RUNTIME_PARALLEL_ACTIVATION.md` con comando de smoke local no-api.
- `ORDER_GITHUB_AUTOMATION_AGENTS_SDK_PREFLIGHT_20260601.md`.
- `OPENAI_UPSTREAM_REFERENCE_MATRIX.csv` con `openai-agents-python`,
  `openai-agents-js` y Responses starter como referencias.
- Harnesses TCU/TGE existentes en repos anidados permanecen repo-native.

## No Duplicado
No se creo un segundo preflight ni se copio codigo de repos anidados. La pieza
nueva cubre solo el hueco root: skeleton local/no-live y registry de baseline.

## Pruebas
El smoke local usa `python -m unittest discover -s apps/sdu-agent-runtime/tests` y valida salida estructurada, bloqueo de superficies prohibidas y ausencia de writes externos.

Resultado ejecutado: PASS, 3 tests.

Preflight SDK existente ejecutado:

- `openai-agents=0.17.0`
- `openai=2.36.0`
- `smoke=OK_NO_API_CALL`

## Dictamen
`AGENTS_SDK_BASELINE_READY`.

## Bloqueos
No hay bloqueo para baseline local/no-live. Si se solicita API live, costo, Agent Builder, agentes persistentes, tenant write o produccion, detener con orden gobernada separada.

## Riesgos
- El skeleton no demuestra ejecucion real de OpenAI Agents SDK live.
- El baseline es intencionalmente determinista y local para no abrir costos ni secretos.

## Rollback
Revertir los archivos de este branch.

## Proximo Gate
Propagar solo despues de mergear cabina y por repo-native branch con validadores propios.
