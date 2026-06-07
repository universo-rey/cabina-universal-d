# Agent Memory Sync

This file is the repo-local governed sync target for the VS Code Insiders
Agent Memory extension.

Configured source:

- `agentMemory.storageBackend`: `disk`
- `agentMemory.autoSyncToFile`:
  `.agents/codex/workpapers/codex.workspace_guardian/AGENT_MEMORY_SYNC.md`
- `agentMemory.tldr.enabled`: `false`

Operational boundary:

- The visual Memory and Memory Log panels are driven by the VS Code Insiders
  Agent Memory language model tool.
- The tool is available inside VSI as `memory`, but it is not exposed as a
  callable MCP/tool in this Codex session.
- `.vscode/memory/` remains ignored by the root repo allowlist, so raw local
  memory files are not versioned by default.
- This sync file is versioned as governed workpaper evidence only.

Current status:

- Bridge configured.
- Visual panel refresh still requires a VSI agent/model turn that invokes the
  Agent Memory tool.
