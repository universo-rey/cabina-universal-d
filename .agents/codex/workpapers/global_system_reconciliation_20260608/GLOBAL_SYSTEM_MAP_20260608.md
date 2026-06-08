# Mapa Global Del Sistema 20260608

estado: GLOBAL_SYSTEM_RECONCILIATION_MAP_READY
generado: 2026-06-08T08:15:42.5725212-03:00
workspace: C:\Users\enzo1\Documents\GitHub\cabina-universal-d
branch: main
head: 9651568
modo: lectura y workpaper local no stageado

## Arquitectura Real

Cabina Universal opera como control plane rector. GitHub conserva el canon tecnico versionable. SharePoint funciona como memoria viva/documental. Power Platform, Dataverse y Microsoft 365 son superficies de ejecucion viva, pero gateadas. OpenAI, Responses API, Agents SDK y Codex Cloud son runtimes/tools gobernados, no autoridad. VSI / Agile Agent Canvas es el tablero madre visual operativo; Control de Agentes de Cabina es auxiliar; la cola web queda externa y gateada.

## Conexiones Principales

- Cabina root -> GitHub origin/main: OK, HEAD local 9651568 alineado y sin PRs abiertos.
- Cabina root -> 13 repos relacionados: OK, todos existen localmente segun registry y perfil git.
- Cabina root -> SDU-CN: OK, agentes canonicos suprarrepo gobiernan criterio, evidencia y cumplimiento.
- Cabina root -> CDF/TGE/runtimes: OK, carriles repo-nativos separados; no absorcion root.
- Cabina root -> VSI/AAC: OK, tablero madre diferenciado de control auxiliar y cola web.
- Cabina root -> Microsoft/Power Platform/Dataverse: OK como enabled governed gated; no write abierto.
- Cabina root -> workpapers locales: INCONSISTENTE, evidencia reciente esta untracked y requiere decision de versionado/export.
- Canon textual -> HEAD real: INCONSISTENTE, textos siguen en PR #132 y HEAD real esta post PR #138.

## Carriles Operativos

- Cadena estandar: rey.control_plane_orchestrator -> court.openai_dispatcher -> sdu-triage-agent -> court.sdu_gate -> court.seshat_evidence.
- Gobernanza repo/tool/agent: registry, matrices REPO/AGENT/TOOL, SURFACE_BOUNDARY_MAP.
- Paralelo gobernado: readonly scouts, disjoint workers y order preparation con locks/owners/validators.
- GitHub lifecycle: branch codex, stage explicito, commit, push, PR, checks, merge solo con gate.
- Change-aware validation: full coverage con priorizacion de riesgo, sin reducir cobertura.
- Codex Cloud: read-only/smoke/diff-no-apply; apply bloqueado.
- OpenAI/Agents SDK: governed runtime; costo/live/tools externas requieren gate.
- Microsoft next lane: Teams/SharePoint/Planner/Graph con objeto exacto y postcheck.
- Power Platform/Dataverse: local/dry-run permitido; apply/import/write gateado.
- VSI/AAC: agentes nativos AAC como equipo operativo y agentes Cabina como gobierno.

## Agentes Y Superficies

- Gobierno Cabina: rey.control_plane_orchestrator, rey.frontier_guardian, rey.repo_cartographer, rey.governance_registrar.
- Corte/SDU: court.openai_dispatcher, court.sdu_gate, court.seshat_evidence, court.thot_schema, seshat-normativa, thot-tecnico, maat-cumplimiento, horus-riesgo.
- Equipo nativo AAC: master, canvas-integrator, analyst, architect, dev, qa, pm, sm y otros declarados en AAC_NATIVE_AGENTS_20260608.
- Superficies: local filesystem, local git readonly, GitHub readonly/write gateado, OpenAI governed, Codex Cloud governed, Microsoft live gated, SharePoint gated, Power Platform/Dataverse gated, VS Code Insiders/AAC.

## Gates Activos

- GATE_REMOTE_GIT_MUTATION para push/PR/branch deletion; merge main requiere gate y HEAD fijo.
- GATE_OPENAI_LIVE y GATE_AGENTS_SDK_LIVE para costo, secreto, tool externa o side effect.
- GATE_MICROSOFT_LIVE_WRITE para SharePoint/Teams/Planner/Graph writes.
- GATE_POWER_PLATFORM_APPLY y GATE_DATAVERSE_APPLY para import/apply/write.
- GATE_PRODUCTION_DEPLOY para produccion.
- GATE_WORKTREE_METADATA para core.worktree, clone move o metadata git critica.

## Matrices Emitidas

- GLOBAL_CONNECTION_MATRIX_20260608.csv
- GLOBAL_LANE_MATRIX_20260608.csv
- GLOBAL_RECONCILIATION_MATRIX_20260608.csv
- RELATED_REPOSITORY_PROFILE_20260608.csv
- EVIDENCE_SOURCE_INDEX_20260608.csv
- GLOBAL_SYSTEM_EXECUTIVE_SUMMARY_20260608.md

## Decision Recomendada

No ejecutar live ni modificar canon en este carril. El siguiente cambio versionable minimo seria reconciliar textos rectores de PR #132 a PR #138 y decidir si los workpapers 20260608 se versionan o se exportan como memoria viva saneada.
