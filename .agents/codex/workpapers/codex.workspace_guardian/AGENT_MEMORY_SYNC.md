# Agent Memory Sanitized Export Bridge

This file is the repo-local governed manual export target for sanitized VS
Code Insiders Agent Memory evidence.

Configured source:

- `agentMemory.storageBackend`: `disk`
- `agentMemory.autoSyncToFile`:
  `.vscode/memory/AGENT_MEMORY_SYNC.md`
- `agentMemory.tldr.enabled`: `false`

Operational boundary:

- The visual Memory and Memory Log panels are driven by the VS Code Insiders
  Agent Memory language model tool.
- The tool is available inside VSI as `memory`, but it is not exposed as a
  callable MCP/tool in this Codex session.
- `.vscode/memory/` remains ignored by the root repo allowlist, so raw
  extension memory and auto-sync output stay local-only.
- This workpaper is versioned only as a sanitized manual export bridge. Do not
  paste raw memory, secrets, broad regulated data, tokens, private prompts or
  tenant identifiers here.
- Any future export into this file must be manually reviewed, summarized and
  validated before staging.

Current status:

- Local-only auto-sync configured.
- Governed workpaper bridge configured for sanitized manual export only.
- Visual panel refresh still requires a VSI agent/model turn that invokes the
  Agent Memory tool.
