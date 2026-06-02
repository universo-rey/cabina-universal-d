# Workpaper: OpenAI Repair Loop And Repo Lanes

agente: `court.openai_dispatcher`
orden: codificar loop OpenAI local y preparar carriles repo-nativos
superficie: `D:/.agents/codex/recipes`, `D:/.agents/codex/matrices`
skill: `openai-developers:agents-sdk|tcu-harness-evals-agentes|openai-docs`
receta: `recipe.openai_review_repair_validate_loop`
tool: `tool.local_validate_openai_upstream_adoption`

## Decision

El loop reusable queda definido como:

`review -> classify -> repair -> validate -> readback`

Se aplica sin OpenAI API live, sin Agents SDK live, sin costos y sin agentes
remotos persistentes.

## Wave 2

Los repos TCU, SDU, Seshat Bootstrap, TGE, TGE Runtime, CDF, Jara y Modo ON
quedan con carril repo-nativo listo. Cada carril bloquea `nested_repo_mixed_commit`
para evitar mezclar cambios de clones dentro del repo raiz.

## Riesgo y Rollback

Riesgo: interpretar una receta local como permiso para ejecutar API, Teams,
SharePoint o produccion. Rollback: revertir receta, matriz de adopcion e
indices asociados antes de merge.

stop_condition: `openai_api_live_requested_without_order|api_or_remote_agent_requested|secret_detected`
