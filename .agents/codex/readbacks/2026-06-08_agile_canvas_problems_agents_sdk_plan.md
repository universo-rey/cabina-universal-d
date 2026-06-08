# Agile Canvas Problems Agents SDK Plan

## Estado

status: READY_FOR_PR_CREATE
surface: repo_local | vscode_insiders_readonly | agents_sdk_local_design
repo: universo-rey/cabina-universal-d
workspace: C:/Users/enzo1/Documents/GitHub/cabina-universal-d
base_branch: main
observed_head: 3c68121
operator_order: revisar 359 Problems, usar agentes, skills, recetas, tools y Agents SDK

## Objetivo

Reducir los Problems visibles en VS Code Insiders sin esconder diagnosticos
reales, separando:

1. salud repo/CI;
2. drift Agile Agent Canvas 0.5.2;
3. fallos internos de schemas de extension;
4. ruido de extensiones de editor;
5. deuda versionable que puede resolverse por rama, validadores y PR.

## Frontera

Permitido ahora:

- lectura repo-local;
- lectura de extension VSI instalada;
- auditoria JSON/schema local;
- harness Agents SDK local con prompts sinteticos y tools deterministas;
- evals sinteticos sin llamada OpenAI API live;
- branch codex/*, commit, push y PR si el operador abre ejecucion del plan;
- validadores locales y GitHub checks repo-scoped.

Bloqueado sin gate humano separado:

- OpenAI API live con costo o secreto real;
- Agents SDK deployment live;
- Microsoft live write;
- Jira live;
- Power Platform apply;
- produccion;
- force push;
- branch deletion;
- cambio de remoto;
- impresion o persistencia de secretos.

## Cadena de agentes

lead_agent: rey.control_plane_orchestrator
owner_agent: codex.workspace_guardian
schema_agent: court.thot_schema
dispatcher_agent: court.openai_dispatcher
runtime_agent: sdu-triage-agent
gate_agent: court.sdu_gate
evidence_agent: court.seshat_evidence
reviewer_agent: court.seshat_evidence

Subagentes locales recomendados:

- Ramanujan: repo health, CI, validators, diff discipline.
- Kuhn: VSI Problems source triage, extension/source grouping.
- Turing: Agile Agent Canvas schema reconciliation and validator design.

## Skills

- tcu-descubridor-capacidades: capability assignment and NO_DISPONIBLE marking.
- parallel-order-governance: sidecar lanes, lock keys, evidence and validators.
- openai-developers:agents-sdk: local code-first agent design and eval harness.
- vsi-superficie-viva-task-runner: VSI surface execution/readback where local.
- governed-readback-closeout: final evidence and stop condition.
- github:gh-address-comments: only if PR comments appear later.

## Recetas

- recipe.parallel_agent_operation
- recipe.vsi_prepared_agent_task_execution
- recipe.openai_local_agent_design
- recipe.schema_tool_contract
- recipe.openai_review_repair_validate_loop
- recipe.github_pr_lifecycle_governed
- recipe.governed_readback_closeout

## Tools

- tool.git_status_readonly
- tool.codex_workspace_audit
- tool.agile_canvas_identity_drift_validator
- tool.agile_canvas_task_ops_validator
- tool.local_validate_parallel_order_governance
- tool.local_validate_capability_use_hardening
- tool.local_run_change_aware_full_coverage_orchestrator
- tool.github_versioning_flow
- tool.agile_canvas_extension_schema_validator
- local JSON/schema audit using Python jsonschema
- Agents SDK local harness with deterministic function tools

## Agents SDK plan

Use Agents SDK as a local orchestrator contract, not as live API execution in
this first lane.

Agent: AgileCanvasProblemsOrchestrator

Instructions:

- classify each Problem into repo_blocking, canvas_schema_drift,
  extension_schema_defect, editor_noise, or gated_external_surface;
- require evidence for each classification;
- never call live APIs;
- never print secrets;
- propose fixes only inside declared file scope;
- emit structured output.

Function tools:

- get_git_preflight(): returns git root, branch, head, status, remote.
- list_canvas_artifacts(): returns .agileagentcanvas-context JSON inventory.
- validate_canvas_local(): runs existing Agile Canvas validators.
- audit_extension_schemas(): validates artifacts against installed AAC schemas.
- classify_problem_batch(): classifies captured Problems rows.
- propose_reconciliation_patch(): returns candidate file changes only.
- run_governance_validators(): runs selected local validators.

Structured output:

```json
{
  "status": "string",
  "summary": {
    "repo_health": "pass|fail",
    "canvas_schema": "pass|drift|extension_schema_defect",
    "editor_noise": "unknown|confirmed|not_detected"
  },
  "findings": [
    {
      "id": "string",
      "source": "string",
      "classification": "repo_blocking|canvas_schema_drift|extension_schema_defect|editor_noise|gated_external_surface",
      "evidence": ["string"],
      "recommended_action": "string",
      "gate": "none|string"
    }
  ],
  "next_commands": ["string"]
}
```

## Carriles

### Carril 1 - Repo health baseline

owner_agent: Ramanujan
write_scope: none
lock_key: readonly.repo.health
commands:

- git status -sb
- git diff --check
- gh pr list --state open
- gh run list --branch main --limit 5
- .agents/codex/tools/local_run_change_aware_full_coverage_orchestrator.ps1 -NoWrite

validator: local_run_change_aware_full_coverage_orchestrator
stop_condition: repo_validator_failure_actionable

### Carril 2 - VSI Problems source capture

owner_agent: Kuhn
write_scope: none
lock_key: readonly.vsi.problems
actions:

- filter Problems by source in VSI: Agile Agent Canvas, json, yaml, Pylance,
  markdownlint, cSpell, CodeQL, ESLint;
- capture first 20 rows per source if possible;
- do not bulk-copy secrets or regulated file content.

validator: evidence rows grouped by source
stop_condition: problems_source_capture_unavailable

### Carril 3 - Agile Canvas schema reconciliation

owner_agent: Turing
write_scope:

- .agileagentcanvas-context/**
- .agents/codex/matrices/VSCODE_INSIDERS_AGILE_AGENT_CANVAS_GOVERNANCE_20260606.csv
- scripts/validators/**

lock_key: agile_canvas.schema.0_5_2
current_evidence:

- installed extension observed: msayedshokry.agileagentcanvas@0.5.2
- governance matrix currently declares: msayedshokry.agileagentcanvas@0.5.0
- schema audit: 24 PASS, 5 FAIL, 2 NO_SCHEMA, 3 SCHEMA_REF_FAIL
- post-reconciliation validator target: 29 PASS, 2 expected NO_SCHEMA,
  3 expected SCHEMA_REF_FAIL, 0 content failures

target fixes:

- update governance matrix observed extension version to 0.5.2;
- reconcile enum/status values in readiness-report, retrospective, source-tree,
  sprint-status and planning/prd;
- document extension-side schema ref failures for TEA artifacts without
  mutating valid content only to satisfy broken refs;
- decide whether vision.json and testing/test-strategy.json remain extension
  no-schema artifacts or need repo-local schema coverage.

validator:

- python scripts/validators/agile_canvas_task_ops_validator.py
- python scripts/validators/agile_canvas_identity_drift_validator.py
- python scripts/validators/agile_canvas_extension_schema_validator.py
- local JSON/schema audit
- git diff --check

stop_condition: agile_canvas_schema_drift_resolved_or_extension_schema_defect_documented

### Carril 4 - Agents SDK local harness

owner_agent: court.openai_dispatcher
write_scope:

- apps/agile-canvas-problems-agent/**
- evals/agile-canvas-problems-agent/**
- .agents/codex/readbacks/**

lock_key: agents_sdk.local.harness
runtime: local_only_no_api_call until GATE_OPENAI_LIVE

deliverables:

- Python Agents SDK app skeleton or local mock-compatible harness;
- deterministic tools wrapping local validators;
- sample fixture with current schema audit rows;
- local eval cases for classification and gate behavior;
- smoke command that does not require OPENAI_API_KEY for mock mode.

validators:

- python -m compileall
- local eval harness
- no secret scan over generated files
- local_validate_openai_upstream_adoption.ps1 if applicable

stop_condition: agents_sdk_live_requested_without_order

### Carril 5 - PR and checks

owner_agent: rey.repo_cartographer
dependency: Carriles 1, 3 and 4 pass
write_scope: explicit changed files only
branch: codex/agile-canvas-problems-agent-sdk-plan-20260608
commands:

- git switch -c codex/agile-canvas-problems-agent-sdk-plan-20260608
- git add -- explicit paths only
- git commit -m "Plan Agile Canvas Problems Agents SDK lane"
- git push origin codex/agile-canvas-problems-agent-sdk-plan-20260608
- gh pr create --base main --head codex/agile-canvas-problems-agent-sdk-plan-20260608

validator:

- git diff --check
- GitHub Actions checks

stop_condition: READY_FOR_MERGE_HUMAN_GATE

## Validacion minima de cierre

- git status -sb
- git diff --check
- python scripts/validators/agile_canvas_task_ops_validator.py
- python scripts/validators/agile_canvas_identity_drift_validator.py
- python scripts/validators/agile_canvas_extension_schema_validator.py
- .agents/codex/tools/local_validate_parallel_order_governance.ps1
- .agents/codex/tools/local_validate_capability_use_hardening.ps1
- .agents/codex/tools/local_run_change_aware_full_coverage_orchestrator.ps1 -NoWrite

## Gates

- GATE_OPENAI_LIVE: required before real OpenAI API or Agents SDK model call.
- GATE_SECRET_USE: required before using real OPENAI_API_KEY or other secret.
- GATE_COST_BOUNDARY: required before any paid API usage.
- GATE_MERGE_MAIN: required before merge to main.
- GATE_MICROSOFT_LIVE_WRITE: required before Microsoft live write.
- GATE_POWER_PLATFORM_APPLY: required before Power Platform apply.
- GATE_PRODUCTION_DEPLOY: required before production.

## Rollback

```powershell
git rm .agents/codex/readbacks/2026-06-08_agile_canvas_problems_agents_sdk_plan.md
```

If later carriles modify canvas artifacts:

```powershell
git restore -- .agileagentcanvas-context scripts/validators .agents/codex/matrices/VSCODE_INSIDERS_AGILE_AGENT_CANVAS_GOVERNANCE_20260606.csv
```

## Fuentes tecnicas consultadas

- https://developers.openai.com/api/docs/guides/agents
- https://developers.openai.com/api/docs/guides/agents/sandboxes
- https://developers.openai.com/api/docs/guides/agent-evals

## Stop condition

Plan preparado y versionable. No se ejecuta OpenAI API live, Agents SDK live,
Microsoft live, produccion ni merge sin gate humano separado.
