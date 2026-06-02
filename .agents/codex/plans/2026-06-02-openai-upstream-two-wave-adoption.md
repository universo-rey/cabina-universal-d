# OpenAI Upstream Two Wave Adoption Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Adopt official `openai/*` GitHub references into the Cabina Universal local governance layer in two waves without OpenAI API live, Microsoft live, production, secrets or remote persistent agents.

**Architecture:** Wave 1 registers official upstream sources, adds a reusable review-repair-validate recipe, and validates the new local artifacts. Wave 2 maps repo-native adoption lanes for TCU, SDU, TGE and CDF while keeping each nested repo separate and ready for its own branch/PR.

**Tech Stack:** PowerShell validators, CSV matrices, Markdown recipes/readbacks, GitHub read-only metadata.

---

### Task 1: Wave 1 Upstream Reference Registry

**Files:**
- Create: `D:\.agents\codex\matrices\OPENAI_UPSTREAM_REFERENCE_MATRIX.csv`
- Modify: `D:\.agents\codex\matrices\MATRIX_INDEX.csv`
- Modify: `D:\.agents\codex\matrices\SKILL_REFERENCE_SOURCE_MATRIX.csv`

- [x] **Step 1: Register official OpenAI upstream repos**

Add rows for `openai/codex`, `openai/skills`, `openai/openai-cookbook`, `openai/openai-agents-python`, `openai/openai-agents-js`, SDKs, `openai/openai-openapi`, `openai/codex-action`, `openai/evals`, Guardrails, Privacy Filter, Model Spec, realtime and CUA examples.

- [x] **Step 2: Keep references subordinate**

Every row must classify upstream as technical reference, block `treat_as_canon`, `bulk_copy`, `openai_api_live`, `production`, `secrets`, `permission_change` and `remote_agent_persistence`.

### Task 2: Review Repair Validate Recipe

**Files:**
- Create: `D:\.agents\codex\recipes\recipe.openai_review_repair_validate_loop.md`
- Modify: `D:\.agents\codex\recipes\RECIPE_INDEX.csv`

- [x] **Step 1: Encode the loop**

The recipe defines `review -> classify -> repair -> validate -> readback` using local artifacts and validators only.

- [x] **Step 2: Declare stop conditions**

Stop on OpenAI API live, Microsoft live, production, secrets, broad regulated data, permission change, source uncertainty or missing validator evidence.

### Task 3: Wave 2 Repo-Native Adoption Lanes

**Files:**
- Create: `D:\.agents\codex\matrices\OPENAI_TWO_WAVE_ADOPTION_MATRIX_20260602.csv`

- [x] **Step 1: Map Wave 1 closure lanes**

Rows must cover upstream matrix, recipe, validator and readback closeout.

- [x] **Step 2: Map Wave 2 repo lanes**

Rows must cover `tcu-agentic-runtime-control`, `sdu-canon`, `seshat-bootstrap-sdu-cn`, `torre-gemela-escribania`, `tge-agentic-runtime-control-escribania`, `cdf-soluciones`, `jara-consultores` and `modo-on-foundation`.

### Task 4: Validator and Evidence

**Files:**
- Create: `D:\.agents\codex\tools\local_validate_openai_upstream_adoption.ps1`
- Modify: `D:\.agents\codex\tools\TOOL_INDEX.csv`
- Modify: `D:\.agents\codex\matrices\TOOL_GOVERNANCE_MATRIX.csv`
- Modify: `D:\.agents\codex\matrices\VALIDATION_COVERAGE_MATRIX.csv`
- Modify: `D:\.agents\codex\matrices\EVIDENCE_AND_VALIDATION_MATRIX.csv`
- Create: `D:\.agents\codex\readbacks\2026-06-02_openai_two_wave_adoption_readback.md`
- Create: `D:\.agents\codex\workpapers\tech.reference_librarian\2026-06-02_openai_upstream_reference.md`
- Create: `D:\.agents\codex\workpapers\court.openai_dispatcher\2026-06-02_openai_repair_loop_and_repo_lanes.md`
- Create: `D:\.agents\codex\workpapers\court.sdu_gate\2026-06-02_openai_adoption_gate_review.md`

- [x] **Step 1: Validate required artifacts**

The validator checks required columns, required upstream repos, required Wave 2 repo lanes, known agents, known recipe/tool ids, stop conditions and blocked-surface tokens.

- [x] **Step 2: Record readback**

The readback declares no OpenAI API live, no Microsoft live, no production, no secrets, no nested repo mutation and no remote persistent agents.

### Task 5: Verification

**Commands:**
- `powershell -NoProfile -ExecutionPolicy Bypass -File D:\.agents\codex\tools\local_validate_openai_upstream_adoption.ps1`
- `powershell -NoProfile -ExecutionPolicy Bypass -File D:\.agents\codex\tools\local_validate_skill_reference_sources.ps1`
- `powershell -NoProfile -ExecutionPolicy Bypass -File D:\.agents\codex\tools\local_validate_operational_chain.ps1`
- `powershell -NoProfile -ExecutionPolicy Bypass -File D:\.agents\codex\tools\local_validate_agent_layer.ps1`
- `git -C D:\ diff --check`

- [x] **Step 1: Run validators**

Expected: all validators return `PASS`.

- [ ] **Step 2: Commit and publish**

Stage only explicit files, commit, push branch and open a draft PR against `main`.
