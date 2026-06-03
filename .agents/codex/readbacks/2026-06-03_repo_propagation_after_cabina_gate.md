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
- Codex Cloud cabina esta `CODEX_CLOUD_CABINA_READY_BY_PRIOR_SMOKE_WITH_ENV_ID_GAP`.
- Agents SDK baseline esta `AGENTS_SDK_LOCAL_NO_LIVE_BASELINE_READY` o bloqueado con razon exacta.
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
- Todo live Microsoft o OpenAI API live requiere orden separada.

## Riesgos
- Propagar desde el wrapper root podria absorber o mezclar repos anidados. Queda prohibido.
- Cada repo debe usar su propio `.git`, branch, PR, validators y readback.

## Rollback
No hubo cambios en repos externos. Revertir esta matriz si cambia el criterio.

## Proximo Gate
Despues del merge de cabina, abrir carril repo-native para `TCU_AGENTIC_RUNTIME`.
