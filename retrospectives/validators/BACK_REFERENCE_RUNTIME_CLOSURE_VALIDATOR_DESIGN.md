# Back-Reference Runtime Closure Validator Design

## Estado
HECHO_VERIFICADO: BACK_REFERENCE_RUNTIME_CLOSURE_VALIDATOR_DESIGNED_AND_IMPLEMENTED

## Tool
- Path: .agents\codex\tools\local_validate_backreference_runtime_closure.ps1
- Mode: local evidence validator
- Live calls: none
- Secrets: none

## Contract
The validator reads the versioned runtime closure matrices and safe-state
postcheck. It blocks if:

- the original queue item lacks canonical_id, idempotency_key or correlation_id;
- the decision state is not a safe mapping/remediation state;
- a target update is marked executed without exact target evidence;
- the mapping record id is missing;
- additional item processed count exceeds 1;
- safe-state evidence does not show all flows off;
- PROD, TEST, Default, secrets, personal data or documents appear as touched.

## Evidence Inputs
- matrices\runtime\BACK_REFERENCE_RUNTIME_TRACE_SOURCE_MATRIX.csv
- matrices\runtime\BACK_REFERENCE_RUNTIME_CLOSURE_DECISION_MATRIX.csv
- matrices\runtime\BACK_REFERENCE_RUNTIME_WRITE_RESULT.csv
- matrices\runtime\BACK_REFERENCE_SECOND_ITEM_VALIDATION_RESULT.csv
- validation\runtime\BACK_REFERENCE_RUNTIME_SAFE_STATE_POSTCHECK.md

## Stop Condition
Any missing evidence file or failed invariant exits with FAIL and blocks PR
readiness.
