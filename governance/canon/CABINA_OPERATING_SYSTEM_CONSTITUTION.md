# Cabina Operating System Constitution

estado: `CABINA_OPERATING_SYSTEM_CONSOLIDATED_TO_PR96`
fecha: `2026-06-05`
base: `origin/main e9e7af7f7e403697878039db27a6e72e0104fa24`
repo: `universo-rey/cabina-universal-d`

## Proposito

Esta constitucion no disena una Cabina nueva. Describe y conecta el sistema
operativo que ya existe en el repositorio.

La Cabina opera como control plane gobernado para:

- GitHub como canon tecnico versionable.
- ChatGPT como intencion rectora.
- Codex como ejecutor gobernado.
- Agentes, skills, recipes, tools, matrices, readbacks, validators y gates como
  capacidades versionables.
- OpenAI, Codex Cloud, Microsoft 365, SharePoint, Teams, Planner, Dataverse y
  Power Platform como superficies gobernadas, no como autoridad autonoma.

## Autoridad

La jerarquia vigente esta declarada en:

- `AGENTS.md`
- `MANIFEST.yaml`
- `02_AUTHORITY_CANON/CURRENT_STATE.md`
- `02_AUTHORITY_CANON/GITHUB_BASE_WORK_POLICY.md`
- `governance/canon/ACTIVE_GOVERNED_EXECUTION_BY_DEFAULT_POLICY_20260603.md`

Regla: la autoridad humana y el canon repo-scoped prevalecen sobre runtime,
plugins, conectores, SDKs, outputs de modelo y readbacks historicos.

## Sistema Existente

El sistema operativo de la Cabina ya existe distribuido en estas capas:

| Capa | Artefactos rectores | Estado |
| --- | --- | --- |
| Instrucciones | `AGENTS.md`, `.agents/codex/maps/AGENTS_INSTRUCTION_HIERARCHY.md` | activo |
| Manifest | `MANIFEST.yaml` | activo |
| Estado canonico | `02_AUTHORITY_CANON/CURRENT_STATE.md` | consolidado a #96 |
| Registro | `01_GOVERNANCE_REGISTRY/GITHUB_BASE_WORK_MATRIX.csv` | activo |
| Agentes | `.agents/codex/agents.json`, `.agents/codex/AGENTS_INDEX.csv` | activo |
| Skills | `.agents/skills/*/SKILL.md`, `.agents/codex/skills/*` | activo |
| Recipes | `.agents/codex/recipes/RECIPE_INDEX.csv` | activo |
| Tools | `.agents/codex/tools/TOOL_INDEX.csv` | activo |
| Matrices | `.agents/codex/matrices/MATRIX_INDEX.csv` | activo |
| Evidencia | `.agents/codex/matrices/EVIDENCE_READBACK_REGISTRY_20260603.csv` | activo |
| Observabilidad | `governance/observability/*.schema.json` | activo |
| Validadores | `.agents/codex/tools/*.ps1`, `scripts/validators/*.py` | activo |
| GitHub Actions | `.github/workflows/cabina-validation.yml` | activo |

## Modelo Operativo

La cadena operativa vigente es:

```text
rey.control_plane_orchestrator
-> court.openai_dispatcher
-> sdu-triage-agent
-> court.sdu_gate
-> court.seshat_evidence
```

Toda ejecucion debe declarar agente, skill, recipe, tool, superficie,
evidencia, validador y stop condition. La matriz rectora es
`.agents/codex/matrices/OPERATIONAL_CHAIN_GOVERNANCE_MATRIX.csv`.

## Fronteras

Superficies habilitadas gobernadas:

- GitHub repo-scoped: branch `codex/*`, stage explicito, commit, push, PR,
  checks y merge solo con precheck aprobado.
- Codex Cloud: smoke o tarea repo-scoped sin apply salvo orden gobernada.
- OpenAI API, Responses API y Agents SDK: gobernados, con secreto/costo/datos
  sensibles solo bajo gate.
- Microsoft 365, SharePoint, Teams, Planner, Graph, Dataverse, Power Platform,
  produccion y propagacion: `ENABLED_GOVERNED_GATED_NOT_EXECUTED` hasta target,
  owner, identidad, rollback, postcheck, evidencia y orden concreta.

Superficies no autorizadas por esta constitucion:

- Produccion sin gate.
- Secretos reales.
- Permisos/admin/consentimientos.
- Cambios de remotos, `core.worktree`, force push o borrado de ramas.
- Absorber repos anidados.

## Evidencia y Readbacks

La evidencia debe ser saneada, acotada y versionable. El modelo de evidencia
esta en:

- `governance/observability/SDU_AGENT_RUNTIME_EVIDENCE_MODEL_20260603.md`
- `governance/observability/readback-evidence.schema.json`
- `.agents/codex/matrices/EVIDENCE_AND_VALIDATION_MATRIX.csv`
- `.agents/codex/matrices/EVIDENCE_READBACK_REGISTRY_20260603.csv`

Un readback no prueba live write si no declara target, gate, owner, rollback,
postcheck y evidencia. Los readbacks historicos son evidencia, no autoridad
superior al estado vigente.

## Reconciliacion

La matriz de reconciliacion de este carril es:

`.agents/codex/matrices/CABINA_OPERATING_SYSTEM_RECONCILIATION_20260605.csv`

Esa matriz conecta componentes del sistema operativo con artefactos reales,
clasifica cobertura y registra brechas verificadas.

## Brechas Reales

Brechas verificadas en este carril:

- `CURRENT_STATE.md`, `MANIFEST.yaml`, `AGENTS.md` y `README.md` conservaban
  referencias a #78 como ultimo estado, aunque `origin/main` ya estaba en #96.
- No existia un unico documento corto que conectara las piezas COS ya
  existentes sin redisenarlas.
- La nueva matriz de reconciliacion y el readback del carril no estaban
  registrados en indices/allowlist antes de este cambio.

Brechas no declaradas:

- No se declara falta de agentes, skills, recipes, tools, validators o
  observabilidad en bloque, porque existen artefactos reales para esas capas.
- No se declara necesidad de live, produccion ni Microsoft write.

## Criterio de Mantenimiento

Antes de crear una capacidad nueva:

1. Buscar equivalente exacto, alias, funcion, universo, superficie, skill,
   recipe, validator y stop condition.
2. Si existe, mejorar o extender.
3. Si hay solapamiento, registrar reconciliacion.
4. Crear solo si no hay equivalente funcional verificable.

## Estado

`CABINA_OPERATING_SYSTEM_CONSOLIDATED_TO_PR96`

La Cabina queda mas conectada y mantenible sin crear una arquitectura paralela.
