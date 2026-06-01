# Agent Levels

Esta carpeta contiene perfiles de agentes locales para `D:\`.

La regla es lectura liviana: no abrir todos los perfiles. Primero leer `LEVELS.yaml`, elegir el subnivel por superficie y abrir solo el README del subnivel y el perfil asignado.

Los perfiles locales son `LOCAL_CODEX_OVERLAY`. Antes de cambiar un perfil, revisar las fuentes copiadas `SOURCE_*` y adaptar desde TCU/TGE/runtime cuando exista equivalencia.

## Subniveles

- `00_ROUTER`: entrada y derivacion inicial.
- `01_AUTORIDAD_Y_GATES`: canon, frontera, gates y stop conditions.
- `02_REGISTRO_Y_CARTOGRAFIA`: inventario, repos, owners, jerarquia y migracion.
- `03_CORTE_EJECUTORA`: OpenAI, Seshat, SDU, Thot, prompts, recetas y evals.
- `04_TORRES_DE_UNIVERSO`: torres por universo.
- `05_SOPORTE_TECNICO`: referencias, herramientas y workspace Codex.

## Politica

- Un agente no debe leer perfiles de otro subnivel salvo handoff expreso.
- Un subnivel no autoriza writes live, Git versioning ni llamadas externas.
- Todo cierre debe dejar readback en `D:\.agents\codex\readbacks`.
- Si una orden cruza universo, gate, tenant, API o costo, escala a `01_AUTORIDAD_Y_GATES`.
