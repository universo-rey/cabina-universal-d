# Current State

## Metadata

- Last updated: 2026-06-08
- Status: `ACTIVE_SNAPSHOT`
- Repo: `universo-rey/cabina-universal-d`
- Workspace: `C:\Users\enzo1\Documents\GitHub\cabina-universal-d`
- Branch: `codex/gov/tool-selection-policy-20260608`
- Base head before Fase 2 cleanup: `816c907`
- Active PR: `#145`
- PR state at Fase 2 preflight: `draft`, `CLEAN`, checks green

## Operating State

- Canon operativo: `CABINA_FULL_LIVE_GOVERNED_GLOBAL_CANON`.
- Execution mode: `ACTIVE_GOVERNED_EXECUTION_BY_DEFAULT`.
- Active execution capability matrix:
  `governance/canon/ACTIVE_EXECUTION_CAPABILITY_MATRIX_20260603.csv`.
- Standard chain: `STANDARD_AGENT_CHAIN_ACTIVE`.
- Memory cleanup state: `FASE_2A_2B_2C_AGGRESSIVE_CONTROLLED_CLEANUP_IN_PROGRESS`.
- GitHub is the versionable technical canon.
- `AGENTS.md` is the active instruction contract.
- `MANIFEST.yaml` is the structured canon/pointer surface.
- `docs/operations/OPERATING_MEMORY_INDEX.md` is the navigation index for
  operating memory.
- `docs/operations/CANON_CHANGELOG.md` summarizes historical milestones.
- `docs/operations/archive/` preserves long historical source text.

## Current PR And Checks

- PR `#145`: `[GOV] Codify governed tool selection policy`.
- PR head at preflight: `816c90759c2e976aa62a564c8c818963b825fe89`.
- Merge state at preflight: `CLEAN`.
- Draft state at preflight: `true`.
- Remote checks at preflight:
  - `Active governed execution validators`: `PASS`.
  - `Local governance validators`: `PASS`.

## Confirmed Workflows And Validators

Confirmed available local validators for this cleanup lane:

- `.agents/codex/tools/local_validate_agents_instruction_hierarchy.ps1`
- `.agents/codex/tools/local_validate_operational_chain.ps1`
- `.agents/codex/tools/local_validate_capability_use_hardening.ps1`
- `.agents/codex/tools/local_validate_agent_layer.ps1`
- `.agents/codex/tools/local_validate_powershell_runtime_friction.ps1`

Confirmed absent in Fase 2 audit:

- `.agents/codex/tools/local_validate_tool_governance.ps1`

## Drift State

- Resolved by Fase 1: operating-memory index and `AGENTS.md` history archive
  exist and are versioned in PR #145.
- Resolved by Fase 2 target: active memory is being split into active contract,
  current snapshot, changelog and archive.
- Active drift to validate after edits: `AGENTS.md`, `CURRENT_STATE.md`,
  `OPERATING_MEMORY_INDEX.md`, `CANON_CHANGELOG.md` and archive pointers must
  agree.

## Known Risks

- `docs/*` is ignored by `.gitignore`; docs under `docs/operations/` require
  explicit forced staging when intentionally versioned.
- PR #145 remains draft until a separate approval converts it.
- This cleanup is documentary/governance only. It does not authorize live
  Microsoft, SharePoint, Dataverse, Power Platform, OpenAI, production,
  permissions, secrets, deploys or workflow changes.
- The Fase 2 commit hash cannot be self-embedded in this snapshot before the
  commit exists; use the final PR head/readback as the post-commit source.

## Needs Verification

- PR #145 checks after the Fase 2 commit.
- Whether `docs/operations/CANON_CHANGELOG.md` should become the only compact
  historical source after merge.
- Whether `MANIFEST.yaml` should later point directly to the new operating
  memory index and changelog.

## Next Lanes

1. Validate the Fase 2 cleanup locally.
2. Stage explicit paths only; do not use `git add .`.
3. Commit and push to PR #145.
4. Keep PR #145 draft until separate approval.
5. After merge of #145, reconcile `CURRENT_STATE.md` to the final merge commit
   in a separate canon update if required.
