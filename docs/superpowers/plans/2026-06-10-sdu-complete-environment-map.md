# SDU Complete Environment Map Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:subagent-driven-development` (recommended) or `superpowers:executing-plans` to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a single validated map of SDU state by environment, covering Dataverse tables, work queues, solutions, and agents, with separate canon for `HUBDesarrollo` and `ESCRIBANIA BITSCH default`.

**Architecture:** Use a read-only first pass to freeze the current evidence, then normalize it into one crosswalk matrix and one human-readable readback. Keep environment-scoped canon separate so queue IDs, table counts, and agent sets are not merged across snapshots. If a live refresh is needed, scope it to one exact environment and one exact target set, with Dataverse handled through `dataverse-atomic-segment-runner` and queue identity reconciliation handled through `dataverse-workqueue-backreference-mapping`.

**Tech Stack:** PowerShell, CSV, Markdown, Dataverse matrices/readbacks, Teams surface docs, local validators.

---

### Task 1: Freeze the current evidence inventory

**Files:**
- Read: `matrices/dataverse/DATAVERSE_DEV_ENVIRONMENT_BINDING_MATRIX.csv`
- Read: `matrices/postmerge/DEV_OPERATIONAL_STATE_MATRIX.csv`
- Read: `matrices/powerautomate/WORK_QUEUE_DEV_CREATION_RESULT.csv`
- Read: `matrices/powerautomate/WORK_QUEUE_DATAVERSE_ENTITY_DISCOVERY.csv`
- Read: `readbacks/dataverse/READBACK_DATAVERSE_DEV_METADATA_ONLY_SEED_APPLY.md`
- Read: `readbacks/powerautomate/READBACK_WORK_QUEUE_OPERATIONAL_BINDING_FROM_SEEDED_DATAVERSE.md`
- Read: `dataverse/data/seed_sdu_agent_runtime_actions.csv`
- Read: `dataverse/data/seed_environments.csv`

- [ ] **Step 1: Re-read the canonical environment and queue evidence**

Run:
```powershell
rg -n "7f65fc04-c27a-ea0d-bd2d-266aa9203c1e|858a0852-44a1-413e-a0fe-f053949797d6|HUBDesarrollo|ESCRIBANIA BITSCH|SDUCapabilityControlPlane|SDU.Matrix.Intake.Queue" matrices dataverse readbacks validation docs -g "*.csv" -g "*.md"
```

Expected: the current repo evidence resolves to one DEV/Sandbox environment (`HUBDesarrollo`) with `SDUCapabilityControlPlane`, plus the separate `ESCRIBANIA BITSCH default` marker that is not allowed for DEV apply.

- [ ] **Step 2: Record the known surface counts from existing artefacts**

Expected inventory from current evidence:
- `HUBDesarrollo`: 22 Dataverse tables, 8 work queues, 6 postchecked active agents
- `ESCRIBANIA BITSCH default`: no local table/queue/agent inventory confirmed yet

---

### Task 2: Build the unified environment crosswalk

**Files:**
- Create: `matrices/sdu/SDU_ENVIRONMENT_SURFACE_CROSSWALK.csv`
- Create: `readbacks/sdu/READBACK_SDU_COMPLETE_ENVIRONMENT_MAP.md`

- [ ] **Step 1: Define the crosswalk columns**

Use these columns:
`environment_name`, `environment_id`, `environment_url`, `tenant_id`, `solution`, `publisher`, `tables_count`, `queues_count`, `agents_count`, `queue_canon_status`, `table_canon_status`, `agent_canon_status`, `evidence_paths`, `notes`

- [ ] **Step 2: Populate the `HUBDesarrollo` row from current evidence**

Required fields:
- `environment_name`: `HUBDesarrollo`
- `environment_id`: `7f65fc04-c27a-ea0d-bd2d-266aa9203c1e`
- `environment_url`: `https://org084965d9.crm.dynamics.com`
- `tenant_id`: `858a0852-44a1-413e-a0fe-f053949797d6`
- `solution`: `SDUCapabilityControlPlane`
- `publisher`: `ModoON/mon`
- `tables_count`: `22`
- `queues_count`: `8`
- `agents_count`: `6`

- [ ] **Step 3: Populate the `ESCRIBANIA BITSCH default` row as incomplete, not guessed**

Mark missing evidence explicitly instead of inventing it:
- `tables_count`: `UNKNOWN_NO_LOCAL_INVENTORY`
- `queues_count`: `UNKNOWN_NO_LOCAL_INVENTORY`
- `agents_count`: `UNKNOWN_NO_LOCAL_INVENTORY`
- `solution`: `UNKNOWN_NO_LOCAL_INVENTORY`
- `notes`: `Default environment marker exists, but no local inventory snapshot for tables/queues/agents was found in this repo`

---

### Task 3: Reconcile queue identity drift by environment

**Files:**
- Read: `matrices/powerautomate/WORK_QUEUE_DEV_CREATION_RESULT.csv`
- Read: `matrices/postmerge/DEV_WORKQUEUE_FREEZE_MATRIX.csv`
- Read: `readbacks/2026-06-10_sdu_workqueue_daily_monitor_readback.md`
- Read: `readbacks/2026-06-10_sdu_dataverse_workqueue_capacity_readback.md`
- Create: `matrices/sdu/SDU_QUEUE_IDENTITY_RECONCILIATION.csv`

- [ ] **Step 1: Compare the queue IDs for `SDU.Matrix.Intake.Queue` across the two snapshots**

Expected reconciliation rule:
- keep one canon per environment
- do not collapse IDs across environments
- treat differing IDs as environment-scoped drift, not a new queue

- [ ] **Step 2: Record the canonical queue ID per snapshot**

Expected entries:
- `HUBDesarrollo` snapshot from `org084965d9`: `SDU.Matrix.Intake.Queue` = `b776b5e7-3f5f-f111-a826-00224805f8f9`
- `ESCRIBANIA BITSCH default` snapshot from `org993e120d`: `SDU.Matrix.Intake.Queue` = `573521e6-4964-f111-ab0d-002248df1063`
- capacity readback snapshot: `SDU.Matrix.Intake.Queue` = `573721e6-4964-f111-ab0d-002248df1063`

- [ ] **Step 3: Write the stop condition for the reconciliation**

Stop if any queue appears in more than one environment snapshot without an explicit environment label, because that would make global canon ambiguous.

---

### Task 4: Map tables, solutions, and agents per environment

**Files:**
- Read: `dataverse/data/seed_sdu_agent_runtime_actions.csv`
- Read: `readbacks/dataverse/READBACK_DATAVERSE_DEV_METADATA_ONLY_SEED_APPLY.md`
- Read: `readbacks/powerautomate/READBACK_WORK_QUEUE_OPERATIONAL_BINDING_FROM_SEEDED_DATAVERSE.md`
- Read: `matrices/dataverse/DATAVERSE_DEV_ENVIRONMENT_BINDING_MATRIX.csv`
- Read: `matrices/postmerge/DEV_OPERATIONAL_STATE_MATRIX.csv`
- Create: `matrices/sdu/SDU_ENVIRONMENT_CAPABILITY_MAP.csv`

- [ ] **Step 1: Extract the confirmed solution and agent set for `HUBDesarrollo`**

Confirmed set:
- solution: `SDUCapabilityControlPlane`
- publisher: `ModoON/mon`
- agents: `seshat-normativa`, `thot-tecnico`, `anubis-gate`, `maat-cumplimiento`, `horus-riesgo`, `narrador-normativo`

- [ ] **Step 2: List the confirmed Dataverse tables for `HUBDesarrollo`**

Use the 22-table snapshot already present in `DEV_OPERATIONAL_STATE_MATRIX.csv`. Preserve the exact `mon_sdu_*` names and the base queue tables `workqueue` / `workqueueitem`.

- [ ] **Step 3: Keep `ESCRIBANIA BITSCH default` separate until a real inventory exists**

Do not infer a solution, table list, or agent roster from the `Default` marker alone.

---

### Task 5: Validation and closeout

**Files:**
- Read: generated `matrices/sdu/*.csv`
- Read: generated `readbacks/sdu/*.md`

- [ ] **Step 1: Validate the working tree**

Run:
```powershell
git diff --check
git diff --name-only
```

- [ ] **Step 2: Sanity-check the new map against the existing evidence**

Verify that every claimed count and identity appears in at least one source file, and that every `UNKNOWN_NO_LOCAL_INVENTORY` field remains explicitly marked as unknown.

- [ ] **Step 3: Write the closeout readback**

The closeout should summarize:
- which environments are confirmed
- which surfaces are complete
- which surfaces are still missing local inventory
- what the next live-read gate would be if the user wants the missing environment filled in

