# Agents SDK Functional Lifecycle Smoke

## Estado
AGENTS_SDK_FUNCTIONAL_LIFECYCLE_PASS

## Alcance
- Repo: universo-rey/cabina-universal-d
- Canon: CABINA_FULL_LIVE_GOVERNED_GLOBAL_CANON
- Superficie: OpenAI API live, Responses API live, Agents SDK runtime live
- Payload: sintetico no sensible
- Script versionado: `.agents/codex/scripts/agents_sdk_functional_lifecycle_smoke.py`

## Evidencia Ejecutada
- `import openai`: PASS
- `import agents`: PASS
- `openai` version: 2.40.0
- `openai-agents` version: 0.17.4
- OpenAI `models.list`: PASS
- Modelo usado: `gpt-5.5`
- Responses API live: PASS
- Responses marker verificado: yes
- Agents SDK `Agent + Runner`: PASS
- Agents marker verificado: yes
- Agent name: `cabina-agents-sdk-functional-lifecycle`

## Seguridad
- Credential source: local ignored env file
- Secrets printed: false
- Response bodies printed: false
- Agent output printed: false
- Datos reales o regulados: no usados
- Dumps amplios: no ejecutados
- Agentes persistentes remotos: no creados

## Superficies No Ejecutadas
- Microsoft live write: ENABLED_GOVERNED_GATED_NOT_EXECUTED
- SharePoint write: ENABLED_GOVERNED_GATED_NOT_EXECUTED
- Teams write: ENABLED_GOVERNED_GATED_NOT_EXECUTED
- Planner write: ENABLED_GOVERNED_GATED_NOT_EXECUTED
- Graph mutation: ENABLED_GOVERNED_GATED_NOT_EXECUTED
- Power Platform mutation: ENABLED_GOVERNED_GATED_NOT_EXECUTED
- Produccion: ENABLED_GOVERNED_GATED_NOT_EXECUTED
- Propagacion: ENABLED_GOVERNED_GATED_NOT_EXECUTED

## Stop Condition
Bloquear si falta `OPENAI_API_KEY`, si no importan `openai` o `agents`, si no responde `models.list`, si falla Responses API, si falla Agents SDK Runner, si se imprime un secreto, si se usan datos reales o si se intenta una superficie gated sin target exacto, owner, rollback y postcheck.

## Rollback
Revertir el commit/PR que agrega el script y readbacks. No hay rollback externo porque no se ejecutaron writes Microsoft, produccion ni propagacion.
