# SDU Canon Delta Reconciliation - 2026-06-13

## Estado

DELTA_RECONCILIADO_EN_BORRADOR:

Este documento reconcilia el delta entre la sesion anterior de activacion SDU-CN
y la sesion actual de mesa en Corte Ejecutora. La reconciliacion es repo-local y
no autoriza live execution.

## Sesion anterior

- readback base: `.agents/codex/readbacks/2026-06-13_sdu_agents_activation_sync_readback.md`
- estado base: `SDU_AGENTS_NEXT_TASK_ACTIVE_NO_MORE_SMOKE`
- modo base: `CORTE_EJECUTORA_GOVERNED`
- frente base: `seshat-normativa`
- gate base: `anubis-gate`
- limite base: `PENDING_TARGET_ONLY`

## Sesion actual

- acta base: `.agents/codex/readbacks/2026-06-13_acta_mesa_corte_ejecutora_sdu_cn_borrador.md`
- estado actual: `BORRADOR_PREPARADO_NO_APROBADO`
- modo actual: `CORTE_EJECUTORA_GOVERNED`
- mesa actual: seis agentes canonicos SDU-CN en Corte Ejecutora
- presidente operativo: `rey.control_plane_orchestrator`
- frente documental: `seshat-normativa`
- gate: `anubis-gate`

## Delta reconciliado

1. La activacion se mantiene, pero ya no queda solo como estado de agentes
   activos: ahora se expresa como mesa formada en Corte Ejecutora.
2. `seshat-normativa` deja de ser solo frente inicial y pasa a ser el punto de
   entrada documental de la mesa.
3. `anubis-gate` conserva el mismo umbral, sin aflojar el requisito de target
   exacto, owner, rollback, postcheck, evidencia y validador.
4. `narrador-normativo` sigue fuera del inicio: no redacta cierre hasta que
   exista evidencia aprobada.
5. El stop condition no cambia: sigue en `PENDING_TARGET_ONLY`.

## No cambió

- no cambió la lista canonica de seis agentes
- no cambió la prohibicion de crear un septimo agente
- no cambió la frontera contra OpenAI live, Microsoft live, Dataverse,
  Power Platform, produccion, permisos o secretos
- no cambió la decision de no correr mas smoke

## Implicacion operativa

La mesa puede empezar a trabajar en evidencia y estructura del siguiente caso
sin reabrir la activacion. El primer paso practico queda en:

1. `seshat-normativa` abre evidencia.
2. `thot-tecnico` estructura campos.
3. `anubis-gate` valida umbral.

## Evidencia

- `MANIFEST.yaml`
- `02_AUTHORITY_CANON/CURRENT_STATE.md`
- `.agents/codex/readbacks/2026-06-13_sdu_agents_activation_sync_readback.md`
- `.agents/codex/readbacks/2026-06-13_acta_mesa_corte_ejecutora_sdu_cn_borrador.md`

## Validacion

- pendiente de `python scripts/validators/sdu_cn_canonical_agent_pantheon_validator.py`
- pendiente de `python scripts/validators/cabina_startup_contract_validator.py`
- pendiente de `.agents/codex/tools/local_validate_operational_chain.ps1`
- pendiente de `git diff --check`

## Riesgos

- riesgo: confundir delta de canon con nueva autorizacion live
- riesgo: narrar el cierre antes de abrir evidencia
- riesgo: perder el hilo entre sesion anterior y sesion actual

## Rollback

Eliminar este borrador o reemplazarlo si la mesa decide un delta distinto.

## Proximos carriles

1. Seshat prepara el primer paquete de evidencia.
2. Thot prepara la estructura minima del acta final.
3. Anubis confirma el gate exacto para la siguiente decision.

## Output Contract

- agente: `court.seshat_evidence`
- orden: `reconciliar el delta del canon entre la sesion anterior y la actual`
- superficie: `03_CORTE_EJECUTORA` repo-local
- skill: `governed-readback-closeout`
- receta: `recipe.governed_readback_closeout`
- tool: `tool.readback_builder`
- estado: `DELTA_RECONCILIADO_EN_BORRADOR`
- evidencia: sesion anterior y actual enlazadas arriba
- validador: pendiente
- riesgo: live confundido con reconciliacion documental
- rollback: borrar o reemplazar este borrador
- stop_condition: `PENDING_TARGET_ONLY`
- proximos_carriles: Seshat evidencia; Thot schema; Anubis gate
