# Branch Governance Inventory 2026-06-08

## Resumen ejecutivo
- Total ramas normalizadas: 123
- OK: 1 (0.81%)
- NO_CONFORME: 11 (8.94%)
- SIN_TRAZABILIDAD: 0 (0%)
- Señal SIN_REFERENCIA_EXTRAIBLE total: 122; activas NO_CONFORME: 11
- STALE/señal stale: 0 (0%)
- RECONCILIADA: 111 (90.24%)
- Duplicadas por mismo SHA: 7
- Criterio stale: fecha de ultimo commit mayor a 30 dias desde 2026-06-08.
- Sin cambios destructivos: no se eliminaron, mergearon, renombraron ni limpiaron ramas.

## Capacidades
- Skills solicitadas no encontradas como repo-locales: repo-introspection, branch-enumeration, governance-classification, metadata-extraction, audit-report-generation.
- Equivalentes funcionales usados: tcu-descubridor-capacidades, repo-agent-tool-governance, governed-readback-closeout, git, gh api.
- Roles aplicados: cdf.project_manager_delegador, cdf.prompt_router, thot-tecnico, seshat-normativa, maat-cumplimiento, cdf.evidence_validator.

## Lista priorizada de intervención
- codex/agent-global-dirty-reconciliation-20260605: NO_CONFORME - FUERA_DE_CANON_NAMING;SDU_CN_NAMING_NO_CONFORME;SIN_REFERENCIA_EXTRAIBLE;sources=local|remote_git|remote_github;head=e4c3b5e;date=2026-06-05;ahead=1;behind=110;protected=false
- codex/agent-global-gate-packet-microsoft-live-write-20260605: DUPLICADA - DUPLICA_SHA_CON=codex/session-worktree-parking-20260605
- codex/agent-global-operability-gate-queue-20260605: NO_CONFORME - FUERA_DE_CANON_NAMING;SDU_CN_NAMING_NO_CONFORME;SIN_REFERENCIA_EXTRAIBLE;sources=local|remote_git|remote_github;head=4e7a3c6;date=2026-06-05;ahead=1;behind=104;protected=false
- codex/agent-global-operability-gated-backlog-20260605: NO_CONFORME - FUERA_DE_CANON_NAMING;SDU_CN_NAMING_NO_CONFORME;SIN_REFERENCIA_EXTRAIBLE;sources=local|remote_git|remote_github;head=7554818;date=2026-06-05;ahead=1;behind=106;protected=false
- codex/agent-global-operability-next-lane-execution-20260605: NO_CONFORME - FUERA_DE_CANON_NAMING;SDU_CN_NAMING_NO_CONFORME;SIN_REFERENCIA_EXTRAIBLE;sources=local|remote_git|remote_github;head=b495ad4;date=2026-06-05;ahead=1;behind=107;protected=false
- codex/agent-global-operability-semaphore-matrix-20260605: NO_CONFORME - FUERA_DE_CANON_NAMING;SDU_CN_NAMING_NO_CONFORME;SIN_REFERENCIA_EXTRAIBLE;sources=local|remote_git|remote_github;head=8df5d2a;date=2026-06-05;ahead=2;behind=105;protected=false
- codex/agent-naming-rationalization-20260605: DUPLICADA - DUPLICA_SHA_CON=codex/agents-global-improvement-20260605|codex/codex-cloud-capability-audit-20260605|codex/full-repo-validation-followups-20260605|codex/process-manuals-framework-20260605
- codex/agents-global-improvement-20260605: DUPLICADA - DUPLICA_SHA_CON=codex/agent-naming-rationalization-20260605|codex/codex-cloud-capability-audit-20260605|codex/full-repo-validation-followups-20260605|codex/process-manuals-framework-20260605
- codex/cabina-full-automation-by-planes-20260605: NO_CONFORME - FUERA_DE_CANON_NAMING;SDU_CN_NAMING_NO_CONFORME;SIN_REFERENCIA_EXTRAIBLE;sources=local|remote_git|remote_github;head=cffa0ca;date=2026-06-05;ahead=2;behind=112;protected=false
- codex/cabina-operating-system-consolidation-20260605: NO_CONFORME - FUERA_DE_CANON_NAMING;SDU_CN_NAMING_NO_CONFORME;SIN_REFERENCIA_EXTRAIBLE;sources=local|remote_git|remote_github;head=57b14bb;date=2026-06-05;ahead=3;behind=113;protected=false
- codex/codex-cloud-capability-audit-20260605: DUPLICADA - DUPLICA_SHA_CON=codex/agent-naming-rationalization-20260605|codex/agents-global-improvement-20260605|codex/full-repo-validation-followups-20260605|codex/process-manuals-framework-20260605
- codex/full-repo-validation-followups-20260605: DUPLICADA - DUPLICA_SHA_CON=codex/agent-naming-rationalization-20260605|codex/agents-global-improvement-20260605|codex/codex-cloud-capability-audit-20260605|codex/process-manuals-framework-20260605
- codex/post-pr-101-next-lane-selection-20260605: NO_CONFORME - FUERA_DE_CANON_NAMING;SDU_CN_NAMING_NO_CONFORME;SIN_REFERENCIA_EXTRAIBLE;sources=local|remote_git|remote_github;head=c7e1854;date=2026-06-05;ahead=1;behind=108;protected=false
- codex/power-platform-teams-governance-alm-20260603: NO_CONFORME - FUERA_DE_CANON_NAMING;SDU_CN_NAMING_NO_CONFORME;SIN_REFERENCIA_EXTRAIBLE;sources=remote_git|remote_github;head=e1bf768;date=2026-06-04;ahead=1;behind=161;protected=false
- codex/process-manuals-framework-20260605: DUPLICADA - DUPLICA_SHA_CON=codex/agent-naming-rationalization-20260605|codex/agents-global-improvement-20260605|codex/codex-cloud-capability-audit-20260605|codex/full-repo-validation-followups-20260605
- codex/process-rescue-framework-20260605: NO_CONFORME - FUERA_DE_CANON_NAMING;SDU_CN_NAMING_NO_CONFORME;SIN_REFERENCIA_EXTRAIBLE;sources=local|remote_git|remote_github;head=4beb992;date=2026-06-05;ahead=1;behind=111;protected=false
- codex/session-worktree-parking-20260605: DUPLICADA - DUPLICA_SHA_CON=codex/agent-global-gate-packet-microsoft-live-write-20260605
- codex/version-agents-sdk-live-findings-20260605: NO_CONFORME - FUERA_DE_CANON_NAMING;SDU_CN_NAMING_NO_CONFORME;SIN_REFERENCIA_EXTRAIBLE;sources=local|remote_git|remote_github;head=7ed596a;date=2026-06-05;ahead=7;behind=109;protected=false

## Artefactos
- CSV principal: `.agents/codex/workpapers/branch_inventory_20260608/BRANCH_GOVERNANCE_INDEX_20260608.csv`
- CSV detalle tecnico: `.agents/codex/workpapers/branch_inventory_20260608/BRANCH_GOVERNANCE_DETAILS_20260608.csv`

## Stop condition
BRANCH_INVENTORY_EVIDENCE_EMITTED_LOCAL_ONLY
