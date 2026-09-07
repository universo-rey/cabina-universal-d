# SDU Agent Runtime

The package provides deterministic local triage. Its compatibility mode label
is full_live_governed; that label is not evidence of an executed live call.

The active security contract is governance/agents/AGENTS_SDK_SECURITY_POLICY.md.
Microsoft, OpenAI, SDK tools/handoffs and Cloud use proportional policy:
READ is direct; known bounded LOW writes need no separate order; positive
HIGH effects require exact authority. Missing capabilities stop only the
affected operation.

triage_request accepts an application-owned operation_resolver(operation_ref).
Resolved effects and bindings determine routing; free text and caller tiers
cannot grant authority. READ/LOW can return ready_for_dispatch, HIGH routes
to authority resolution, and missing prerequisites return resolution_required.
The triage does not execute tools, resolve credentials or install a dispatcher.
Its external_writes=forbidden field describes that local no-I/O implementation.

The existing PR #56 OpenAI smoke is separate from these offline tests. Setup
and maintenance scripts remain under .agents/codex/scripts. Running a smoke
is not a prerequisite for an unrelated READ/LOW operation.

Precision markers:
- SDU_TRIAGE_AGENT_IMPLEMENTATION=full_live_governed
- LIVE_RUNTIME_VALIDATION=external_governed_smoke
- SETUP_SCRIPT_VERSIONED=yes
- MAINTENANCE_SCRIPT_VERSIONED=yes
- SETUP_SCRIPT_SELF_SUFFICIENT=yes
- DEPENDENCY_INSTALL=openai|openai-agents
- PWSH_PRECHECK=yes

Run offline regression checks:
python -m unittest discover -s apps/sdu-agent-runtime/tests
