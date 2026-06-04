# ACTIVE_GOVERNED_EXECUTION_BY_DEFAULT_POLICY_20260603

Estado: `ACTIVE_GOVERNED_EXECUTION_BY_DEFAULT`

## Regla madre

La cabina ejecuta por defecto todo lo que sea seguro, reversible, trazable y validable. No permanece en documentacion si existe una accion local, mock, DEV, read-only, smoke, preflight o live-gated que pueda producir evidencia real sin cruzar secreto, produccion, permiso, tenant ambiguo ni datos regulados amplios. Dentro de un carril ya autorizado no se pide aprobacion por cada subpaso seguro: se ejecuta, se evidencia, se valida y se detiene solo el subpaso afectado cuando aparece riesgo real.

## Estados canonicos activos

- `EXECUTE_LOCAL_NOW`: ejecutar accion local reversible y validable.
- `EXECUTE_MOCK_NOW`: ejecutar mock/simulacion con evidencia reproducible.
- `EXECUTE_DEV_NOW`: ejecutar DEV sin produccion ni datos regulados amplios.
- `EXECUTE_LIVE_READ_NOW`: ejecutar lectura live permitida con limite de datos.
- `EXECUTE_LIVE_WRITE_GATED_NOW`: ejecutar escritura live solo con target, identidad, owner, rollback, postcheck y evidencia.
- `EXECUTE_CODEX_CLOUD_SMOKE_NOW`: ejecutar smoke Codex Cloud no-diff/no-apply cuando el environment exista.
- `EXECUTE_MCP_READ_PROBE_NOW`: ejecutar probe MCP read-only o mock con evidencia.
- `EXECUTE_TEAMS_DEV_TEST_NOW`: ejecutar prueba Teams DEV si hay app/chat/canal/owner/rollback.
- `READY_FOR_PROD_HUMAN_GATE`: produccion queda lista para gate humano explicito.
- `PENDING_TARGET_ONLY`: falta target exacto; debe quedar proximo comando exacto.
- `PENDING_SECRET_ONLY`: falta secreto en store gobernado; no se inventa ni se versiona.
- `PENDING_IDENTITY_ONLY`: falta identidad operativa confirmada.
- `PENDING_OWNER_ONLY`: falta owner/reviewer humano o institucional.
- `PENDING_COST_BOUNDARY_ONLY`: falta limite economico explicito.
- `BLOCKED_SECURITY_RISK`: riesgo tecnico real impide ejecucion segura.
- `BLOCKED_SECRET_EXPOSURE`: hubo o habria exposicion de secreto.
- `BLOCKED_TENANT_AMBIGUOUS`: tenant/sitio/equipo/lista/canal no esta resuelto.
- `BLOCKED_PRODUCTION_UNAPPROVED`: produccion sin autorizacion separada.
- `BLOCKED_COST_BOUNDARY_MISSING`: no se puede ejecutar porque el costo no esta acotado.

## Prohibicion de cierres pasivos

Queda prohibido cerrar un carril con estados genericos `disabled`, `blocked`, `not executed`, `prepared` o `pending` sin causa exacta, estado canonico activo, evidencia disponible y proximo comando exacto. Si falta target, secreto, identidad u owner, se usa el estado `PENDING_*_ONLY` que corresponda y se registra el comando que debe ejecutarse cuando el dato exista.

## Aprobacion dentro de carril

Una aprobacion humana de carril cubre subpasos seguros, reversibles y verificables dentro del mismo alcance. No cubre force push, permisos, secretos, produccion, costos abiertos, tenant ambiguo, datos regulados amplios ni live write sin target/rollback/postcheck. Esos subpasos se detienen de forma localizada y el resto del carril continua si no comparte write scope.

## Regla anti-escalamiento

La ejecucion activa por defecto no autoriza escalamiento de alcance.

Un carril autorizado como local, mock, DEV, read-only, smoke o preflight no
puede convertirse automaticamente en:

- escritura remota;
- push a repositorio;
- creacion de pull request;
- merge;
- force push;
- apply de Codex Cloud;
- escritura Microsoft Graph, Teams, SharePoint, Planner, Dataverse o Power Platform;
- llamada OpenAI API live;
- operacion con costo externo;
- operacion sobre produccion;
- lectura amplia de datos regulados;
- cambio de tenant;
- cambio de identidad operativa;
- ampliacion de write scope.

Cualquier escalamiento requiere un nuevo estado, target exacto, owner,
identidad, rollback, postcheck, evidencia, limite de costo cuando aplique y
aprobacion explicita.

La regla practica es:

- `EXECUTE_LOCAL_NOW` nunca incluye `git push`, `gh pr create`, `gh pr merge`, live API, apply remoto ni produccion.
- `EXECUTE_CODEX_CLOUD_SMOKE_NOW` nunca incluye apply, diff oculto, push ni PR.
- `EXECUTE_LIVE_READ_NOW` nunca incluye escritura.
- `EXECUTE_DEV_NOW` nunca implica produccion.
- `READY_FOR_PROD_HUMAN_GATE` nunca ejecuta produccion por si mismo.

## Limite de costo

Toda ejecucion que pueda consumir API, tokens, compute, almacenamiento,
servicios cloud o herramientas externas pagas debe declarar un limite de costo.

Un carril con OpenAI API live, Agents SDK live, Codex Cloud apply, produccion o
servicios cloud externos no puede ejecutarse si el costo queda abierto.

## Comando exacto obligatorio

Todo carril activo debe tener un comando exacto o un script exacto.

No son comandos validos expresiones como:

- "crear matriz";
- "preparar paquete";
- "revisar despues";
- "ejecutar cuando este listo";
- "Enzo decide".

Si falta una decision humana, target, secreto o costo, el carril debe quedar
como `PENDING_*_ONLY` y debe registrar el comando exacto que se ejecutara cuando
el dato faltante exista.

## Evidencia minima

Evidencia significa ejecucion o verificacion real: comando local corrido, workflow remoto observado, tarea Codex Cloud creada, probe read-only ejecutado, mock pasado, check verde o target faltante comprobado. Un documento preparado sin ejecucion debe declararse como `PENDING_*_ONLY` o como orden lista para gate, nunca como evidencia de ejecucion.
