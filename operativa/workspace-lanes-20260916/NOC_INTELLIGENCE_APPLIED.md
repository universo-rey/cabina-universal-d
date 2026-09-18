# NOC intelligence reconciliation applied — 2026-09-16

> Classification: `HISTORICAL_EVIDENCE_ONLY`.
> This document preserves observations, changes, paths, hashes and pending items as of 2026-09-16.
> It is not current authority, a live binding, or proof of present runtime health.
> Absolute local paths are provenance only; current execution must consume the active repo/object contract and exact binding.


## Resultado
Installed and published through the existing NOC producer. Direct readback PASS: operacion-en-vivo.json, noc-state.operation_live and noc-state.noc.operacion_en_vivo agree. Embedded intelligence generated_at=2026-09-16T07:39:25.061631Z matches the source at verification; CRITICAL=0, WARNING=0, INFO=13. The exact obsolete SNS warning is absent. This is not a claim that all ecosystem issues are resolved.

Correlation retained: SYSTEM-SCHEDULED-20260916-044437-044437.
Published projection: f1a9454f-d14e-42b4-a8eb-a0fa04dff40b.

## Cambios
- C:/CEO/project-cdx/noc/actions/_shared.ps1: updates source-attributed intelligence and alerts, preserves other producers, reports missing/invalid/future/regressive sources, checks source hash before publication and synchronizes nested view after merge.
- C:/CEO/project-cdx/noc/build-noc-state.ps1: fast-return consumes the same helper. Full/NoPublish already consume Build-NocState.
- No SLA invented: timestamp validation is non-regression, not global freshness certification.
- Legacy warning removal requires the exact recovered I1 object and a unique validated SNS INFO decision.

## Validación
Thot prepared candidate; Seshat reviewed and identified independent nested JSON instances. The defect was fixed before installation and review confirmed closure.
Seven fixture groups PASS: current I1/preservation/idempotency, time validity/nonregression, missing/invalid source, ambiguous I1, new tagged alerts/source mutation, real ISO source under StrictMode, independently deserialized nested view.
Existing visible-operation refresh test PASS.
Full existing producer NoPublish reproduced old state before change and showed corrected state afterward. Publication then succeeded using the current governed context and the existing admission, mutex and atomic bundle. Direct postcheck read actual output files.

## Rollback y alcance
Backups beside both runtime files: .pre-intelligence-recovery.bak. Workspace before/candidate files and harness under noc-fix/. Hash guard prevented installing over concurrent edits; publication single-flight mutex held during installation.
Shared installed SHA256=90A3F40ED1CED20AE8AEA7E08172A5A97EBE9C9D47A81891300B559850B9384D.
Builder installed SHA256=DA3F3C3729D92B200E3E50C4759BF55C5A8FF9ABAF42FDA01B2E5714A6D7F659.
If regression occurs, restore those backed-up code versions and regenerate via the producer, rather than restoring stale generated data.

Local code and NOC output bundle changed; no Microsoft/SharePoint/Dataverse/Git writes, no task restarts. Existing runtime publishing may produce local technical receipts. Source hash check detects observed changes but is not an atomic lock on the source producer.

## Pendientes separados
Next natural scheduled cycle remains to observe; do not claim it ran after this explicit publication. Triage invocation, Graphify remaining issues, and generic telemetry PowerShell warning remain outside this change.

Lane: noc_projection_hygiene / PROJECT-CDX-OVERLAY. Observation: SDU-NOC-PRP.
Agentes: court.thot_schema, court.seshat_evidence, root coordinator.
Skill de cierre: governed-readback-closeout.
