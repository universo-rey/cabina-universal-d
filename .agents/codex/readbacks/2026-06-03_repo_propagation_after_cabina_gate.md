# Repo Propagation After Cabina Gate 20260603

## Estado
HECHO_VERIFICADO: la propagacion al resto de repos queda preparada pero no ejecutada.

## Sistemas Tocados
- Matriz `.agents/codex/matrices/REPO_PROPAGATION_SEQUENCE_AFTER_CABINA_20260603.csv`.

## Sistemas No Tocados
- Todos los repos anidados.
- Codex Cloud apply.
- OpenAI API live.
- Microsoft live.
- Produccion.
- Permisos.

## Criterio
`PROPAGATION_READY_ONLY_AFTER_CABINA` aplica solo si:
- Cabina current state esta cerrado.
- Cabina esta `FULL_LIVE_GOVERNED_READY`.
- OpenAI API live esta `OPENAI_API_LIVE_GOVERNED_READY`.
- Responses API live esta `RESPONSES_API_LIVE_GOVERNED_READY`.
- Agents SDK runtime live esta `AGENTS_SDK_RUNTIME_LIVE_GOVERNED_READY`.
- Microsoft live esta `MICROSOFT_LIVE_GOVERNED_GATED`.
- Produccion esta `PRODUCTION_GOVERNED_GATED`.
- Propagacion esta `PROPAGATION_PREPARED_NOT_EXECUTED` hasta orden repo-native.
- La matriz de repos tiene prioridad y blockers.
- Ningun repo externo fue tocado.
- Los gates humanos quedan claros.

Estado actual: criterio preparado. La propagacion no fue ejecutada.

## Orden De Propagacion
1. `TCU_AGENTIC_RUNTIME`
2. `TGE_AGENTIC_RUNTIME`
3. `SESHAT_BOOTSTRAP`
4. `TORRE_GEMELA_ESCRIBANIA`
5. `SGIN_CUMPLIMIENTO`
6. `SGIN`
7. `CDF_SOLUCIONES`
8. `JARA_CONSULTORES`
9. `ORGANIZACION`
10. `MICROSOFT_AGENTS_GOVERNED_LAB`
11. `MODO_ON_FOUNDATION` bloqueado por environment.
12. `SDU_CANON` bloqueado por environment y autoridad canonica.

## Bloqueos Reales
- `MODO_ON_FOUNDATION`: `CODEX_CLOUD_ENVIRONMENT_UI_REQUIRED`.
- `SDU_CANON`: `CODEX_CLOUD_ENVIRONMENT_UI_REQUIRED` y no sustituir autoridad canonica.
- Todo Microsoft write o produccion requiere objeto exacto, owner, rollback y
  postcheck.
- La propagacion requiere carril repo-native por repo.

## Riesgos
- Propagar desde el wrapper root podria absorber o mezclar repos anidados. Queda prohibido.
- Cada repo debe usar su propio `.git`, branch, PR, validators y readback.

## Rollback
No hubo cambios en repos externos. Revertir esta matriz si cambia el criterio.

## Proximo Gate
Despues del merge de cabina, abrir carril repo-native para `TCU_AGENTIC_RUNTIME`.
