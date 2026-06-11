# Cabina Universal D Backlog

## Status
BACKLOG_LOCAL_COORDINATION_DRAFT

## Scope
- Repo: `cabina-universal-d`
- Surface: local repo + repo-visible canon docs + workpaper routing + coordination branch
- Non-scope: live write, production, secrets, tenant admin, remote git mutation
- Current focus: local coordination backlog on the branch, with SharePoint pilot closeout still open on `SYS-GobiernoOperativo-PILOTO`

## Coordination Branch Snapshot
- Branch: `codex/cabina-universal-d-coordination-20260611`
- HEAD: `f7ec21d`
- Upstream: not set yet
- Published sibling lanes:
  - `codex/sharepoint-pnp-live-map` -> `origin/codex/sharepoint-pnp-live-map`
  - `codex/sdu-dataverse-readback-main-merge` -> `origin/codex/sdu-dataverse-readback-main-merge`
  - `codex/tenant-controlled-dataverse-segments-20260608` -> `origin/codex/tenant-controlled-dataverse-segments-20260608`
- Current local payload: SDU reconciliation artifacts, SharePoint governance artifacts, repo hygiene/indexing updates, and SDU-CN queue-state evidence captured in `court.sdu_gate`
- Next read-only lane: reconcile current-front splits for SDU/MW versus historical SGIN in the backlog-by-list section

## Snapshot Notes
- `SDU.Agent.Dispatch.Queue` is not the backlog driver right now; the 2026-06-11 queue readback shows it fully completed (`10/10`).
- `Inventory SDU-CN queue state` is now captured as local evidence in `court.sdu_gate`, so it should no longer stay as the next lane.
- `codex/sharepoint-pnp-live-map` is already published and matches `main`, so it is a coordination label rather than a pending branch delta.
- `codex/sdu-dataverse-readback-main-merge` and `codex/tenant-controlled-dataverse-segments-20260608` are already published and tracking `origin`.
- The repo review queue is separate from the agent dispatch queue and should stay separate in the backlog.
- The live Power Automate monitor surface for this work is the Preview `work-queues` page in `HUBDesarrollo`, not the `Default` environment.
- `SDU Capability Control Plane` is the SDU solution surface for the queue work; `SP Governance Model` is a separate solution and should stay out of the SDU backlog.
- The SharePoint site for this carril is `SYS-GobiernoOperativo-PILOTO` at `https://escribaniabitsch.sharepoint.com/sites/SYS-GobiernoOperativo-PILOTO`.
- The governed SharePoint surface is `Soporte de Sistemas - Gobierno Declarativo`, with `LIB_GobiernoSistemas` as the operative control bundle.
- The live SharePoint gap is metadata and file-body extraction, not site discovery; the root site, governance bundle, and key live lists are already confirmed.
- `WB_RevisionSemanal` is the live weekly-review list; the underscore alias `WB_Revision_Semanal` is retired.
- The live lists mix historical SGIN rows and current SDU/MW rows; backlog items must be split by list and then by front.
- Historical SGIN content is archive signal, not the active backlog driver.
- Current SDU/MW content is the active backlog driver when the row still describes the live site, a current gate, or a current risk.
- The current dirty tree snapshot still mixes:
  - SDU reconciliation artifacts
  - SharePoint governance artifacts
  - repo hygiene/indexing updates

## SDU-CN Next Task
- Concrete task: split `WB_Decisiones` and `SYS_EstadoOperativo` into current-front (`MW-*`, `SDU-*`) versus historical `SGIN` rows, starting with `WB_Decisiones` as the first visible split.
- Why now: the queue-state inventory is already captured locally, so the next safe step is the backlog split that unblocks the rest of the SDU-CN coordination.
- Gate: none for read-only; keep API key, Microsoft live, and Dataverse live unused unless a concrete target is selected.

## Backlog

| Pri | Bucket | Item | Next safe step | Gate | Stop condition | Evidence |
|---|---|---|---|---|---|---|
| P0 | SDU-CN next task | Normalize the backlog-by-list view into current-front vs historical SGIN | Re-read `WB_Decisiones` and `SYS_EstadoOperativo`, split `MW-*` and `SDU-*` rows apart from historical `SGIN`, and keep the work local and read-only | none | Do not widen into live writes, API key use, or SharePoint/Dataverse changes until a concrete target is selected | `docs/superpowers/plans/2026-06-11-cabina-universal-d-backlog.md`, `.agents/codex/workpapers/court.sdu_gate/*` |
| P0 | Power Automate surface | Confirm the live preview monitor is bound to `HUBDesarrollo` and `SDU Capability Control Plane` | Open the Preview `monitor/work-queues` page, verify the environment id, confirm `SDU.Agent.Dispatch.Queue`, and keep `SP Governance Model` separate | none for read-only; `GATE_DATAVERSE_APPLY` only if a live read is needed to fill an unknown | Do not drift into the `Default` environment or merge the `SP Governance Model` solution into the SDU queue canon | `powerplatform/solution/solution.manifest.yml`, `readbacks/sdu/READBACK_SDU_COMPLETE_ENVIRONMENT_MAP.md`, `readbacks/powerautomate/READBACK_WORK_QUEUE_OPERATIONAL_BINDING_FROM_SEEDED_DATAVERSE.md` |
| P0 | SDU canon | Close the SDU environment / solution reconciliation pack | Re-read and reconcile `SDU_ENVIRONMENT_CAPABILITY_MAP.csv`, `SDU_ENVIRONMENT_SURFACE_CROSSWALK.csv`, `SDU_QUEUE_IDENTITY_RECONCILIATION.csv`, `READBACK_SDU_COMPLETE_ENVIRONMENT_MAP.md`, and `READBACK_SDU_MASTER_ENVIRONMENT_SOLUTION_LIST.md` | none for local reconciliation; `GATE_DATAVERSE_APPLY` only if a live read is needed to fill an unknown | Do not guess missing inventory for `ESCRIBANIA BITSCH default` | `matrices/sdu/*`, `readbacks/sdu/*`, `.agents/codex/readbacks/2026-06-10_project_historian_capability_reconciliation_readback.md` |
| P0 | SharePoint pilot | Close the `SYS-GobiernoOperativo-PILOTO` surface and governance package | Re-read the exact bodies for `MW-MAQUINA-CABINA-OPERATIVA-SHAREPOINT-V1`, `TGE_Control_20260514`, and `TGE_SDU_CN_MICROSOFT_EXECUTION_20260531`; then reconcile the gap map against the live list presence already confirmed | none for read-only; live read only if needed and gated | No live write, no tenant expansion, no invented list metadata, and no drifting into retired aliases `OPS_Tickets` / `CMP_Controles`; use `WB_RevisionSemanal` for the live weekly-review list and keep the underscore alias retired | `matrices/sharepoint/*`, `readbacks/sharepoint/*`, `docs/superpowers/plans/2026-06-10-sys-gobiernooperativo-piloto-sharepoint-read-plan.md` |
| P1 | Repo hygiene | Keep the index and allowlist aligned with the new surfaces | Validate `.agents/codex/matrices/MATRIX_INDEX.csv` and `.gitignore` against the new `docs/superpowers`, `matrices/sharepoint`, and `readbacks/sharepoint` folders | none | Do not use `git add .`; stage explicit paths only | `.agents/codex/matrices/MATRIX_INDEX.csv`, `.gitignore` |
| P1 | Dirty tree | Split the current dirty tree into small reversible commits | Group SDU, SharePoint, and hygiene changes into separate commits after validation | none | Do not merge, push, or stage unrelated paths together | `git status -sb`, `git diff --name-only` |
| P2 | Workpaper routing | Decide whether the backlog should also be mirrored into a workpaper `OPEN_ITEMS.csv` | If needed, update the nearest owner workpaper after the repo plan is accepted | none | Do not create duplicate backlog sources unless there is a clear owner split | `.agents/codex/workpapers/*/OPEN_ITEMS.csv`, `CURRENT_WORKPAPER.md` |

## Recommended Order
1. SDU-CN backlog split by list and front.
2. SharePoint surface closeout.
3. Dirty-tree split into small reversible commits.
4. Repo hygiene / index alignment.

## Validation
- `git diff --check`
- `git diff --name-only`

## Backlog By List

### `WB_Decisiones`
- Priority: `P0`
- Active split: keep current `MW-*` and `SDU-*` rows in the active backlog; keep the older `SGIN Soporte / SYS-SEI Escribanía` rows as historical archive.
- Backlog signal: this list is the main decision register, so the first task is to split by `Frente` and normalize the current rows into a clean current-front view.
- Next safe step: create a current-front filter for `MW-*` and `SDU-*`, and an archive filter for historical `SGIN` rows.
- Stop condition: do not mix historical SGIN setup decisions with current site or SDU decisions in the same backlog lane.

### `SYS_EstadoOperativo`
- Priority: `P0`
- Active split: current state rows that mention the live site, current gates, or current review items stay active; historical Day 1 setup rows stay archival.
- Backlog signal: this list still carries open operational items such as review cadence, permissions, responsible roles, and next actions.
- Next safe step: isolate open or observed rows that still map to current work and sort them by whether they are a site-state, review, permission, or evidence task.
- Stop condition: do not treat Day 1 setup rows as current backlog unless they still point to a live unresolved item.

### `WB_Riesgos`
- Priority: `P0`
- Active split: current live-site risks stay active; old SGIN opening/bootstrapping risks stay historical unless they still map to the current site.
- Backlog signal: this is the clearest list for unresolved operational blockers.
- Current active themes: nominal owners, permissions, runtime gate, delegation, and rollout boundaries.
- Next safe step: turn active risks into backlog items with one owner, one mitigation, one stop condition, and one rollback.
- Stop condition: do not collapse MW/SDU current risks into the older SGIN launch risks.

### `WB_AprendizajesOperativos`
- Priority: `P1`
- Active split: keep reusable rules that explain current operational behavior; archive the older setup lessons that only explain SGIN Day 1.
- Backlog signal: these rows are policy and prevention signals, not execution tasks.
- Next safe step: extract only the rules that affect current backlog items, especially PnP auth, DateTime handling, evidence hygiene, permissions, and runtime gating.
- Stop condition: do not turn historical setup lessons into new work items unless they still constrain the live site.

### `WB_CapacidadesOperativas`
- Priority: `P1`
- Active split: keep validated current capabilities that can still be used; move historical setup capabilities into reference-only status.
- Backlog signal: this list tells us what is actually safe to do next, and what remains partial.
- Next safe step: use only validated capabilities to support current backlog items; treat partial capabilities as dependent work, not as finished capacity.
- Stop condition: do not schedule work that exceeds the listed restrictions or depends on unvalidated runtime.

### `Historical SGIN`
- Priority: `P2`
- Scope: early `SGIN Soporte / SYS-SEI Escribanía` rows in the live lists, plus any older bootstrapping notes that no longer describe the current `SYS-GobiernoOperativo-PILOTO` backlog.
- Use: archive, reference, and preserve, but do not let them drive the active backlog.
- Next safe step: keep these rows readable, tagged, and separated from the current MW/SDU front.
- Stop condition: no SGIN historical row should be used as an active backlog driver unless it is explicitly revalidated against the current site.

## Ciclo Operativo Integrado
- Read: confirm the exact live list, its current rows, and whether each row is current SDU/MW or historical SGIN.
- Reconcile: match the row against existing canon, readbacks, and the live-list confirmation so we do not invent a new surface.
- Classify: split the row into current front, historical archive, or dependency gap.
- Execute: only then prepare the governed live-write order for the exact list and exact target row.
- Validate: run the local diff checks plus any surface-specific validator or postcheck that exists for that lane.
- Evidence: capture the row snapshot, the gate used, the rollback instruction, and the readback path that proves closure.
- Readback: close the lane only after the result is reflected back into the backlog and the historical/current split stays intact.
- Stop condition: if the target identity is ambiguous, if rollback is missing, if the row still mixes SGIN with current SDU/MW, or if a live write is requested without the exact gate.

## Secuencia De Escritura Live Por Lista

| Lista | Prioridad | Frente activo | Secuencia operativa | Gate explícito | Rollback explícito | Stop condition |
|---|---|---|---|---|---|---|
| `WB_Decisiones` | `P0` | `MW-*` y `SDU-*` activos; `SGIN` histórico | Read -> reconcile -> classify -> prepare order -> execute live write only on current rows -> validate -> evidence -> readback | `GATE_MICROSOFT_LIVE_WRITE` + `GATE_POWER_PLATFORM_APPLY` when the execute step crosses into live write | Revert the exact decision row or restore the prior snapshot, then publish a rollback readback | Do not mix historical SGIN setup decisions with current front decisions in the same write lane |
| `SYS_EstadoOperativo` | `P0` | current live site, current gates, current review items; Day 1 setup archival | Read -> reconcile -> classify by site-state/review/permission/evidence -> prepare order -> execute -> validate -> evidence -> readback | `GATE_MICROSOFT_LIVE_WRITE` + `GATE_POWER_PLATFORM_APPLY` when updating live state rows | Restore the prior state row or mark the change as superseded, then read back the restored state | Do not treat Day 1 setup rows as current backlog unless they still point to a live unresolved item |
| `WB_Riesgos` | `P0` | current live-site risks active; older SGIN opening risks archival | Read -> reconcile -> classify by current blocker vs historical launch risk -> prepare order -> execute -> validate -> evidence -> readback | `GATE_MICROSOFT_LIVE_WRITE` + `GATE_POWER_PLATFORM_APPLY` when turning a risk into a live control row | Revert the exact risk status or mitigation row, then preserve the before/after evidence | Do not collapse MW/SDU current risks into the older SGIN launch risks |
| `WB_AprendizajesOperativos` | `P1` | current reusable rules active; older setup lessons archival | Read -> reconcile -> classify by current operational rule vs historical setup note -> prepare order -> execute -> validate -> evidence -> readback | `GATE_MICROSOFT_LIVE_WRITE` if a live rule row must be updated; otherwise read-only | Restore the prior lesson row or append a rollback note referencing the superseded rule | Do not promote historical setup lessons into active work unless they still constrain the live site |
| `WB_CapacidadesOperativas` | `P1` | validated current capabilities active; partials are dependency work | Read -> reconcile -> classify validated vs partial -> prepare order -> execute -> validate -> evidence -> readback | `GATE_MICROSOFT_LIVE_WRITE` if the capability row is being changed; otherwise read-only | Restore the prior capability row and keep the rejected capability as evidence | Do not schedule work that exceeds the listed restrictions or depends on unvalidated runtime |
| `Historical SGIN` | `P2` | archive only | Read -> reconcile -> classify -> preserve -> evidence -> readback | none for archive-only handling | Restore from the preserved historical snapshot only if a revalidation gate later reopens it | No historical SGIN row should become an active write target without explicit revalidation against the current site |

## Current Decision Boundary
- Local documentation and matrix reconciliation is safe now.
- Anything that fills missing live inventory, changes tenant state, or writes to Dataverse/SharePoint remains gated.
