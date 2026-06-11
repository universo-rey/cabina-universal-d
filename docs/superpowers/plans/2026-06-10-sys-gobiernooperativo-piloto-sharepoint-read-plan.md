# SYS Gobierno Operativo PILOTO SharePoint Read Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Recolectar y reconciliar la superficie viva del sitio `SYS-GobiernoOperativo-PILOTO`, dejando un mapa mínimo de bibliotecas, paquetes de gobierno, artefactos canónicos y gaps de metadata listo para cierre gobernado.

**Architecture:** Trabajamos por carriles paralelos y sin solapamiento de escritura. Un carril inventaría la superficie raíz y las bibliotecas visibles; otro carril leería el paquete de gobierno en `LIB_GobiernoSistemas`; otro carril consolidaría readbacks, matrices y el gap entre modelo y superficie viva. El lead agent integra la evidencia y cierra con readback gobernado.

**Tech Stack:** SharePoint connector, Markdown readbacks, CSV matrices, governed order preparation, governed readback closeout.

---

### Task 1: Root Surface Inventory

**Files:**
- Create: `readbacks/sharepoint/READBACK_SYS_GOBIERNOOPERATIVO_PILOTO_SURFACE.md`
- Modify: `matrices/sharepoint/SHAREPOINT_AGENT_REGISTRY_SURFACE_MATRIX.csv`

- [ ] **Step 1: Confirm site and visible libraries**

```text
Use the SharePoint connector to resolve:
- hostname: escribaniabitsch.sharepoint.com
- site path: /sites/SYS-GobiernoOperativo-PILOTO

Then list the site drives and root folders.
Capture the confirmed site id, display name, webUrl, and the visible libraries/folders.
```

- [ ] **Step 2: Record the surface inventory**

```text
Write the inventory into readbacks/sharepoint/READBACK_SYS_GOBIERNOOPERATIVO_PILOTO_SURFACE.md.
Include:
- site identity
- usable document libraries
- folders that clearly act as governance/control surfaces
- the immediate read scope and the folders explicitly not yet opened
```

- [ ] **Step 3: Update the sharepoint surface matrix**

```text
Add one row per confirmed surface to matrices/sharepoint/SHAREPOINT_AGENT_REGISTRY_SURFACE_MATRIX.csv.
Keep the matrix narrow: surface kind, object name, relation shape, evidence refs, and notes.
```

### Task 2: Governance Package Read

**Files:**
- Create: `readbacks/sharepoint/READBACK_SYS_GOBIERNOOPERATIVO_PILOTO_GOVERNANCE_PACKAGE.md`

- [ ] **Step 1: Read the governing package folders in parallel**

```text
Open these folders in parallel:
- LIB_GobiernoSistemas/MW-MAQUINA-CABINA-OPERATIVA-SHAREPOINT-V1
- LIB_GobiernoSistemas/TGE_Control_20260514
- LIB_GobiernoSistemas/TGE_SDU_CN_MICROSOFT_EXECUTION_20260531/context
- LIB_GobiernoSistemas/TGE_SDU_CN_MICROSOFT_EXECUTION_20260531/readbacks

Collect file names only unless a file is explicitly needed to disambiguate a gate or matrix.
```

- [ ] **Step 2: Reconcile the control artifacts**

```text
Classify each artifact into one of:
- architecture
- manifest
- matrix
- readback
- gate
- evidence
- runbook
- operating guide

Document the result in readbacks/sharepoint/READBACK_SYS_GOBIERNOOPERATIVO_PILOTO_GOVERNANCE_PACKAGE.md.
```

- [ ] **Step 3: Identify the minimum reusable canon**

```text
Mark which files should be treated as canonical starting points for future work:
- manifest
- readback
- matrix
- gate
- runbook

Call out any folder that is clearly a duplicate, mirror, or derived execution pack.
```

### Task 3: Reconciliation and Gap Map

**Files:**
- Create: `matrices/sharepoint/SYS_GOBIERNOOPERATIVO_PILOTO_GAP_MAP.csv`
- Create: `readbacks/sharepoint/READBACK_SYS_GOBIERNOOPERATIVO_PILOTO_GAP_MAP.md`

- [ ] **Step 1: Build the gap map**

```text
Compare the root surface inventory against the governance package and record:
- what is clearly live
- what is only documentary
- what is duplicated across folders
- what is missing metadata
- what requires a deeper folder read
```

- [ ] **Step 2: Classify the next safe probes**

```text
Separate next probes into:
- safe read-only folder probes
- metadata-only file reads
- anything that would require a live write gate

Only include read-only or metadata-only follow-ups in this plan.
```

- [ ] **Step 3: Close the readback**

```text
Write a governed readback with:
- touched files
- untouched surfaces
- validator status
- remaining risk
- next lanes
```

### Task 4: Validation and Handoff

**Files:**
- Modify: `docs/superpowers/plans/2026-06-10-sys-gobiernooperativo-piloto-sharepoint-read-plan.md`
- Create: `readbacks/sharepoint/READBACK_SYS_GOBIERNOOPERATIVO_PILOTO_CLOSEOUT.md`

- [ ] **Step 1: Run local validation**

```text
Validate the repo diff with:
- git diff --check
- git diff --name-only

If any new CSV or Markdown file is added, verify the file is present in the expected folder and referenced by the relevant readback.
```

- [ ] **Step 2: Check for plan hygiene**

```text
Scan the plan for:
- placeholder language
- overlapping task scopes
- missing evidence paths
- missing stop conditions
```

- [ ] **Step 3: Handoff**

```text
Return:
- what was actually read
- what remains unread
- the exact next folder or file to inspect
- whether the next step is still read-only or needs a gate
```
