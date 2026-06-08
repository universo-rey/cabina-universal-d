# Operating Memory Index

## Metadata

- Updated on: 2026-06-08
- Scope: `universo-rey/cabina-universal-d`
- Phase: Fase 1 limpieza integral de memoria operativa
- Status: active
- Mode: non-destructive, no pruning

## Use

Start here when cleaning or navigating operational memory. This index maps the
current sources of truth without moving, deleting or shortening active
instructions in Fase 1.

## Sources Of Truth

| Path | Role | Status | Notes |
| --- | --- | --- | --- |
| `AGENTS.md` | Persistent active rules for Codex execution, gates, Git/GitHub, Microsoft/Power Platform, validation and readback. | active | Keep active until a later approved phase rewrites it. |
| `02_AUTHORITY_CANON/CURRENT_STATE.md` | Current operational snapshot, latest reconciled state and recent decisions. | snapshot | Temporal state; update when repo/PR/runtime state changes. |
| `MANIFEST.yaml` | Structured pointers, canon metadata, validators, lanes and declared surfaces. | active | Use as structured canon index, not as narrative history. |
| `docs/operations/CANON_CHANGELOG.md` | Summarized milestone history. | needs verification | Planned source for compact history; not present in Fase 1 preflight. |
| `docs/operations/archive/` | Long historical context preserved outside active instruction memory. | archive | Fase 1 creates the archive folder and first AGENTS history copy. |
| `.agents/codex/tools/TOOL_INDEX.csv` | Tool index and tool capability references. | active | Existing tool inventory source. |
| `.agents/codex/matrices/TOOL_GOVERNANCE_MATRIX.csv` | Tool governance, side effects, gates and selection policy matrix. | active | Actual repo path. The requested `.agents/codex/tools/TOOL_GOVERNANCE_MATRIX.csv` path was not found. |
| `.agents/skills/` | Repo-local reusable skills and activation rules. | active | No pruning in Fase 1. |
| `.agents/codex/recipes/` | Step-by-step recipes and recipe indexes. | active | No pruning in Fase 1. |
| `.agents/codex/skills/` | Skill catalogs, usage matrices and quality matrices. | active | Catalog/index layer for skills. |
| `.github/workflows/` | GitHub Actions validation and PR gates. | active | Validate before closeout when changed. |
| `README.md` | Human-facing project entrypoint. | needs verification | Not cleaned in Fase 1. |
| `docs/` | Human and operational documentation. | needs verification | Review in later phases before consolidation. |

## Fase 1 Classification Policy

| Class | Meaning | Fase 1 action |
| --- | --- | --- |
| Vigente | Still correct and evidence-backed. | Keep active. |
| Vigente pero mal ubicado | Useful, but too long or procedural for active memory. | Copy/archive only; move in later approved phase. |
| Duplicado | Repeats another source of truth. | Mark by index; do not delete in Fase 1. |
| Obsoleto | Contradicts current state or uses old structure. | Preserve if historical; do not remove in Fase 1. |
| Historico util | Explains migrations, PR history, legacy paths or prior gates. | Archive. |
| Incierto | Not enough current evidence. | Mark `needs verification`. |

## Fase 1 Output

- `docs/operations/OPERATING_MEMORY_INDEX.md`: active navigation index.
- `docs/operations/archive/AGENTS_HISTORY_20260608.md`: non-destructive archive
  copy of long `AGENTS.md` operating history and related current-memory
  pointers.
