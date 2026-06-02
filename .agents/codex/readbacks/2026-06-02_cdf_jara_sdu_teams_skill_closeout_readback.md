# CDF Jara SDU Teams Skill Closeout Readback - 2026-06-02

## Estado

HECHO_VERIFICADO: se cerraron los carriles gobernados de CI Modo ON,
lectura SDU-CN SharePoint, inventario Teams efigueroa y deriva de skills. La
evidencia se registra saneada, sin secretos, sin contenido bruto de Teams y sin
documentos SharePoint versionados.

## Carril CDF

- Agente: `universe.modo_on_tower`.
- Orden: elevar checks remotos gobernados sin Microsoft live, OpenAI API live,
  produccion ni secretos.
- Superficie: GitHub Actions repo-scoped en `SeshatSgin/cdf-soluciones`.
- Skill: `cabina-github-actions-templates`.
- Receta: `recipe.repo_universe_alignment_runtime`.
- Tool: `gh workflow run`, `gh run watch`, `gh run view`.
- Estado: workflow remoto existente ejecutado en `main`.
- Evidencia: `CDF agent versioning CI`,
  `https://github.com/SeshatSgin/cdf-soluciones/actions/runs/26841865838`,
  head `4f1cddb312cb8730e423a8f52667d3e2e1eddf33`, conclusion `success`.
- Validador: GitHub Actions remoto.
- Riesgo: bajo, repo-scoped read/check only.
- Rollback: no hubo cambio local ni remoto persistente que revertir.
- Stop condition: `production_requested_without_explicit_authorization` si el
  CI intenta deploy, secretos o live Microsoft/OpenAI.

## Carril Jara

- Agente: `universe.modo_on_tower`.
- Orden: elevar checks remotos gobernados al mismo nivel que CDF.
- Superficie: GitHub repo `SeshatSgin/jara-consultores`.
- Skill: `cabina-github-actions-templates`, `cabina-commit-work`.
- Receta: `recipe.repo_universe_alignment_runtime`,
  `recipe.governed_readback_closeout`.
- Tool: `git`, `gh pr create`, `gh pr ready`, `gh pr merge`, GitHub Actions.
- Estado: PR `https://github.com/SeshatSgin/jara-consultores/pull/7`
  mergeado a `main`.
- Evidencia: commit `5179c7a3bc465b96353be80130eef99b05774243`, merge commit
  `96733d7c8fe117f69540f8a68f1afa710dc7a9ae`, post-merge run
  `https://github.com/SeshatSgin/jara-consultores/actions/runs/26842227150`,
  conclusion `success`.
- Validador: `validate_jara_remote_ci_checks.py`,
  `validate_jara_cdf_quality_checklist.py`,
  `validate_jara_cdf_feasibility_traceability.py`,
  `validate_synthetic_agent.py`, `agent.py`, `git diff --check`, GitHub
  Actions remoto.
- Riesgo: bajo, cambio de CI repo-scoped con permisos `contents: read`.
- Rollback: revertir merge commit o abrir PR inverso en `jara-consultores`.
- Stop condition: `merge_without_approved_precheck` si no hay checks verdes,
  HEAD fijo o merge state limpio.

## Carril SDU-CN SharePoint

- Agente: `court.sdu_gate`.
- Orden: ejecutar solo lectura completa gobernada con superficie e identidad
  exactas.
- Superficie: SharePoint
  `https://escribaniabitsch.sharepoint.com/sites/Soporte-Gobierno-Sistema-Declarativo-Torre-Control`.
- Identidad operativa: conector Microsoft SharePoint de la sesion gobernada.
- Skill: `sharepoint:sharepoint`.
- Receta: `recipe.sharepoint_complete_read_order`.
- Tool: SharePoint connector `_get_site`, `_list_site_drives`,
  `_list_folder_items`, `_search`.
- Estado: sitio resuelto y bibliotecas enumeradas; no se descargaron archivos.
- Evidencia: site id
  `escribaniabitsch.sharepoint.com,f70d5940-0e5e-41d5-be23-90a7df07baef,12e2cf5a-89ec-456b-92bc-e2ca1db16101`;
  17 document libraries detectadas.
- Validador: evidencia de conector live read-only; no hay validador local
  SharePoint especifico disponible en `D:\.agents\codex\tools`.
- Riesgo: medio por superficie Microsoft live; mitigado por lectura acotada y
  no versionar documentos.
- Rollback: no hay mutacion externa que revertir.
- Stop condition: `microsoft_live_requested_without_governed_order` para
  cualquier lectura ampliada sin superficie, identidad, limite de datos y
  postcheck.

## Carril Teams efigueroa

- Agente: `rey.frontier_guardian`.
- Orden: preparar o ejecutar inventario gobernado por equipos/canales/chats
  definidos para `efigueroa@registronotarial8tdf.com.ar`.
- Superficie: Microsoft Teams chat container inventory.
- Identidad operativa: conector Microsoft Teams de la sesion gobernada.
- Skill: `teams:teams`.
- Receta: `recipe.governed_order_preparation`.
- Tool: Teams connector `_list_chats`.
- Estado: inventario inicial de contenedores ejecutado; no se leyeron mensajes
  completos, no se enviaron mensajes y no se versionaron previews.
- Evidencia: 20 contenedores devueltos; tipos observados `oneOnOne` y
  `meeting`; tenant id observado en URLs
  `299ffa84-f0e1-45d9-bb4e-494b3dbbea81`.
- Validador:
  `D:\.agents\codex\tools\local_validate_teams_governance.ps1`: PASS;
  `D:\.agents\codex\tools\local_validate_teams_cross_repo_lane_audit.ps1`:
  PASS.
- Riesgo: medio por previews devueltos por el conector; mitigado por no
  copiar, no persistir y no ampliar lectura sin targets exactos.
- Rollback: no hay mutacion externa que revertir.
- Stop condition: `microsoft_live_requested_without_governed_order` si se pide
  leer mensajes, canales, planner o enviar respuestas sin destino exacto.

## Carril Skills

- Agente: `court.thot_schema`.
- Orden: revisar deriva y asegurar que todas las skills esten disponibles.
- Superficie: `D:\.agents\skills` y matrices de skill en `D:\.agents\codex`.
- Skill: `skill-creator`, `superpowers:writing-skills`,
  `matrix-recipe-skill-sync`.
- Receta: `recipe.matrix_recipe_skill_sync`.
- Tool: `local_validate_skill_metadata.ps1`, `local_validate_agent_layer.ps1`,
  `local_validate_operational_chain.ps1`.
- Estado: 5 skills promovidas a `D:\.agents\skills\<skill>\SKILL.md`.
- Evidencia: 49 skills declaradas, 49 disponibles; 10 repo-locales portables.
- Validador: metadata PASS, agent layer PASS, operational chain PASS, parallel
  order governance PASS, `git diff --check` PASS.
- Riesgo: bajo, repo-local y reversible.
- Rollback: revertir el commit del PR de `cabina-universal-d`.
- Stop condition: `skill_metadata_missing_or_ambiguous`.

## Proximos carriles

- Teams: elegir lista exacta de equipos, canales o chats antes de leer mensajes
  completos.
- SharePoint SDU-CN: si se quiere lectura profunda, declarar bibliotecas,
  limite de datos, tratamiento de datos regulados y postcheck.
- CI Modo ON: monitorear checks post-merge de CDF/Jara y abrir carriles por
  repo si aparece drift.
