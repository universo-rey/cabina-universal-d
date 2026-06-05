# GitHub Base Work Policy

Estado: `GITHUB_BASE_WORK_DECLARED_ACTIVE`
Fecha: 2026-06-01

## Declaracion

GitHub queda declarado como base obligatoria de trabajo, revision y
trazabilidad para el universo de repositorios de la Cabina Universal del Rey.

El remoto raiz `universo-rey/cabina-universal-d` es la base GitHub transversal
de la cabina `C:\Users\enzo1\Documents\GitHub\cabina-universal-d`: registra gobierno, mapas, matrices, agentes locales y
politicas de trabajo sin absorber repos anidados.

Estado actualizado 2026-06-01: `universo-rey/cabina-universal-d` ya esta
activo como repo raiz envoltorio sobre `main`. Todos los repos registrados
conservan remoto propio y quedan indexados/ruteados por esta cabina.

Cada repo anidado conserva su propio remoto GitHub y su propio ciclo de branch,
commit, push y PR. La cabina raiz no reemplaza esos repos: los indexa, gobierna
y rutea.

## Regla Operativa

Todo cambio durable sobre repos debe pasar por GitHub:

1. clasificar superficie, universo, repo y frontera;
2. trabajar en rama `codex/*` o rama gobernada equivalente;
3. validar localmente;
4. stagear solo archivos explicitos;
5. commitear con alcance claro;
6. pushear a remoto GitHub;
7. abrir o actualizar PR draft;
8. registrar evidencia, validador y stop condition.

## Alcance

Incluye:

- repo raiz `universo-rey/cabina-universal-d`;
- repo rector documental `universo-rey/organizacion`;
- repos de Corte Ejecutora;
- repos de Universo Escribania;
- repos de Universo Modo ON;
- matrices, agentes locales, tools, skills, recipes, evals y readbacks que
  sean versionables y saneados.

No incluye:

- secretos;
- dumps de datos regulados;
- caches, binarios generados o carpetas temporales;
- clones completos dentro del repo raiz;
- Microsoft live;
- OpenAI API live;
- produccion;
- permisos o identidad.

## Reglas De Separacion

- `C:\Users\enzo1\Documents\GitHub\cabina-universal-d` usa repo raiz envoltorio con allowlist.
- `C:\Users\enzo1\Documents\GitHub\cabina-universal-d` no usa `git add .`.
- `organizacion` conserva su propio repo y PR.
- Los demas clones bajo `10_REPOS\02_ACTIVE` conservan su propio repo.
- Si un repo no tiene remoto confirmado, queda `NO_CONSTA_REMOTE` y no avanza a
  trabajo durable hasta registrar remoto o decision de archivo.

## GitHub Permitido Bajo Orden Gobernada

- lectura de remoto;
- branch;
- commit;
- push;
- PR draft o actualizacion de PR;
- issues, labels, comentarios y readbacks cuando el frente lo requiera.

## GitHub Bloqueado Sin Orden Separada

- force push;
- merge;
- delete branch remoto;
- cambio de permisos;
- cambio de visibilidad;
- cambio de owners;
- proteccion de ramas;
- publicacion productiva;
- uso de secretos o credenciales en archivos.

## Stop Condition

Detener si aparece cualquiera de estas condiciones:

- remoto ambiguo o inexistente;
- repo anidado intenta ser absorbido por la raiz envoltorio;
- dato regulado o secreto en archivos a versionar;
- branch fuera de politica sin decision humana;
- validador fallido;
- accion live, productiva o de permisos sin orden separada.
