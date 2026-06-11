# SDU-CN Canonical Agent Discovery 2026-06-04

## Estado

`SDU_CN_CANONICAL_AGENT_DISCOVERY_READY`

## Fuente De Orden

- Issue raiz: `universo-rey/cabina-universal-d#88`.
- Fan-in: `universo-rey/cabina-universal-d#87`.
- Orden humana: Enzo aprueba ejecutar el carril `sdu-cn-canonical-agents-multirepo-multiuniverse-20260604`.
- Frontera: sin Microsoft live, sin OpenAI API live, sin produccion y sin secretos.

## Hallazgo Principal

Los seis agentes SDU-CN ya aparecian en registros fuente repo-locales, pero no
estaban elevados como capa canonica suprarrepo en `02_AUTHORITY_CANON`.

## Donde Aparecen

| Superficie | Evidencia | Lectura |
| --- | --- | --- |
| `.agents/codex/agents/SOURCE_TGE_SDU_CN_AGENT_REGISTRY.csv` | contiene `seshat-normativa`, `horus-riesgo`, `maat-cumplimiento`, `anubis-gate`, `thot-tecnico`, `narrador-normativo` | registro fuente TGE/Escribania |
| `.agents/codex/agents/SOURCE_SESHAT_BOOTSTRAP_SDU_CN_AGENT_REGISTRY.csv` | contiene los mismos seis agentes con gates Microsoft live | registro fuente Seshat bootstrap |
| `C:\Users\enzo1\.codex\workpapers/WORKPAPER_INDEX.csv` | contiene `court.seshat_evidence`, `court.sdu_gate`, `court.thot_schema`, `universe.escribania_tower`, `universe.modo_on_tower` | capa operativa de Cabina |
| `AGENTS.md` y `MANIFEST.yaml` | declaran cadena estandar con `rey.control_plane_orchestrator`, `court.openai_dispatcher`, `sdu-triage-agent`, `court.sdu_gate`, `court.seshat_evidence` | cadena operativa, no panteon SDU-CN |
| Issues #87/#88 y espejos | declaran los seis agentes como canonicos multirepo | contrato GitHub ya preparado |

## Donde Faltaban

- Faltaba archivo rector de panteon canonico en `02_AUTHORITY_CANON`.
- Faltaba modelo operativo multiuniverso para `ESCRIBANIA` y `MODO_ON`.
- Faltaba matriz canonica agente/universo/repo.
- Faltaba mapeo canonico a agentes operativos.
- Faltaba template repo-native con seccion obligatoria de agentes SDU-CN.
- Faltaban validadores locales para bloquear septimo agente, tool/adaptor drift,
  OpenAI como autoridad y live sin target.

## Reducciones Incorrectas Detectadas

No se detecto que los seis agentes fueran tratados como tools en el canon raiz,
pero si existia ambiguedad por coexistencia con agentes operativos de Cabina.
La correccion es separar:

- agente canonico SDU-CN: gobierna, evalua, valida, narra o habilita bajo orden;
- agente operativo Cabina: enruta, ejecuta, versiona o evidencia.

## Mezclas Con Agentes Operativos

Los siguientes ids son operativos y no sustituyen al panteon canonico:

- `rey.control_plane_orchestrator`
- `court.openai_dispatcher`
- `sdu-triage-agent`
- `court.sdu_gate`
- `court.seshat_evidence`
- `court.thot_schema`
- `rey.frontier_guardian`
- `universe.escribania_tower`
- `universe.modo_on_tower`

## Correccion Requerida

Elevar los seis agentes SDU-CN como identidades canonicas suprarrepo,
multiuniverso y bajo orden humana; enlazarlos a los agentes operativos sin
convertirlos en tools, adapters TGE ni runtime local.

## Stop Condition

`canonical_agent_missing`, `seventh_agent_created`,
`canonical_agent_treated_as_tool`, `canonical_agent_treated_as_tge_adapter`,
`openai_treated_as_authority_source`, `microsoft_live_without_target`.
