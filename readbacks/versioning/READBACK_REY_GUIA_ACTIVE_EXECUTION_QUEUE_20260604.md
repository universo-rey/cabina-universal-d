# READBACK_REY_GUIA_ACTIVE_EXECUTION_QUEUE_20260604

Estado: `REY_GUIA_ACTIVE_EXECUTION_QUEUE_READY_LOCAL`

Fecha: 2026-06-04

## Orden

Revisar impacto del contrato `ACTIVE_GOVERNED_EXECUTION_BY_DEFAULT` sobre el paquete Rey-Guia y convertir el cierre documental local en carriles activos, reversibles, trazables y validables cuando la accion sea local, mock, DEV, read-only o preflight.

## Resultado local

- Impacto canonico registrado: `governance/canon/REY_GUIA_ACTIVE_CONTRACT_IMPACT_20260604.md`
- Impacto parseable registrado: `governance/canon/REY_GUIA_ACTIVE_CONTRACT_IMPACT_20260604.csv`
- Puntero brownfield registrado con `SHA256`, `verified_at`, `verified_by` y `exists_at_verification`: `governance/canon/REY_GUIA_BROWNFIELD_LOCAL_PACKAGE_POINTER_20260604.csv`
- Cola activa creada: `governance/canon/REY_GUIA_ACTIVE_EXECUTION_QUEUE_20260604.csv`
- Validador creado: `scripts/validators/rey_guia_active_execution_queue_validator.py`

## Carriles activos

- `rey_guia.versionable_canon_pointer`: `EXECUTE_LOCAL_NOW` / `QUEUED_ACTIVE_LOCAL`
- `rey_guia.dataverse_v2_semantic_matrix`: `EXECUTE_LOCAL_NOW`
- `rey_guia.agent_delegation_consolidation`: `EXECUTE_LOCAL_NOW`
- `rey_guia.decisions_owner_review`: `PENDING_OWNER_ONLY`
- `rey_guia.product_package_map`: `PENDING_OWNER_ONLY`

## Frontera

- `NO_MICROSOFT_LIVE`
- `NO_OPENAI_LIVE`
- `NO_RESPONSES_API_LIVE`
- `NO_AGENTS_SDK_LIVE`
- `NO_PRODUCTION`
- `NO_PERMISSIONS`
- `NO_TENANT_WRITES`
- `NO_SECRETS`
- `NO_REMOTE_WRITE`
- `NO_NESTED_REPO_WRITE`

## Evidencia

- Los artefactos viven en rutas allowlisted de `governance/canon`, `scripts/validators` y `readbacks/versioning`.
- El paquete brownfield local queda referenciado por hash, sin mover ni absorber `D:\docs` ni `D:\matrices`.
- La matriz maestra local fue verificada como parseable: 20 filas y 19 columnas.
- La cola usa `queue_status` como estado operativo secundario y conserva `active_state` como estado canonico.
- `write_scope` no usa wildcards; cada ruta queda declarada de forma deterministica.
- `Producto` queda formalizado en el impacto y `Matriz maestra en matrices` queda cubierta por el carril `rey_guia.versionable_canon_pointer`.
- Las acciones pendientes quedan con estado canonico activo, proximo comando y stop condition.
- Las decisiones humanas no bloquean el trabajo local seguro; bloquean publicacion, marca, produccion o ejecucion live hasta decision de owner.

## Validador

```powershell
python scripts/validators/rey_guia_active_execution_queue_validator.py
git diff --check
```

## Rollback

Eliminar o revertir los artefactos de este carril:

- `governance/canon/REY_GUIA_ACTIVE_CONTRACT_IMPACT_20260604.md`
- `governance/canon/REY_GUIA_ACTIVE_CONTRACT_IMPACT_20260604.csv`
- `governance/canon/REY_GUIA_BROWNFIELD_LOCAL_PACKAGE_POINTER_20260604.csv`
- `governance/canon/REY_GUIA_ACTIVE_EXECUTION_QUEUE_20260604.csv`
- `scripts/validators/rey_guia_active_execution_queue_validator.py`
- `readbacks/versioning/READBACK_REY_GUIA_ACTIVE_EXECUTION_QUEUE_20260604.md`

## Stop condition

Detener si aparece target live, permiso, secreto, produccion, tenant ambiguo, datos regulados amplios, OpenAI live sin gate, Dataverse live apply, escritura remota no aprobada o intento de escribir en repos anidados.
