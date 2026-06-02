# Readback - Validator performance improvements

Fecha: 2026-06-02

## Orden

Leer los analisis adjuntos y aplicar mejoras reales en la cabina sin reducir
fronteras, cobertura ni trazabilidad.

## Analisis leidos

- `C:/Users/enzo1/.codex/attachments/887b439f-6249-4fcb-9c6b-52ec4c8b3ee7/pasted-text.txt`
- `C:/Users/enzo1/.codex/attachments/6d223293-4ca3-4d2a-b948-591a75b59dc0/pasted-text.txt`

## Mejoras implementadas

- `local_validate_agent_layer.ps1` ahora cachea `Import-Csv` por path resuelto
  dentro del mismo proceso.
- `local_validate_agent_layer.ps1` agrega `-SkipWorkflowNestedValidators` para
  CI. En ese modo omite solo los validadores que el workflow ya corre como
  pasos propios: operational chain, parallel order governance y order packets.
  Mantiene agent levels y workpapers dentro del validador paraguas.
- `.github/workflows/cabina-validation.yml` usa ese flag solo en el paso
  `Agent layer`.
- El escaneo de secretos de `local_validate_agent_layer.ps1` lee cada archivo
  una vez y evalua los patrones por linea, preservando `path`, `line` y
  `pattern`.
- `local_run_repo_alignment_runtime.ps1` cachea CSV/JSON por path resuelto.
- `local_validate_operational_chain.ps1` cachea CSV por path resuelto.
- `local_validate_capability_use_hardening.ps1` cachea CSV por path resuelto.

## Pendiente por alcance

- Runner change-aware por archivos modificados.
- Hash sets para membership checks en todos los validadores anchos.
- Un runner agregado que comparta snapshot entre validadores.
- Medicion comparativa de duracion CI antes/despues una vez que el PR corra.

## Cadena operativa

- agente: `court.thot_schema`
- orden: `validator_performance_improvements_20260602`
- superficie: `universo-rey/cabina-universal-d`, `.agents/codex/tools`,
  `.github/workflows`
- skill: `tcu-descubridor-capacidades`,
  `superpowers:receiving-code-review`,
  `superpowers:verification-before-completion`
- receta: `recipe.schema_tool_contract`,
  `recipe.github_pr_lifecycle_governed`
- tool: `tool.local_validate_agent_layer`, `tool.repo_alignment_runtime`,
  `tool.local_validate_operational_chain`,
  `tool.local_validate_capability_use_hardening`
- estado: `implemented_validated`
- evidencia:
  `D:/.agents/codex/matrices/VALIDATOR_PERFORMANCE_IMPROVEMENT_MATRIX_20260602.csv`,
  `D:/.agents/codex/tools/local_validate_agent_layer.ps1`,
  `D:/.github/workflows/cabina-validation.yml`
- validador:
  `D:/.agents/codex/tools/local_validate_agent_layer.ps1`,
  `D:/.agents/codex/tools/local_validate_agent_layer.ps1 -SkipWorkflowNestedValidators`,
  `D:/.agents/codex/tools/local_run_repo_alignment_runtime.ps1 -NoWrite`,
  `D:/.agents/codex/tools/local_validate_operational_chain.ps1`,
  `D:/.agents/codex/tools/local_validate_capability_use_hardening.ps1`,
  `git diff --check`
- riesgo: reducir cobertura si el flag CI se usa fuera de workflow; mitigado
  por nombre explicito y uso solo en workflow.
- rollback: quitar `-SkipWorkflowNestedValidators` del workflow y revertir los
  cambios de cache/scan en los scripts.
- stop_condition: `github_order_missing_checks`, `secret_detected`,
  `runtime_alignment_failed`, `capability_use_preflight_missing`

## Proximos carriles paralelos

- CI routing: disenar runner change-aware sin perder validators obligatorios.
- Validator core: convertir listas de ids a hash sets en scripts anchos.
- Metrics: comparar tiempos de workflow despues del PR actualizado.
