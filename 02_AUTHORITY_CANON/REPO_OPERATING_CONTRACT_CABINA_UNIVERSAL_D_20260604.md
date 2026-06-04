# REPO OPERATING CONTRACT - CABINA UNIVERSAL D - 2026-06-04

status: REPO_NATIVE_OPERATING_CONTRACT_READY_FOR_REVIEW

```yaml
repo: universo-rey/cabina-universal-d
universe: BOTH
role: control_plane_root
issue_contract: https://github.com/universo-rey/cabina-universal-d/issues/88
master_issue: https://github.com/universo-rey/cabina-universal-d/issues/87

human_authority:
  operator: Enzo ON
  order_required: true
  rule: agents_assist_human_authority

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
  microsoft_operator: NO_APLICA salvo target exacto
  codex_cloud_operator: court.openai_dispatcher
  agents_sdk_operator: court.openai_dispatcher

scopes:
  read_scope: repo raiz, issues, PRs, matrices, canon
  write_scope: repo-scoped bajo PR
  live_scope: GATED_BY_TASK
  production_scope: HUMAN_GATE_ONLY

capabilities:
  github: enabled
  codex_cloud: enabled_gated
  agents_sdk: enabled_gated
  mcp: enabled_gated
  microsoft_live: enabled_gated_when_target_exact
  teams: enabled_gated_when_target_exact
  sharepoint: enabled_gated_when_target_exact
  power_platform: enabled_gated_when_target_exact

role_rules:
  - Cabina mantiene matriz central y fan-in
  - cada repo conserva contrato rama PR y validadores propios
  - no absorber repos anidados
  - no crear septimo agente
  - OpenAI Codex Agents SDK MCP y Microsoft son medios de ejecucion no fuente de autoridad
  - Microsoft live no se ejecuta en este PR
  - OpenAI live no se ejecuta en este PR
  - Responses API live no se ejecuta en este PR
  - Agents SDK live no se ejecuta en este PR
  - produccion no se ejecuta en este PR

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

This contract is repo-scoped and reviewable by pull request. It does not execute
Microsoft live, OpenAI live, Responses API live, Agents SDK live, production,
permission changes, tenant writes, propagation, or secret handling.

## Evidence

- Root canon merge: `a669f2ba1761490dbf0f6c7f166cabaaa5c11bb2`.
- Contract issue: https://github.com/universo-rey/cabina-universal-d/issues/88.
- Master fan-in: https://github.com/universo-rey/cabina-universal-d/issues/87.
