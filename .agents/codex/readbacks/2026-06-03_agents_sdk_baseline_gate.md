# Agents SDK Baseline Gate 20260603

## Estado
HECHO_VERIFICADO: el repo ya tenia preflight Agents SDK local y referencias
OpenAI SDK gobernadas. No tenia skeleton root `apps/sdu-agent-runtime` ni
`governance/agents` antes de este carril. El carril queda actualizado a
`FULL_LIVE_GOVERNED_READY` para PR #56: OpenAI API live, Responses API live y
Agents SDK `Runner` live fueron validados con payload sintetico, sin imprimir
body ni secretos.

## Sistemas Tocados
- `governance/agents/AGENTS_SDK_BASELINE_POLICY.md`
- `governance/agents/AGENTS_SDK_AGENT_REGISTRY.md`
- `governance/agents/AGENTS_SDK_SECURITY_POLICY.md`
- `governance/agents/AGENTS_SDK_ORCHESTRATION_MODEL.md`
- `apps/sdu-agent-runtime/`
- `.agents/codex/matrices/AGENTS_SDK_BASELINE_GATE_20260603.csv`

## Sistemas No Tocados
- Import `openai-agents`.
- SDK tools, SDK handoffs y SDK tracing.
- Agent Builder.
- Vector stores externos.
- Microsoft live.
- Produccion.
- Permisos.
- Repos anidados.

## Baseline Creado
- Agente permitido: `sdu-triage-agent`.
- Modo: `full_live_governed`.
- Default path: `local_no_live`.
- Estado: `FULL_LIVE_GOVERNED_READY`.
- OpenAI API live: `OPENAI_API_LIVE_GOVERNED_READY`.
- Responses API live: `RESPONSES_API_LIVE_GOVERNED_READY`.
- Agents SDK runtime live: `AGENTS_SDK_RUNTIME_LIVE_GOVERNED_READY`.
- Microsoft live: `MICROSOFT_LIVE_GOVERNED_GATED`.
- Produccion: `PRODUCTION_GOVERNED_GATED`.
- Propagacion: `PROPAGATION_PREPARED_NOT_EXECUTED`.
- Salida: `structured_json`.
- Tools permitidas: biblioteca estandar local y validacion de schema.
- Writes externos: prohibidos.
- SDK real: importado y ejecutado solo en smoke gobernado.
- OpenAI API live: autorizado solo para smoke PR #56, sin body dump.
- Microsoft live: preparado pero no ejecutado sin objeto exacto.
- Produccion: preparada pero no ejecutada sin target exacto.

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

Resultado ejecutado: PASS, 5 tests.

Preflight SDK existente ejecutado:

- `openai-agents=0.17.0`
- `openai=2.36.0`
- `smoke=OK_NO_API_CALL`

Smokes live gobernados ejecutados:

- `import openai`: PASS.
- `import agents`: PASS.
- OpenAI `models.list`: PASS, body no impreso.
- Responses API: PASS, body no impreso.
- Agents SDK `Agent` + `Runner`: PASS, body no impreso.
- Modelo smoke: `gpt-5.5`.

## Dictamen
`FULL_LIVE_GOVERNED_READY`.

## Bloqueos
No hay bloqueo para OpenAI live smoke gobernado PR #56. Microsoft live write,
produccion, permisos, SDK tools, SDK handoffs, SDK tracing, Agent Builder,
agentes persistentes, tenant write o propagacion siguen detenidos hasta orden
gobernada separada con objeto exacto, rollback y postcheck.

## Riesgos
- Los smokes live consumen API, aunque con payload minimo sintetico.
- No se imprimio body ni secreto.
- Microsoft y produccion estan preparados como gates, no ejecutados.
- Propagacion al resto de repos no fue ejecutada.

## Rollback
Revertir los archivos de este branch.

## Proximo Gate
Mantener PR #56 draft hasta cierre completo. Propagar solo despues de cerrar
cabina y por repo-native branch con validadores propios.
