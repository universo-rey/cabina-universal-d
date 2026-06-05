# SDU_REPO_REVIEW_QUEUE

## Estado

`SDU_REPO_REVIEW_QUEUE_READY`

## Criterio de entrada

Un repo entra a esta cola cuando necesita revisar su contrato operativo,
validadores, workflows o runtime contra el canon endurecido
`ACTIVE_GOVERNED_EXECUTION_BY_DEFAULT`.

La revision es repo-scoped, sin live externo y sin absorcion de repos anidados.

## Criterio de prioridad

- `P0`: foco inmediato o riesgo alto por canon, runtime, TGE, CDF o cabina raiz.
- `P1`: repos con impacto transversal o regulado que requieren lectura pronta.
- `P2`: repos de soporte o referencia que deben alinearse despues del foco.

## Cola ordenada

| Prioridad | Repo | Motivo | Proximo gate |
| --- | --- | --- | --- |
| `P0` | `universo-rey/cabina-universal-d` | baseline post merge y patron replicable | `GATE_CABINA_UNIVERSAL_D_POST_MERGE_BASELINE_AND_REPO_REVIEW_QUEUE` |
| `P0` | `SeshatSgin/torre-gemela-escribania` | alinear TGE con hardening activo y contratos repo-native | `GATE_TGE_ACTIVE_HARDENING_REVIEW` |
| `P0` | `SeshatSgin/seshat-bootstrap-sdu-cn` | verificar canon SDU-CN y validators del bootstrap | `GATE_SESHAT_BOOTSTRAP_ACTIVE_HARDENING_REVIEW` |
| `P0` | `SeshatSgin/cdf-soluciones` | revisar contrato CDF y frontera Dataverse Power Platform sin live | `GATE_CDF_ACTIVE_HARDENING_REVIEW` |
| `P0` | `SeshatSgin/tge-agentic-runtime-control-escribania` | revisar runtime agentico TGE y Agents SDK local preflight | `GATE_TGE_AGENTIC_RUNTIME_ACTIVE_HARDENING_REVIEW` |
| `P1` | `SeshatSgin/tcu-agentic-runtime-control` | revisar runtime agentico general contra canon activo | `GATE_TCU_AGENTIC_RUNTIME_ACTIVE_HARDENING_REVIEW` |
| `P1` | `universo-rey/organizacion` | revisar organizacion como referencia multirepo sin absorber repos | `GATE_ORGANIZACION_ACTIVE_HARDENING_REVIEW` |
| `P1` | `SeshatSgin/sgin-cumplimiento` | revisar cumplimiento documental y frontera datos regulados | `GATE_SGIN_CUMPLIMIENTO_ACTIVE_HARDENING_REVIEW` |
| `P2` | `SeshatSgin/jara-consultores` | revisar frente MODO_ON proveedor y contratos operativos | `GATE_JARA_ACTIVE_HARDENING_REVIEW` |
| `P2` | `universo-rey/microsoft-agents-governed-lab` | revisar laboratorio Microsoft gobernado sin escritura tenant | `GATE_MICROSOFT_AGENTS_LAB_ACTIVE_HARDENING_REVIEW` |
| `P2` | `SeshatSgin/modo-on-foundation` | revisar foundation MODO_ON y consistencia canon | `GATE_MODO_ON_FOUNDATION_ACTIVE_HARDENING_REVIEW` |
| `P2` | `SeshatSgin/sdu-canon` | revisar canon SDU como referencia documental sin live | `GATE_SDU_CANON_ACTIVE_HARDENING_REVIEW` |

## Lecturas obligatorias por repo

Antes de abrir cambios en cualquier repo de la cola:

1. Leer `AGENTS.md` o instruccion equivalente del repo.
2. Leer validators existentes.
3. Leer workflows existentes.
4. Revisar PRs abiertos y checks.
5. Confirmar que el cambio requerido es repo-scoped.

## Proximo repo recomendado

`SeshatSgin/torre-gemela-escribania`

Motivo: es foco inmediato, universo `ESCRIBANIA`, alto impacto documental y
contratos repo-native ya relacionados con la secuencia `#91/#92`.

## Stop conditions

- `secret_detected`
- `scope_mixed`
- `checks_not_green`
- `live_without_gate`
- `nested_repo_write`
- `tenant_ambiguous`
- `admin_bypass_requested`
- `branch_deletion_without_explicit_authorization`
