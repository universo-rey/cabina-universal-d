# SDU Agents Codex Cloud Operating Model 20260603

## Objetivo

Preparar un carril Codex Cloud repo-scoped para delegar tareas sobre
`universo-rey/cabina-universal-d` con evidencia, sin ejecutar apply remoto ni
persistir agentes remotos.

## Modelo DEV

- Perfil versionado en `.codex/cloud/sdu-agents/profile.yml`.
- Scripts de setup y maintenance como plantillas no ejecutadas por CI.
- Cinco task templates repo-scoped.
- Assignment matrix con owner, reviewer, rollback y stop conditions.

## Permitido

- Preparar prompts de tarea.
- Ejecutar revisiones read-only o mock bajo orden.
- Usar checks GitHub como evidencia cuando existan.

## Bloqueado hasta gate separado

- `codex cloud apply`.
- Live write remoto.
- Persistencia de agente remoto.
- Produccion.
- Permisos.
- Microsoft live.
- OpenAI API live.
- Material sensible.

## Estado

`SDU_CODEX_CLOUD_OPERATING_MODEL_DEV_READY`
