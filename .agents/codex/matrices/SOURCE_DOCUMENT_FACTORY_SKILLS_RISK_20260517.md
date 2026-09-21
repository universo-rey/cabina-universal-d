# MATRIZ_SKILLS_RIESGO

Riesgo evaluado para versionado documental y uso futuro. Una skill puede ser lista para metadata y estar bloqueada para ejecucion.

| risk_level | handles | bloqueo dominante | decision |
|---|---|---|---|
| CRITICO | openai-platform-api-key | secretos/API keys | no usar sin `GATE_OPENAI_API_SECRET_REVIEW` |
| ALTO | github; gh-address-comments; gh-fix-ci; yeet; skill.github.repo-hygiene | Git remoto | metadata only; push y remoto bloqueados |
| ALTO | mcp-builder | MCP/runtime | metadata only; no ejecutar MCP |
| ALTO | tcu-harness-evals-agentes; tcu-gate-api-no-sensible; tcu-openai-api-non-sensitive-gate | OpenAI API/evals/runtime | metadata only; API bloqueada |
| ALTO | rey-modo-codex-routing; rey-modo-carril-codex-cloud-api | Codex Cloud | metadata only; cloud bloqueado |
| ALTO | rey-modo-auditor-sharepoint-seguro; rey-modo-sharepoint-safety-auditor; sdu-live-sharepoint-audit; sharepoint; sharepoint-spreadsheet-formula-builder; skill.sharepoint.inventory; skill.sharepoint.contenttypes; skill.taxonomy.reconcile | SharePoint/tenant live | metadata only; conector y tenant bloqueados |
| ALTO | rey-modo-auditor-taxonomia-contenttypes; rey-modo-taxonomy-contenttype-auditor; rey-modo-auditor-taxonomy-contenttype | taxonomia/content types live | requiere normalizacion y gate SharePoint |
| ALTO | rey-modo-auditor-flujos-cola; rey-modo-flow-workqueue-auditor; skill.powerautomate.inspect | Power Platform | metadata only; runtime bloqueado |
| ALTO | sdu-gate-executor | SDU gate/runtime | no ejecutar desde paquete |
| ALTO | chunk; circleci-cli; circleci-config; outlook-calendar; outlook-calendar-free-up-time; outlook-email; slack-outgoing-message; teams-planner-task-management | conectores externos | cache fisico no autoriza uso live |
| MEDIO | tcu-normalizador-estado-cabinas; rey-modo-gobernador-capacidades; rey-modo-recuperador-codigo-repos; tcu-modo-e-system-normalizer; tcu-normalizador-sistema-modo-on; tcu-publicador-documental-sys; tcu-despacho-agentes-paralelos; agentation; rey-modo-repo-code-recovery; rey-modo-report-pack-generator; tcu-cabina-state-normalizer; doc; pdf; fix-finding; skill.sdu.validate; skill.ready-for-agent-tcu; tcu-builder-paquetes-factory; tcu-desarrollo-con-subagentes; rey-modo-generador-paquetes-informe | filesystem, subagentes, paquete o evidencia incompleta | metadata only y gate por accion |
| BAJO | rey-modo-auditor-vscode-insiders; rey-modo-verificacion-previa-cierre; rey-modo-continuidad-sesion; rey-modo-evidencia-riesgo-handoff; rey-modo-salida-breve; tcu-readback-handoff-sys; skill-judge; rey-modo-mapa-documental-escenarios; rey-modo-traductor-reino-tecnico; rey-modo-docset-scenario-mapper; rey-modo-evidence-risk-handoff; rey-modo-frontier-continuity-planner; rey-modo-gobierno-capacidades; rey-modo-reino-technical-translator; rey-modo-vscode-insiders-auditor; tcu-sys-readback-handoff-normalizer; skill.evidence.package; skill.workspace.vscode; skill.rey-torre-translator; skill.frontier-continuity; tcu-descubridor-capacidades; tcu-redactor-planes-operativos; tcu-planificador-con-archivos; rey-modo-handoff-continuidad | documental local | reutilizable como metadata |

## Stop conditions

- Secreto, token, credential, cookie, certificado o `.env`: detener.
- Runtime, API, SDK, MCP, Codex Cloud, SharePoint, Power Platform o conector: detener salvo gate explicito.
- Git remoto o push: detener salvo gate explicito.
- Skill sin evidencia fisica: no promover.
- Script no revisado dentro de skill: bloquear instalacion.
