# Power Automate Flow Inventory Recipe

Estado: `POWER_AUTOMATE_FLOW_INVENTORY_PREPARED`

## Objetivo

Inventariar flows Power Automate sin mutar ambientes, separando flows
solution-aware, connection references, environment variables, owners, risks y
gates.

## Alcance

- Read-only por defecto.
- DEV/STAGING o ambiente exacto autorizado.
- No exportar datos regulados ni payloads amplios.

## Entradas

- Environment URL exacto.
- Auth profile o service principal.
- Solution name opcional.
- Output folder local saneado.

## Salidas

- Inventario de flows.
- Matriz de riesgos.
- Duplicados y gaps.
- Recomendacion de inclusion en Solution.

## Prechecks

1. Confirmar ambiente exacto.
2. Ejecutar `who-am-i`.
3. Verificar que el comando sea read-only.
4. Confirmar limite de datos.

## Ejecucion

1. Listar soluciones.
2. Listar flows dentro de solution cuando sea posible.
3. Registrar connection references.
4. Registrar triggers y acciones a nivel metadata.
5. Clasificar: solution-aware, orphan, disabled, owner_gap, evidence_gap.

## Postchecks

- Inventario no contiene secretos ni payloads.
- Todo flow tiene status y owner si esta visible.
- Gaps quedan como proximo carril.

## Rollback

No aplica para read-only. Si se genera archivo incorrecto, revertir el archivo
local o reemplazarlo con una nueva version saneada.

## Evidencias

- Output de PAC/PowerShell saneado.
- Matriz CSV/MD.
- Readback.

## Criterio de cierre

`FLOW_INVENTORY_READY_FOR_GOVERNANCE_DECISION`.
