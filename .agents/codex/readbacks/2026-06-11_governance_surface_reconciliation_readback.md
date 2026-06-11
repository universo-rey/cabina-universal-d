# READBACK / README: GOVERNANCE SURFACE RECONCILIATION 20260611

## Estado
HECHO_VERIFICADO:
- Este archivo es la lectura humana del CSV [GOVERNANCE_SURFACE_RECONCILIATION_20260611.csv](../matrices/GOVERNANCE_SURFACE_RECONCILIATION_20260611.csv).
- La decision operativa actual es conservar como puente, evidencia o puntero todo lo que sigue anclado a canon rector o a superficies gobernadas.
- Resultado del carril: 0 moves, 0 retiros, 0 writes live.

## Sistemas tocados
- `.agents/codex/readbacks/2026-06-11_governance_surface_reconciliation_readback.md`

## Sistemas no tocados
- `governance/` canon rector.
- `dataverse/`, `teams-app/`, Microsoft live, production y secrets.
- El CSV fuente maquina sigue intacto.

## Resumen ejecutivo
- Los 18 archivos de soporte/evidencia quedaron clasificados como `keep_as_bridge`, `keep_as_evidence` o `keep_as_pointer`.
- Las superficies externas `.agents`, `readbacks`, `scripts`, `validation`, `teams-app` y `dataverse` quedaron mapeadas contra canon rector.
- No aparecieron duplicados exactos de basename que justificaran mover o retirar artefactos en este carril.

## Regla de lectura
- `keep_as_bridge`: el archivo sigue siendo un puente operativo hacia canon o hacia una frontera gobernada.
- `keep_as_evidence`: el archivo conserva evidencia o readback, sin convertirse en canon.
- `keep_as_pointer`: el archivo solo indexa o señala canon, sin reemplazarlo.

## Inventario de soporte / evidencia

| asset_path | classification | live_boundary | decision | canonical_source |
| --- | --- | --- | --- | --- |
| `governance/agents/SDU_AGENTS_RUNTIME_CAPABILITY_DISCOVERY_20260603.md` | `bridge_support` | `local_only` | `keep_as_bridge` | `governance/agents/* \| 02_AUTHORITY_CANON/SDU_CN_CANONICAL_AGENT_PANTHEON_20260604.md` |
| `governance/canon/CABINA_FULL_AUTOMATION_BY_PLANES.md` | `bridge_support` | `local_only` | `keep_as_bridge` | `AGENTS.md \| MANIFEST.yaml \| governance/canon/*` |
| `governance/canon/CABINA_PROCESS_RESCUE_MULTI_REPO_FRAMEWORK_20260605.md` | `bridge_support` | `local_only` | `keep_as_bridge` | `AGENTS.md \| governance/canon/* \| docs/operations/*` |
| `governance/canon/CANON_CONSERVATIVE_LANGUAGE_AUDIT_20260603.md` | `evidence_support` | `local_only` | `keep_as_evidence` | `AGENTS.md \| governance/canon/*` |
| `governance/canon/REY_GUIA_BROWNFIELD_LOCAL_PACKAGE_POINTER_20260604.csv` | `pointer_support` | `local_only` | `keep_as_pointer` | `governance/canon/* \| docs/operations/*` |
| `governance/codex-cloud/SDU_CODEX_CLOUD_DEV_ACTIVATION_PLAN_20260603.md` | `bridge_support` | `governed_before_live` | `keep_as_bridge` | `governance/codex-cloud/* \| MANIFEST.yaml` |
| `governance/connections/MCP_TEAMS_CANON_POINTER_20260603.md` | `bridge_support` | `governed_before_live` | `keep_as_bridge` | `governance/connections/* \| governance/teams/*` |
| `governance/connections/MCP_TEAMS_CANON_RECONCILIATION_REPORT_20260603.md` | `evidence_support` | `governed_before_live` | `keep_as_evidence` | `governance/connections/* \| governance/teams/*` |
| `governance/connections/SDU_DEV_ACTIVATION_SECRETS_CHECKLIST_20260603.md` | `evidence_support` | `governed_before_live` | `keep_as_evidence` | `governance/connections/* \| GATE_SECRET_USE` |
| `governance/observability/gate-decision.schema.json` | `evidence_support` | `local_only` | `keep_as_evidence` | `governance/observability/* \| AGENTS.md` |
| `governance/observability/readback-evidence.schema.json` | `evidence_support` | `local_only` | `keep_as_evidence` | `governance/observability/* \| AGENTS.md` |
| `governance/observability/runtime-event.schema.json` | `evidence_support` | `local_only` | `keep_as_evidence` | `governance/observability/* \| AGENTS.md` |
| `governance/observability/SDU_AGENT_RUNTIME_EVIDENCE_MODEL_20260603.md` | `evidence_support` | `local_only` | `keep_as_evidence` | `governance/observability/* \| AGENTS.md` |
| `governance/observability/tool-call.schema.json` | `evidence_support` | `local_only` | `keep_as_evidence` | `governance/observability/* \| AGENTS.md` |
| `governance/power-platform/DISCOVERY_POWER_PLATFORM_TEAMS.md` | `bridge_support` | `governed_before_live` | `keep_as_bridge` | `governance/power-platform/* \| governance/connections/*` |
| `governance/power-platform/POWER_AUTOMATE_GITHUB_SCOUTING.md` | `bridge_support` | `local_only` | `keep_as_bridge` | `governance/power-platform/*` |
| `governance/teams/SDU_TEAMS_FIRST_INTERNAL_MESSAGE_TEST_PLAN_20260603.md` | `bridge_support` | `governed_before_live` | `keep_as_bridge` | `governance/teams/* \| GATE_MICROSOFT_LIVE_WRITE` |
| `governance/teams/SDU_TEAMS_IDENTITY_DEV_ACTIVATION_PLAN_20260603.md` | `bridge_support` | `governed_before_live` | `keep_as_bridge` | `governance/teams/* \| GATE_TENANT_IDENTITY` |

## Mapa de superficies externas

| surface | classification | live_boundary | decision | canonical_source |
| --- | --- | --- | --- | --- |
| `.agents/codex/agents` | `surface_bridge` | `local_only` | `keep_as_bridge` | `governance/agents/* \| 02_AUTHORITY_CANON/*` |
| `.agents/codex/matrices` | `surface_bridge` | `local_only` | `keep_as_bridge` | `governance/canon/* \| governance/connections/* \| governance/observability/* \| governance/teams/* \| governance/power-platform/* \| 02_AUTHORITY_CANON/*` |
| `.agents/codex/maps` | `surface_bridge` | `local_only` | `keep_as_bridge` | `AGENTS.md \| governance/canon/* \| governance/connections/*` |
| `.agents/codex/recipes` | `surface_bridge` | `local_only` | `keep_as_bridge` | `AGENTS.md \| governance/canon/* \| governance/power-platform/*` |
| `.agents/codex/readbacks` | `surface_evidence` | `local_only` | `keep_as_evidence` | `governance/observability/readback-evidence.schema.json \| 02_AUTHORITY_CANON/CURRENT_STATE.md` |
| `.agents/codex/scripts` | `surface_bridge` | `local_only` | `keep_as_bridge` | `governance/connections/* \| governance/teams/* \| governance/power-platform/* \| governance/observability/*` |
| `.agents/codex/tools` | `surface_bridge` | `local_only` | `keep_as_bridge` | `governance/connections/* \| governance/power-platform/* \| governance/observability/* \| governance/canon/*` |
| `.agents/codex/workpapers` | `surface_bridge` | `local_only` | `keep_as_bridge` | `governance/canon/* \| governance/connections/* \| governance/teams/* \| governance/power-platform/* \| 02_AUTHORITY_CANON/*` |
| `.agents/codex/skills` | `surface_bridge` | `local_only` | `keep_as_bridge` | `governance/agents/* \| governance/canon/* \| governance/teams/* \| governance/power-platform/*` |
| `.agents/codex/orders` | `surface_bridge` | `governed_before_live` | `keep_as_bridge` | `governance/canon/* \| governance/connections/* \| 02_AUTHORITY_CANON/*` |
| `.agents/codex/evals` | `surface_evidence` | `local_only` | `keep_as_evidence` | `governance/observability/* \| governance/agents/* \| 02_AUTHORITY_CANON/*` |
| `readbacks` | `surface_evidence` | `local_only` | `keep_as_evidence` | `governance/observability/readback-evidence.schema.json \| 02_AUTHORITY_CANON/CURRENT_STATE.md` |
| `scripts/validators` | `surface_bridge` | `local_only` | `keep_as_bridge` | `governance/canon/* \| governance/observability/* \| 02_AUTHORITY_CANON/*` |
| `scripts/connections` | `surface_bridge` | `governed_before_live` | `keep_as_bridge` | `governance/connections/* \| governance/observability/*` |
| `scripts/power-platform` | `surface_bridge` | `governed_before_live` | `keep_as_bridge` | `governance/power-platform/* \| governance/connections/*` |
| `scripts/sharepoint` | `surface_bridge` | `governed_before_live` | `keep_as_bridge` | `governance/teams/* \| governance/connections/*` |
| `validation` | `surface_bridge` | `local_only` | `keep_as_bridge` | `governance/* \| matrices/* \| 02_AUTHORITY_CANON/*` |
| `teams-app/sdu-agent-chat` | `surface_bridge` | `governed_before_live` | `keep_as_bridge` | `governance/teams/* \| 02_AUTHORITY_CANON/POLICIES/TEAMS_GOVERNANCE_POLICY_20260602.md` |
| `dataverse` | `surface_bridge` | `governed_before_live` | `keep_as_bridge` | `governance/connections/* \| matrices/dataverse/* \| validation/dataverse/* \| docs/dataverse/* \| governance/canon/CABINA_OPERATING_SYSTEM_CONSTITUTION.md` |

## Validacion
- Este cierre nace de la reconciliacion local del CSV y del inventario de superficies del repo.
- `git diff --check`: PASS.
- `git diff --name-only`: solo este readback.
- `git status -sb`: un unico archivo nuevo en la rama de coordinacion, sin otros cambios.

## Riesgos
- Bajo: la salida es documental y no toca superficies live.
- Medio si se intenta usar este mapa como canon vivo para Microsoft o Dataverse sin gate exacto.

## Rollback
- El rollback es trivial: borrar este archivo readback si se decide volver al estado previo.

## Proximos carriles
- Si queres, el siguiente paso es derivar este readback en un README de navegación por superficie.
- Otra opcion es compactarlo como indice operativo para `move/retire` por archivo o superficie.
