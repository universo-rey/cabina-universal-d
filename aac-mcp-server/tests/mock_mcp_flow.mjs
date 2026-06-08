import assert from "node:assert/strict";
import { spawn } from "node:child_process";
import path from "node:path";
import { fileURLToPath } from "node:url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const serverPath = path.resolve(__dirname, "..", "src", "index.mjs");
const repoRoot = path.resolve(__dirname, "..", "..");

const child = spawn(process.execPath, [serverPath], {
  cwd: repoRoot,
  env: { ...process.env, AAC_MCP_REPO_ROOT: repoRoot, AAC_MCP_FORCE_MATRIX_FALLBACK: "true" },
  stdio: ["pipe", "pipe", "pipe"]
});

let nextId = 1;
const pending = new Map();
let buffer = "";

child.stdout.on("data", (chunk) => {
  buffer += chunk.toString("utf8");
  let newline = buffer.indexOf("\n");
  while (newline >= 0) {
    const line = buffer.slice(0, newline);
    buffer = buffer.slice(newline + 1);
    if (line.trim()) {
      const message = JSON.parse(line);
      const resolve = pending.get(message.id);
      if (resolve) {
        pending.delete(message.id);
        resolve(message);
      }
    }
    newline = buffer.indexOf("\n");
  }
});

function request(method, params = {}) {
  const id = nextId;
  nextId += 1;
  const payload = { jsonrpc: "2.0", id, method, params };
  const promise = new Promise((resolve, reject) => {
    const timeout = setTimeout(() => {
      pending.delete(id);
      reject(new Error(`timeout waiting for ${method}`));
    }, 5000);
    pending.set(id, (message) => {
      clearTimeout(timeout);
      resolve(message);
    });
  });
  child.stdin.write(`${JSON.stringify(payload)}\n`);
  return promise;
}

try {
  const initialized = await request("initialize", {
    protocolVersion: "2024-11-05",
    capabilities: {},
    clientInfo: { name: "aac-mcp-test", version: "0.1.0" }
  });
  assert.equal(initialized.result.serverInfo.name, "aac-mcp-server");

  const listed = await request("tools/list");
  const toolNames = listed.result.tools.map((tool) => tool.name);
  assert.deepEqual(toolNames.sort(), [
    "aac_get_board_context",
    "aac_get_extension_capabilities",
    "aac_list_native_agents",
    "aac_prepare_native_invocation",
    "aac_write_artifact_gated"
  ].sort());

  const agents = await request("tools/call", {
    name: "aac_list_native_agents",
    arguments: { response_format: "json", limit: 100 }
  });
  assert.equal(agents.result.structuredContent.total_count, 21);
  assert.equal(agents.result.structuredContent.direct_invocation_from_codex, false);
  assert.ok(agents.result.structuredContent.items.every(
    (agent) => agent.activation_status === "ACTIVE_AAC_NATIVE_TEAM_GOVERNED"
  ));

  const board = await request("tools/call", {
    name: "aac_get_board_context",
    arguments: { include_stories: true, response_format: "json" }
  });
  assert.equal(board.result.structuredContent.primary_board.explicit_name, "Agile Agent Canvas");
  assert.equal(board.result.structuredContent.primary_board.native_agent_status, "ACTIVE_AAC_NATIVE_TEAM_GOVERNED");
  assert.equal(board.result.structuredContent.auxiliary_board.explicit_name, "Control de Agentes de Cabina");

  const capabilities = await request("tools/call", {
    name: "aac_get_extension_capabilities",
    arguments: { response_format: "json" }
  });
  assert.equal(capabilities.result.structuredContent.extension_name, "agileagentcanvas");
  assert.equal(capabilities.result.structuredContent.extension_package_available, false);
  assert.equal(capabilities.result.structuredContent.capabilities_source, "repo_local_aac_native_agents_matrix_fallback");
  assert.equal(capabilities.result.structuredContent.fallback_reason, "forced_matrix_fallback");
  assert.equal(capabilities.result.structuredContent.command_count, 0);
  assert.equal(capabilities.result.structuredContent.language_model_tool_count, 0);
  assert.equal(capabilities.result.structuredContent.native_manifest_agent_count, 21);

  const packet = await request("tools/call", {
    name: "aac_prepare_native_invocation",
    arguments: { story_id: "S-6.1", native_agent_id: "canvas-integrator", response_format: "json" }
  });
  assert.equal(packet.result.structuredContent.status, "PREPARED_NOT_EXECUTED");
  assert.equal(packet.result.structuredContent.direct_invocation_from_codex, false);
  assert.equal(packet.result.structuredContent.live_executed, false);

  const gatedWrite = await request("tools/call", {
    name: "aac_write_artifact_gated",
    arguments: {
      target_path: ".agileagentcanvas-context/planning/epics.json",
      content_json: { dry_run_only: true },
      owner: "rey.control_plane_orchestrator",
      rollback: "git restore -- .agileagentcanvas-context/planning/epics.json",
      postcheck: ["python scripts/validators/aac_mcp_server_validator.py"],
      gate: {
        gate_id: "GATE_AAC_ARTIFACT_WRITE",
        approval_status: "PENDING_APPROVAL_ONLY",
        approval_ref: "mock-client-no-write"
      },
      execute: false,
      response_format: "json"
    }
  });
  assert.equal(gatedWrite.result.structuredContent.status, "PREPARED_NOT_EXECUTED");
  assert.equal(gatedWrite.result.structuredContent.live_executed, false);
  assert.equal(gatedWrite.result.structuredContent.stop_condition, "execute_false_prepare_only");

  child.kill();
  console.log("AAC_MCP_SERVER_MOCK_FLOW_PASS");
} catch (error) {
  child.kill();
  throw error;
}
