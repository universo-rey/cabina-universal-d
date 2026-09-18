# Operating Memory Index

## Metadata

- Updated on: 2026-06-08
- Version: v2.1.0
- Current: v2.1.0
- Last updated: 2026-06-08
- Scope: `universo-rey/cabina-universal-d`
- Phase: Fase 2 limpieza integral de memoria operativa
- Status: active
- Mode: non-destructive, no pruning

## Use

Start here when cleaning or navigating operational memory. This index maps the
current sources of truth after Fase 2 active-memory slimming.

## Historical Continuity Evidence

The artifacts listed in this section are dated evidence and continuity records.
They are not active authority, current runtime bindings, or proof of present health.
For current behavior use `AGENTS.md`, `02_AUTHORITY_CANON/CURRENT_STATE.md`,
`MANIFEST.yaml`, and the exact object contract/binding being operated.

### Cierre del hilo de ajustes — 2026-09-16

- [Cierre gobernado y continuidad](../../operativa/READBACK_CIERRE_HILO_20260916.md): resultados recuperados de IDE, skills, Cloud, lanes, watchdog y NOC; pendientes por orden y alcance de las comprobaciones. Consultar este balance antes de reabrir pendientes de informes intermedios. Cierre documental con pendientes explicitos, sin cierre global ni entrega Git.

### EATOMIC and Cloud continuity recovered — 2026-09-16

Classification: `HISTORICAL_EVIDENCE_ONLY`. Local absolute paths below preserve
provenance observed on that date; they do not override current repo-native or
GitHub bindings.

- Existing local entry: [CAPABILITY_FRONTDOOR.md](C:/CEO/project-cdx/.cabina/SDU_RUNTIME_ROOT/00_START_HERE/CAPABILITY_FRONTDOOR.md). Git excludes `.cabina/` via project-cdx `.git/info/exclude:8`; exclusion does not remove its operational role.
- Existing host launcher: [codex-cloud-live.ps1](C:/CEO/project-cdx/tools/codex-cloud-live.ps1). Its default EATOMIC branch invokes `codex exec --cd <projectRoot>` and supplies the user's order, EATOMIC recipe, dispatcher assignment and wave recipe. The CodexCloudAtomic branch is the separate SDK surface.
- Dispatcher assignment: [court.openai_dispatcher.md](C:/CEO/project-cdx/.agents/codex/agents/03_CORTE_EJECUTORA/court.openai_dispatcher.md). The authenticated host conducts the order; Cloud delivery uses Start-SDUCodex, WP007 and WP006.
- Preserved continuation: [BONTEMPS_OPERATIVA.md](C:/CEO/.metadata/reports/inicio-codex-cloud-2026-09-09/BONTEMPS_OPERATIVA.md), with sibling READBACK.json and CONSUMO_RESPUESTA_CLOUD.json. It preserves task `task_e_6aa13811876c832e9e53937e073f1434` and continuation through `LANE-SDU-CLOUD-READY-001`; do not turn the partial task observation into a new smoke requirement.
- Launch Desk `history.jsonl` contains six launch-planning records in the inspected file; it is not the recovered Cloud continuation package. Its endpoint is not the sole dispatch entry.
- This recovery read the existing artifacts; it did not invoke a new agent run or Cloud task. Resume the matching order and correlation; do not create a replacement bridge because the UI lacks an automatic call.


| Path | Role | Status | Notes |
| --- | --- | --- | --- |
| `AGENTS.md` | Persistent active rules for Codex execution, gates, Git/GitHub, Microsoft/Power Platform, validation and readback. | active | Slimmed in Fase 2; history lives in archive/changelog. |
| `02_AUTHORITY_CANON/CURRENT_STATE.md` | Current operational snapshot, PR/check state, drift, risks and next lanes. | snapshot | Slimmed in Fase 2; update when repo/PR/runtime state changes. |
| `MANIFEST.yaml` | Structured pointers, canon metadata, validators, lanes and declared surfaces. | active | Use as structured canon index, not as narrative history. |
| `docs/operations/CANON_CHANGELOG.md` | Summarized milestone history. | active | Compact historical navigation; not a current-state source. |
| `docs/operations/archive/` | Long historical context preserved outside active instruction memory. | archive | Contains AGENTS and CURRENT_STATE source archives. |
| `docs/operations/archive/AGENTS_HISTORY_20260608.md` | Preserved long AGENTS history and current-memory excerpts from before slimming. | archive | Use for historical evidence, not active instruction. |
| `docs/operations/archive/CURRENT_STATE_HISTORY_20260608.md` | Full pre-Fase-2 CURRENT_STATE source archive. | archive | Use for historical evidence, not active snapshot. |
| `.agents/codex/tools/TOOL_INDEX.csv` | Tool index and tool capability references. | active | Existing tool inventory source. |
| `.agents/codex/matrices/TOOL_GOVERNANCE_MATRIX.csv` | Tool governance, side effects, gates and selection policy matrix. | active | Actual repo path; the earlier tools-directory variant was not found. |
| `.agents/codex/tools/local_validate_operating_memory_pointers.ps1` | Local validator for active memory pointers, metadata and anti-history-regression. | active | Added in PR #145; read-only. |
| `.agents/skills/` | Repo-local reusable skills and activation rules. | active | No pruning in Fase 2/post-check. |
| `.agents/codex/recipes/` | Step-by-step recipes and recipe indexes. | active | No pruning in Fase 2/post-check. |
| `.agents/codex/skills/` | Skill catalogs, usage matrices and quality matrices. | active | Catalog/index layer for skills. |
| `.github/workflows/` | GitHub Actions validation and PR gates. | active | Validate before closeout when changed. |
| `README.md` | Human-facing project entrypoint. | needs verification | Not cleaned in Fase 1. |
| `docs/` | Human and operational documentation. | needs verification | Review in later phases before consolidation. |

## Classification Policy

| Class | Meaning | Action |
| --- | --- | --- |
| Vigente | Still correct and evidence-backed. | Keep active. |
| Vigente pero mal ubicado | Useful, but too long or procedural for active memory. | Move to changelog, archive, recipe or skill. |
| Duplicado | Repeats another source of truth. | Keep one active source and replace duplicates with pointers. |
| Obsoleto | Contradicts current state or uses old structure. | Mark historical/deprecated in archive. |
| Historico util | Explains migrations, PR history, legacy paths or prior gates. | Archive. |
| Incierto | Not enough current evidence. | Mark `needs verification`. |

## Cleanup Outputs

- `docs/operations/OPERATING_MEMORY_INDEX.md`: active navigation index.
- `docs/operations/archive/AGENTS_HISTORY_20260608.md`: non-destructive archive
  copy of long `AGENTS.md` operating history and related current-memory
  pointers.
- `docs/operations/archive/CURRENT_STATE_HISTORY_20260608.md`: full
  pre-Fase-2 `CURRENT_STATE.md` source archive.
- `docs/operations/CANON_CHANGELOG.md`: compact milestone history.
