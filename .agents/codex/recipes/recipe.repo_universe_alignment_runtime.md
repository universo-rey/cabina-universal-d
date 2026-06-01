# recipe.repo_universe_alignment_runtime

1. Read `GITHUB_BASE_WORK_MATRIX.csv`, `AGENT_DEFAULT_SKILL_ASSIGNMENT_MATRIX.csv`, `AGENT_TOOL_RECIPE_SKILL_MATRIX.csv`, `TOOL_INDEX.csv`, `RECIPE_INDEX.csv`, `PLUGIN_USAGE_MATRIX.csv` and `agents.json`.
2. Confirm every active repo has a GitHub route, owner agent, default skill bundle and local-only runtime boundary.
3. Confirm every agent has default skills, recipes, tools and plugins assigned by purpose.
4. Run `tool.repo_alignment_runtime` in local synthetic mode only.
5. Stop before OpenAI API live, Microsoft live, production, permission changes, force push, merge, remote agent persistence or secrets.
6. Record the runtime result path and validators in the closeout.
