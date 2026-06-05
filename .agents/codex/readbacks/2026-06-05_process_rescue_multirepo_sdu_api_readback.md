# READBACK_PROCESS_RESCUE_MULTIREPO_SDU_API_20260605

## Estado

HECHO_VERIFICADO: carril repo-scoped limpio creado desde
`origin/main 159c56850e832c74775f2ec4bcb8bae919e34d5f`.

ESTADO_OBJETIVO: `PROCESS_RESCUE_FRAMEWORK_PR_DRAFT_OPEN`.

## Sistemas Tocados

- Repo raiz: `universo-rey/cabina-universal-d`.
- Worktree limpio: `C:\Users\enzo1\.codex\worktrees\process-rescue-cabina-20260605`.
- Branch: `codex/process-rescue-framework-20260605`.

## Sistemas No Tocados

- Dirty lane `codex/agents-global-improvement-20260605`.
- Repos registrados o anidados.
- Microsoft live, SharePoint, Teams, Planner, Dataverse y Power Platform.
- OpenAI API live, Responses API live y Agents SDK live.
- Produccion, tenants, permisos, secretos y costos externos.

## Cambios

- Se agrego un framework de rescate de procesos multi-repo.
- Se agrego una matriz de procesos rescatados.
- Se agrego un plan de ejecucion por oleadas.
- Se indexaron las matrices nuevas en `MATRIX_INDEX.csv`.
- Se agrego cobertura generica en `VALIDATION_COVERAGE_MATRIX.csv`.
- Se creo este readback saneado.

## Procesos Rescatados

1. Re-anclaje a raiz efectiva.
2. Lectura rectora obligatoria.
3. GitHub lifecycle con HEAD fijo.
4. Change-aware full coverage.
5. Governance validation suite.
6. Separacion de repos anidados.
7. Codex Cloud governed lane.
8. OpenAI, Responses API y Agents SDK gobernados.
9. Microsoft y Power Platform live gated.
10. Readback closeout.
11. No duplicacion antes de crear.
12. Diff minimo, stage explicito y rollback.
13. Carriles paralelos con lock.
14. Reconciliacion de dirty repos externos.
15. Carril limpio de process rescue.

## Uso API / SDU

No se ejecuto API live ni Agents SDK live. La evidencia local fue suficiente
para clasificar y formalizar. Cualquier llamada live futura queda en
`PENDING_COST_BOUND_ONLY` si no hay limite de costo y en `PENDING_SECRET_ONLY`
si falta secreto gobernado.

## Validacion

Validadores previstos:

- `git diff --check`.
- parse CSV de matrices nuevas.
- parse YAML de `MANIFEST.yaml`.
- `.agents\codex\tools\local_validate_capability_use_hardening.ps1`.
- `.agents\codex\tools\local_validate_operational_chain.ps1`.
- `.agents\codex\tools\local_validate_agents_instruction_hierarchy.ps1`.

## Riesgos

- Riesgo bajo: cambios repo-scoped, declarativos y reversibles.
- Riesgo medio controlado: los procesos rescatados gobiernan carriles
  multi-repo, pero no ejecutan writes repo-nativos.

## Rollback

Rollback del carril:

```powershell
git revert <commit>
```

Rollback si el PR no debe conservarse:

```powershell
git worktree remove C:\Users\enzo1\.codex\worktrees\process-rescue-cabina-20260605
git branch -D codex/process-rescue-framework-20260605
```

## Proximos Carriles

1. Revisar PR draft del process rescue framework.
2. Reconciliar el dirty lane `codex/agents-global-improvement-20260605`.
3. Preparar paquetes repo-nativos para dirty states externos.
4. Crear validador especifico de process rescue solo si el schema queda
   aprobado.

## Stop Condition

`PROCESS_RESCUE_FRAMEWORK_PR_DRAFT_OPEN`
