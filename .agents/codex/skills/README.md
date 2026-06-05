# Skills

This folder maps external and repo-local Codex skills to local
`.agents\codex` sublevels.

It does not install or execute skills by itself. It tells the router which skill
family belongs to each agent lane.

Source-first rule: prefer `SOURCE_TCU_SKILLS_INDEX.csv`, `SOURCE_TCU_PLUGINS_INDEX.csv`, and copied SDK references before defining a new skill lane.

Storage rule:

- Portable cabina skills live in `.agents\skills\<skill>\SKILL.md`.
- Governance catalog rows live here in `SKILL_USAGE_MATRIX.csv` and
  `SUBSKILL_USAGE_MATRIX.csv`.
- Repo-local skill metadata quality lives here in
  `SKILL_METADATA_QUALITY_MATRIX.csv` and is explained in
  `SKILL_METADATA_GOVERNANCE.md`.
- Machine-global skill roots are runtime installs, not repo source of truth.
