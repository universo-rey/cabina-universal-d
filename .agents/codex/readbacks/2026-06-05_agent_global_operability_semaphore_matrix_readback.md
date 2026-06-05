# Readback - Agent Global Operability Semaphore Matrix

agente: codex.workspace_guardian + rey.frontier_guardian + court.seshat_evidence
orden: recuperar y versionar la matriz semaforo de agent_global_operability
superficie: repo-scoped local governance matrix
repo: universo-rey/cabina-universal-d
workspace: C:\Users\enzo1\.codex\worktrees\2aa1\cabina-universal-d
branch: codex/agent-global-operability-semaphore-matrix-20260605
base: origin/main 32de5fe44210466119be4269a0d2454e9f974d2b

## Estado

AGENT_GLOBAL_OPERABILITY_SEMAPHORE_MATRIX_ROUTED

## Preflight de no duplicacion

Se busco matriz existente por nombre y funcion:

- `semaforo`
- `semáforo`
- `traffic`
- `RAG`
- `red`
- `yellow`
- `green`
- `verde`
- `amarillo`
- `rojo`
- `status matrix`
- `decision matrix`
- `gate matrix`
- `backlog`

Resultado: no se encontro una matriz semaforo explicita. Se reutilizo como fuente la matriz de backlog gated ya mergeada por PR #104.

## Regla semaforo

| Color | Significado operativo |
| --- | --- |
| GREEN | Frontera local satisfecha; no requiere accion nueva. |
| YELLOW | Guardrail activo; puede avanzar solo dentro de scope explicito. |
| RED | Gate real pendiente; no ejecutar sin orden humana/gate requerido. |

## Conteo

- GREEN: 4
- YELLOW: 1
- RED: 4

## Acciones ejecutadas

- Se creo `.agents/codex/matrices/AGENTS_SDK_LIVE_AGENT_GLOBAL_OPERABILITY_SEMAPHORE_MATRIX_20260605.csv`.
- Se registro la matriz en `MATRIX_INDEX.csv`.
- Se agrego cobertura en `VALIDATION_COVERAGE_MATRIX.csv`.
- Se agrego allowlist exacta del readback en `.gitignore`.
- No se ejecuto OpenAI API live.
- No se ejecuto Microsoft live.
- No se toco produccion.
- No se tocaron secretos.
- No se tocaron repos externos ni repos anidados.

## Riesgo

bajo. Es una vista operacional derivada de decisiones ya versionadas y backlog ya mergeado.

## Rollback

Revertir el commit del carril o eliminar la matriz semaforo, su fila de indice, su fila de cobertura, la allowlist exacta y este readback.

## Stop condition

AGENT_GLOBAL_OPERABILITY_SEMAPHORE_MATRIX_ROUTED
