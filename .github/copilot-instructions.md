# Cabina Universal del Rey: GitHub Agent Instructions

Actua como agente GitHub/Copilot dentro de la Cabina Universal del Rey.

Fuente rectora local: `AGENTS.md`.

Antes de actuar:

1. Leer `AGENTS.md`.
2. Leer `MANIFEST.yaml`, `MAPA_HUMANO.md`, `00_CONTROL_PLANE_INGRESS/ROUTING.json`,
   `01_GOVERNANCE_REGISTRY/README.md`, `02_AUTHORITY_CANON/CURRENT_STATE.md`,
   `.agents/codex/README.md`, `.agents/codex/agents.json` y
   `.agents/codex/routing.json` cuando existan en el checkout.
3. Identificar universo, repo/superficie, agente local rector y frontera.

Regla rectora:

- `universo-rey/cabina-universal-d` es base transversal e indice de gobierno.
- Cada repo anidado conserva su propio `.git`, remoto, rama y PR.
- No absorbas clones anidados dentro del repo raiz.
- Trabaja en rama `codex/*` y PR; no hagas merge.
- No uses `git add .`.
- Los agentes GitHub/Copilot/issue/PR/Actions de este repo estan aprobados como
  superficie operativa. No requieren gate separado para tareas repo-scoped en
  rama, PR y validacion.

Agentes locales:

- `rey.control_plane_orchestrator`
- `rey.frontier_guardian`
- `rey.governance_registrar`
- `rey.authority_canonist`
- `rey.repo_cartographer`
- `rey.migration_planner`
- `court.openai_dispatcher`
- `court.seshat_evidence`
- `court.sdu_gate`
- `court.thot_schema`
- `tech.reference_librarian`
- `codex.workspace_guardian`
- `universe.escribania_tower`
- `universe.modo_on_tower`

Bloqueos:

- No production.
- No Microsoft live.
- No OpenAI API live.
- No secretos, credenciales o datos regulados.
- No permisos, visibilidad, owners o branch protections.
- No force push.
- No borrar ramas remotas.
- No mover clones.
- No agentes externos fuera de GitHub/Copilot sin orden especifica.

Runtime productivo y live externo:

Los agentes GitHub aprobados pueden operar issues, instrucciones, ramas, commits,
PRs y GitHub Actions de validacion dentro del repo. Produccion, Microsoft live,
OpenAI API live, permisos, secretos, costos externos o datos regulados siguen
fuera de esta aprobacion.

Cierre minimo:

- agente:
- orden:
- superficie:
- estado:
- evidencia:
- validador:
- stop_condition:
- proximos_carriles:
