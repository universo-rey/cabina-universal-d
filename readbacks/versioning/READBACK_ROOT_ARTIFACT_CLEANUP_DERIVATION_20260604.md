# READBACK_ROOT_ARTIFACT_CLEANUP_DERIVATION_20260604

## Estado

HECHO_VERIFICADO:

Se clasificaron 12 artefactos pendientes del repo raiz `universo-rey/cabina-universal-d`.
No se detecto basura descartable en esta pasada: los archivos estan dentro de rutas
allowlist y corresponden a evidencia o matrices gobernadas.

## Sistemas tocados

- Repo raiz `D:\` / `universo-rey/cabina-universal-d`.
- Matriz de derivacion `D:\matrices\versioning\ROOT_ARTIFACT_CLEANUP_DERIVATION_MATRIX_20260604.csv`.
- Indice de matrices `D:\.agents\codex\matrices\MATRIX_INDEX.csv`.
- Readback local `D:\readbacks\versioning\READBACK_ROOT_ARTIFACT_CLEANUP_DERIVATION_20260604.md`.

## Sistemas no tocados

- Repos anidados TGE, Seshat, CDF y agentic escribania.
- Microsoft live, Entra, SharePoint, Teams, Dataverse, Power Platform y produccion.
- OpenAI API live y Agents SDK live.
- Permisos, secretos, conectores, licencias y ramas remotas ajenas.

## Cambios

- Se conserva la propiedad fisica de los artefactos en el repo raiz.
- La derivacion se declara por referencia:
  - Entra: CDF y agentic escribania consumen como insumo de revision gobernada.
  - OpenAI SDU agents: Seshat y agentic escribania consumen como evidencia de runtime.
  - Dataverse: CDF consume como scorecard y matriz de brechas metadata-only.
  - Rey guia: queda como evidencia canonica del repo raiz.
- No se borro ni movio ningun archivo.

## Validacion

- `git diff --check`: PASS.
- Escaneo local de patrones sensibles sobre los 12 artefactos y archivos de cierre: sin hits.
- `D:\.agents\codex\tools\local_validate_agent_layer.ps1`: PASS.
- `D:\.agents\codex\tools\local_validate_capability_use_hardening.ps1`: PASS.
- `D:\.agents\codex\tools\local_validate_operational_chain.ps1`: PASS.

## Riesgos

- Las matrices Entra contienen metadata de tenant limitada; no deben copiarse a repos anidados ni a superficies live sin orden gobernada.
- Los artefactos OpenAI son evidencia saneada existente; esta limpieza no autoriza nuevas llamadas live.

## Rollback

- Quitar de la rama los archivos agregados o el registro de derivacion antes de merge.
- Si un validador detecta secreto o alcance incorrecto, detener con `secret_detected_or_unclassified_scope`.

## Proximos carriles

- Carril CDF: revisar Dataverse scorecard y brechas por referencia, sin mover archivos.
- Carril agentic escribania: revisar Entra/OpenAI runtime por referencia, sin live write.
- Carril Seshat: consumir evidencia OpenAI SDU agents solo como readback/runtime evidence.
