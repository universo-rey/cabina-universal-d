# READBACK_SDU_AGENTS_GOVERNED_PROFILE_20260610

agente: Codex
orden: preparar cierre gobernado del perfil `sdu-agents` y del PR 153
superficie: repo local + GitHub PR
skill: governed-readback-closeout
receta: NO_APLICA
tool: gh pr view | gh pr checks | local validators
estado: HECHO_VERIFICADO

## Estado
HECHO_VERIFICADO: el perfil `sdu-agents` quedó alineado con `repo_scoped_governed`, la validacion local pasó y el PR 153 quedó listo para revisión con checks verdes.

## Sistemas tocados

- `.codex/cloud/sdu-agents/profile.yml`
- `.codex/cloud/sdu-agents/README.md`
- `.codex/cloud/sdu-agents/setup.sh`
- `scripts/validators/sdu_codex_cloud_assignment_validator.py`
- PR [#153](https://github.com/universo-rey/cabina-universal-d/pull/153)

## Sistemas no tocados

- Microsoft live surfaces
- OpenAI API live
- Production
- SharePoint, Teams, Planner, Graph
- Dataverse live writes
- GitHub merge a `main`

## Cambios

- El perfil paso de `repo_scoped_review_first` a `repo_scoped_governed`.
- La guia humana y el setup quedaron alineados con el mismo vocabulario gobernado.
- El validador ahora exige el modo gobernado y rechaza tokens legacy de review-first.
- El PR 153 quedo publicado y marcado como ready for review.

## Validacion

- `python scripts/validators/sdu_codex_cloud_assignment_validator.py`: PASS
- `.agents\codex\tools\local_validate_operational_chain.ps1`: PASS
- `.agents\codex\tools\local_validate_agent_layer.ps1`: PASS
- `gh pr view 153`: `state=OPEN`, `isDraft=false`, `mergeStateStatus=CLEAN`
- `gh pr checks 153`: PASS en todos los checks visibles

## Riesgos

- Riesgo bajo.
- No se toco ninguna superficie live, production o de permisos.
- El unico paso pendiente es el merge si se ordena explicitamente.

## Rollback

- `git revert 81ba903`
- Si hiciera falta retirar la publicacion remota, `git push origin :codex/tenant-controlled-dataverse-segments-20260608`

## Proximos carriles

1. Merge del PR 153 solo con orden explicita.
2. Si queres, actualizar el readback de PR con el cierre final despues del merge.
3. Mantener el perfil gobernado como default hasta nuevo cambio de politica.
