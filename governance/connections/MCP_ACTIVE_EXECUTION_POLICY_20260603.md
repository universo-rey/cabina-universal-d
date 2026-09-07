# MCP active execution policy

MCP read-only and mock execute directly when the required connection is available.
Known bounded writes are LOW by default. Consume AGENTS.md and
governance/canon/TCU_RISK_TIER_POLICY_CONSUMER.json; only positive HIGH effects
require separate explicit authority.

Resolve the tool, capability, identity, exact binding and target. LOW writes
also need precheck, rollback or compensation and postcheck. Keep result evidence
proportional to the operation. Missing prerequisites produce RESOLUTION_REQUIRED
for that substep, without downgrading the rest of the system.

Offline contract checks:
- python scripts/validators/sdu_mcp_dev_activation_validator.py
- node local-agent-bridge/tests/mock_bridge_flow.mjs
- python scripts/validators/sdu_dev_activation_secret_contract_validator.py

Mock and contract-only status do not prove a remote connection. No live adapter
or credential is created by validating these files. Secret values remain outside
the repository and logs. Stop only the affected operation for unresolved target,
untrusted writable server, credential exposure or HIGH effect without authority.
