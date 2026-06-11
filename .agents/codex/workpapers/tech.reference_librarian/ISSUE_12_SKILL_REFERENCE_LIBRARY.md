# Issue 12 - Skill Reference Library

Estado: `VALIDATED_LOCAL_DRAFT`

## Orden

Materializar el carril `issue-12-skill-reference-library` para definir una
biblioteca de referencias de skills y documentacion API sin convertir fuentes
externas en canon rector.

## Superficie

- Repo: `universo-rey/cabina-universal-d`
- Workspace: `D:\`
- Issue: `https://github.com/universo-rey/cabina-universal-d/issues/12`
- Rama propuesta: `codex/skill-reference-library-issue-12`
- Lock: `lock.issue.12.skill_reference_library`

## Cadena Operativa

- agente: `tech.reference_librarian`
- lead_agent: `rey.control_plane_orchestrator`
- reviewer_agent: `rey.authority_canonist`
- skill: `tcu-descubridor-capacidades|mcp-builder|openai-docs|superpowers:writing-skills`
- receta: `recipe.workspace_reference_audit|recipe.parallel_agent_operation`
- tool: `tool.reference_classifier|tool.plugin_registry_check|tool.local_validate_agent_layer`
- validador: `D:\.agents\codex\tools\local_validate_skill_reference_sources.ps1`
- stop_condition: `source_uncertain|source_reference_treated_as_canon`

## Artefactos

- `D:\.agents\codex\skills\SKILL_REFERENCE_LIBRARY_POLICY.md`
- `D:\.agents\codex\matrices\SKILL_REFERENCE_SOURCE_MATRIX.csv`
- `D:\.agents\codex\tools\local_validate_skill_reference_sources.ps1`
- `C:\Users\enzo1\.codex\workpapers\tech.reference_librarian\ISSUE_12_SKILL_REFERENCE_LIBRARY.md`

## Decisiones

- Las fuentes externas quedan como `technical_reference`.
- Las API docs vivas requieren refresco antes de cambios ejecutables.
- Las instalaciones globales de Codex o caches de plugins son runtime local y
  no sustituyen la raiz durable `D:\.agents\skills`.
- No se copian docs amplios ni contenido con licencia incierta.

## Validacion

- `D:\.agents\codex\tools\local_validate_skill_reference_sources.ps1`: PASS.
- Filas de fuente validadas: 5.
- Errores: 0.
- Warnings: 0.
- Validadores transversales de cabina: PASS.

Validadores transversales ejecutados:

- `local_validate_github_automation_preflight.ps1 -CheckLocalSdk`: PASS,
  `smoke=OK_NO_API_CALL`.
- `local_validate_operational_chain.ps1`: PASS.
- `local_validate_agents_instruction_hierarchy.ps1`: PASS.
- `local_validate_skill_metadata.ps1`: PASS.
- `local_validate_document_skill_lane.ps1`: PASS.
- `local_run_repo_alignment_runtime.ps1 -NoWrite`: PASS,
  `result_written=false`.
- `local_validate_agent_layer.ps1`: PASS.
- `local_validate_parallel_order_governance.ps1`: PASS.
- `local_validate_parallel_issue_queue.ps1`: PASS.
- `local_validate_order_packets.ps1`: PASS.

## Riesgos

- `source_uncertain`: fuente, licencia o frescura no confirmada.
- `source_reference_treated_as_canon`: una referencia tecnica intenta desplazar
  `D:\AGENTS.md` o authority canon.

## Proximo Carril

El registro en indices compartidos y workflow corresponde al carril serial
`wave-20260601-shared-index-integration`.
