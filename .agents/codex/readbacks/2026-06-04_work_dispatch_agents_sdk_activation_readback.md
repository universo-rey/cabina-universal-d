# READBACK_WORK_DISPATCH_AGENTS_SDK_ACTIVATION_20260604

## Estado

HECHO_VERIFICADO: la cabina queda ajustada para que todo envio de trabajo a
Codex Cloud, GitHub automation, OpenAI, Responses API o Agents SDK active la
cadena estandar de agentes antes del despacho. `codex cloud exec` queda tratado
como despacho remoto task-scoped y `codex cloud apply` queda fuera del envio
inicial hasta revision de diff, branch clasificada, rollback y validadores.

## Sistemas tocados

- `D:\AGENTS.md`
- `D:\.agents\codex\maps\RUNTIME_PARALLEL_ACTIVATION.md`
- `D:\.agents\codex\maps\CODEX_CLOUD_GOVERNED_LANE.md`
- `D:\.agents\codex\recipes\recipe.codex_cloud_governed_lane.md`
- `D:\.agents\codex\matrices\CODEX_CLOUD_GOVERNED_LANE_MATRIX.csv`
- `D:\.gitignore`

## Sistemas no tocados

- No se ejecuto `codex cloud exec`.
- No se ejecuto `codex cloud apply`.
- No se ejecuto OpenAI API live, Responses API live ni Agents SDK live.
- No se escribio en Microsoft, SharePoint, Teams, Graph, Power Platform,
  Dataverse, tenant, produccion ni permisos.
- No se imprimieron ni persistieron secretos.

## Cambios

- Se agrego en `D:\AGENTS.md` la regla rectora de despacho externo y SDK.
- Se reforzo el mapa de runtime para activar cadena estandar antes de enviar
  trabajo.
- Se actualizo la receta de Codex Cloud para que `exec` pase por cadena
  estandar y Agents SDK gobernado cuando haya razonamiento runtime.
- Se agrego el carril `codex_cloud.work_dispatch_standard_agent_chain` en la
  matriz de Codex Cloud.
- Se allowlisteo este readback.

## Validacion

- `local_validate_codex_cloud_governed_lane.ps1`: PASS, 12 carriles Cloud,
  0 errores, 0 warnings.
- `local_validate_capability_use_hardening.ps1`: PASS, 12 filas de capacidad,
  0 errores, 0 warnings.
- `local_validate_operational_chain.ps1`: PASS, 11 filas de cadena, 0 errores,
  0 warnings.
- `local_validate_agents_instruction_hierarchy.ps1`: PASS, 8 superficies de
  instruccion, 0 errores, 0 warnings.
- `git diff --check` y `git diff --cached --check`: PASS. Git solo aviso
  normalizacion LF/CRLF en `.gitignore`.

## Riesgos

- Riesgo principal: confundir envio remoto con autorizacion de apply o live.
  Queda mitigado declarando que `apply`, OpenAI live con costo, Microsoft live,
  produccion, permisos, secretos, datos regulados amplios y agentes remotos
  persistentes requieren gate separado.

## Rollback

Revertir los archivos listados en sistemas tocados o restaurar desde Git antes
de stage/commit. No hay rollback live porque no hubo ejecucion externa.

## Proximos carriles

- Validar el nuevo carril local.
- Si el operador aprueba, revisar diff y stage explicito solo de estos archivos.
- Despues, publicar por ciclo GitHub gobernado si corresponde.
