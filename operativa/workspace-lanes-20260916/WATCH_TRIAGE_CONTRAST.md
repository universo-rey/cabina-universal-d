# Watch snapshot and SDU triage contrast — 2026-09-16

> Classification: `HISTORICAL_EVIDENCE_ONLY`.
> This document preserves observations, changes, paths, hashes and pending items as of 2026-09-16.
> It is not current authority, a live binding, or proof of present runtime health.
> Absolute local paths are provenance only; current execution must consume the active repo/object contract and exact binding.


Read-only comparison against C:/CEO/snapshots/20260808-062828-watch-present-atemporal-reconciled.

## Observed

- watch/active-baseline.txt selects that exact snapshot. run-primary.ps1:1323 calls watch/CEO-Watchdog.ps1 with -Once -Action Alert.
- core/00-Env.ps1 preserves a valid process CODEX_CLI_PATH before falling back to policy. The snapshot unconditionally selected the policy executable.
- policy.json adds BONTEMPS/MCP routing, interaction-surface separation, VSI source contracts, autonomy bindings and Python runtime bindings.
- Start-CEO.ps1 differs by 4108 added and 37 removed lines. Both versions parse without PowerShell syntax errors. Current bootstrap includes distributed consumers and context projections. This is not full functional validation of all changes.
- Start-CEO.ps1:3829 and :3838 set native_runtime_consumer_resolved=false for operational_chain_canon and risk_policy. These are literal bootstrap declarations, not proof of runtime absence.
- D:/apps/sdu-agent-runtime/src/agents/sdu_triage_agent.py declares local_no_live; Cabina's same relative path declares full_live_governed. Both triage functions classify locally and emit structured results.
- Cabina governance/agents/AGENTS_SDK_AGENT_REGISTRY.md distinguishes this classification function and separately governed live smoke facilities; it does not declare a deployed remote agent.

## Isolated simulation

Ran each existing triage function in a separate Python process with -B, synthetic text and metadata read_only=true, authorized=true. No external calls or runtime activation.

1. `Revisar bloqueo BUS en ventana local cerrada`: both return local_governance_review, next_action=run_local_validators.
2. `Revisar en lectura permisos existentes, sin modificar permisos`: both return blocked_governed_order_required, permission_change, next_action=prepare_governed_order.

The second case demonstrates a lexical false positive for a read-only request. guardrails/policies.py concatenates text and metadata and matches substrings; it does not resolve an exact authorization contract. This is a concrete triage limitation, not evidence that this agent caused the BUS file lock.

## Pending

### Correction after authorized apply simulation

The proposed import-path repair was unnecessary. Before and after candidate both returned exit 0 for `python -B -m sdu.court.actor_runtime.actor_runner --help` with cwd C:/CEO/project-cdx and the existing PYTHONPATH=C:/CEO/project-cdx/src.

Exact readback of imported module origins under that environment resolved actor_runner.py and actor_orchestrator.py to the preserved sdu-control-plane/37_REPO_CLEANUP_20260702/extracted_from_project_cdx/src/sdu/court/actor_runtime directory. project-cdx/src/sdu/__init__.py uses pkgutil.extend_path; sdu.__path__ includes project-cdx/src/sdu, worktrees/project-cdx-runtime-main/src/sdu and the preserved source directory. Absence of a physical executor.py under the first directory did not establish a broken Python import.

Candidate removed without applying it. No runtime configuration or production state changed, no workpacket executed. Full_live_governed remains the intended mode. Outstanding triage invocation and BUS lock were not resolved by this import verification.

### Executor lookup follow-up

- /v1/sdu/route is explicitly DEV in local-agent-bridge/contracts/local-agent-bridge.contract.json: response.liveExecutedValue=false. Assignment without execution is its defined behavior.
- Existing direct invocations of triage_request found in scoped Cabina/D runtime searches are unit tests. No production caller was established by these searches.
- .agents/codex/scripts/agents_sdk_functional_lifecycle_smoke.py:83 invokes SDK Runner.run, but instantiates cabina-agents-sdk-functional-lifecycle, not sdu-triage-agent. It is a separate synthetic validation executor.
- BONTEMPS sdu_intent_metadata_resolve returned FMN-003 from SYSTEM_NERVOUS_INDEX: surface_map=D:/apps/sdu-agent-runtime|D:/.agents/codex/agents, circulation_lane=packet_to_agent_worker_handoff, owner chain including court.openai_dispatcher. It did not establish an exact invocation connecting bridge route to triage runtime.
- This locates a second binding discrepancy: the current session selects Cabina's full_live_governed implementation, while federal navigation still points at D:'s local_no_live copy. A navigation reference is not proof that that copy executes. Preserve full_live_governed as the intended mode and recover the exact executor receipt/caller before editing bindings.

### Follow-up: effective session binding

User confirms full_live_governed is the intended mode. Current process SDU_AGENT_RUNTIME_ROOT and Cabina .codex/config.toml:21 both select Cabina/apps/sdu-agent-runtime (whose agent declares that mode). CABINA_LOCAL_AGENT_BRIDGE_ROOT selects Cabina/local-agent-bridge.

The bridge's /v1/sdu/route handler in src/server.mjs calls selectRoute and buildEvidence, returning live_executed=false. src/router.mjs assigns sdu-triage-agent by name for its default route, but this handler does not invoke the Python agent or load either runtime copy. Thus the assumption that this bridge route selects the D: copy is unsupported; session configuration already selects the intended Cabina runtime. The concrete integration boundary is route assignment to actual agent execution, subject to the existing DEV route contract. This finding does not establish that no other executor exists.

Trace the actual caller and runtime selection before reconciling the two copies. Recover any existing contract-aware classifier/adapter before proposing a replacement. Do not roll back the complete bootstrap or policy to the snapshot: that would remove later bindings. No production files changed by this contrast; no secrets read or emitted.
