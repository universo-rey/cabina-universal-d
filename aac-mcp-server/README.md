# AAC MCP Server

Local stdio MCP server for the governed Agile Agent Canvas surface in this
workspace.

It exposes direct MCP tools for reading the AAC native roster, reading board
context, reading extension capabilities and preparing a governed native-agent
invocation packet. It does not call OpenAI, Microsoft, Jira, remote GitHub,
production or external providers.

## Tools

- `aac_list_native_agents`: lists the 21 native AAC agents from the governed
  repo matrix.
- `aac_get_board_context`: returns the mother-board, auxiliary-board and active
  native/Cabina agent layer context.
- `aac_get_extension_capabilities`: reads the local VS Code Insiders extension
  manifest and reports available AAC commands and language model tools.
- `aac_prepare_native_invocation`: prepares a non-executing invocation packet
  for an AAC native agent and story.
- `aac_write_artifact_gated`: writes one allowlisted AAC board artifact only
  when `target_path`, `owner`, `rollback`, `postcheck` and explicit gate
  approval are present. With `execute=false`, it validates and prepares without
  writing.

## Run

```powershell
npm test --prefix aac-mcp-server
node aac-mcp-server/src/index.mjs
```

Workspace MCP registration lives in `.vscode/mcp.json`.

## Boundary

- local stdio only
- no secrets
- no live provider calls
- no remote mutation
- no production
- no direct native AAC execution claim unless a callable extension tool exists
- no AAC artifact write unless target, owner, rollback, postcheck and gate are
  concrete and approved
