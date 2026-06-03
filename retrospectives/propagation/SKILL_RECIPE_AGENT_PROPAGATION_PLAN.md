# Skill Recipe Agent Propagation Plan

## Estado
SKILL_RECIPE_AGENT_PROPAGATION_PLAN_READY

## Canon Fuente
- Repo fuente: universo-rey/cabina-universal-d
- PR fuente: https://github.com/universo-rey/cabina-universal-d/pull/69
- Merge commit fuente: a3b58d2e90ac373444b54dabc4e1324731481dd0
- Canon operativo: CABINA_FULL_LIVE_GOVERNED_GLOBAL_CANON
- Estado raiz: CABINA_EXTENDED_RECONCILIATION_CANONIZED

## Principio
La propagacion es repo por repo, con rama `codex/*`, PR propio, validadores del
repo destino, revision humana y sin ejecucion live automatica. Este plan no
propaga archivos a otros repos.

## Skills a Propagar
- `agent-retrospective-learning`: propagar como skill de cierre y aprendizaje
  cuando el repo tenga ciclos operativos cerrados con evidencia.
- `dataverse-metadata-only-provisioning`: propagar solo a repos que gobiernan
  Dataverse DEV metadata-only o manifiestos equivalentes.
- `dataverse-workqueue-backreference-mapping`: propagar solo donde existan Work
  Queues, back-reference columns y regla de target exacto.
- `no-inference-runtime-write-guard`: propagar como guard comun para bloquear
  writes basados en inferencia, match parcial o historico no probado.

## Recipes a Propagar
- `recipe.one-flow-one-item-runtime-test`: para pruebas DEV controladas con un
  flow exacto y un item exacto.
- `recipe.retrospective-to-skill-propagation`: para convertir aprendizaje
  cerrado en skills, recipes, agentes, matrices y readbacks.
- `recipe.backreference-target-mapping-before-write`: para decidir target exacto
  antes de cualquier write final.
- `recipe.mapping-record-before-target-write`: para registrar mapping
  metadata-only antes de escribir en el target final.

## Agentes que Reciben Actualizacion
- `rey.control_plane_orchestrator`: coordina carriles y fan-in.
- `rey.frontier_guardian`: bloquea live, target dudoso, secreto, PROD, TEST,
  Default y writes sin rollback/postcheck.
- `court.sdu_gate`: valida exactitud de gate, item, flow, target y cobertura.
- `court.seshat_evidence`: exige evidencia, readback y matriz de aprendizaje.
- `court.thot_schema`: traduce aprendizaje a schemas, matrices y validators.

## Que Queda Solo en Cabina
- La autoridad canonica `CABINA_FULL_LIVE_GOVERNED_GLOBAL_CANON`.
- Indices globales de cabina y matrices transversales.
- Evidence readbacks de PR68/PR69.
- Historial de merges y checks de `universo-rey/cabina-universal-d`.

## Adaptacion por Contexto
- Cada repo destino debe mapear sus rutas locales, validadores, agentes,
  recipes y stop conditions propias.
- Repos sin Dataverse o Work Queues deben usar las skills Dataverse como
  referencia, no como artefacto activo.
- Repos Microsoft/Power Platform requieren target exacto, owner, rollback,
  postcheck y evidencia antes de cualquier write.
- Repos SGIN deben preservar su canon propio y no absorber la cabina.

## Gate Humano Requerido
Antes de propagar a cualquier repo destino:
- confirmar repo y rama base;
- confirmar owner/reviewer;
- confirmar archivos exactos a crear o modificar;
- confirmar validadores locales del repo destino;
- confirmar que no hay secretos ni datos regulados;
- confirmar que no se ejecutara live externo;
- abrir PR separado y esperar checks;
- no mergear sin orden posterior.

## Validadores Requeridos
- `git diff --check`
- validador local del repo destino
- validador de skills/recipes si existe
- secret scan material del diff
- validacion de no PROD, no TEST, no Default y no live externo
- para cabina: `local_validate_skill_recipe_agent_learning.ps1`,
  governance validation suite y Change-Aware Full-Coverage Orchestrator

## Riesgos
- Contexto destino incompleto o rutas distintas.
- Skills Dataverse no aplicables en repos sin Dataverse.
- Back-reference mapping podria confundirse con autorizacion de write final; el
  plan lo bloquea expresamente.
- Microsoft/Power Platform/production siguen gated aunque el canon global los
  reconozca.

## No Propagar Todavia
- Ningun write live.
- Ninguna clave, `.env`, token o secreto.
- Ningun flow activo.
- Ningun item nuevo procesado.
- Ningun target final sin candidato exacto unico.
- Ningun cambio a PROD, TEST o Default.
- Ninguna rama remota borrada.
- Ninguna propagacion multi-repo automatica.

## Cierre de Este Carril
Este carril queda cerrado cuando el plan y sus matrices se versionan en un PR
contra `main`. Ese PR no debe mergearse sin orden posterior explicita.
