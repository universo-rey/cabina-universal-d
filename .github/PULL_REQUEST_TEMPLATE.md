# Cabina Universal PR

## Agent

- agente:
- lead_agent:
- owner_agent:
- reviewer_agent:
- orden:
- superficie:
- skill:
- recipe:
- plugin:
- tool:
- base_sha:
- branch:
- lane:
- read_scope:
- write_scope:
- declared_file_set:
- lock_key:
- dependency:
- max_parallel:

## Change

- What changed:
- Why:
- Risk:
- Rollback:
- Postcheck:

## Boundaries

- [ ] No nested repo absorption
- [ ] No `git add .`
- [ ] Capability-use preflight declared from intake
- [ ] No Microsoft live
- [ ] No OpenAI API live
- [ ] No production
- [ ] No permissions or visibility changes
- [ ] No secrets or regulated data
- [ ] Merge only with approved lifecycle or explicit merge order, fixed HEAD and green checks
- [ ] GitHub Actions remain validation-only with `contents: read`

## Validation

- validator:
- specific_validator:
- capability_use_hardening_validator:
- autonomous_agent_execution_validator:
- codex_cloud_environment_status:
- GitHub Actions:
- evidence:

## Closeout

- estado:
- stop_condition:
- proximos_carriles:
