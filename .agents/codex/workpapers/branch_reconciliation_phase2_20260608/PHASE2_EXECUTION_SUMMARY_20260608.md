# Phase 2 Semantic Branch Reconciliation 2026-06-08

## Estado
PHASE2_SEMANTIC_RECONCILIATION_LOCAL_EXECUTED_AND_EVIDENCED

## Resumen
- Ramas tratadas: 11
- Branch base: main
- Head main inicial/final: 3ce2129
- Estrategias: CONSERVAR_MAIN=94; FUSION_SEMANTICA=80; INTEGRAR_RAMA=19; SEPARAR_EN_WORKPAPER=8
- Estados de ramas: DERIVED_TO_WORKPAPER_ONLY=10; READY_FOR_PR_WITH_NORMATIVE_NOTE=1
- Grupos semanticos: GRUPO_A_CANON_DOCTRINA=13; GRUPO_B_MATRICES_ESTRUCTURALES=87; GRUPO_C_EVIDENCIA_READBACKS=12; GRUPO_D_GUARDRAILS_VALIDACION_HARDENING=22; GRUPO_E_CONFIGURACION_BORDE=11
- Artefactos derivados a workpaper: 8
- Diff checks por rama: 11/11 PASS

## Decision semantica
- `main` se conservo para canon rector, indices compartidos, `.gitignore`, workflow y matrices maestras cuando representaba el estado PR132 o contenido equivalente.
- La unica integracion directa fue `ISSUE-RECON-004`, porque aportaba skills/adapters y politica no presentes en `main`; se normalizo su metadata a la raiz C actual y paso validadores.
- Las otras 10 ramas quedaron `DERIVED_TO_WORKPAPER_ONLY`: el valor esta absorbido por `main` o preservado por referencia original/workpaper, sin abrir PR de canon viejo.

## Rama lista para PR con nota normativa
- codex/gov/cabina/agent-dispatch-skill-adapters__ISSUE-RECON-004 -> 6900454; estado=READY_FOR_PR_WITH_NORMATIVE_NOTE; rollback=git branch -f codex/gov/cabina/agent-dispatch-skill-adapters__ISSUE-RECON-004 e1bf7683e0f9187cb17dc9ff2dbcf6eda1869d2a

## Validacion rama ISSUE-RECON-004
- git diff --check: PASS
- local_validate_agent_workpapers: PASS
- local_validate_operational_chain: PASS
- local_validate_capability_use_hardening: PASS
- local_validate_agent_layer: PASS
- local_validate_skill_metadata: PASS

## Riesgos
- Bajo para `main` y remoto: sin merge, push, delete ni rename remoto.
- Medio semantico: 10 ramas quedan como evidencia/workpaper y no como PR de contenido; promoverlas requiere nueva decision por dominio.
- Nota normativa: `ISSUE-RECON-004` agrega politica/skills y debe explicitar en PR que D legacy fue normalizado a C repo-local.

## Rollback
- codex/feature/agents/global-operability-next-lane__ISSUE-RECON-008: git branch -f codex/feature/agents/global-operability-next-lane__ISSUE-RECON-008 b495ad4d6056c7167318ca5e91b0c6df8c8690a3
- codex/feature/cabina/full-automation-planes__ISSUE-RECON-003: git branch -f codex/feature/cabina/full-automation-planes__ISSUE-RECON-003 cffa0ca44723c4dc2aead2bec319b6a5b333aacf
- codex/gov/agents-sdk/live-operability-findings__ISSUE-RECON-001: git branch -f codex/gov/agents-sdk/live-operability-findings__ISSUE-RECON-001 7ed596a68d6ce393c1156af65d66e69b979b7a36
- codex/gov/agents/global-operability-gated-backlog__ISSUE-RECON-007: git branch -f codex/gov/agents/global-operability-gated-backlog__ISSUE-RECON-007 7554818fe854a866858c509a80dc362cc1b81fc7
- codex/gov/agents/global-operability-reconciliation__ISSUE-RECON-005: git branch -f codex/gov/agents/global-operability-reconciliation__ISSUE-RECON-005 e4c3b5e8d01f7bf7440679a2332e467bc04d9645
- codex/gov/cabina/agent-dispatch-skill-adapters__ISSUE-RECON-004: git branch -f codex/gov/cabina/agent-dispatch-skill-adapters__ISSUE-RECON-004 e1bf7683e0f9187cb17dc9ff2dbcf6eda1869d2a
- codex/gov/cabina/operating-system-consolidation__ISSUE-RECON-002: git branch -f codex/gov/cabina/operating-system-consolidation__ISSUE-RECON-002 57b14bb92f5c1d9004c8b8c3ad7bbbba1e8cce8c
- codex/gov/cabina/post-pr101-next-lane-selection__ISSUE-RECON-010: git branch -f codex/gov/cabina/post-pr101-next-lane-selection__ISSUE-RECON-010 c7e185423a04879596011543b0bd929bb1441fcb
- codex/gov/process/rescue-framework__ISSUE-RECON-011: git branch -f codex/gov/process/rescue-framework__ISSUE-RECON-011 4beb992036c365025cc2c5c62c9790bee51326da
- codex/hardening/agents/global-operability-gate-queue__ISSUE-RECON-006: git branch -f codex/hardening/agents/global-operability-gate-queue__ISSUE-RECON-006 4e7a3c659f68af2345cb03219b179e5e6cd04c4d
- codex/hardening/agents/global-operability-semaphore__ISSUE-RECON-009: git branch -f codex/hardening/agents/global-operability-semaphore__ISSUE-RECON-009 8df5d2af95ee10084936b8c4429cfc795714ab53

## Estado git final
```text
## main...origin/main
?? .agents/codex/workpapers/branch_inventory_20260608/
?? .agents/codex/workpapers/branch_reconciliation_phase1_20260608/
?? .agents/codex/workpapers/branch_reconciliation_phase2_20260608/
```
