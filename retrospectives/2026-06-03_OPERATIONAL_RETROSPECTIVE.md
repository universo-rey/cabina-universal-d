# Operational Retrospective

## Estado
OPERATIONAL_RETROSPECTIVE_READY

## Que Funciono
- The metadata-only boundary held across Dataverse, Work Queues, OpenAI advisory output and runtime evidence.
- Grouped versioning made PR #64 reviewable despite broad scope.
- Change-Aware Full-Coverage stayed as a full gate, not test selection.
- `--match-head-commit` prevented stale PR merges.
- The one-flow/one-item runtime lane proved productive execution without opening uncontrolled automation.

## Que No Funciono
- Some evidence paths were outside the default allowlist and required explicit forced staging.
- Back-reference target identity was not available at runtime, so final target update could not safely complete.
- The first CI pass treated governed secret-boundary evidence too broadly until the allowlist fix.

## Que Fue Lento
- Repeated manual reconstruction of capability chains.
- Reading large matrices without focused source maps.
- Re-validating already stable surfaces when the material change was documentary.

## Bloqueos Correctos
- OpenAI Batch stayed blocked when key/cost gate was not complete.
- Target update stayed blocked when exact candidates were 0.
- PROD, TEST and Default stayed out of every runtime lane.
- Flows were created disabled and later restored disabled after the controlled runtime test.

## Bloqueo Excesivo
- Documentary paths such as runtime/readback evidence were ignored by default and needed explicit `git add -f`. This is safe but costly; it should be a reviewed allowlist decision, not an ad hoc habit.

## Paralelizacion Mejorable
- Connection dedup, Dataverse schema validation, Work Queue payload contract and OpenAI metadata schema validation could run in parallel after shared source freeze.
- Index updates should remain serial because they share write scope.

## Debio Ser Skill Desde El Inicio
- Dataverse metadata-only provisioning.
- Work Queue pilot binding.
- Runtime one-flow/one-item activation.
- Back-reference exact mapping guard.
- Retrospective-to-skill extraction.

## Debio Ser Recipe Desde El Inicio
- Raw-to-canonical-to-seed registry pipeline.
- Mapping record before target write.
- Post-merge live state freeze.
- Credential gate with no secret read.

## Debio Ser Validador Desde El Inicio
- Work Queue payload contract.
- Runtime one-flow/one-item contract.
- Back-reference exactness.
- No infinite readback chain.

## Prompt Conservador
The prompts were correctly conservative around PROD, TEST, Default, secrets and writes. The excessive part was repeating full exploratory audits when source evidence and remote checks were already green.

## Prompt Suficientemente Seguro
The runtime prompt that limited execution to one DEV flow and one metadata-only item was the right shape: exact identity, bounded action, rollback, postcheck and stop condition.

## Patron A Propagar
Freeze state, execute the smallest exact live action, restore safe state, then version evidence and validators through GitHub.

## Patron Que No Debe Repetirse
Never infer a target row from nearby metadata. Never convert advisory OpenAI output into canon without validation.

## Runtime 1 Flow / 1 Item
It proved that live governed execution can be useful without becoming broad automation. The reusable rule is: exact flow, exact item, metadata-only payload, restore disabled state, verify active count 0.

## Mapping Metadata-Only Sin Target Final
The mapping record is valid as traceability because it does not pretend the unresolved target exists. It is not a substitute for final back-reference update.

## 0 Candidatos Exactos
When exact target candidates are 0, the only safe action is to record evidence or request exact target identity. A write to a guessed target is blocked.
