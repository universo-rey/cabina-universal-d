# Acta de Inicio Borrador - Consolidacion de Entornos SDU y Surfaces Relacionadas

## Estado

BORRADOR_DE_INICIO_PREPARADO

## Fuente y Alcance

- Fuente primaria: evidencia local del repo `universo-rey/cabina-universal-d`.
- Alcance: consolidacion de entornos ya mapeados en distintas superficies
  del repo, sin abrir nuevas fronteras live.
- Fecha de inicio del borrador: 2026-06-10.

## Agentes / Carriles Propuestos

- `rey.governance_registrar`: relevar inventarios ya existentes por entorno.
- `court.seshat_evidence`: convertir hallazgos en acta legible y trazable.
- `rey.frontier_guardian`: separar superficie local, metadata y live-gated.

## Evidencia Ya Reunida

- `MATRIX_INDEX.csv` ya referencia el inventario de environments de Codex Cloud.
- `.agents/codex/matrices/CODEX_CLOUD_ENVIRONMENT_INVENTORY_20260602.csv`
  ya consolida environments visibles de Codex Cloud.
- `dataverse/data/seed_environments.csv` ya registra el target DEV explícito y
  el marcador `ESCRIBANIA BITSCH default`.
- `matrices/connections/CONNECTION_INSTANCE_INVENTORY.csv` ya concentra
  superficies y conexiones con muchos entornos/referencias cruzadas.
- `readbacks/sdu/READBACK_SDU_COMPLETE_ENVIRONMENT_MAP.md` ya fija el mapa
  SDU local completo para `HUBDesarrollo` y deja `ESCRIBANIA BITSCH default`
  como inventario local incompleto.
- `matrices/sdu/SDU_MASTER_ENVIRONMENT_SOLUTION_MATRIX.csv` ya consolida el
  mapa maestro unico de entornos y soluciones conocidas o pendientes.

## Hallazgo Operativo

- La consolidacion ya existe por capas y por superficie.
- Ya existe un indice unico de lectura para los entornos conocidos del repo.
- El siguiente paso, si el usuario lo pide, es abrir lectura live solo sobre
  las filas visibility-only para completar nombres de soluciones.

## Sistemas Tocados

- Repo local `cabina-universal-d`.
- Lectura de matrices, readbacks, manifest y docs de gobierno.

## Sistemas No Tocados

- Microsoft live.
- Dataverse live.
- Power Platform live.
- OpenAI API live.
- Produccion.
- Secrets.

## Riesgo

- Riesgo bajo: trabajo documental y local.
- Riesgo medio solo si se intenta convertir esta consolidacion en write live
  sin target exacto, owner, rollback, postcheck y evidencia.

## Criterio de Cierre del Borrador

- Mantener una sola fila por entorno unico, aunque aparezca en varias
  superficies.
- Conservar estado, evidencia y solucion conocida o pendiente por fila.
- No duplicar el inventario por superficie.

## Próximos Carriles

1. Extraer la lista completa de entornos ya visibles en el repo.
2. Clasificarlos por superficie y estado: `completo`, `visible`, `pendiente`,
   `gated`.
3. Redactar el acta final con el mapa maestro consolidado.
