# Cabina Universal Del Rey

Estado: `CABINA_EXTENDED_RECONCILIATION_CANONIZED`

## Estado operativo actual

Reglas activas: `AGENTS.md`. Punteros estructurados: `MANIFEST.yaml`.
Snapshot documental fechado: `02_AUTHORITY_CANON/CURRENT_STATE.md`.
Para HEAD, PRs abiertos y checks actuales prevalece GitHub; los snapshots
historicos no son un inventario vivo ni acreditan una sesion Microsoft.

## Hito historico de consolidacion

La Cabina Universal del Rey queda canonizada como
`CABINA_OPERATING_SYSTEM_CONSOLIDATED_TO_PR96` despues de reconciliar 75 PRs
reales mergeados hasta el PR #96. El canon operativo subyacente sigue siendo
`CABINA_FULL_LIVE_GOVERNED_GLOBAL_CANON` y la cadena activa es
`STANDARD_AGENT_CHAIN_ACTIVE`.

Ya no queda limitada a repo-only. GitHub sigue siendo canon tecnico, pero la
cabina queda habilitada para gobernar runtime live, OpenAI, Codex Cloud,
Agents SDK, Microsoft 365 y propagacion con control proporcional por efecto.
Solo HIGH requiere orden y autorizacion humana explicita; produccion conserva HIGH.
Todo write live requiere target exacto, owner, identidad, rollback, postcheck,
evidencia, stop condition y readback.

Este disco contiene el mapa local objetivo para organizar repos, herramientas, sistemas, licencias, evidencia y archivos por jerarquia.

Por orden expresa del operador, `C:\Users\enzo1\Documents\GitHub\cabina-universal-d`
opera como repo local envoltorio para visibilidad nativa de Codex/Git. Este
repo no absorbe clones anidados:
`organizacion` y los demas repos conservan sus propios `.git`.

Remoto del repo raiz: `https://github.com/universo-rey/cabina-universal-d`.

Base rectora/remota visible para Codex/Git: `main`. La rama activa debe
verificarse en cada sesion. El PR raiz #1 esta mergeado; nuevos cambios
versionables deben usar rama `codex/*` desde `main` y PR gobernado.

Commit historico de consolidacion: `e9e7af7f7e403697878039db27a6e72e0104fa24`
por `universo-rey/cabina-universal-d#96`. El hito textual #78 queda como
antecedente historico, no como ultimo estado raiz.

Alineacion universal local: los repos registrados se alinean a
`universo-rey/cabina-universal-d` como base transversal e indice, sin perder
su remoto nativo. Los agentes GitHub/Copilot y GitHub Actions de validacion
estan aprobados para issues, ramas, commits, push, PR y checks repo-scoped;
runtime productivo y live externo quedan habilitados solo bajo el canon
`CABINA_FULL_LIVE_GOVERNED_GLOBAL_CANON`, con controles proporcionales y sin writes
ciegos. READ exact-bound no requiere orden. Todo write conocido sin trigger
HIGH positivo es LOW por defecto con capability autenticada, binding, target
acotado, precheck, reversa o compensacion, postcheck y evidencia tecnica.
La falta de readiness produce `RESOLUTION_REQUIRED`, conserva el tier y
bloquea solo el subpaso afectado. `ENABLED_GOVERNED_GATED_NOT_EXECUTED`
se conserva como marcador historico; no impone un gate universal a READ/LOW.

Agentes en GitHub: `.github/copilot-instructions.md`,
`.github/ISSUE_TEMPLATE/agent-task.yml`,
`.github/ISSUE_TEMPLATE/runtime-approval.yml` y `.github/PULL_REQUEST_TEMPLATE.md`
publican la forma GitHub aprobada para operar agentes en issues, ramas, commits
y PRs sin activar produccion. `.github/workflows/cabina-validation.yml` ejecuta
validaciones locales en GitHub Actions con permisos `contents: read`; usa los
workpapers saneados bajo `.agents/codex/workpapers` como evidencia declarativa.

Operacion paralela: `.agents/codex/matrices/PARALLEL_OPERATION_CRITERIA_MATRIX.csv`
define carriles, owners, alcance, evidencia, validador y stop condition.
`.agents/codex/matrices/ORDER_PREPARATION_ASSIGNMENT_MATRIX.csv` asigna que
agente prepara la orden cuando un trigger HIGH la requiere. La mera lectura
live o un write LOW no abren una orden por superficie.

Los carriles paralelos requieren scopes y locks declarados. Las ordenes
gobernadas se preparan cuando corresponde HIGH. No condicionan operaciones
READ/LOW independientes; cada operador debe resolver su capability y efectos reales.

Regla de lectura:

1. `00_CONTROL_PLANE_INGRESS` recibe.
2. `01_GOVERNANCE_REGISTRY` clasifica.
3. `02_AUTHORITY_CANON` gobierna.
4. `03_CORTE_EJECUTORA_DEL_REY` ejecuta con agentes OpenAI, Seshat y SDU.
5. `10_UNIVERSOS` contiene universos operativos como Escribania y Modo ON.

Este mapa no concede autoridad para absorber repos, mover clones ni cruzar
tenants. El ciclo GitHub repo-visible y reversible opera en la rama autorizada;
Microsoft usa READ/LOW/HIGH. Permisos/admin, secretos, efectos destructivos,
activacion productiva y demas triggers HIGH conservan autorizacion expresa.
Merge sigue siendo `MANUAL_OWNER_GATED`. No se ejecuta Microsoft live por
actualizar este README.
