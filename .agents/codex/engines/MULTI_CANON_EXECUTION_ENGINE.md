# Multi-Canon Execution Engine

Estado: `MULTI_CANON_EXECUTION_ENGINE_ACTIVE_REPO_LOCAL_20260614`

## Proposito

Este motor convierte una orden multi-repo en una secuencia de waves gobernadas,
idempotentes y escalables. No modela a Codex como un agente lineal: lo modela
como una maquina coordinada de agentes especializados con contratos explicitos.

## Principio operativo

Cada wave ejecuta:

```text
ANALIZAR -> PRONAR -> PROMOVER -> CONFIRMAR -> EXPANDIR
```

El motor no reabre canon ya aplicado, no crea PRs duplicados, no mergea sin
gate y no ejecuta live writes por inferencia.

## Algoritmo base

```text
INPUT: canon_config, repo_list, wave_plan, validators, gates, governed_information_sources

FOR each wave IN wave_plan:
  initialize wave_state
  FOR each repo_delta IN repo_list:
    assign repo_delta to agent_chain
    FOR each agent IN agent_chain:
      agent reads only required inputs
      IF agent requires external evidence:
        request read-only information from allowed connector_or_agent
        attach evidence to handoff
      agent emits structured result
      result is validated
      IF result.status == BLOCKED:
        mark repo_delta BLOCKED
        record blocker
        break current repo_delta
      IF result.status == NO_OP:
        record convergence evidence
        continue next agent
      IF result.status == PASS:
        pass artifact to next agent
    END
    aggregate repo_delta result
  END
  compute wave_summary
  decide next_wave eligibility
END

OUTPUT: promotion_report, pr_map, blockers, next_gates, reusable_artifacts, evidence_map
```

## Contrato de agente

Cada agente debe emitir:

- `agent_id`
- `input_contract`
- `allowed_reads`
- `blocked_writes`
- `output_contract`
- `evidence`
- `validator`
- `risk`
- `rollback`
- `status`
- `handoff_to`

Ningun agente invade el rol de otro. Los agentes pueden pedir informacion
read-only a conectores o tools, pero cualquier write live requiere orden atomica
separada.

## Superficies gobernadas

Lectura/evidencia permitida cuando esta alineada al carril:

- repos locales
- GitHub PR/checks/reviews
- SharePoint metadata/list/library reads gobernadas
- Dataverse metadata/queue/readback reads gobernadas
- Power Platform inventory/no-op reads gobernadas
- Graph/Admin inventory reads gobernadas
- Planner/SGIN selected reads gobernadas
- Agent365/Copilot/MCP inventory/handshake reads gobernadas
- validadores, logs y checks disponibles

Writes live no autorizados sin orden atomica:

- SharePoint list/library/site/permission writes
- Dataverse table/row/schema/app writes
- Power Platform flow/app/environment/connection writes
- Graph/Admin settings/users/groups/policy writes
- Planner/SGIN writes
- Agent365/Copilot/MCP persistent writes
- production, deploys, migrations, permissions, secrets

Regla corta: Write live por inferencia no.

## Idempotencia

Cada wave debe poder reintentarse sin duplicar PRs ni reabrir reconciliacion.
El estado se decide por artefactos observables: rama, commit, PR URL, checks,
review threads, validators y readbacks.

## Wave 2 modelada

La Wave 2 estabiliza reviews/checks ya promovidos:

- PR #78 Torre: checks PASS, sin threads activos, `REVIEW_REQUIRED`.
- PR #157 Cabina: checks PASS, `CLEAN`.
- PR #13 Microsoft lab: thread resuelto, un check Node podia quedar pendiente.
- PR #24 Modo: checks PASS, `CLEAN`.
- Organizacion: commit aislable, sin push automatico por pendientes ajenos.

Fuente estructurada: `.agents/codex/matrices/MULTI_CANON_WAVE2_STABILIZATION_MATRIX_20260614.csv`.

## Stop conditions

- `live_write_without_atomic_order`
- `review_required_without_human_gate`
- `checks_pending_or_failed`
- `active_review_thread`
- `dirty_unclassified_worktree`
- `pr_duplicate_or_missing_remote`
- `secret_or_permission_surface_requested`
- `agent_chain_missing_contract`
