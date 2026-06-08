# Phase 1 Branch Reconciliation 2026-06-08

## Estado
PHASE1_BRANCH_RECONCILIATION_LOCAL_EXECUTED_AND_EVIDENCED

## Resumen minimo
- Total ramas NO_CONFORME intervenidas: 11
- Migradas limpiamente desde main por cherry-pick: 0
- Ramas canonicas locales creadas como alias del head fuente: 11
- Cerrables sin migrar por falta de commits unicos: 0
- Requieren rebase/resolucion tecnica antes de PR: 11
- Grupos duplicados por SHA analizados: 2
- Ramas duplicadas cerrables registradas: 7
- Base branch: main
- Head inicial: 3ce2129
- Head final: 3ce2129

## Ramas canonicas locales creadas
- codex/gov/agents-sdk/live-operability-findings__ISSUE-RECON-001 -> 7ed596a (source: codex/version-agents-sdk-live-findings-20260605, ISSUE-RECON-001)
- codex/gov/cabina/operating-system-consolidation__ISSUE-RECON-002 -> 57b14bb (source: codex/cabina-operating-system-consolidation-20260605, ISSUE-RECON-002)
- codex/feature/cabina/full-automation-planes__ISSUE-RECON-003 -> cffa0ca (source: codex/cabina-full-automation-by-planes-20260605, ISSUE-RECON-003)
- codex/gov/cabina/agent-dispatch-skill-adapters__ISSUE-RECON-004 -> e1bf768 (source: codex/power-platform-teams-governance-alm-20260603, ISSUE-RECON-004)
- codex/gov/agents/global-operability-reconciliation__ISSUE-RECON-005 -> e4c3b5e (source: codex/agent-global-dirty-reconciliation-20260605, ISSUE-RECON-005)
- codex/hardening/agents/global-operability-gate-queue__ISSUE-RECON-006 -> 4e7a3c6 (source: codex/agent-global-operability-gate-queue-20260605, ISSUE-RECON-006)
- codex/gov/agents/global-operability-gated-backlog__ISSUE-RECON-007 -> 7554818 (source: codex/agent-global-operability-gated-backlog-20260605, ISSUE-RECON-007)
- codex/feature/agents/global-operability-next-lane__ISSUE-RECON-008 -> b495ad4 (source: codex/agent-global-operability-next-lane-execution-20260605, ISSUE-RECON-008)
- codex/hardening/agents/global-operability-semaphore__ISSUE-RECON-009 -> 8df5d2a (source: codex/agent-global-operability-semaphore-matrix-20260605, ISSUE-RECON-009)
- codex/gov/cabina/post-pr101-next-lane-selection__ISSUE-RECON-010 -> c7e1854 (source: codex/post-pr-101-next-lane-selection-20260605, ISSUE-RECON-010)
- codex/gov/process/rescue-framework__ISSUE-RECON-011 -> 4beb992 (source: codex/process-rescue-framework-20260605, ISSUE-RECON-011)

## Cherry-pick limpio
- Resultado: todos los intentos de cherry-pick desde main fueron abortados limpiamente por conflictos.
- Evidencia: PHASE1_CHERRY_PICK_CONFLICTS_20260608.csv.
- Decision: no resolver conflictos a la fuerza; preservar head fuente bajo nombre canonico y derivar rebase/manual conflict resolution a siguiente carril.

## Ramas con decision pendiente
- codex/version-agents-sdk-live-findings-20260605: CHERRY_PICK_CONFLICT_ABORTED
- codex/cabina-operating-system-consolidation-20260605: CHERRY_PICK_CONFLICT_ABORTED
- codex/cabina-full-automation-by-planes-20260605: CHERRY_PICK_CONFLICT_ABORTED
- codex/power-platform-teams-governance-alm-20260603: CHERRY_PICK_CONFLICT_ABORTED
- codex/agent-global-dirty-reconciliation-20260605: CHERRY_PICK_CONFLICT_ABORTED
- codex/agent-global-operability-gate-queue-20260605: CHERRY_PICK_CONFLICT_ABORTED
- codex/agent-global-operability-gated-backlog-20260605: CHERRY_PICK_CONFLICT_ABORTED
- codex/agent-global-operability-next-lane-execution-20260605: CHERRY_PICK_CONFLICT_ABORTED
- codex/agent-global-operability-semaphore-matrix-20260605: CHERRY_PICK_CONFLICT_ABORTED
- codex/post-pr-101-next-lane-selection-20260605: CHERRY_PICK_CONFLICT_ABORTED
- codex/process-rescue-framework-20260605: CHERRY_PICK_CONFLICT_ABORTED

## Duplicadas
- sha=6b644a1: codex/agent-global-gate-packet-microsoft-live-write-20260605, codex/session-worktree-parking-20260605
- sha=b0e30cb: codex/agent-naming-rationalization-20260605, codex/agents-global-improvement-20260605, codex/codex-cloud-capability-audit-20260605, codex/full-repo-validation-followups-20260605, codex/process-manuals-framework-20260605

Decision: si el SHA ya esta contenido en main, main conserva el valor y las ramas quedan como DUPLICADA_CERRABLE. No se borro ninguna rama local ni remota.

## Riesgos
- Bajo para main: no hubo merge a main ni push.
- Medio operativo: las 11 ramas utiles requieren rebase/resolucion tecnica antes de convertirse en PR limpio contra main.
- No se tocaron Microsoft live, OpenAI live, produccion, secretos ni permisos.

## Rollback
- Ramas canonicas locales creadas: ejecutar `git branch -D <branch_canonica>` solo si el operador aprueba descartar la migracion local.
- Workpaper local: borrar `.agents/codex/workpapers/branch_reconciliation_phase1_20260608` solo si se descarta la evidencia.

## Postcheck
- main inicial=3ce2129 final=3ce2129.
- status final:

```text
## main...origin/main
?? .agents/codex/workpapers/branch_inventory_20260608/
?? .agents/codex/workpapers/branch_reconciliation_phase1_20260608/
```
