# Cabina Operating System Constitution

estado: `CABINA_OPERATING_SYSTEM_RECONCILED_TO_PR132`
fecha: `2026-06-08`
base: `origin/main de7f873395c2c67dec2738987e99e02b5553c150`
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
| Estado canonico | `02_AUTHORITY_CANON/CURRENT_STATE.md` | reconciliado a #132 |
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

## Modelo de Salud

La Cabina sabe que esta sana cuando sus senales rectoras cierran de forma
coherente, no cuando existe un documento que lo afirma.

Senales minimas de salud:

- `AGENTS.md`, `MANIFEST.yaml` y `CURRENT_STATE.md` declaran el mismo estado
  vigente o registran explicitamente una supersesion.
- La jerarquia de instrucciones valida en
  `.agents/codex/tools/local_validate_agents_instruction_hierarchy.ps1`.
- La cadena agente/skill/recipe/tool/superficie/evidencia/validador/stop
  condition valida en
  `.agents/codex/tools/local_validate_operational_chain.ps1`.
- El uso endurecido de capacidades valida en
  `.agents/codex/tools/local_validate_capability_use_hardening.ps1`.
- La capa de agentes, skills, tools, matrices y manifiestos valida en
  `.agents/codex/tools/local_validate_agent_layer.ps1`.
- El gate remoto productivo de GitHub Actions cierra en PASS para el PR activo.
- La suite agregada local cierra en PASS o clasifica fallos externos como
  `EXTERNAL_BLOCKER` con repos, archivos y siguiente carril.
- No hay referencias operativas no justificadas a superficies legacy como
  `D:\`.
- No hay secretos persistidos, produccion tocada, live write sin gate, cambios
  de remotos, `core.worktree`, force push ni absorcion de repos anidados.

Estados de salud permitidos para cierre:

| Estado | Uso |
| --- | --- |
| `HEALTHY_LOCAL` | Validadores locales relevantes PASS y sin bloqueos externos. |
| `HEALTHY_REMOTE` | PR/checks remotos PASS, base y HEAD trazables. |
| `HEALTHY_WITH_EXTERNAL_BLOCKERS` | El repo actual valida, pero la suite global detecta repos hermanos dirty o dependencia externa clasificada. |
| `UNHEALTHY_LOCAL_ACTIONABLE` | Falla local corregible dentro del scope actual. |
| `BLOCKED_SECURITY` | Se detecta secreto, produccion, permisos, tenant, live write o dato regulado sin gate. |

Owners del modelo de salud:

- `rey.frontier_guardian`: fronteras, gates y stop conditions.
- `rey.authority_canonist`: coherencia entre autoridad, manifest y estado.
- `court.thot_schema`: validators, schemas y matrices.
- `court.seshat_evidence`: evidencia, readbacks y trazabilidad.
- `rey.repo_cartographer`: topologia, repos hermanos, worktrees y drift.

La salud se observa mediante validadores y checks existentes. Esta constitucion
no reemplaza esos validadores: los conecta como contrato operativo.

## Modelo de Evolucion

La Cabina cambia sin romperse cuando toda evolucion sigue este circuito:

1. Sincronizar `main` y crear una rama `codex/*` nueva para el carril.
2. Descubrir equivalentes por nombre, alias, funcion, universo, superficie,
   skill, recipe, validator y stop condition.
3. Reconciliar o extender antes de crear.
4. Declarar archivos candidatos y confirmar allowlist antes de escribir.
5. Hacer cambios atomicos, sin mezclar politica Git, workflows, secretos,
   produccion, permisos o live gates con mejoras de agentes salvo gate
   especifico.
6. Stagear rutas explicitas, nunca `git add .`.
7. Ejecutar validadores relevantes y `git diff --check`.
8. Abrir o actualizar PR contra `main` dentro del scope autorizado.
9. Exigir checks PASS, base trazable y HEAD fijo para cualquier merge.
10. Registrar readback con rollback y proximo carril.

Si aparece una mejora necesaria fuera de scope, no se aplica en el carril
actual. Se registra como proximo carril con archivo, motivo, riesgo, orden
requerida, rollback, postcheck, validador y stop condition.

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

`CABINA_OPERATING_SYSTEM_RECONCILED_TO_PR132`

La Cabina queda mas conectada y mantenible sin crear una arquitectura paralela.
