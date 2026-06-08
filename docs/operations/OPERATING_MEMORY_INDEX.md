# Operating Memory Index

## Metadata

- Updated on: 2026-06-08
- Scope: `universo-rey/cabina-universal-d`
- Phase: Fase 2 limpieza integral de memoria operativa
- Status: active
- Mode: non-destructive, no pruning

## Use

Start here when cleaning or navigating operational memory. This index maps the
current sources of truth after Fase 2 active-memory slimming.

## Sources Of Truth

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
| `.agents/codex/matrices/TOOL_GOVERNANCE_MATRIX.csv` | Tool governance, side effects, gates and selection policy matrix. | active | Actual repo path. The requested `.agents/codex/tools/TOOL_GOVERNANCE_MATRIX.csv` path was not found. |
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
