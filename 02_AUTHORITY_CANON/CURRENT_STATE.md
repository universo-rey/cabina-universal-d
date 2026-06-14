# Current State

## Metadata

- Last updated: 2026-06-13
- Version: v2.1.2
- Current: v2.1.2
- Status: `snapshot`
- Repo: `universo-rey/cabina-universal-d`
- Workspace: repo-local root `.`
- Branch: `codex/workpapers-power-automate-queue-20260612`
- Current HEAD: `a9a813e`
- Main after PR #145 merge: `29bb1804a31089170cdd782a463f496fe90353fe`
- PR #145 final head: `a1b3d6ef4389c65913fede54546a0793b3cee6b4`
- Active PR: none in merged main snapshot before this post-merge canon sync
- PR #145 state: `MERGED`

## Operating State

- Canon operativo: `CABINA_FULL_LIVE_GOVERNED_GLOBAL_CANON`.
- Execution mode: `ACTIVE_GOVERNED_EXECUTION_BY_DEFAULT`.
- Active execution capability matrix:
  `governance/canon/ACTIVE_EXECUTION_CAPABILITY_MATRIX_20260603.csv`.
- Standard chain: `STANDARD_AGENT_CHAIN_ACTIVE`.
- SDU-CN canonical agents status:
  `SDU_AGENTS_NEXT_TASK_ACTIVE_NO_MORE_SMOKE`.
- SDU-CN execution mode: `CORTE_EJECUTORA_GOVERNED`.
- SDU-CN front agent: `seshat-normativa`; gate: `anubis-gate`; operational
  lead: `court.openai_dispatcher`.
- Active SDU-CN roster: `seshat-normativa`, `thot-tecnico`, `anubis-gate`,
  `maat-cumplimiento`, `horus-riesgo`, `narrador-normativo`.
- Active SDU-CN order:
  `.agents/codex/orders/ORDER_SDU_AGENTS_NEXT_TASK_ACTIVATION_20260608.md`.
- SDU-CN live side effects remain `PENDING_TARGET_ONLY` until a concrete target,
  owner, rollback, postcheck and validator are declared.
- Memory cleanup state: `OPERATING_MEMORY_POINTER_VALIDATOR_IMPLEMENTED`.
- GitHub is the versionable technical canon.
- `AGENTS.md` is the active instruction contract.
- `MANIFEST.yaml` is the structured canon/pointer surface.
- `docs/operations/OPERATING_MEMORY_INDEX.md` is the navigation index for
  operating memory.
- `docs/operations/CANON_CHANGELOG.md` summarizes historical milestones.
- `docs/operations/archive/` preserves long historical source text.

## Latest Merged PR And Checks

- PR `#145`: `[GOV] Codify governed tool selection policy`.
- PR #145 merged at `2026-06-08T18:29:20Z`.
- Merge commit:
  `29bb1804a31089170cdd782a463f496fe90353fe`.
- Final PR head:
  `a1b3d6ef4389c65913fede54546a0793b3cee6b4`.
- Remote checks before merge:
  - `Active governed execution validators`: `PASS`.
  - `Local governance validators`: `PASS`.

## Confirmed Workflows And Validators

Confirmed available local validators for this cleanup lane:

- `.agents/codex/tools/local_validate_agents_instruction_hierarchy.ps1`
- `.agents/codex/tools/local_validate_operational_chain.ps1`
- `.agents/codex/tools/local_validate_capability_use_hardening.ps1`
- `.agents/codex/tools/local_validate_agent_layer.ps1`
- `.agents/codex/tools/local_validate_powershell_runtime_friction.ps1`
- `.agents/codex/tools/local_validate_operating_memory_pointers.ps1`

Confirmed absent in Fase 2/post-check audit:

- Tool-governance validator script: `NO_ENCONTRADO`.

## Drift State

- Resolved by Fase 1: operating-memory index and `AGENTS.md` history archive
  exist and are versioned in PR #145.
- Resolved by Fase 2 target: active memory is being split into active contract,
  current snapshot, changelog and archive.
- Resolved by PR #145 merge: operating memory pointer validator and active
  memory slimming are on `main`.
- Active drift in this lane: post-merge canon text must stop treating PR #145
  as active or draft.

## Known Risks

- `docs/*` is ignored by `.gitignore`; docs under `docs/operations/` require
  explicit forced staging when intentionally versioned.
- PR #145 is merged; it is no longer active or draft.
- This cleanup is documentary/governance only. It does not authorize live
  Microsoft, SharePoint, Dataverse, Power Platform, OpenAI, production,
  permissions, secrets, deploys or workflow changes.
- This activation sync is repo-local and declarative. It does not execute
  OpenAI live, Microsoft live, production, permissions, secrets, deploys or
  persistent remote agents.

## Needs Verification

- Whether `docs/operations/CANON_CHANGELOG.md` should become the only compact
  historical source after merge.
- Whether `MANIFEST.yaml` should later point directly to the new operating
  memory index and changelog.
- Ignored local skill `.agents/skills/threat-modeling/SKILL.md` references
  `NO_ENCONTRADO: docs/SKILL-ARCHITECTURE-DESIGN.md`; it is excluded from this
  PR because `.gitignore` excludes `/.agents/skills/threat-modeling/`.
  Candidate for Fase 3 skills/recipes pointer review.

## Next Lanes

1. Select the next concrete SDU-governed task target.
2. Keep SDU-CN readbacks naming the six canonical agents used, mappings,
   target, owner, rollback, postcheck, evidence, validator and stop condition.
3. Do not run more smoke tests unless a concrete SDU task requires it under the
   active cost, data and secret boundaries.
4. Keep Microsoft live and production parked until exact target gates are met.
