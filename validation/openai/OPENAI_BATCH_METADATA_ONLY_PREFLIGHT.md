# OpenAI Batch Metadata-Only Preflight

## Estado
OPENAI_BATCH_BLOCKED_KEY_MISSING

## Resultado
- Batch input exists: yes
- Manifest exists: yes
- Lines: 5222
- Valid JSONL lines: 5222
- Invalid JSONL lines: 0
- OPENAI_API_KEY env present: False
- D:\.env.local read: no
- Secret signal count: 0
- Email signal count: 0
- Naive numeric phone-like signal count: 1369
- Contextual phone signal count: 0
- DNI/CUIT/CUIL keyword count: 0
- Redaction PASS: True
- Cost gate: POR_DEFINIR
- Submitted live: no
- Body printed: no
- Secret printed: no

## False Positive Control
The broad numeric scanner matched technical IDs/counters. The security decision uses contextual phone indicators plus numeric pattern to avoid false positives.

## Batch Shape
- Models: gpt-4.1-mini
- URLs: /v1/responses

## Decision
No Batch API submission was executed because the process environment does not expose OPENAI_API_KEY and the cost gate remains POR_DEFINIR.

## Stop Condition
key_missing_or_cost_gate_missing_or_secret_risk_or_invalid_jsonl
