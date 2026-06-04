# SDU-CN Multi Universe Operating Model 2026-06-04

## Estado

`SDU_CN_MULTI_UNIVERSE_OPERATING_MODEL_ACTIVE`

## Universos

```yaml
universos:
  ESCRIBANIA:
    tower_agent: universe.escribania_tower
    superficies:
      - TGE
      - SharePoint/SYS
      - Teams
      - Dataverse
      - Power Automate
      - cumplimiento
      - evidencia

  MODO_ON:
    tower_agent: universe.modo_on_tower
    superficies:
      - CDF
      - proveedores
      - Power Platform
      - operaciones
      - activos digitales
      - transformacion digital
```

## Regla Operativa

Los seis agentes SDU-CN operan en ambos universos. Cada accion requiere:

- orden humana;
- target;
- owner;
- alcance;
- rollback;
- postcheck;
- evidencia;
- stop condition.

## Cadena De Mando

```text
Orden humana
-> rey.control_plane_orchestrator
-> agentes_sdu_cn_canonicos segun dominio
-> court.openai_dispatcher si se requiere OpenAI/Codex/Agents SDK
-> sdu-triage-agent como runtime operativo
-> anubis-gate / court.sdu_gate para frontera
-> seshat-normativa / court.seshat_evidence para evidencia
-> narrador-normativo para cierre documental aprobado
```

## Fronteras

- Este modelo no ejecuta Microsoft live.
- Este modelo no ejecuta OpenAI API live, Responses API live ni Agents SDK
  live.
- Este modelo no ejecuta produccion ni permisos.
- Este modelo no autoriza secretos en repo, logs, matrices o readbacks.

## Stop Condition

`universe_boundary_missing`, `chain_of_command_missing`,
`microsoft_live_without_target`, `production_target_missing`,
`secret_detected`.
