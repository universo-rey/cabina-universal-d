# READBACK_CODEX_AUX_WORKTREES_CLEANUP_20260602

## Estado

HECHO_VERIFICADO:

- La cabina raiz `D:\` estaba limpia antes de registrar este readback.
- Se revisaron los worktrees auxiliares de Codex en `C:\Users\enzo1\.codex\worktrees`.
- Se removio el worktree auxiliar `75c6` con `git worktree remove` normal, sin `--force`.
- `75c6` era fisicamente identico a `5083` en archivos versionables revisados; `5083` queda como keeper y rollback.
- `0985` y `44af` no se removieron porque no son identicos fisicamente.

## Sistemas tocados

- Git worktree metadata del repo raiz `universo-rey/cabina-universal-d`.
- Carpeta auxiliar local `C:\Users\enzo1\.codex\worktrees\75c6`.

## Sistemas no tocados

- No se tocaron repos anidados.
- No se tocaron remotos GitHub.
- No se tocaron Microsoft live, SharePoint, Teams, Outlook, Entra, Planner, Power Platform ni Dataverse.
- No se tocaron OpenAI API live, produccion, permisos, secretos ni tenant writes.

## Cambios

- `C:\Users\enzo1\.codex\worktrees\75c6` quedo eliminado.
- `D:\.git\worktrees\75c6` quedo eliminado.
- Worktrees restantes:
  - `D:\` en branch `codex/codex-cloud-env-assignment-20260602`.
  - `C:\Users\enzo1\.codex\worktrees\0985`, detached en `ad8d756`.
  - `C:\Users\enzo1\.codex\worktrees\44af`, detached en `ad8d756`.
  - `C:\Users\enzo1\.codex\worktrees\5083`, detached en `c397623`.

## Validacion

- `git worktree list --porcelain` ya no lista `75c6`.
- `Test-Path C:\Users\enzo1\.codex\worktrees\75c6` devuelve `False`.
- `Test-Path D:\.git\worktrees\75c6` devuelve `False`.
- `Test-Path C:\Users\enzo1\.codex\worktrees\5083` devuelve `True`.
- `git status --short --branch` en `D:\` permanecio limpio antes de agregar este readback.

## Riesgos

- `0985` y `44af` quedan como carril pendiente porque difieren en archivos de entorno Codex local y no deben borrarse como duplicados puros.
- `5083` queda como carril pendiente amplio porque conserva diferencias reales contra `D:\`.

## Rollback

- Para recuperar el estado retirado de `75c6`, usar `5083` como keeper fisicamente identico.
- Si se requiere reabrir el worktree retirado, recrearlo de forma gobernada desde commit `c397623ce5ce5d560c7ca55a437541e423fde7c9` y comparar contra `5083` antes de cualquier uso.

## Proximos carriles

- `worktree_reconcile_small_pair`: comparar `0985` contra `44af` y decidir si las variantes viejas de `.codex` tienen valor o quedan descartadas.
- `worktree_recover_broad_keeper`: revisar `5083` contra `D:\` para rescatar solo artefactos no integrados, si existen.
- `worktree_prune_after_recovery`: retirar worktrees auxiliares restantes solo despues de clasificar diferencias y conservar rollback.

## Cierre operativo

- agente: `codex.workspace_guardian`
- orden: `cleanup_codex_aux_worktrees`
- superficie: `local_git_worktrees`
- skill: `tcu-descubridor-capacidades; repo-agent-tool-governance; governed-readback-closeout`
- receta: `recipe.repo_agent_tool_governance; recipe.governed_readback_closeout`
- tool: `git worktree list; git worktree remove; Test-Path; Get-FileHash`
- estado: `PARTIAL_CLEANUP_VERIFIED`
- evidencia: `75c6_removed; 5083_keeper_exists; root_status_clean_before_readback`
- validador: `git_worktree_postcheck; git_diff_check; local_validate_operational_chain`
- riesgo: `remaining_aux_worktrees_have_real_differences`
- rollback: `use_5083_keeper_or_recreate_detached_worktree_from_c397623`
- stop_condition: `dirty_or_nonidentical_worktree_requires_reconciliation`
