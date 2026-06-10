# READBACK_SDU_FULL_LIVE_GOVERNED_DEFAULT_20260610

agente: Codex
orden: switch_default_runtime_to_full_live_governed + run_governed_openai_agents_sdk_smoke
superficie: repo local + OpenAI live sintético + Agents SDK
repo: universo-rey/cabina-universal-d
workspace: C:\Users\enzo1\Documents\GitHub\cabina-universal-d
branch: codex/tenant-controlled-dataverse-segments-20260608
head: 423dc17
skill: governed-readback-closeout | cabina-agent-md-refactor | openai-platform-api-key | openai-developers:agents-sdk
receta: governed_readback_closeout
tool: apply_patch | git diff --check | .venv\Scripts\python.exe | OpenAI Platform connector
estado: HECHO_VERIFICADO

## Sistemas tocados

- apps/sdu-agent-runtime/src/agents/sdu_triage_agent.py
- apps/sdu-agent-runtime/src/schemas/triage_schema.py
- apps/sdu-agent-runtime/tests/test_sdu_triage_agent.py
- apps/sdu-agent-runtime/README.md
- governance/agents/AGENTS_SDK_BASELINE_POLICY.md
- governance/agents/AGENTS_SDK_AGENT_REGISTRY.md
- .agents/codex/scripts/codex_cloud_full_live_governed_setup.sh
- .agents/codex/scripts/codex_cloud_full_live_governed_maintenance.sh
- .env.local

## Sistemas no tocados

- Microsoft live surfaces
- Dataverse live writes
- SharePoint, Teams, Planner, Graph
- Production
- GitHub PRs, pushes, merges
- Historical readbacks preserved as evidence

## Cambios

- El default runtime del agente cambió de `local_no_live` a `full_live_governed`.
- La validacion del schema y el test del agente quedaron alineados con el nuevo modo base.
- La documentacion activa y los scripts de cabina quedaron alineados con el default live gobernado.
- Se creo `OPENAI_API_KEY` en `.env.local` para este workspace y no se imprimio su valor.

## Validacion

- `git diff --check`: PASS
- OpenAI live smoke sintético: PASS
- Responses API live: PASS
- Agents SDK Runner live: PASS
- `secrets_printed`: false
- `response_bodies_printed`: false

## Riesgos

- Riesgo medio por key local persistida en `.env.local`.
- Los readbacks historicos con `local_no_live` se preservan como evidencia y no se reescriben.

## Rollback

- Revertir los archivos tocados.
- Eliminar o desactivar `OPENAI_API_KEY` en `.env.local` si se quiere retirar el acceso live local.

## Proximos carriles

1. Commit de los cambios activos si querés una base versionada.
2. Ajuste documental adicional solo si querés normalizar historia antigua.
3. Continuar con nuevos smoke/live governed tasks bajo este default.
