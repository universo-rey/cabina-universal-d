# REPO OPERATING CONTRACT - CABINA UNIVERSAL D - 2026-06-04

status: REPO_NATIVE_OPERATING_CONTRACT_ACTIVE

```yaml
repo: universo-rey/cabina-universal-d
universe: BOTH
role: control_plane_root
issue_contract: https://github.com/universo-rey/cabina-universal-d/issues/88
master_issue: https://github.com/universo-rey/cabina-universal-d/issues/87

human_authority:
  operator: Enzo ON
  current_request_is_present_authority: true
  new_order_required: false_when_current_request_covers_exact_scope
  rule: consume_present_authority_without_future_gate

sdu_cn_canonical_agents:
  seshat-normativa: aplica
  thot-tecnico: aplica
  anubis-gate: aplica
  maat-cumplimiento: aplica
  horus-riesgo: aplica
  narrador-normativo: aplica

canonical_agent_domains:
  seshat-normativa: documentary_governance_evidence_metadata
  thot-tecnico: content_types_metadata_taxonomy_tools_events
  anubis-gate: gates_stop_conditions_rollback_postcheck
  maat-cumplimiento: coherence_proportionality_raci_compliance_recommendation
  horus-riesgo: risk_alerts_contradictions_nucleo_umbral_watch
  narrador-normativo: documentary_narrative_after_approved_evidence

chain_of_command:
  agente_rector: rey.control_plane_orchestrator
  agente_delegado: rey.authority_canonist
  agente_runtime: sdu-triage-agent
  gate: anubis-gate
  evidencia: seshat-normativa
  cierre_narrativo: narrador-normativo

operational_agents:
  owner_agent: rey.repo_cartographer
  reviewer_agent: court.seshat_evidence
  github_operator: rey.repo_cartographer
  microsoft_operator: resolved_by_exact_live_binding
  codex_cloud_operator: court.openai_dispatcher
  agents_sdk_operator: court.openai_dispatcher

scopes:
  read_scope: repo raiz, issues, PRs, matrices, canon
  write_scope: repo-scoped bajo PR
  live_scope: ACTIVE_BY_EXACT_INTENT_AND_BINDING
  production_scope: HUMAN_DECISION_WHEN_NOT_ALREADY_COVERED

capabilities:
  github: enabled
  codex_cloud: active_when_repo_and_task_exact
  agents_sdk: active_when_runtime_task_exact
  mcp: active_when_binding_exact
  microsoft_live: active_when_target_identity_environment_and_operation_exact
  teams: active_when_target_identity_environment_and_operation_exact
  sharepoint: active_when_target_identity_environment_and_operation_exact
  power_platform: active_when_target_identity_environment_and_operation_exact

role_rules:
  - Cabina mantiene matriz central y fan-in
  - cada repo conserva contrato rama PR y validadores propios
  - no absorber repos anidados
  - no crear septimo agente
  - OpenAI Codex Agents SDK MCP y Microsoft son medios de ejecucion no fuente de autoridad
  - este contrato no produce por si mismo efectos de negocio
  - los ejecutores consumen live cuando la orden presente y el binding exacto lo cubren
  - una brecha localizada detiene solo el objeto afectado
  - auditoria ampliada se activa solo ante contradiccion o riesgo material

rollback:
  method: revertir commit o PR repo-scoped

postcheck:
  method: contrato presente, validador PASS, PR abierto, fan-in a #87

validators:
  local: scripts/validators/repo_native_operating_contracts_validator.py
  canon: scripts/validators/sdu_cn_canonical_agent_pantheon_validator.py
  focus: scripts/validators/focus_5_repo_contracts_validator.py

stop_conditions:
  - secret_detected
  - production_without_human_gate
  - tenant_boundary_unclear
  - chain_of_command_missing
  - canonical_agent_missing
  - seventh_agent_created
  - openai_treated_as_authority_source
  - microsoft_live_without_target
  - multi_repo_commit_mixed_scope
```

## Boundary

This contract is repo-scoped and active. It routes GitHub and registered live
surfaces through the exact current intent and binding. The contract itself does
not create a business side effect; it also does not impose a future generic
gate on an executor that already has exact authority, target, identity,
environment, operation and postcheck.

## Evidence

- Root canon merge: `a669f2ba1761490dbf0f6c7f166cabaaa5c11bb2`.
- Contract issue: https://github.com/universo-rey/cabina-universal-d/issues/88.
- Master fan-in: https://github.com/universo-rey/cabina-universal-d/issues/87.
