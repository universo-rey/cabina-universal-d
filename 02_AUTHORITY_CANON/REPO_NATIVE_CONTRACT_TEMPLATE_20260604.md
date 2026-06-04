# Repo Native Contract Template 2026-06-04

## Estado

`REPO_NATIVE_CONTRACT_TEMPLATE_WITH_SDU_CN_CANONICAL_AGENTS_ACTIVE`

## Uso

Cada repo foco conserva su `.git`, remoto, rama, PR, validadores y reglas
internas. La cabina raiz solo referencia y coordina fan-in.

## Bloque Obligatorio

```yaml
agentes_sdu_cn_canonicos:
  seshat-normativa:
    dominio: documentary_governance_evidence_metadata
    aplica: true|false
  thot-tecnico:
    dominio: content_types_metadata_taxonomy_tools_events
    aplica: true|false
  anubis-gate:
    dominio: gates_stop_conditions_rollback_postcheck
    aplica: true|false
  maat-cumplimiento:
    dominio: coherence_proportionality_raci_compliance_recommendation
    aplica: true|false
  horus-riesgo:
    dominio: risk_alerts_contradictions_nucleo_umbral_watch
    aplica: true|false
  narrador-normativo:
    dominio: documentary_narrative_after_approved_evidence
    aplica: true|false

cadena_mando:
  orden_humana: required
  agentes_canonicos_sdu_cn: required
  agente_rector_operativo: rey.control_plane_orchestrator
  agente_delegado: <agent_id>
  agente_runtime: <sdu-triage-agent|NO_APLICA|NO_DISPONIBLE>
  gate: <anubis-gate|court.sdu_gate|rey.frontier_guardian>
  evidencia: <seshat-normativa|court.seshat_evidence>
  cierre_narrativo: <narrador-normativo|NO_APLICA>
```

## Campos De Gate

Todo contrato repo-native debe declarar:

- target;
- owner;
- identidad cuando aplique;
- alcance;
- acciones permitidas;
- acciones bloqueadas;
- rollback;
- postcheck;
- evidencia;
- validador;
- stop condition.

## Stop Condition

`repo_native_contract_missing`, `chain_of_command_missing`,
`canonical_agent_missing`, `rollback_missing`, `postcheck_missing`,
`secret_detected`.
