# Cabina Process Rescue Multi-Repo Framework

estado: `PROCESS_RESCUE_FRAMEWORK_ACTIVE`
fecha: `2026-06-05`
repo: `universo-rey/cabina-universal-d`
base: `origin/main 159c56850e832c74775f2ec4bcb8bae919e34d5f`

## Proposito

Este framework convierte procesos ya ejecutados por la Cabina en activos
reutilizables antes de iniciar mejoras globales de agentes. No crea una Cabina
paralela, no absorbe repos anidados y no reemplaza los contratos ya vigentes.

## Cuando Usar

Usar este framework cuando una orden pida rescatar carriles, decisiones,
prompts, criterios, validaciones, readbacks, matrices o patrones operativos ya
probados y convertirlos en framework, runbook, recipe, skill, tool spec, matriz,
gate package, readback pattern o plan multi-repo.

## Cuando No Usar

No usar para ejecutar live writes, produccion, permisos, tenants, secretos,
costos externos, propagacion multi-repo o mejoras masivas de agentes sin carril
propio. Esas superficies requieren gate especifico.

## Fuentes Rectoras

1. Gate humano explicito.
2. Seguridad, secretos, produccion y datos regulados.
3. `AGENTS.md`.
4. `MANIFEST.yaml`.
5. Validators y workflows vigentes.
6. Recipes, skills, tools, matrices y readbacks.
7. Documentacion historica.

## Fases

### F0 Re-Anclaje

Confirmar root efectivo, branch, HEAD, remoto, dirty state y `origin/main`.
Si el root canonico esta sucio con otro carril, crear worktree limpio desde el
HEAD autorizado y no stagear cambios preexistentes.

### F1 Descubrimiento

Leer fuentes rectoras y registrar repos, procesos, activos, validators, recipes,
skills, tools, readbacks, gates y stop conditions existentes.

### F2 Extraccion

Extraer cada proceso como unidad operativa con origen, repo, superficie,
agente, skill, recipe, tool, entrada, pasos, salida, evidencia, validator,
rollback, postcheck, estado activo, riesgo y stop condition.

### F3 Reconciliacion

Buscar equivalentes por nombre, alias, funcion, repo, universo, superficie,
skill, recipe, tool, validator y stop condition. Reutilizar o extender antes de
crear. Si hay solapamiento, registrar reconciliacion en matriz.

### F4 Formalizacion

Crear o actualizar solo activos allowlisted: canon, matrices, readbacks,
recipes, skills o tool specs. Mantener cambios pequenos, atomicos y
reversibles.

### F5 Validacion

Ejecutar validadores locales relevantes, parse de CSV/YAML cuando aplique y
`git diff --check`. No declarar PASS si un validator no corrio.

### F6 Cierre

Stage explicito, commit, push a `codex/*`, PR draft y readback con evidencia,
riesgo, rollback, stop condition y proximos carriles.

## Gates

- `GATE_SECRET_USE`: cualquier secreto real.
- `GATE_COST_BOUNDARY`: API paga o costo externo sin limite.
- `GATE_LIVE_WRITE`: Microsoft, OpenAI, GitHub o Power Platform live write.
- `GATE_PRODUCTION_DEPLOY`: produccion.
- `GATE_REPO_NATIVE_WRITE`: write en repo registrado distinto de la cabina raiz.
- `GATE_WORKTREE_METADATA`: metadata Git critica, remotos o `core.worktree`.
- `GATE_MERGE_MAIN`: merge a `main`.

## Evidencia Minima

- root y branch verificados;
- HEAD base autorizado;
- archivos fuente leidos;
- procesos rescatados;
- duplicados evitados;
- activos creados o actualizados;
- validators ejecutados;
- rollback por archivo;
- PR o motivo exacto si no hubo PR.

## Stop Conditions

- `ROOT_WORKTREE_DIRTY_SCOPE_CONFLICT`
- `PROCESS_EQUIVALENT_FOUND_RECONCILE_FIRST`
- `PENDING_REPO_NATIVE_ORDER_ONLY`
- `PENDING_COST_BOUND_ONLY`
- `PENDING_SECRET_ONLY`
- `PENDING_VALIDATOR_ONLY`
- `BLOCKED_REPO_BOUNDARY`
- `BLOCKED_SECURITY_RISK`
- `BLOCKED_PRODUCTION_UNAPPROVED`

## Relacion Con Planos

Este framework se ejecuta entre el plano de clasificacion y el plano de agentes.
Su salida alimenta los planos de skills, recipes, validacion, evidencia,
readback y evolucion, sin saltar gates de live o produccion.
