# Current State

Estado: `D_ROOT_WRAPPER_REPO_LOCAL_ACTIVE`

La estructura en `D:/` fue creada para revision local y ya tiene versionado GitHub gobernado abierto en PR borrador.

Actualizacion 2026-06-01: por orden expresa del operador, `D:/` queda
inicializado como repo local envoltorio nuevo y separado. Este repo raiz no
absorbe `organizacion` ni otros clones; `organizacion` conserva su repo y PR
propios.

Actualizacion remota 2026-06-01: el repo raiz de cabina tiene remoto privado
separado en `universo-rey/cabina-universal-d`. El repo `universo-rey/organizacion`
continua como repo rector documental separado y no fue reemplazado.

Reglas vigentes:

- GitHub repo-visible reversible esta habilitado para lectura, validacion, branch, commit, push, PR draft/update, issues, labels, comentarios y readbacks bajo orden gobernada.
- No mover clones aun.
- Microsoft live queda gobernado a nivel global: SharePoint, Teams, Outlook, Entra, Microsoft Graph, Power Platform, Planner, Dataverse o tenant requieren orden gobernada con superficie, identidad, owner, rollback, postcheck y evidencia.
- Produccion solo con autorizacion explicita separada.
- No force push, no delete branch remoto, no merge a rama protegida, no permisos, no produccion sin autorizacion, no Microsoft/SharePoint/Power Platform writes sin orden gobernada, no OpenAI API live ni agentes remotos persistentes sin orden separada.
- No versionar secretos ni datos regulados fuera de frontera.
- Escribania y Modo ON son universos.
- CDF y Jara pertenecen a Modo ON.
- Seshat y SDU pertenecen a la Corte Ejecutora.

PR rector activo: `universo-rey/organizacion#40`.
Rama rectora activa: `codex/d-drive-governance-versioning-20260601`.
