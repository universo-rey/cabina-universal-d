# Working Paper: SYS Gobierno Operativo PILOTO

## Fecha

2026-06-11

## Proposito

Dejar una lectura consolidada de hoy con tres capas separadas:

- capa viva
- capa documental
- capa local

El objetivo es evitar mezclar presencia real en SharePoint, paquetes documentales y estado del workspace local.

## Capa Viva

### Sitio confirmado

- Site: `SYS-GobiernoOperativo-PILOTO`
- Display name: `Soporte de Sistemas - Gobierno Declarativo`
- Host: `escribaniabitsch.sharepoint.com`

### Biblioteca operativa principal

- `LIB_GobiernoSistemas`

### Bibliotecas / listas vivas confirmadas

- `WB_Decisiones`
- `WB_RevisionSemanal`
- `SYS_EstadoOperativo`
- `WB_AprendizajesOperativos`
- `WB_CapacidadesOperativas`
- `WB_Riesgos`

### Lectura viva relevante

- `WB_Decisiones` existe como lista moderna con columnas visibles de decision, estado, responsable, riesgo y documento relacionado.
- `WB_RevisionSemanal` existe como la lista viva de revision semanal; la forma con guion bajo quedo retirada.
- `SYS_EstadoOperativo` existe como lista viva para estado operativo.
- `WB_AprendizajesOperativos` existe como lista viva para aprendizajes.
- `WB_CapacidadesOperativas` existe como lista viva para capacidades.
- `WB_Riesgos` existe y el readback controlado lo deja con items 13 y 14 en estado `Controlado`.

## Capa Documental

### Paquete rector de gobierno

- `LIB_GobiernoSistemas/TGE_Control_20260514`
- `LIB_GobiernoSistemas/TGE_SDU_CN_MICROSOFT_EXECUTION_20260531`
- `LIB_GobiernoSistemas/MW-MAQUINA-CABINA-OPERATIVA-SHAREPOINT-V1`

### Lo que hoy quedó claro

- La cabina visible no es un sitio nuevo.
- La cabina visible es una capa operativa sobre el sitio actual.
- Git conserva exactitud tecnica, manifiestos, runbooks, commits y rollback.
- SharePoint muestra estado, decisiones, riesgos, evidencias y vistas operativas.

### Archivos clave leidos hoy

- `TGE_SDU_CN_AGENT_ACTIVATION_ORDER_20260531.md`
- `TGE_SDU_CN_AGENT_ACTIVATION_DISPATCH_20260531.md`
- `MAPA_BLOQUES_PAGINA_MAQUINA.md`
- `MATRIZ_VISTAS_SHAREPOINT_MAQUINA.md`
- `03_RUNBOOK_NORMALIZACION_SYS_TGE_20260514.md`
- `READBACK_SYS_GOBIERNOOPERATIVO_PILOTO_DATAVERSE_SHAREPOINT_BRIDGE.md`
- `READBACK_SYS_GOBIERNOOPERATIVO_PILOTO_LIST_DATAVERSE_BRIDGE.md`

### Modelo operativo derivado

- `TGE_SDU_CN_AGENT_ACTIVATION_ORDER_20260531.md` habilita solo preparacion, evidencia, gate, risk review, schema mapping y acta.
- `TGE_SDU_CN_AGENT_ACTIVATION_DISPATCH_20260531.md` distribuye seis agentes SDU-CN rectores.
- `03_RUNBOOK_NORMALIZACION_SYS_TGE_20260514.md` deja prohibido crear listas o columnas sin autorizacion nueva.
- `MAPA_BLOQUES_PAGINA_MAQUINA.md` define la pagina madre `Maquina de Trabajo - Cabina Operativa`.
- `MATRIZ_VISTAS_SHAREPOINT_MAQUINA.md` mapea vistas sobre `SYS_EstadoOperativo`, `WB_Decisiones` y `WB_Riesgos`.

## Capa Local

### Workspace actual

- Repo: `cabina-universal-d`
- Branch: `codex/sdu-workqueue-daily-monitor`
- Estado local: dirty con cambios previos ya presentes

### Capas locales que no conviene confundir

- `C:\Users\enzo1\.codex` = estado y cache de Codex a nivel usuario
- `C:\Users\enzo1\.agents` = skills y plugins a nivel usuario
- `<repo>\.codex` = configuracion repo-local
- `<repo>\.agents\codex` = canon y gobierno repo-local

### Vecinos y worktrees

- El analisis de hoy tuvo que considerar repos vecinos y worktrees, no solo este repo.
- Eso ayudo a no mezclar canon, runtime y superficies distintas.

## Reintento De Browse

### Resultado confirmado

- `LIB_DiccionarioCanonico`
- `LIB_Runbooks`
- `LIB_Plantillas`
- `LIB_AgentPrompts`
- `LIB_EvidenciaTecnica`

Estas bibliotecas existen como `documentLibrary` en `list_site_drives`.

### Resultado no confirmado por browse directo

- `list_folder_items` sobre esas bibliotecas devolvio `404`.
- `search` con carpeta y `query = null` tambien devolvio `404`.
- `search` por nombre de biblioteca no devolvio resultados.

### Lectura operativa

- Confirmado: son drives reales del sitio.
- No confirmado en este turno: navegacion por contenido usando el conector actual.
- Por ahora conviene tratarlas como anchors nominales con existencia viva, pero sin browse de carpeta validado desde esta interfaz.

### Intento De Archivo Conocido

- `LIB_AgentPrompts/TGE_AGENT_ACTIVATION_WAVE1_ORDER_20260531.md` -> `403 / sharesAccessDenied`
- `LIB_AgentPrompts/TGE_COURT_ORDER_ADAPTER_PROMPT_PACK_20260601.md` -> `403 / sharesAccessDenied`
- `LIB_EvidenciaTecnica/READBACK_SYS_GOBIERNOOPERATIVO_PILOTO_DATAVERSE_SHAREPOINT_BRIDGE.md` -> `403 / sharesAccessDenied`
- `LIB_EvidenciaTecnica/READBACK_SYS_GOBIERNOOPERATIVO_PILOTO_LIST_DATAVERSE_BRIDGE.md` -> `403 / sharesAccessDenied`

Lectura operativa: el conector sigue sin resolver un archivo puntual aun cuando se lo apunta por nombre plausible y ruta de biblioteca. La frontera sigue siendo la misma: drive visible, contenido no navegable por esta via.

## Puente Dataverse

### Estado

- El puente Dataverse-SharePoint esta publicado y validado.

### Mapeo resumido

- `WB_Decisiones` -> `sdu_reconciliation_item` como `bridge_proxy`
- `SYS_EstadoOperativo` -> `sdu_matrix` como `bridge_proxy`
- `WB_AprendizajesOperativos` -> `sdu_readback` como `bridge_exact`
- `WB_CapacidadesOperativas` -> `sdu_capability` como `bridge_exact`
- `WB_RevisionSemanal` is live in SharePoint, but no exact Dataverse proxy row has been selected yet; apply remains `PENDING_TARGET_ONLY` until a single `mon_sdu_*` target exists.

### Lectura operativa

- Dataverse queda como registry de metadatos.
- SharePoint queda como superficie operativa y documental.
- GitHub queda como canon tecnico.

## Conclusión De Hoy

1. El sitio ya esta configurado como base operativa gobernada.
2. Hay listas vivas suficientes para operar decisiones, estado, aprendizajes, capacidades y riesgos.
3. El paquete documental ya define cabina, orden de lectura y frontera de ejecucion.
4. El puente Dataverse-SharePoint ya esta reconciliado.
5. Algunas bibliotecas ancla existen como drives, pero este conector no logro navegar su raiz por browse directo en este turno.

## Siguiente Paso

- Si hace falta seguir, el mejor siguiente movimiento es abrir contenido puntual de `LIB_AgentPrompts` o `LIB_EvidenciaTecnica` por archivo conocido, no por browse de carpeta.
- Si no hace falta, este working paper ya deja el estado de hoy congelado en una sola pieza.
