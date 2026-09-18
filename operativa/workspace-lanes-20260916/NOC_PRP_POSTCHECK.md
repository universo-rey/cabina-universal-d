# SDU-NOC-PRP postcheck — 2026-09-16

> Classification: `HISTORICAL_EVIDENCE_ONLY`.
> This document preserves observations, changes, paths, hashes and pending items as of 2026-09-16.
> It is not current authority, a live binding, or proof of present runtime health.
> Absolute local paths are provenance only; current execution must consume the active repo/object contract and exact binding.


## Estado
HECHO_VERIFICADO: the installed telemetry snapshot consumer ran in COMMIT mode on the real bus. Latest result as_of_utc=2026-09-16T06:56:28.4653254+00:00; file updated 03:57:36 Argentina time. Window 227709–227722: 14 lines, one fresh telemetry candidate, zero invalid contracts, source_hash_scope=BOUNDED_BYTE_SNAPSHOT and source_hash_unchanged=true.

Task Scheduler readback: CEO_WATCHDOG_PRIMARY last start 03:44:33, result 0; CEO_WATCHDOG_CONSUMER_TELEMETRY last start 04:04:11, result 0. Scheduled next starts at time of query: 04:14:32 and 04:14:09 respectively. These are observed schedules, not promises of future completion.

Bus readback includes AAC_RETURNED 03:49:32 and WATCHDOG_FUNCTIONAL_COMPONENT_COMPLETED 03:51:13. This primary run predates installation; do not attribute its success to the telemetry patch. Telemetry result explicitly confirms the installed patch was consumed afterward.

## Validacion y limites
No FILE_LOCK_TIMEOUT or SOURCE_HASH_CHANGED found among matching PowerShellCore/Operational 4100 records since 03:40. This does not prove future contention impossible. A real telemetry-host Warning at 04:08:56 says only System error, with no command or script location. Task result remains 0; cause unresolved. Invalid JSON records during the local test runs originate from the deliberate not-json fixture, not evidence of production bus corruption.

NOC generated_at=03:49:04: alertas contains Consumidor autonomo unico no resuelto, while alertas_activas is empty. Display/state reconciliation remains outstanding; no alert was deleted.

## Sistemas tocados
Read-only: local bus tail, telemetry metadata/state, Task Scheduler, PowerShell event log, NOC projection, existing domain consumer code. Write: this local readback only. No task started or restarted; no external services or secrets accessed.

## Rollback y proximos carriles
No runtime mutation in this postcheck. Existing telemetry rollback is sdu-telemetry-consumer.ps1.pre-snapshot-fix.bak. Continue PROJECT-CDX-OVERLAY for the concrete NOC alert discrepancy and telemetry-host warning; retain SDU-NOC-PRP for subsequent observation. Triage invocation remains a separate repo-native pending task.

agente: Codex coordinator
orden: user-authorized lane execution for BUS/NOC verification
superficie: C:/CEO/watchdog and C:/CEO/project-cdx/noc
skill: governed-readback-closeout
