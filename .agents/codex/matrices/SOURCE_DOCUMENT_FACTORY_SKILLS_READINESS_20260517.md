# MATRIZ_SKILLS_GITHUB_READINESS

El paquete esta listo para versionar metadata, no cuerpos instalables. `SI_METADATA` significa que puede entrar a un PR como registro/indice. No significa que la skill pueda instalarse o ejecutarse.

| grupo | total | lista_para_github | bloqueo | motivo | archivos requeridos | archivos faltantes | riesgo | proximo gate |
|---|---:|---|---|---|---|---|---|---|
| skills fisicas directas o equivalentes | 76 | SI_METADATA | no instalables aun | no se copiaron cuerpos ni se crearon carpetas por skill | SKILLS_INDEX.yaml, SKILLS_INDEX.md, matrices, politicas | skills/<handle>/SKILL.md y metadata.yaml por cada skill | variable | GATE_SKILLS_SYS_MODEON_ALIAS_CANONICALIZATION_NO_RUNTIME |
| referencias sin implementacion | 2 | SI_REGISTRO_BLOQUEADO | no usar como skill | no hay SKILL.md fisico propio | registro de bloqueo | SKILL.md, metadata.yaml, owner decision | MEDIO | GATE_SKILL_PHYSICALIZATION_DECISION |
| skills con runtime/API/cloud | 8 | SI_METADATA | BLOQUEADA | implican API, evals, MCP, Codex Cloud o SDU runtime | metadata y politica | approval runtime | ALTO/CRITICO | gate runtime especifico |
| skills con conectores/tenant | 16 | SI_METADATA | BLOQUEADA | SharePoint, Outlook, Teams, Slack, CircleCI o tenant live | metadata y politica | approval conector/tenant | ALTO | GATE_CONNECTOR_APPROVAL o GATE_LIVE_M365_APPROVAL |
| GitHub plugin skills | 5 | SI_METADATA | BLOQUEADA | Git remoto y push bloqueados | metadata y plan PR | autorizacion remoto | ALTO | GATE_GIT_REMOTE_PUBLICATION_REVIEW |
| aliases/equivalentes/wrappers | 31 | SI_METADATA | requiere normalizacion | varios nombres apuntan a misma capability | matriz equivalencias | canonical alias map final | MEDIO/ALTO | GATE_SKILLS_SYS_MODEON_ALIAS_CANONICALIZATION_NO_RUNTIME |
| paquete documental | 1 | SI | no push | raiz no es repo Git y remoto no detectado | README, indices, templates, policies, matrices, evidence | root .gitignore del futuro repo destino | MEDIO | GATE_GIT_REMOTE_PUBLICATION_REVIEW |

## Commit plan preparado

- Branch sugerida: `docs/skills-github-readiness-20260517`
- Commit sugerido: `docs(skills): prepare skills package for github readiness`
- No ejecutar automaticamente.

## PR plan preparado

- Title: `Prepare Codex skills package for GitHub readiness`
- Body debe incluir objetivo, alcance, fuentes leidas, archivos creados, validacion, riesgos, acciones bloqueadas, proximos gates y confirmacion de no runtime/no secrets/no push.

## Exclusion readiness

Se agrego `skills/.gitignore` para el paquete. Como la raiz actual no es repo Git y no existe `.gitignore` raiz, el futuro repo remoto debe confirmar exclusiones antes del primer push.
