# Order Connect D Cabina Github Approval Draft 20260601

Estado: SUPERSEDED_NON_EXECUTABLE
Fecha: 2026-06-01

## Estado rector posterior

Esta orden queda supersedida y no ejecutable. Contradice el estado rector
vigente de `D:\AGENTS.md`, que ya declara `D:\` como repo raiz envoltorio
gobernado en `universo-rey/cabina-universal-d`, sin absorber repos anidados.
Se conserva solo como evidencia historica de aprobacion anterior.

## Orden propuesta

Preparar y ejecutar conexion/versionado gobernado de la Cabina Universal `D:\`
mediante el repo rector existente `universo-rey/organizacion`, sin convertir
`D:\` en repo Git directo.

## Aprobacion humana requerida

```text
Autorizo conectar/versionar la Cabina Universal D:\ mediante el repo rector
universo-rey/organizacion, usando la rama
codex/d-drive-governance-versioning-20260601 y el PR draft #40.

Alcance autorizado:
- actualizar el snapshot gobernado y registros necesarios de D:\ dentro del repo rector;
- incluir archivos rectores, capa .agents/codex, workpapers, matrices, rutas,
  ordenes y readbacks que correspondan a la cabina;
- ejecutar validadores locales, git diff --check, secret scan y postcheck;
- stagear archivos explicitos, crear commit gobernado, pushear a la rama
  indicada y actualizar el PR draft si hace falta.

Limites:
- no inicializar D:\ como repo Git directo;
- no mover clones locales;
- no crear repo remoto nuevo;
- no force push;
- no borrar ramas;
- no mergear PR;
- no tocar permisos;
- no ejecutar Microsoft, SharePoint, Power Platform, OpenAI API, costos,
  produccion ni datos regulados fuera de frontera;
- no persistir secretos.

Rollback esperado: revert commit o commit correctivo sobre la misma rama,
manteniendo intacta la superficie local fuente.

Stop condition: secreto detectado, datos regulados fuera de frontera,
worktree inesperadamente sucio, divergencia de rama, validador fallido,
checks GitHub fallidos, conflicto de autoridad o necesidad de produccion.
```

## Superficie

- Raiz local: `D:\`
- Repo rector local:
  `D:\01_GOVERNANCE_REGISTRY\10_REPOS\02_ACTIVE\organizacion`
- Repo remoto: `https://github.com/universo-rey/organizacion.git`
- Branch:
  `codex/d-drive-governance-versioning-20260601`
- PR:
  `https://github.com/universo-rey/organizacion/pull/40`

## Identidad / owner

- Owner local: `operador`
- Cuenta GitHub autenticada observada: `SeshatSgin`
- Protocolo Git: `https`

## Universo / torre

- Universo origen: `CABINA_UNIVERSAL_DEL_REY`
- Universo destino: no aplica como universo; destino tecnico es repo rector
  del plano raiz de gobierno.
- Torre responsable: `01_GOVERNANCE_REGISTRY`
- Corte/Gate: `CORTE_EJECUTORA_DEL_REY`

## Agentes

- Primario: `rey.repo_cartographer`
- Gate: `rey.frontier_guardian`
- Canon: `rey.authority_canonist`
- Evidencia: `court.seshat_evidence`
- Schema/validadores: `court.thot_schema`
- Workspace: `codex.workspace_guardian`

## Receta / carril

- Carril: GitHub repo-visible reversible bajo orden gobernada.
- Receta: snapshot/versionado rector de `D:\` via `universo-rey/organizacion`.
- Tools: git local, gh read/write al PR draft, validadores locales.

## Evidencia esperada

- `git status --short --branch` antes y despues.
- `git diff --check`.
- Validadores de capa agente:
  - `local_validate_agent_levels.ps1`
  - `local_validate_agent_workpapers.ps1`
  - `local_validate_agent_layer.ps1`
- Secret scan.
- PR #40 actualizado o confirmado.
- Readback final con commit, branch, PR, validadores y stop condition.

## No autorizado

- Convertir `D:\` en repo Git directo.
- Ejecutar live Microsoft, SharePoint, Power Platform, OpenAI API o produccion.
- Mover clones.
- Crear secretos, logs con secretos o dumps regulados.
- Mergear, force pushear, borrar ramas o cambiar permisos.

## Stop condition

Detener y pedir nueva orden si aparece cualquiera de estos casos:

- secreto o dato regulado fuera de frontera;
- repo rector sucio con cambios no atribuibles al carril;
- branch distinto o divergente;
- validador fallido;
- GitHub checks fallidos;
- necesidad de produccion, permiso, Microsoft live u OpenAI API live;
- conflicto entre `D:\AGENTS.md`, manifest, canon o PR.
