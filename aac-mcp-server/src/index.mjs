import fs from "node:fs";
import path from "node:path";
import readline from "node:readline";
import { fileURLToPath } from "node:url";

const SERVER_NAME = "aac-mcp-server";
const SERVER_VERSION = "0.1.0";
const PROTOCOL_VERSION = "2024-11-05";

const ALLOWED_WRITE_TARGETS = new Set([
  ".agileagentcanvas-context/vision.json",
  ".agileagentcanvas-context/discovery/product-brief.json",
  ".agileagentcanvas-context/planning/prd.json",
  ".agileagentcanvas-context/planning/epics.json",
  ".agileagentcanvas-context/bmm/sprint-status.json"
]);

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

function repoRoot() {
  return path.resolve(process.env.AAC_MCP_REPO_ROOT || path.join(__dirname, "..", ".."));
}

function safeJoin(root, relativePath) {
  const resolved = path.resolve(root, relativePath);
  const normalizedRoot = path.resolve(root);
  if (resolved !== normalizedRoot && !resolved.startsWith(`${normalizedRoot}${path.sep}`)) {
    throw new Error(`Path escapes repo root: ${relativePath}`);
  }
  return resolved;
}

function parseCsv(text) {
  const rows = [];
  let row = [];
  let value = "";
  let quoted = false;

  for (let index = 0; index < text.length; index += 1) {
    const char = text[index];
    const next = text[index + 1];
    if (quoted) {
      if (char === '"' && next === '"') {
        value += '"';
        index += 1;
      } else if (char === '"') {
        quoted = false;
      } else {
        value += char;
      }
      continue;
    }
    if (char === '"') {
      quoted = true;
    } else if (char === ",") {
      row.push(value);
      value = "";
    } else if (char === "\n") {
      row.push(value);
      rows.push(row);
      row = [];
      value = "";
    } else if (char !== "\r") {
      value += char;
    }
  }
  if (value.length > 0 || row.length > 0) {
    row.push(value);
    rows.push(row);
  }

  const [headers, ...records] = rows.filter((line) => line.some((cell) => cell.trim() !== ""));
  if (!headers) return [];
  return records.map((record) => Object.fromEntries(
    headers.map((header, index) => [header, record[index] ?? ""])
  ));
}

function readCsv(root, relativePath) {
  return parseCsv(fs.readFileSync(safeJoin(root, relativePath), "utf8"));
}

function readJson(root, relativePath) {
  return JSON.parse(fs.readFileSync(safeJoin(root, relativePath), "utf8"));
}

function writeJson(root, relativePath, value) {
  const target = safeJoin(root, relativePath);
  fs.writeFileSync(target, `${JSON.stringify(value, null, 2)}\n`, "utf8");
  return target;
}

function inferExtensionVersion(manifestPath) {
  const normalized = String(manifestPath || "").replaceAll("\\", "/");
  return normalized.match(/agileagentcanvas-([^/]+)/)?.[1] || "UNKNOWN";
}

function matrixFallbackExtension(nativeAgents, manifestPath, fallbackReason) {
  return {
    packagePath: "UNAVAILABLE_LOCAL_EXTENSION_PACKAGE",
    packageJson: {
      name: "agileagentcanvas",
      version: inferExtensionVersion(manifestPath),
      activationEvents: [],
      contributes: {
        commands: [],
        languageModelTools: []
      }
    },
    manifestPath: manifestPath || "NO_DECLARADO",
    manifestRows: nativeAgents,
    extensionPackageAvailable: false,
    capabilitiesSource: "repo_local_aac_native_agents_matrix_fallback",
    fallbackReason
  };
}

function readExtensionPackage(nativeAgents) {
  const manifestPath = nativeAgents[0]?.native_manifest_path;
  if (!manifestPath) {
    return matrixFallbackExtension(nativeAgents, manifestPath, "native_manifest_path_missing");
  }
  if (process.env.AAC_MCP_FORCE_MATRIX_FALLBACK === "true") {
    return matrixFallbackExtension(nativeAgents, manifestPath, "forced_matrix_fallback");
  }
  const packagePath = path.resolve(path.dirname(manifestPath), "..", "..", "..", "package.json");
  if (!fs.existsSync(manifestPath) || !fs.existsSync(packagePath)) {
    return matrixFallbackExtension(nativeAgents, manifestPath, "local_extension_path_unavailable");
  }
  const packageJson = JSON.parse(fs.readFileSync(packagePath, "utf8"));
  const manifestRows = parseCsv(fs.readFileSync(manifestPath, "utf8"));
  return {
    packagePath,
    packageJson,
    manifestPath,
    manifestRows,
    extensionPackageAvailable: true,
    capabilitiesSource: "local_vscode_insiders_extension_package",
    fallbackReason: null
  };
}

function responseFormat(params) {
  return params?.response_format === "json" ? "json" : "markdown";
}

function textResult(output, format = "markdown") {
  const text = format === "json" ? JSON.stringify(output, null, 2) : output.markdown || JSON.stringify(output, null, 2);
  return {
    content: [{ type: "text", text }],
    structuredContent: output
  };
}

function paginate(items, limit = 50, offset = 0) {
  const safeLimit = Math.min(Math.max(Number(limit) || 50, 1), 100);
  const safeOffset = Math.max(Number(offset) || 0, 0);
  const page = items.slice(safeOffset, safeOffset + safeLimit);
  return {
    total_count: items.length,
    count: page.length,
    offset: safeOffset,
    limit: safeLimit,
    has_more: safeOffset + page.length < items.length,
    next_offset: safeOffset + page.length < items.length ? safeOffset + page.length : null,
    items: page
  };
}

function loadState() {
  const root = repoRoot();
  const nativeAgents = readCsv(root, ".agents/codex/matrices/AAC_NATIVE_AGENTS_20260608.csv");
  const nativeUse = readCsv(root, ".agents/codex/matrices/AAC_NATIVE_AGENT_USE_FOR_VSI_20260608.csv");
  const cabinaAgents = readCsv(root, ".agents/codex/matrices/CABINA_GOVERNANCE_AGENTS_FOR_VSI_20260608.csv");
  const epics = readJson(root, ".agileagentcanvas-context/planning/epics.json");
  const sprintStatus = readJson(root, ".agileagentcanvas-context/bmm/sprint-status.json");
  return { root, nativeAgents, nativeUse, cabinaAgents, epics, sprintStatus };
}

function normalizeWriteTarget(targetPath) {
  if (typeof targetPath !== "string" || targetPath.trim() === "") {
    throw new Error("target_path is required for gated AAC writes.");
  }
  const normalized = targetPath.trim().replaceAll("\\", "/").replace(/^\.\//, "");
  const relative = normalized.startsWith(".agileagentcanvas-context/")
    ? normalized
    : `.${normalized.startsWith("/") ? "" : "/"}${normalized}`;
  if (!ALLOWED_WRITE_TARGETS.has(relative)) {
    throw new Error(`target_path '${targetPath}' is not in the AAC gated write allowlist.`);
  }
  return relative;
}

function requireNonEmptyString(value, fieldName) {
  if (typeof value !== "string" || value.trim() === "") {
    throw new Error(`${fieldName} is required for gated AAC writes.`);
  }
  return value.trim();
}

function validateWriteGate(params) {
  const target_path = normalizeWriteTarget(params.target_path);
  const owner = requireNonEmptyString(params.owner, "owner");
  const rollback = requireNonEmptyString(params.rollback, "rollback");
  const postcheck = Array.isArray(params.postcheck)
    ? params.postcheck.map((item) => requireNonEmptyString(item, "postcheck item"))
    : [];
  if (postcheck.length === 0) {
    throw new Error("postcheck must contain at least one concrete validation command or action.");
  }
  const gate = params.gate;
  if (!gate || typeof gate !== "object" || Array.isArray(gate)) {
    throw new Error("gate object is required for gated AAC writes.");
  }
  const gate_id = requireNonEmptyString(gate.gate_id, "gate.gate_id");
  const approval_status = requireNonEmptyString(gate.approval_status, "gate.approval_status");
  const approval_ref = requireNonEmptyString(gate.approval_ref, "gate.approval_ref");
  if (!["APPROVED_EXPLICIT", "PENDING_APPROVAL_ONLY"].includes(approval_status)) {
    throw new Error("gate.approval_status must be APPROVED_EXPLICIT or PENDING_APPROVAL_ONLY.");
  }
  const content_json = params.content_json;
  if (!content_json || typeof content_json !== "object" || Array.isArray(content_json)) {
    throw new Error("content_json object is required for gated AAC writes.");
  }
  return {
    target_path,
    owner,
    rollback,
    postcheck,
    gate: { gate_id, approval_status, approval_ref },
    content_json
  };
}

const tools = [
  {
    name: "aac_list_native_agents",
    description: "List governed Agile Agent Canvas native agents from the repo-local AAC roster. Read-only and local-only.",
    inputSchema: {
      type: "object",
      properties: {
        module: { type: "string", description: "Optional module filter such as core, bmm, bmb, tea or cis." },
        activation_status: { type: "string", description: "Optional activation status filter." },
        limit: { type: "number", minimum: 1, maximum: 100, default: 50 },
        offset: { type: "number", minimum: 0, default: 0 },
        response_format: { type: "string", enum: ["markdown", "json"], default: "markdown" }
      },
      additionalProperties: false
    },
    annotations: { readOnlyHint: true, destructiveHint: false, idempotentHint: true, openWorldHint: false }
  },
  {
    name: "aac_get_board_context",
    description: "Read the VSI Agile Agent Canvas mother-board context and Cabina governance boundary from local artifacts. Read-only.",
    inputSchema: {
      type: "object",
      properties: {
        include_stories: { type: "boolean", default: false },
        response_format: { type: "string", enum: ["markdown", "json"], default: "markdown" }
      },
      additionalProperties: false
    },
    annotations: { readOnlyHint: true, destructiveHint: false, idempotentHint: true, openWorldHint: false }
  },
  {
    name: "aac_get_extension_capabilities",
    description: "Read local VS Code Insiders Agile Agent Canvas extension commands, language model tools and native manifest. Read-only.",
    inputSchema: {
      type: "object",
      properties: {
        response_format: { type: "string", enum: ["markdown", "json"], default: "markdown" }
      },
      additionalProperties: false
    },
    annotations: { readOnlyHint: true, destructiveHint: false, idempotentHint: true, openWorldHint: false }
  },
  {
    name: "aac_prepare_native_invocation",
    description: "Prepare a governed non-executing invocation packet for an AAC native agent and story. Does not call VS Code commands, external providers or any live surface.",
    inputSchema: {
      type: "object",
      properties: {
        story_id: { type: "string", description: "Story id such as S-6.1, S-6.2, S-6.3, S-6.4, S-6.5 or EPIC-6." },
        native_agent_id: { type: "string", description: "AAC native agent id such as canvas-integrator, sm, dev or architect." },
        response_format: { type: "string", enum: ["markdown", "json"], default: "markdown" }
      },
      required: ["story_id", "native_agent_id"],
      additionalProperties: false
    },
    annotations: { readOnlyHint: true, destructiveHint: false, idempotentHint: true, openWorldHint: false }
  },
  {
    name: "aac_write_artifact_gated",
    description: "Write one allowlisted AAC board artifact only when target_path, owner, rollback, postcheck and explicit gate approval are present. Defaults to non-writing preparation.",
    inputSchema: {
      type: "object",
      properties: {
        target_path: {
          type: "string",
          enum: [...ALLOWED_WRITE_TARGETS],
          description: "Exact repo-local AAC artifact path to update."
        },
        content_json: {
          type: "object",
          description: "Full replacement JSON object for the allowlisted artifact."
        },
        owner: { type: "string", description: "Human or governed owner responsible for this write." },
        rollback: { type: "string", description: "Concrete rollback command or action." },
        postcheck: {
          type: "array",
          minItems: 1,
          items: { type: "string" },
          description: "Concrete validation commands or actions to run after the write."
        },
        gate: {
          type: "object",
          properties: {
            gate_id: { type: "string", description: "Gate id, for example GATE_AAC_ARTIFACT_WRITE." },
            approval_status: { type: "string", enum: ["APPROVED_EXPLICIT", "PENDING_APPROVAL_ONLY"] },
            approval_ref: { type: "string", description: "Human approval reference for the write." }
          },
          required: ["gate_id", "approval_status", "approval_ref"],
          additionalProperties: false
        },
        execute: { type: "boolean", default: false, description: "When false, prepare and validate only. A write requires true plus APPROVED_EXPLICIT." },
        response_format: { type: "string", enum: ["markdown", "json"], default: "markdown" }
      },
      required: ["target_path", "content_json", "owner", "rollback", "postcheck", "gate"],
      additionalProperties: false
    },
    annotations: { readOnlyHint: false, destructiveHint: true, idempotentHint: false, openWorldHint: false }
  }
];

function listNativeAgents(params = {}) {
  const { nativeAgents } = loadState();
  let rows = nativeAgents;
  if (params.module) rows = rows.filter((row) => row.module === params.module);
  if (params.activation_status) rows = rows.filter((row) => row.activation_status === params.activation_status);
  const page = paginate(rows, params.limit, params.offset);
  const output = {
    status: "OK",
    direct_invocation_from_codex: false,
    activation_boundary: "repo_local_board_activation_only",
    ...page
  };
  output.markdown = [
    "# AAC Native Agents",
    "",
    `Total: ${page.total_count}; showing ${page.count}`,
    `Direct Codex invocation: ${output.direct_invocation_from_codex}`,
    "",
    ...page.items.map((agent) => `- ${agent.native_agent_id} (${agent.display_name}) - ${agent.module} - ${agent.activation_status || agent.status}`)
  ].join("\n");
  return textResult(output, responseFormat(params));
}

function getBoardContext(params = {}) {
  const { nativeAgents, nativeUse, cabinaAgents, epics, sprintStatus } = loadState();
  const epic6 = epics?.content?.epics?.find((epic) => epic.id === "EPIC-6") || epics?.epics?.find?.((epic) => epic.id === "EPIC-6");
  const stories = epic6?.stories || [];
  const output = {
    status: "OK",
    primary_board: {
      board_id: "vsi_agile_agent_canvas_mother_board",
      explicit_name: "Agile Agent Canvas",
      role: "tablero_principal_madre",
      native_agent_status: nativeAgents.every((row) => row.activation_status === "ACTIVE_AAC_NATIVE_TEAM_GOVERNED")
        ? "ACTIVE_AAC_NATIVE_TEAM_GOVERNED"
        : "NEEDS_REVIEW",
      native_agent_count: nativeAgents.length,
      native_use_count: nativeUse.length
    },
    auxiliary_board: {
      explicit_name: "Control de Agentes de Cabina",
      role: "tablero_auxiliar_cola_control",
      not_primary_board: true
    },
    cabina_governance: {
      status: cabinaAgents.every((row) => row.status === "ACTIVE_LOCAL_GOVERNED_USE")
        ? "ACTIVE_CABINA_GOVERNED_WORK_LAYER"
        : "NEEDS_REVIEW",
      agent_count: cabinaAgents.length,
      authority: "cabina_governs_vsi_agile_agent_canvas_board"
    },
    sprint_status: sprintStatus?.metadata?.status || sprintStatus?.status || "NO_DECLARADO",
    direct_invocation_from_codex: false,
    live_executed: false
  };
  if (params.include_stories) {
    output.stories = stories.map((story) => ({
      id: story.id,
      title: story.title,
      status: story.status,
      native_status: story.governance?.agentOrder?.nativeAacAgentAssignment?.status || "NO_DECLARADO"
    }));
  }
  output.markdown = [
    "# AAC Board Context",
    "",
    `Primary: ${output.primary_board.explicit_name} (${output.primary_board.native_agent_status})`,
    `Native agents: ${output.primary_board.native_agent_count}; native use rows: ${output.primary_board.native_use_count}`,
    `Auxiliary: ${output.auxiliary_board.explicit_name}`,
    `Cabina layer: ${output.cabina_governance.status}`,
    `Direct Codex invocation: ${output.direct_invocation_from_codex}`,
    `Live executed: ${output.live_executed}`
  ].join("\n");
  return textResult(output, responseFormat(params));
}

function getExtensionCapabilities(params = {}) {
  const { nativeAgents } = loadState();
  const {
    packagePath,
    packageJson,
    manifestPath,
    manifestRows,
    extensionPackageAvailable,
    capabilitiesSource,
    fallbackReason
  } = readExtensionPackage(nativeAgents);
  const commands = packageJson.contributes?.commands?.map((command) => ({
    command: command.command,
    title: command.title
  })) || [];
  const languageModelTools = packageJson.contributes?.languageModelTools?.map((tool) => ({
    name: tool.name,
    displayName: tool.displayName
  })) || [];
  const output = {
    status: "OK",
    extension_name: packageJson.name,
    extension_version: packageJson.version,
    activation_events: packageJson.activationEvents || [],
    command_count: commands.length,
    language_model_tool_count: languageModelTools.length,
    native_manifest_agent_count: manifestRows.length,
    package_path: packagePath,
    manifest_path: manifestPath,
    extension_package_available: extensionPackageAvailable,
    capabilities_source: capabilitiesSource,
    fallback_reason: fallbackReason,
    commands,
    language_model_tools: languageModelTools,
    direct_invocation_from_codex: false
  };
  output.markdown = [
    "# AAC Extension Capabilities",
    "",
    `Extension: ${output.extension_name} ${output.extension_version}`,
    `Activation events: ${output.activation_events.join(", ")}`,
    `Commands: ${output.command_count}`,
    `Language model tools: ${output.language_model_tool_count}`,
    `Native manifest agents: ${output.native_manifest_agent_count}`,
    `Capabilities source: ${output.capabilities_source}`,
    `Direct Codex invocation: ${output.direct_invocation_from_codex}`
  ].join("\n");
  return textResult(output, responseFormat(params));
}

function prepareNativeInvocation(params = {}) {
  const { nativeAgents, nativeUse } = loadState();
  const nativeAgent = nativeAgents.find((row) => row.native_agent_id === params.native_agent_id);
  if (!nativeAgent) {
    throw new Error(`Unknown AAC native agent '${params.native_agent_id}'. Use aac_list_native_agents first.`);
  }
  const useRow = nativeUse.find((row) => row.story_id === params.story_id && row.native_agent_id === params.native_agent_id)
    || nativeUse.find((row) => row.story_id === params.story_id);
  if (!useRow) {
    throw new Error(`No governed AAC native use row found for story '${params.story_id}'.`);
  }
  const output = {
    status: "PREPARED_NOT_EXECUTED",
    story_id: params.story_id,
    native_agent_id: params.native_agent_id,
    display_name: nativeAgent.display_name,
    invocation_surface: useRow.invocation_surface,
    invocation_method: useRow.invocation_method,
    callable_from_codex_now: useRow.callable_from_codex_now,
    direct_invocation_from_codex: false,
    live_executed: false,
    external_sync: false,
    allowed_actions: useRow.allowed_actions.split("|").filter(Boolean),
    blocked_actions: useRow.blocked_actions.split("|").filter(Boolean),
    cabina_governed_work_agents: useRow.cabina_governed_work_agents.split("|").filter(Boolean),
    validator: useRow.validator,
    stop_condition: useRow.stop_condition,
    next_safe_action: "Use the VS Code Insiders Agile Agent Canvas command surface or keep execution through Cabina multi_agent_v1.spawn_agent; do not claim direct native invocation from this MCP server."
  };
  output.markdown = [
    "# AAC Native Invocation Packet",
    "",
    `Status: ${output.status}`,
    `Story: ${output.story_id}`,
    `Native agent: ${output.native_agent_id} (${output.display_name})`,
    `Invocation surface: ${output.invocation_surface}`,
    `Callable from Codex now: ${output.callable_from_codex_now}`,
    `Direct Codex invocation: ${output.direct_invocation_from_codex}`,
    `Live executed: ${output.live_executed}`,
    `Stop condition: ${output.stop_condition}`,
    "",
    output.next_safe_action
  ].join("\n");
  return textResult(output, responseFormat(params));
}

function writeArtifactGated(params = {}) {
  const writeRequest = validateWriteGate(params);
  const output = {
    tool: "aac_write_artifact_gated",
    target_path: writeRequest.target_path,
    owner: writeRequest.owner,
    rollback: writeRequest.rollback,
    postcheck: writeRequest.postcheck,
    gate: writeRequest.gate,
    execute_requested: params.execute === true,
    local_write_executed: false,
    live_executed: false,
    external_sync: false,
    status: "PREPARED_NOT_EXECUTED"
  };

  if (params.execute !== true) {
    output.stop_condition = "execute_false_prepare_only";
  } else if (writeRequest.gate.approval_status !== "APPROVED_EXPLICIT") {
    output.status = "PENDING_APPROVAL_ONLY";
    output.stop_condition = "explicit_gate_approval_missing";
  } else {
    const target = writeJson(repoRoot(), writeRequest.target_path, writeRequest.content_json);
    output.status = "EXECUTED_LOCAL_WRITE";
    output.local_write_executed = true;
    output.written_path = target;
    output.stop_condition = "repo_local_gated_write_completed_postcheck_required";
  }

  output.markdown = [
    "# AAC Gated Artifact Write",
    "",
    `Status: ${output.status}`,
    `Target: ${output.target_path}`,
    `Owner: ${output.owner}`,
    `Gate: ${output.gate.gate_id} (${output.gate.approval_status})`,
    `Execute requested: ${output.execute_requested}`,
    `Local write executed: ${output.local_write_executed}`,
    `Live executed: ${output.live_executed}`,
    `Stop condition: ${output.stop_condition}`,
    "",
    `Rollback: ${output.rollback}`,
    `Postcheck: ${output.postcheck.join(" | ")}`
  ].join("\n");
  return textResult(output, responseFormat(params));
}

const toolHandlers = {
  aac_list_native_agents: listNativeAgents,
  aac_get_board_context: getBoardContext,
  aac_get_extension_capabilities: getExtensionCapabilities,
  aac_prepare_native_invocation: prepareNativeInvocation,
  aac_write_artifact_gated: writeArtifactGated
};

function success(id, result) {
  return { jsonrpc: "2.0", id, result };
}

function failure(id, code, message) {
  return { jsonrpc: "2.0", id, error: { code, message } };
}

async function handleMessage(message) {
  const { id, method, params } = message;
  if (method === "initialize") {
    return success(id, {
      protocolVersion: PROTOCOL_VERSION,
      capabilities: { tools: {} },
      serverInfo: { name: SERVER_NAME, version: SERVER_VERSION }
    });
  }
  if (method === "notifications/initialized") {
    return null;
  }
  if (method === "tools/list") {
    return success(id, { tools });
  }
  if (method === "tools/call") {
    const name = params?.name;
    const handler = toolHandlers[name];
    if (!handler) return failure(id, -32601, `Unknown tool '${name}'`);
    try {
      return success(id, handler(params?.arguments || {}));
    } catch (error) {
      return success(id, {
        isError: true,
        content: [{ type: "text", text: `Error: ${error.message}` }],
        structuredContent: { status: "ERROR", message: error.message }
      });
    }
  }
  return failure(id, -32601, `Unsupported method '${method}'`);
}

export async function handleJsonRpcLine(line) {
  const message = JSON.parse(line);
  return handleMessage(message);
}

if (process.argv[1] === __filename) {
  const rl = readline.createInterface({ input: process.stdin, crlfDelay: Infinity });
  rl.on("line", async (line) => {
    if (!line.trim()) return;
    try {
      const response = await handleJsonRpcLine(line);
      if (response) process.stdout.write(`${JSON.stringify(response)}\n`);
    } catch (error) {
      process.stdout.write(`${JSON.stringify(failure(null, -32700, `Parse or handler error: ${error.message}`))}\n`);
    }
  });
}
