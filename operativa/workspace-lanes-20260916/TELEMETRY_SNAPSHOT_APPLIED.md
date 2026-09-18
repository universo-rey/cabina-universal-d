# Telemetry snapshot correction applied

> Classification: `HISTORICAL_EVIDENCE_ONLY`.
> This document preserves observations, changes, paths, hashes and pending items as of 2026-09-16.
> It is not current authority, a live binding, or proof of present runtime health.
> Absolute local paths are provenance only; current execution must consume the active repo/object contract and exact binding.


Target: C:/CEO/watchdog/runtime/sdu-telemetry-consumer.ps1

SHA256: 7315E6DF918075FF2233D086F2497D75766267501E740DEA781656E756BEAB3D

The consumer captures the byte length at open and copies that bounded prefix with FileShare.ReadWrite. It closes the bus before classification and checkpoint writes. Processing and hash verification use the temporary snapshot; source_hash_scope explicitly identifies BOUNDED_BYTE_SNAPSHOT. Checkpoints retain original SourceStream and original physical line numbers. Temporary snapshot is removed in finally.

Validation: existing freshness/sanitization/shadow/commit/replay tests passed. Synthetic concurrent writer appended while a 100-line commit window ran; append succeeded, original identity was retained, and a following window consumed line 101. Candidate compiled successfully. Installation hash matched candidate with original-file hash guard and atomic replacement.

Backup: C:/CEO/watchdog/runtime/sdu-telemetry-consumer.ps1.pre-snapshot-fix.bak. Workspace copies: telemetry.original.ps1 and telemetry.candidate.ps1.

No scheduled task launched or restarted. The next normal invocation loads the installed script. Verification of the next natural cycle remains pending. The snapshot relies on the existing append-only bus contract; it does not protect against another process rewriting already captured bytes. No claim that all possible bus lock sources are fixed.

SDU triage remains full_live_governed in the selected Cabina runtime. Its exact operational invocation and lexical false-positive correction are still separate unresolved items; neither was silently changed by this installation.
