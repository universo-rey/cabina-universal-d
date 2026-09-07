# Agents SDK Security Policy

## Active contract

Consume AGENTS.md and governance/canon/TCU_RISK_TIER_POLICY_CONSUMER.json.
Microsoft, OpenAI and Cloud are classified by resolved effects. READ needs an
authenticated available capability, exact binding/target and minimization.
Known bounded writes default to LOW and require precheck, recovery or
compensation, postcheck and operation-scoped result; they need no separate order.
Positive HIGH effects require exact explicit authority. Secret exposure,
privilege mutation and professional decisions retain their specific boundaries.

SDK tools and handoffs follow that same contract. A tool being mentioned in
a registry or prompt does not prove that it is callable in this runtime.
Missing capabilities or bindings stop only that operation as RESOLUTION_REQUIRED.

## Local triage implementation

apps/sdu-agent-runtime performs deterministic routing without external calls.
Free text and caller risk labels cannot authorize execution or classify HIGH
effects away. The application supplies operation_resolver(operation_ref), which
must resolve the requested reference against its trusted capability and binding
source, returning concrete operation_ref/capability_id/binding_id/tenant/
exact_target, effects, capability_available and minimization. Write descriptors
also supply owner, precheck_passed, rollback_or_compensation and postcheck.
Effects use read, bounded_write or positive HIGH IDs from the canonical consumer;
the resolver must account for the capability ceiling and complete actual effects.

READ/LOW may return ready_for_dispatch; this is a routing result, not a call or
a permission grant. HIGH returns high_authority_required for the existing
authority lane. No live resolver or dispatcher is installed by this contract.
Without an operation reference, text remains local analysis, including discussion
of Microsoft, permissions, production and negated operations.
Without a matching resolver, an execution request returns resolution_required.

## Data, secrets and outputs

The offline fixtures use synthetic data; do not infer a global synthetic-only
restriction for an authenticated operational adapter. Minimize actual operation
data and never expose raw regulated data or credentials in prompts, logs or Git.
Existing live adapters may use credentials through their configured secret store;
offline validation does not need keys or API calls.

Outputs preserve agent_id, mode, decision, blocked_surfaces, next_action and
evidence, adding risk_tier and missing_prerequisites. The legacy evidence field
external_writes=forbidden describes this local classifier's no-write behavior,
not a platform-wide ban. Result evidence is scoped to the operation; no global
audit, repeated smoke or full-system proof is required.
