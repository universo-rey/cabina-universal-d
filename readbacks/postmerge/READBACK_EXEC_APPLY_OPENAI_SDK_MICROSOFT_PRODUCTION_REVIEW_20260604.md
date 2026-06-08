# READBACK_EXEC_APPLY_OPENAI_SDK_MICROSOFT_PRODUCTION_REVIEW_20260604

## Estado

HECHO_VERIFICADO: se revisaron localmente las seis superficies indicadas por
el operador: `codex cloud exec`, `codex cloud apply`, OpenAI live, Agents SDK
live, Microsoft live y produccion. La revision fue documental/local y no
ejecuto tareas Cloud, no aplico diffs, no llamo OpenAI live, no ejecuto Agents
SDK live, no escribio en Microsoft y no toco produccion.

## Dictamen operativo

| Superficie | Estado cabina | Regla vigente | Stop condition principal |
| --- | --- | --- | --- |
| `codex cloud exec` | habilitado gobernado | Solo task-scoped con environment/repo, branch, prompt, data boundary, rollback, postcheck, evidencia y cadena estandar activa. | `capability_use_preflight_missing` |
| `codex cloud apply` | gate separado | No forma parte del envio inicial. Requiere diff revisado, branch `codex/*` o repo-native equivalente, worktree clasificado, rollback Git y validadores. | `github_order_missing_checks` |
| OpenAI live | habilitado gobernado | Solo con operacion exacta, payload sintetico o saneado, owner, evidencia y sin imprimir body ni secretos. | `openai_api_live_requested_without_order` |
| Agents SDK live | habilitado gobernado | Solo para runtime/triage gobernado con contrato de respuesta, payload sintetico o saneado y evidencia; sin herramientas/handoffs/tracing persistentes salvo orden separada. | `api_or_remote_agent_requested` |
| Microsoft live | enabled governed gated | Solo con tenant/sitio/equipo/lista/canal/objeto exacto, identidad, owner, rollback, postcheck y evidencia. | `microsoft_live_requested_without_governed_order` |
| Produccion | enabled governed gated | Solo con autorizacion explicita separada, target exacto, owner, rollback, postcheck, evidencia y readback. | `production_requested_without_explicit_authorization` |

## Crosswalk aplicado

HECHO_APLICADO: no se crea matriz nueva. Las seis superficies quedan atadas a
matrices existentes para evitar duplicacion de canon. Este crosswalk se usa
como lectura ejecutiva de despacho y gate.

| Punto revisado | Matriz rectora existente | Fila o clave | Uso operativo inmediato |
| --- | --- | --- | --- |
| `exec` | `D:\.agents\codex\matrices\CODEX_CLOUD_GOVERNED_LANE_MATRIX.csv` | `codex_cloud.work_dispatch_standard_agent_chain` | Preparar envio Cloud solo con repo/environment, branch, prompt saneado, data boundary, rollback, postcheck, evidencia y cadena estandar. |
| `apply` | `D:\.agents\codex\matrices\CODEX_CLOUD_GOVERNED_LANE_MATRIX.csv` | `codex_cloud.apply_gate` | Mantenerlo separado del envio; aplicar solo despues de diff review, branch/estado Git clasificado, rollback y validadores. |
| OpenAI live | `D:\.agents\codex\matrices\CABINA_FULL_LIVE_GLOBAL_CANON_MATRIX_20260603.csv` + `D:\.agents\codex\matrices\LIVE_SURFACE_GATE_MATRIX_20260603.csv` | `OpenAI API` / `openai_api` | Ejecutar solo con orden live gobernada, operacion exacta, payload sintetico o saneado, sin imprimir body ni secretos. |
| Agents SDK live | `D:\.agents\codex\matrices\CABINA_FULL_LIVE_GLOBAL_CANON_MATRIX_20260603.csv` + `D:\.agents\codex\matrices\AGENTS_SDK_BASELINE_GATE_20260603.csv` | `Agents SDK Runtime` / `sdu-triage-agent` | Usar runtime gobernado solo con contrato, payload sintetico o saneado, evidencia y sin herramientas/handoffs/tracing persistentes salvo orden separada. |
| Microsoft live | `D:\.agents\codex\matrices\LIVE_SURFACE_GATE_MATRIX_20260603.csv` + `D:\.agents\codex\matrices\CABINA_FULL_LIVE_GLOBAL_CANON_MATRIX_20260603.csv` | `microsoft_live_write` / Microsoft Graph, SharePoint, Teams, Planner, Power Platform | Ejecutar solo con identidad, tenant/sitio/equipo/lista/canal/objeto exacto, owner, rollback, postcheck y evidencia. |
| Produccion | `D:\.agents\codex\matrices\LIVE_SURFACE_GATE_MATRIX_20260603.csv` + `D:\.agents\codex\matrices\CABINA_FULL_LIVE_GLOBAL_CANON_MATRIX_20260603.csv` | `production` / `Production` | Ejecutar solo con autorizacion explicita separada, target exacto, owner, rollback productivo, postcheck, evidencia y readback. |

Decision aplicada: cualquier proximo carril que mencione estas seis superficies
debe referenciar esta tabla y las matrices existentes antes de escribir,
despachar, aplicar, llamar API, tocar Microsoft o tocar produccion.

## Evidencia revisada

- `D:\AGENTS.md`: regla de despacho externo y SDK; cadena estandar activa.
- `D:\MANIFEST.yaml`: OpenAI, Responses, Agents SDK, Codex Cloud, Microsoft y
  produccion figuran como gobernados; Microsoft y produccion siguen gated.
- `D:\.agents\codex\matrices\CODEX_CLOUD_GOVERNED_LANE_MATRIX.csv`: separa
  `exec`, `diff`, `apply`, PR handoff y superficies bloqueadas.
- `D:\.agents\codex\matrices\AGENTS_SDK_BASELINE_GATE_20260603.csv`: registra
  `OPENAI_API_LIVE_GOVERNED_READY`, `RESPONSES_API_LIVE_GOVERNED_READY` y
  `AGENTS_SDK_RUNTIME_LIVE_GOVERNED_READY`.
- `D:\.agents\codex\matrices\CABINA_FULL_LIVE_GLOBAL_CANON_MATRIX_20260603.csv`:
  exige target, owner, rollback, postcheck y evidencia para live.
- `D:\.agents\codex\matrices\LIVE_SURFACE_GATE_MATRIX_20260603.csv`: conserva
  Microsoft live write y produccion como gated/not executed.
- `D:\apps\sdu-agent-runtime\README.md`: confirma default `local_no_live` y
  live smoke solo bajo gate externo gobernado.

## Validacion

- `codex cloud --help`: confirma comandos `exec`, `status`, `list`, `apply` y
  `diff`.
- `codex cloud exec --help`: confirma que `exec` envia una tarea Cloud con
  `--env`, branch opcional y prompt.
- `codex cloud apply --help`: confirma que `apply` aplica localmente el diff de
  un task.
- `local_validate_codex_cloud_governed_lane.ps1`: PASS, 12 carriles.
- `local_validate_capability_use_hardening.ps1`: PASS, 12 filas.
- `local_validate_operational_chain.ps1`: PASS, 11 filas.
- `local_validate_autonomous_agent_execution.ps1`: PASS, 30 filas.
- `local_validate_order_packets.ps1`: PASS, 6 clases de orden y 14 archivos.
- `local_validate_github_automation_preflight.ps1 -CheckLocalSdk`: PASS,
  `smoke=OK_NO_API_CALL`, `openai_api_key_present=false`.
- `python -m unittest discover -s apps\sdu-agent-runtime\tests`: PASS, 5 tests.
- `local_validate_openai_upstream_adoption.ps1`: PASS.
- `local_validate_teams_governance.ps1`: PASS.
- `local_validate_teams_cross_repo_lane_audit.ps1`: PASS.
- `local_validate_agents_instruction_hierarchy.ps1`: PASS.
- `git check-ignore -v`: el readback esta allowlisteado por
  `!/readbacks/postmerge/*.md`.
- Secret scan focal del readback: 0 hits.
- `git diff --check`: PASS. Git solo aviso normalizacion LF/CRLF pendiente en
  `.gitignore`, heredada del worktree.

## Riesgos

- `exec`: puede crear trabajo remoto si se usa con prompt amplio o repo
  equivocado.
- `apply`: puede mezclar cambios Cloud con worktree local si no hay diff review
  y rollback.
- OpenAI/Agents SDK live: puede generar costo o persistir body si se omiten
  guardrails.
- Microsoft live: puede tocar tenant, mensajes, listas, Planner, Graph,
  Dataverse o Power Platform si falta objeto exacto.
- Produccion: riesgo alto; no debe ejecutarse por inferencia ni por nombre
  ambiguo de entorno.

## Rollback

No hubo ejecucion externa ni live. Para esta revision, el rollback es borrar
este readback o no stagearlo. Para acciones futuras:

- `exec`: cancelar/no continuar task, revisar status/diff, no aplicar.
- `apply`: revertir por Git antes de commit.
- OpenAI/Agents SDK live: detener antes de payload real; no persistir body.
- Microsoft live: ejecutar rollback declarado por objeto.
- Produccion: rollback productivo aprobado antes de ejecutar.

## Proximos carriles

1. Preparar orden ejemplo para un `exec` seguro read-only.
2. Preparar orden ejemplo para `apply` con diff review y rollback.
3. Preparar gates separados para OpenAI/Agents SDK live, Microsoft live y
   produccion, cada uno con target exacto.
4. Si el operador pide permanencia extra, extender solo la matriz existente
   que corresponda, sin crear matriz duplicada.
