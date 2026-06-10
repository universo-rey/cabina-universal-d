# READBACK_SDU_AGENTS_GOVERNED_PROFILE_POST_MERGE_20260610

agente: Codex
orden: preparar cierre gobernado post-merge del PR 153
superficie: repo local + GitHub PR merged
skill: governed-readback-closeout
receta: NO_APLICA
tool: gh pr view | gh pr checks
estado: HECHO_VERIFICADO

## Estado
HECHO_VERIFICADO: el PR 153 fue mergeado en `main` y quedó confirmado con merge commit `640c045487840cb514c92cfd4e64403a514f5800`.

## Sistemas tocados

- `.codex/cloud/sdu-agents/profile.yml`
- `.codex/cloud/sdu-agents/README.md`
- `.codex/cloud/sdu-agents/setup.sh`
- `scripts/validators/sdu_codex_cloud_assignment_validator.py`
- `.agents/codex/readbacks/2026-06-10_sdu_agents_governed_profile_closeout.md`
- PR [#153](https://github.com/universo-rey/cabina-universal-d/pull/153)

## Sistemas no tocados

- Microsoft live surfaces
- OpenAI API live
- Production
- SharePoint, Teams, Planner, Graph
- Dataverse live writes
- Branch protection, remotes o metadata Git crítica

## Cambios

- El perfil `sdu-agents` quedó alineado con `repo_scoped_governed`.
- La guía humana y el setup del pack quedaron alineados con el modo gobernado.
- El validador pasó a exigir el modo gobernado y rechazar tokens legacy de review-first.
- El PR 153 pasó de draft a ready for review, luego a mergeado en `main`.

## Validacion

- `python scripts/validators/sdu_codex_cloud_assignment_validator.py`: PASS
- `.agents\codex\tools\local_validate_operational_chain.ps1`: PASS
- `.agents\codex\tools\local_validate_agent_layer.ps1`: PASS
- `gh pr view 153`: `state=MERGED`, `mergeStateStatus=CLEAN` antes del cierre final del hilo
- `gh pr checks 153`: checks verdes antes del merge

## Riesgos

- Riesgo bajo.
- No se tocaron superficies live, production ni permisos.
- El merge ya quedó confirmado y no requiere más acción técnica para este cierre.

## Rollback

- `git revert -m 1 640c045487840cb514c92cfd4e64403a514f5800`

## Proximos carriles

1. Si queres, retirar la rama remota `codex/tenant-controlled-dataverse-segments-20260608`.
2. Si queres, dejar un resumen corto de cierre para el hilo.
3. Mantener el perfil gobernado como default hasta nuevo cambio de politica.
