# MATRIZ_SKILLS_EXISTENCIA

Fuente base: `_operativa/sys_modoon_piloto/SKILLS_EXISTENCE_AUDIT_20260517_082014/MATRIZ_VERIFICACION_EXISTENCIA_SKILLS.md`.

No se copiaron cuerpos de skills. La existencia se valida por ruta, `SKILL.md`, indice o equivalencia.

## Resumen

| categoria | total | criterio |
|---|---:|---|
| registros normalizados | 78 | aparecen en fuentes SYS/TCU/SDU/control plane |
| con `SKILL.md` directo o equivalente | 76 | ruta fisica detectada en `.agents`, `.codex` o plugin cache |
| referencias sin implementacion | 2 | indice o matriz sin `SKILL.md` fisico propio |
| plugin cache fisico | 17 | existe `SKILL.md`, pero no autoriza conector |
| wrappers SDU | 10 | `skill.*` mapeado a skill fisica o referencia |
| duplicados funcionales marcados | 2 | no eliminados |
| posible colision de nombre | 1 | requiere normalizacion |

## Existencia fisica directa

| status | handles |
|---|---|
| EXISTE_CON_SKILL_MD | rey-modo-verificacion-previa-cierre; rey-modo-continuidad-sesion; tcu-modo-e-system-normalizer; rey-modo-salida-breve; skill-judge; github; gh-address-comments; gh-fix-ci; yeet; mcp-builder; agentation; rey-modo-codex-routing; rey-modo-docset-scenario-mapper; rey-modo-evidence-risk-handoff; rey-modo-flow-workqueue-auditor; rey-modo-frontier-continuity-planner; rey-modo-gobierno-capacidades; rey-modo-reino-technical-translator; rey-modo-repo-code-recovery; rey-modo-report-pack-generator; rey-modo-sharepoint-safety-auditor; rey-modo-taxonomy-contenttype-auditor; rey-modo-vscode-insiders-auditor; tcu-cabina-state-normalizer; tcu-openai-api-non-sensitive-gate; tcu-sys-readback-handoff-normalizer; doc; pdf; chunk; fix-finding; openai-platform-api-key; outlook-calendar; outlook-calendar-free-up-time; outlook-email; sharepoint; sharepoint-spreadsheet-formula-builder; slack-outgoing-message; teams-planner-task-management |
| EXISTE_COMO_ALIAS | tcu-normalizador-estado-cabinas; rey-modo-gobernador-capacidades; rey-modo-recuperador-codigo-repos; rey-modo-auditor-vscode-insiders; rey-modo-evidencia-riesgo-handoff; rey-modo-auditor-sharepoint-seguro; tcu-readback-handoff-sys; tcu-publicador-documental-sys; tcu-despacho-agentes-paralelos; rey-modo-mapa-documental-escenarios; tcu-harness-evals-agentes; tcu-gate-api-no-sensible; circleci-cli; circleci-config; tcu-builder-paquetes-factory; tcu-descubridor-capacidades; tcu-redactor-planes-operativos; tcu-desarrollo-con-subagentes; tcu-planificador-con-archivos; rey-modo-generador-paquetes-informe |
| EQUIVALENTE_A_EXISTENTE | tcu-normalizador-sistema-modo-on; rey-modo-traductor-reino-tecnico; rey-modo-auditor-taxonomia-contenttypes; rey-modo-auditor-flujos-cola; rey-modo-handoff-continuidad; rey-modo-carril-codex-cloud-api |
| EXISTE_COMO_WRAPPER | skill.sharepoint.inventory; skill.sharepoint.contenttypes; skill.powerautomate.inspect; skill.github.repo-hygiene; skill.evidence.package; skill.taxonomy.reconcile; skill.workspace.vscode; skill.rey-torre-translator; skill.frontier-continuity |
| DUPLICADO_FUNCIONAL | sdu-gate-executor; sdu-live-sharepoint-audit |
| POSIBLE_COLISION | rey-modo-auditor-taxonomy-contenttype |
| REFERENCIADA_NO_IMPLEMENTADA | skill.ready-for-agent-tcu |
| NO_DETECTADA | skill.sdu.validate |

## Criterio de uso

- `EXISTE_CON_SKILL_MD`, `EXISTE_COMO_ALIAS`, `EQUIVALENTE_A_EXISTENTE`, `EXISTE_COMO_WRAPPER` pueden versionarse como metadata.
- Ninguna entrada se vuelve instalable desde este paquete.
- Las entradas con runtime, conector, tenant, API o Git remoto quedan bloqueadas aunque tengan `SKILL.md` fisico.
