# SDU Agent MCP Connection Policy

Consume AGENTS.md and governance/canon/TCU_RISK_TIER_POLICY_CONSUMER.json.
Approval is high_only: mock, READ and bounded LOW work do not require a new
approval. HIGH positive effects retain explicit authority for the exact object.

MCP_CONNECTION_REGISTRY_20260603.csv and MCP_DEV_ACTIVATION_MATRIX_20260603.csv
describe the available scope of each connection. Template, contract-only and
mock rows do not assert a live connected adapter. Their out-of-scope actions
remain unavailable in those specific implementations, not globally forbidden
on Microsoft, OpenAI or Cloud.

READ requires available authenticated capability, exact binding/target and
minimization. LOW writes additionally require owner, precheck, reversibility or
compensation and postcheck. The result supplies operation-scoped evidence;
neither an approval receipt nor global audit evidence is a prerequisite.
A missing target, tool or credential returns RESOLUTION_REQUIRED for that
operation, preserving its tier and other executable work.

Codex Cloud may apply an authorized repo-scoped patch when the task allows it.
Review-only tasks retain their requested read scope. Merge, permission changes,
secret exposure and production effects keep their HIGH boundaries.
The local bridge remains loopback/mock. Never version credential material.
