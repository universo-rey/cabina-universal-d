# Agent Workpapers

Status: LOCAL_GOVERNED_WORKPAPERS_ACTIVE

This folder turns the local Codex agent layer into governed operating workpapers. It does not create remote persistent agents and does not authorize Microsoft live, production, tenant writes, secrets, cost, or broad regulated reads by itself.

Every agent has a folder with current workpaper, routing map, evidence log, decision log, open items and validation log. Sanitized workpapers are repo-visible in this root wrapper so GitHub Actions can validate the agent layer without reading external repos or live systems.
