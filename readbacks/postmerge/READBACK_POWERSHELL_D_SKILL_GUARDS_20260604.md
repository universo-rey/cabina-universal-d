# READBACK_POWERSHELL_D_SKILL_GUARDS_20260604

## Estado

HECHO_VERIFICADO: la cabina incorpora un carril repo-scoped para detectar
friccion recurrente de PowerShell y separar skills durables de `D:\.agents`
frente a skills externas, plugins o runtime.

## Sistemas tocados

- `D:\.agents\codex\matrices\POWERSHELL_RUNTIME_FRICTION_MATRIX.csv`
- `D:\.agents\codex\matrices\D_SKILL_AVAILABILITY_AND_ISSUE_PR_FRICTION_MATRIX.csv`
- `D:\.agents\codex\recipes\recipe.powershell_runtime_friction_guard.md`
- `D:\.agents\codex\recipes\recipe.d_skill_availability_issue_pr_friction_review.md`
- `D:\.agents\codex\tools\local_validate_powershell_runtime_friction.ps1`
- `D:\.agents\codex\tools\local_validate_d_skill_availability_and_issue_pr_friction.ps1`
- Indices de matrices, recetas, tools, governance y coverage.
- Evidencia JSON local bajo `D:\.agents\codex\evals\results`.

## Sistemas no tocados

- No se ejecuto Microsoft live, SharePoint, Teams, Graph, Power Platform,
  Dataverse, produccion, permisos ni cambios de identidad.
- No se ejecuto OpenAI API live, Responses API live ni Agents SDK live.
- No se ejecuto `codex cloud apply`.
- No se absorbieron repos anidados.

## Cambios

- Se agregan dos matrices de reglas para friccion PowerShell y disponibilidad
  de skills D-local.
- Se agregan dos recetas de cierre operativo.
- Se agregan dos validadores locales.
- Se indexan los nuevos artefactos en los registros existentes.
- Se escriben resultados locales actuales:
  - `powershell_runtime_friction_latest.json`: PASS, 0 bloqueos, 0 warnings.
  - `d_skill_availability_issue_pr_friction_latest.json`: PASS, 0 bloqueos de
    skills, 38 skills externas clasificadas, 19 hallazgos GitHub read-only como
    advertencias.

## Validacion

- `local_validate_powershell_runtime_friction.ps1 -WriteResult`: PASS.
- `local_validate_d_skill_availability_and_issue_pr_friction.ps1 -UseGitHub -WriteResult`: PASS.
- `local_validate_operational_chain.ps1`: PASS.
- `local_validate_capability_use_hardening.ps1`: PASS.
- `local_validate_agent_layer.ps1`: PASS.
- `git diff --check`: PASS.

## Riesgos

- Riesgo bajo: el validador de GitHub lee issues y PRs en modo read-only y solo
  registra ids y reglas, no cuerpos completos.
- Riesgo de mezcla controlado: evidencia Entra, OpenAI y Dataverse queda fuera
  de este carril y requiere rama/gate separado.

## Rollback

Revertir este PR o remover los artefactos listados en `Sistemas tocados` y sus
filas de indice. No hay rollback live porque no hubo escritura externa.

## Proximos carriles

- Revisar y versionar por separado evidencia Entra/Power Platform/Teams si el
  owner confirma que es publicable en repo.
- Revisar evidencia OpenAI SDU Agents con redaccion antes de cualquier commit.
- Preparar carril Dataverse documental separado si no contiene datos regulados.
