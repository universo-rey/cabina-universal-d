# Telemetry snapshot correction applied

> Classification: `OPERATIONAL_CONTINUITY_EVIDENCE`.
> Consume this artifact when its object, lane, owner, binding, correlation, pending action or rollback matches the current task.
> It is not global authority by itself, but it may carry the active workpaper context needed to continue without rediscovery.
> Re-resolve only fields that are missing, contradicted, or materially changed.


Target: C:/CEO/watchdog/runtime/sdu-telemetry-consumer.ps1

SHA256: 7315E6DF918075FF2233D086F2497D75766267501E740DEA781656E756BEAB3D

The consumer captures the byte length at open and copies that bounded prefix with FileShare.ReadWrite. It closes the bus before classification and checkpoint writes. Processing and hash verification use the temporary snapshot; source_hash_scope explicitly identifies BOUNDED_BYTE_SNAPSHOT. Checkpoints retain original SourceStream and original physical line numbers. Temporary snapshot is removed in finally.

Validation: existing freshness/sanitization/shadow/commit/replay tests passed. Synthetic concurrent writer appended while a 100-line commit window ran; append succeeded, original identity was retained, and a following window consumed line 101. Candidate compiled successfully. Installation hash matched candidate with original-file hash guard and atomic replacement.

Backup: C:/CEO/watchdog/runtime/sdu-telemetry-consumer.ps1.pre-snapshot-fix.bak. Workspace copies: telemetry.original.ps1 and telemetry.candidate.ps1.

No scheduled task launched or restarted. The next normal invocation loads the installed script. Verification of the next natural cycle remains pending. The snapshot relies on the existing append-only bus contract; it does not protect against another process rewriting already captured bytes. No claim that all possible bus lock sources are fixed.

SDU triage remains full_live_governed in the selected Cabina runtime. Its exact operational invocation and lexical false-positive correction are still separate unresolved items; neither was silently changed by this installation.
