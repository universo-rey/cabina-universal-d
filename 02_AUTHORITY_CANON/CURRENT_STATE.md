# Current State

## Metadata

- Last updated: 2026-09-03
- Version: v2.1.3
- Current: v2.1.3
- Status: `snapshot`
- Repo: `universo-rey/cabina-universal-d`
- Workspace: repo-local root `.`
- Snapshot branch: `codex/validator-workflow-current-state-20260903`
- Main baseline HEAD: `a4a92165fcd709ab6cdb0247c3dae4e24ce74e7c`
- Validated branch HEAD: `a7a825219c1b7521ebfb447b8a9e9e1833641515` (immutable CI evidence before this metadata-only closure commit)
- Latest merged PR: `#160`
- PR #160 state: `MERGED`
- Active PR for this snapshot: `#165`

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
- Repo-native Codex carrier state: recorded by merged PR `#159`.
- Codex Cloud environment state: Modo ON Foundation and SDU Canon activated in
  the governed matrices by merged PR `#160`.
- GitHub is the versionable technical canon.
- Runtime reading precedence remains: governed order and exact authority/binding,
  then the exact Microsoft live target when authorized, then GitHub technical
  canon and evidence, with documentary history as fallback.
- `AGENTS.md` is the active instruction contract.
- `MANIFEST.yaml` is the structured canon/pointer surface.
- `docs/operations/OPERATING_MEMORY_INDEX.md` is the navigation index for
  operating memory.
- `docs/operations/CANON_CHANGELOG.md` summarizes historical milestones.
- `docs/operations/archive/` preserves long historical source text.

## Current Validation Topology

- `.github/workflows/cabina-validation.yml` invokes the change-aware full
  coverage orchestrator on Windows.
- `.agents/codex/matrices/CHANGE_AWARE_TEST_MANIFEST.csv` declares 22 required
  merge-blocking tests consumed by that orchestrator.
- `.github/workflows/active-governed-execution-validation.yml` invokes the
  active-governed-execution and DEV/mock Python validators on Ubuntu.
- `.agents/codex/matrices/GITHUB_ACTIONS_WORKFLOW_MATRIX.csv` is the existing
  workflow-to-validator registry. Its correspondence with both workflows is
  enforced by `local_validate_github_automation_preflight.ps1` in this lane.
- Remote checks at validated branch HEAD `a7a825219c1b7521ebfb447b8a9e9e1833641515`:
  - `Cabina Validation` run `33787322508`: `PASS`.
  - `Active Governed Execution Validation` run `33787322509`: `PASS`.

## Confirmed Workflows And Validators

Confirmed relevant local validators for this lane:

- `.agents/codex/tools/local_validate_agents_instruction_hierarchy.ps1`
- `.agents/codex/tools/local_validate_operational_chain.ps1`
- `.agents/codex/tools/local_validate_capability_use_hardening.ps1`
- `.agents/codex/tools/local_validate_agent_layer.ps1`
- `.agents/codex/tools/local_validate_operating_memory_pointers.ps1`
- `.agents/codex/tools/local_validate_github_automation_preflight.ps1`
- `.agents/codex/tools/local_validate_change_aware_full_coverage_orchestrator.ps1`

Tool governance does not require a new standalone validator under the current
contract. `REPO_AGENT_TOOL_GOVERNANCE_MATRIX.csv` assigns tool governance to
`local_validate_agent_layer.ps1`, which validates the required columns of
`TOOL_GOVERNANCE_MATRIX.csv` and rejects tools missing a governance row.

## Drift State

- Resolved before this lane: operating-memory index, history archive and
  pointer validator are versioned on `main`.
- Resolved in this lane: the current snapshot no longer presents the June
  branch or PR #145 as current.
- Resolved in this lane: workflow registry entries enumerate the validators
  actually reachable through the two governed CI workflows.
- Guard added in this lane: the GitHub automation preflight fails if a required
  change-aware test or a directly invoked Python validator is missing from the
  workflow registry.

## Known Risks

- `docs/*` is ignored by `.gitignore`; docs under `docs/operations/` require
  explicit forced staging when intentionally versioned.
- The main baseline is fixed to the observed commit above; a later remote HEAD
  requires a fresh read before merge.
- This cleanup is documentary/governance only. It does not authorize live
  Microsoft, SharePoint, Dataverse, Power Platform, OpenAI, production,
  permissions, secrets, deploys or workflow changes.
- This activation sync is repo-local and declarative. It does not execute
  OpenAI live, Microsoft live, production, permissions, secrets, deploys or
  persistent remote agents.

## Needs Verification

- Remote CI passed on validated branch HEAD `a7a825219c1b7521ebfb447b8a9e9e1833641515`; this metadata-only closure commit requires fresh CI before merge.
- Standalone validators outside the two governed workflow contracts require a
  separate disposition review before they can be classified as required CI,
  nested, manual or historical. Their mere presence does not prove merge-gate
  intent.

## Next Lanes

1. Close this repo-scoped validator/workflow registry delta through a reviewed
   PR without automatic merge.
2. Keep SDU-CN readbacks naming the six canonical agents used, mappings,
   target, owner, rollback, postcheck, evidence, validator and stop condition.
3. Do not run more smoke tests unless a concrete SDU task requires it under the
   active cost, data and secret boundaries.
4. Keep Microsoft live and production parked until exact target gates are met.
