# READBACK_SDU_CN_CANONICAL_AGENTS_MULTI_REPO_MULTI_UNIVERSE_20260604

## Estado

`SDU_CN_CANONICAL_AGENTS_MULTI_REPO_MULTI_UNIVERSE_READY_FOR_REVIEW`

## Correccion Conceptual

Los agentes SDU-CN quedan canonizados como identidades suprarrepo,
multiuniverso y bajo orden humana. No son herramientas, no son adaptadores TGE
y no pertenecen a un solo repo. OpenAI, Codex, Agents SDK, MCP, GitHub y
Microsoft live son medios de ejecucion o lectura, no fuente de autoridad.

## Agentes Canonicos

- `seshat-normativa`: documentary_governance_evidence_metadata.
- `thot-tecnico`: content_types_metadata_taxonomy_tools_events.
- `anubis-gate`: gates_stop_conditions_rollback_postcheck.
- `maat-cumplimiento`: coherence_proportionality_raci_compliance_recommendation.
- `horus-riesgo`: risk_alerts_contradictions_nucleo_umbral_watch.
- `narrador-normativo`: documentary_narrative_after_approved_evidence.

## Dos Universos

- `ESCRIBANIA`: TGE, cumplimiento, evidencia, Teams, SharePoint, Dataverse y
  procesos juridico-documentales bajo gate.
- `MODO_ON`: CDF, proveedores, Power Platform, operaciones, activos digitales y
  transformacion digital bajo gate.

## Cinco Repos

- `universo-rey/cabina-universal-d`
- `SeshatSgin/torre-gemela-escribania`
- `SeshatSgin/seshat-bootstrap-sdu-cn`
- `SeshatSgin/cdf-soluciones`
- `SeshatSgin/tge-agentic-runtime-control-escribania`

## Mapeo Operacional

La matriz `02_AUTHORITY_CANON/SDU_CN_CANONICAL_TO_OPERATIONAL_AGENT_MAPPING_20260604.csv`
declara el mapeo desde cada agente canonico a agentes operativos Cabina,
runtime, gate, evidencia, GitHub, Microsoft, Codex Cloud y Agents SDK.

## Archivos Creados

- `02_AUTHORITY_CANON/SDU_CN_CANONICAL_AGENT_DISCOVERY_20260604.md`
- `02_AUTHORITY_CANON/SDU_CN_CANONICAL_AGENT_PANTHEON_20260604.md`
- `02_AUTHORITY_CANON/SDU_CN_MULTI_UNIVERSE_OPERATING_MODEL_20260604.md`
- `02_AUTHORITY_CANON/SDU_CN_CANONICAL_AGENT_UNIVERSE_REPO_MATRIX_20260604.csv`
- `02_AUTHORITY_CANON/SDU_CN_CANONICAL_TO_OPERATIONAL_AGENT_MAPPING_20260604.csv`
- `02_AUTHORITY_CANON/REPO_NATIVE_CONTRACT_TEMPLATE_20260604.md`
- `02_AUTHORITY_CANON/FOCUS_5_REPOS_CONTRACT_INVENTORY_20260604.md`
- `02_AUTHORITY_CANON/FOCUS_5_REPOS_CANONICAL_AGENT_ASSIGNMENT_MATRIX_20260604.csv`
- `02_AUTHORITY_CANON/FOCUS_5_REPOS_CHAIN_OF_COMMAND_MATRIX_20260604.csv`
- `scripts/validators/sdu_cn_canonical_agent_pantheon_validator.py`
- `scripts/validators/focus_5_repo_contracts_validator.py`
- `scripts/validators/cabina_startup_contract_validator.py`

## Sistemas Tocados

- Repo raiz `universo-rey/cabina-universal-d` en rama
  `codex/sdu-cn-canonical-agents-multirepo-multiuniverse-20260604`.
- Canon local bajo `02_AUTHORITY_CANON`.
- Validadores locales bajo `scripts/validators`.
- Readback local versionable.

## Sistemas No Tocados

- Microsoft live.
- OpenAI API live, Responses API live y Agents SDK live.
- Produccion.
- Permisos, visibilidad, secrets y tenant writes.
- Repos anidados y sus `.git`.

## Validadores

- `python scripts/validators/sdu_cn_canonical_agent_pantheon_validator.py`
- `python scripts/validators/focus_5_repo_contracts_validator.py`
- `python scripts/validators/cabina_startup_contract_validator.py`
- validadores de capa agente disponibles
- `git diff --check`
- secret scan material
- Change-Aware Full-Coverage Orchestrator si existe

## Riesgos

- Riesgo principal: confundir agente canonico con agente operativo o runtime.
- Mitigacion: separacion explicita en panteon, matriz universo/repo y mapeo
  canonico-operativo.

## Rollback

Revertir el commit/PR del carril y retirar enlaces rectores a los archivos
canonicos nuevos. Los issues GitHub pueden restaurarse desde historial si se
detecta error conceptual.

## Proximos Gates

- Revisar PR del carril #88.
- Si se aprueba, merge con precheck y HEAD fijo.
- Despues del merge, decidir si se espejan ajustes repo-native en cada repo
  foco mediante sus propias ramas y PRs.

## Stop Condition

`secret_detected`, `seventh_agent_created`, `canonical_agent_missing`,
`canonical_agent_treated_as_tool`, `canonical_agent_treated_as_tge_adapter`,
`universe_boundary_missing`, `repo_native_contract_missing`,
`chain_of_command_missing`, `openai_treated_as_authority_source`,
`microsoft_live_without_target`.
