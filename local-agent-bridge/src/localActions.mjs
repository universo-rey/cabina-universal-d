import { spawn } from "node:child_process";
import fs from "node:fs";
import path from "node:path";

const POSTCHECK_ACTION_ID = "local.action.prepare_local_validation";
const CANVAS_LANE_REVIEW_ACTION_ID = "local.action.inspect_canvas_lane";
const TASK_QUEUE_REVIEW_ACTION_ID = "local.action.review_task_queue";
const LIVE_GATE_PACKET_REVIEW_ACTION_ID = "local.action.review_live_gate_packets";
const BRIDGE_CONTRACT_REVIEW_ACTION_ID = "local.action.review_bridge_contract";
const DASHBOARD_INTEGRITY_REVIEW_ACTION_ID = "local.action.review_dashboard_integrity";
const ACTION_BOUNDARY_REVIEW_ACTION_ID = "local.action.review_action_boundary";
const READINESS_BUNDLE_REVIEW_ACTION_ID = "local.action.review_readiness_bundle";
const UI_TRANSLATION_REVIEW_ACTION_ID = "local.action.review_ui_translation_integrity";
const TASK_LINEAGE_REVIEW_ACTION_ID = "local.action.review_task_lineage";
const CANVAS_STORY_SYNC_REVIEW_ACTION_ID = "local.action.review_canvas_story_sync";
const ROUTE_CONTRACT_SYNC_REVIEW_ACTION_ID = "local.action.review_route_contract_sync";
const SERVER_ENDPOINT_GUARD_REVIEW_ACTION_ID = "local.action.review_server_endpoint_guards";
const VALIDATOR_COVERAGE_REVIEW_ACTION_ID = "local.action.review_validator_coverage";
const ERROR_RESPONSE_SHAPE_REVIEW_ACTION_ID = "local.action.review_error_response_shape";
const POSTCHECK_ALLOWLIST_REVIEW_ACTION_ID = "local.action.review_postcheck_allowlist";
const SHELL_BLOCK_CONSISTENCY_REVIEW_ACTION_ID = "local.action.review_shell_block_consistency";
const DASHBOARD_SUMMARY_CONSISTENCY_REVIEW_ACTION_ID = "local.action.review_dashboard_summary_consistency";
const LOCAL_ACTION_STATUS_CONSISTENCY_REVIEW_ACTION_ID = "local.action.review_local_action_status_consistency";
const READINESS_COMPONENT_COVERAGE_REVIEW_ACTION_ID = "local.action.review_readiness_component_coverage";
const CANVAS_SCHEMA_HEALTH_REVIEW_ACTION_ID = "local.action.review_canvas_schema_health";
const TASK_QUEUE_PATH = ".agents/codex/matrices/VSCODE_INSIDERS_AGENT_TASK_QUEUE_20260606.csv";
const BRIDGE_CONTRACT_PATH = "local-agent-bridge/contracts/local-agent-bridge.contract.json";
const ROUTES_MATRIX_PATH = "local-agent-bridge/matrices/routes_matrix.csv";
const AGENT_OPERABILITY_INVENTORY_PATH = ".agents/codex/matrices/AGENTS_GLOBAL_OPERABILITY_INVENTORY_20260605.csv";
const LIVE_SEMAPHORE_MATRIX_PATH = ".agents/codex/matrices/AGENTS_SDK_LIVE_AGENT_GLOBAL_OPERABILITY_SEMAPHORE_MATRIX_20260605.csv";
const LIVE_GATE_QUEUE_PATH = ".agents/codex/matrices/AGENTS_SDK_LIVE_AGENT_GLOBAL_OPERABILITY_GATE_QUEUE_20260605.csv";
const AUTONOMOUS_EXECUTION_MATRIX_PATH = ".agents/codex/matrices/AUTONOMOUS_AGENT_EXECUTION_MATRIX_20260602.csv";
const AGILE_AGENT_CANVAS_GOVERNANCE_PATH = ".agents/codex/matrices/VSCODE_INSIDERS_AGILE_AGENT_CANVAS_GOVERNANCE_20260606.csv";
const CANVAS_ARTIFACT_PATHS = [
  ".agileagentcanvas-context/vision.json",
  ".agileagentcanvas-context/discovery/product-brief.json",
  ".agileagentcanvas-context/planning/prd.json",
  ".agileagentcanvas-context/planning/epics.json"
];
const CANVAS_SCHEMA_HEALTH_ARTIFACT_PATHS = [
  ".agileagentcanvas-context/bmm/sprint-status.json",
  ".agileagentcanvas-context/discovery/product-brief.json",
  ".agileagentcanvas-context/planning/prd.json",
  ".agileagentcanvas-context/planning/epics.json",
  ".agileagentcanvas-context/solutioning/requirements.json",
  ".agileagentcanvas-context/testing/test-cases.json",
  ".agileagentcanvas-context/testing/test-strategy.json"
];
const LIVE_GATE_PACKET_PATHS = [
  ".agents/codex/orders/ORDER_VSI_JIRA_READ_20260606.md",
  ".agents/codex/orders/ORDER_VSI_OPENAI_LIVE_20260606.md",
  ".agents/codex/orders/ORDER_VSI_MICROSOFT_LIVE_20260606.md",
  ".agents/codex/orders/ORDER_VSI_POWER_PLATFORM_DRY_RUN_20260607.md"
];

function getRequiredLocalActionIds() {
  return [
    CANVAS_LANE_REVIEW_ACTION_ID,
    TASK_QUEUE_REVIEW_ACTION_ID,
    POSTCHECK_ACTION_ID,
    LIVE_GATE_PACKET_REVIEW_ACTION_ID,
    BRIDGE_CONTRACT_REVIEW_ACTION_ID,
    DASHBOARD_INTEGRITY_REVIEW_ACTION_ID,
    ACTION_BOUNDARY_REVIEW_ACTION_ID,
    READINESS_BUNDLE_REVIEW_ACTION_ID,
    UI_TRANSLATION_REVIEW_ACTION_ID,
    TASK_LINEAGE_REVIEW_ACTION_ID,
    CANVAS_STORY_SYNC_REVIEW_ACTION_ID,
    ROUTE_CONTRACT_SYNC_REVIEW_ACTION_ID,
    SERVER_ENDPOINT_GUARD_REVIEW_ACTION_ID,
    VALIDATOR_COVERAGE_REVIEW_ACTION_ID,
    ERROR_RESPONSE_SHAPE_REVIEW_ACTION_ID,
    POSTCHECK_ALLOWLIST_REVIEW_ACTION_ID,
    SHELL_BLOCK_CONSISTENCY_REVIEW_ACTION_ID,
    DASHBOARD_SUMMARY_CONSISTENCY_REVIEW_ACTION_ID,
    LOCAL_ACTION_STATUS_CONSISTENCY_REVIEW_ACTION_ID,
    READINESS_COMPONENT_COVERAGE_REVIEW_ACTION_ID,
    CANVAS_SCHEMA_HEALTH_REVIEW_ACTION_ID
  ];
}

function getStructuredReviewActionIds() {
  return [
    CANVAS_LANE_REVIEW_ACTION_ID,
    TASK_QUEUE_REVIEW_ACTION_ID,
    LIVE_GATE_PACKET_REVIEW_ACTION_ID,
    BRIDGE_CONTRACT_REVIEW_ACTION_ID,
    DASHBOARD_INTEGRITY_REVIEW_ACTION_ID,
    ACTION_BOUNDARY_REVIEW_ACTION_ID,
    READINESS_BUNDLE_REVIEW_ACTION_ID,
    UI_TRANSLATION_REVIEW_ACTION_ID,
    TASK_LINEAGE_REVIEW_ACTION_ID,
    CANVAS_STORY_SYNC_REVIEW_ACTION_ID,
    ROUTE_CONTRACT_SYNC_REVIEW_ACTION_ID,
    SERVER_ENDPOINT_GUARD_REVIEW_ACTION_ID,
    VALIDATOR_COVERAGE_REVIEW_ACTION_ID,
    ERROR_RESPONSE_SHAPE_REVIEW_ACTION_ID,
    POSTCHECK_ALLOWLIST_REVIEW_ACTION_ID,
    SHELL_BLOCK_CONSISTENCY_REVIEW_ACTION_ID,
    DASHBOARD_SUMMARY_CONSISTENCY_REVIEW_ACTION_ID,
    LOCAL_ACTION_STATUS_CONSISTENCY_REVIEW_ACTION_ID,
    READINESS_COMPONENT_COVERAGE_REVIEW_ACTION_ID,
    CANVAS_SCHEMA_HEALTH_REVIEW_ACTION_ID
  ];
}

function commandSpec(label, command, args) {
  return { label, command, args };
}

function resolveSpawnSpec(spec) {
  if (process.platform !== "win32") {
    return { command: spec.command, args: spec.args };
  }
  if (spec.command === "npm") {
    return { command: "cmd.exe", args: ["/d", "/s", "/c", "npm", ...spec.args] };
  }
  if (spec.command === "powershell") {
    return { command: "powershell.exe", args: spec.args };
  }
  return { command: spec.command, args: spec.args };
}

function getPostcheckCommands() {
  return [
    commandSpec("npm test", "npm", ["test", "--prefix", "local-agent-bridge"]),
    commandSpec("bridge validator", "python", ["scripts/validators/local_agent_bridge_validator.py"]),
    commandSpec("parallel governance", "powershell", [
      "-NoProfile",
      "-ExecutionPolicy",
      "Bypass",
      "-File",
      ".agents/codex/tools/local_validate_parallel_order_governance.ps1"
    ]),
    commandSpec("capability hardening", "powershell", [
      "-NoProfile",
      "-ExecutionPolicy",
      "Bypass",
      "-File",
      ".agents/codex/tools/local_validate_capability_use_hardening.ps1"
    ]),
    commandSpec("diff whitespace", "git", ["diff", "--check"])
  ];
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

function findDuplicates(values) {
  const seen = new Set();
  const duplicates = new Set();
  for (const value of values) {
    if (!value) continue;
    if (seen.has(value)) duplicates.add(value);
    seen.add(value);
  }
  return [...duplicates].sort();
}

function readJsonFile(repoRoot, artifactPath) {
  return JSON.parse(fs.readFileSync(path.join(repoRoot, artifactPath), "utf8"));
}

function getActiveGovernedLane(prdJson) {
  return prdJson?.metadata?.customFields?.activeGovernedLane || prdJson?.content?.activeGovernedLane || {};
}

function readJsonArtifact(repoRoot, artifactPath) {
  const fullPath = path.join(repoRoot, artifactPath);
  if (!fs.existsSync(fullPath)) {
    return {
      path: artifactPath,
      exists: false,
      parsed: false,
      project_name: "NO_ENCONTRADO"
    };
  }

  try {
    const parsed = readJsonFile(repoRoot, artifactPath);
    return {
      path: artifactPath,
      exists: true,
      parsed: true,
      project_name: parsed?.metadata?.projectName || parsed?.content?.productOverview?.productName || "NO_DECLARADO"
    };
  } catch (error) {
    return {
      path: artifactPath,
      exists: true,
      parsed: false,
      project_name: "JSON_INVALID",
      error: error.message
    };
  }
}

function reviewCanvasLane(repoRoot) {
  const prd = readJsonArtifact(repoRoot, ".agileagentcanvas-context/planning/prd.json");
  let activeLane = {};
  if (prd.parsed) {
    const prdJson = readJsonFile(repoRoot, ".agileagentcanvas-context/planning/prd.json");
    activeLane = getActiveGovernedLane(prdJson);
  }

  const artifacts = CANVAS_ARTIFACT_PATHS.map((artifactPath) => readJsonArtifact(repoRoot, artifactPath));
  const writeAllowlist = Array.isArray(activeLane.writeAllowlist) ? activeLane.writeAllowlist : [];
  const validators = Array.isArray(activeLane.validators) ? activeLane.validators : [];
  const missingAllowlistEntries = writeAllowlist
    .filter((relativePath) => !fs.existsSync(path.join(repoRoot, relativePath)))
    .sort();
  const missingLaneFields = [
    ["laneId", activeLane.laneId],
    ["status", activeLane.status],
    ["ownerAgent", activeLane.ownerAgent],
    ["reviewerAgent", activeLane.reviewerAgent],
    ["lockKey", activeLane.lockKey],
    ["writeAllowlist", writeAllowlist.length > 0],
    ["validators", validators.length > 0]
  ]
    .filter(([, value]) => !value)
    .map(([field]) => field);

  const liveExecuted = activeLane.liveExecuted === true;
  const externalSync = activeLane.externalSync === true;
  const passed = artifacts.every((artifact) => artifact.exists && artifact.parsed)
    && missingAllowlistEntries.length === 0
    && missingLaneFields.length === 0
    && !liveExecuted
    && !externalSync;

  return {
    status: passed ? "PASS" : "FAIL",
    lane_id: activeLane.laneId || "NO_DECLARADO",
    lane_status: activeLane.status || "NO_DECLARADO",
    owner_agent: activeLane.ownerAgent || "NO_DECLARADO",
    reviewer_agent: activeLane.reviewerAgent || "NO_DECLARADO",
    lock_key: activeLane.lockKey || "NO_DECLARADO",
    artifact_count: artifacts.length,
    parsed_artifact_count: artifacts.filter((artifact) => artifact.parsed).length,
    allowlist_count: writeAllowlist.length,
    missing_allowlist_entries: missingAllowlistEntries,
    validator_count: validators.length,
    missing_lane_fields: missingLaneFields,
    live_executed: liveExecuted,
    external_sync: externalSync,
    artifacts
  };
}

function addIssue(issues, artifactPath, field, message) {
  issues.push(`${artifactPath}:${field}:${message}`);
}

function hasObject(value) {
  return value !== null && typeof value === "object" && !Array.isArray(value);
}

function hasText(value) {
  return typeof value === "string" && value.trim().length > 0;
}

function validateMetadataEnvelope(issues, artifactPath, artifact, expectedArtifactType) {
  const metadata = artifact?.metadata || {};
  const allowedStatuses = new Set(["draft", "in-progress", "approved", "final"]);
  if (!hasText(metadata.schemaVersion)) addIssue(issues, artifactPath, "metadata.schemaVersion", "missing schema version");
  if (metadata.artifactType !== expectedArtifactType) {
    addIssue(issues, artifactPath, "metadata.artifactType", `expected ${expectedArtifactType}`);
  }
  if (!hasObject(metadata.timestamps)) addIssue(issues, artifactPath, "metadata.timestamps", "missing timestamps");
  if (!allowedStatuses.has(metadata.status)) addIssue(issues, artifactPath, "metadata.status", "status outside allowed set");
}

function validateGovernedLaneCustomField(issues, artifactPath, artifact) {
  if (artifact?.content?.activeGovernedLane) {
    addIssue(issues, artifactPath, "content.activeGovernedLane", "must stay out of content for schema compatibility");
  }
  if (!hasObject(artifact?.metadata?.customFields?.activeGovernedLane)) {
    addIssue(issues, artifactPath, "metadata.customFields.activeGovernedLane", "missing governed lane custom field");
  }
}

function reviewCanvasSchemaHealth(repoRoot) {
  const artifacts = CANVAS_SCHEMA_HEALTH_ARTIFACT_PATHS.map((artifactPath) => readJsonArtifact(repoRoot, artifactPath));
  const parsedArtifacts = artifacts
    .filter((artifact) => artifact.parsed)
    .map((artifact) => [artifact.path, readJsonFile(repoRoot, artifact.path)]);
  const byPath = new Map(parsedArtifacts);
  const issues = [];

  for (const artifact of artifacts) {
    if (!artifact.exists) addIssue(issues, artifact.path, "file", "missing artifact");
    if (artifact.exists && !artifact.parsed) addIssue(issues, artifact.path, "json", "invalid json");
  }

  const sprintStatusPath = ".agileagentcanvas-context/bmm/sprint-status.json";
  const sprintStatus = byPath.get(sprintStatusPath);
  if (sprintStatus) {
    if (sprintStatus.metadata || sprintStatus.content) {
      addIssue(issues, sprintStatusPath, "root", "sprint status must remain flat");
    }
    for (const field of ["project", "tracking_system", "development_status"]) {
      if (!sprintStatus[field]) addIssue(issues, sprintStatusPath, field, "missing root field");
    }
  }

  const productBriefPath = ".agileagentcanvas-context/discovery/product-brief.json";
  const productBrief = byPath.get(productBriefPath);
  if (productBrief) {
    validateMetadataEnvelope(issues, productBriefPath, productBrief, "product-brief");
    validateGovernedLaneCustomField(issues, productBriefPath, productBrief);
    const targetUsers = productBrief?.content?.targetUsers || [];
    const invalidPainPoints = targetUsers.flatMap((user, userIndex) => (user.painPoints || [])
      .filter((painPoint) => !["low", "medium", "high", "critical"].includes(painPoint.severity))
      .map((painPoint, painIndex) => `targetUsers[${userIndex}].painPoints[${painIndex}].severity=${painPoint.severity}`));
    for (const issue of invalidPainPoints) addIssue(issues, productBriefPath, issue, "severity outside allowed set");
  }

  const prdPath = ".agileagentcanvas-context/planning/prd.json";
  const prd = byPath.get(prdPath);
  if (prd) {
    validateMetadataEnvelope(issues, prdPath, prd, "prd");
    validateGovernedLaneCustomField(issues, prdPath, prd);
    if (!["low", "medium", "high", "enterprise"].includes(prd?.content?.projectType?.complexity)) {
      addIssue(issues, prdPath, "content.projectType.complexity", "complexity outside allowed set");
    }
    const invalidProficiency = (prd?.content?.userPersonas || [])
      .filter((persona) => !["beginner", "intermediate", "advanced", "expert"].includes(persona.technicalProficiency))
      .map((persona) => `${persona.name || "NO_DECLARADO"}:${persona.technicalProficiency || "NO_DECLARADO"}`);
    for (const issue of invalidProficiency) {
      addIssue(issues, prdPath, "content.userPersonas.technicalProficiency", issue);
    }
  }

  const epicsPath = ".agileagentcanvas-context/planning/epics.json";
  const epics = byPath.get(epicsPath);
  if (epics) {
    validateMetadataEnvelope(issues, epicsPath, epics, "epics");
    validateGovernedLaneCustomField(issues, epicsPath, epics);
    const requirementRows = Object.values(epics?.content?.requirementsInventory || {})
      .flatMap((value) => Array.isArray(value) ? value : []);
    const missingDescriptions = requirementRows
      .filter((row) => !hasText(row.description))
      .map((row) => row.id || "NO_DECLARADO");
    for (const issue of missingDescriptions) {
      addIssue(issues, epicsPath, "content.requirementsInventory.description", issue);
    }
  }

  const requirementsPath = ".agileagentcanvas-context/solutioning/requirements.json";
  const requirements = byPath.get(requirementsPath);
  if (requirements) {
    validateMetadataEnvelope(issues, requirementsPath, requirements, "requirements");
  }

  const testCasesPath = ".agileagentcanvas-context/testing/test-cases.json";
  const testCases = byPath.get(testCasesPath);
  if (testCases) {
    validateMetadataEnvelope(issues, testCasesPath, testCases, "test-cases");
    const allowedTypes = new Set(["unit", "integration", "component", "e2e", "performance", "security"]);
    const allowedStatuses = new Set(["draft", "ready", "pass", "fail", "blocked"]);
    const invalidCases = (testCases?.content?.testCases || [])
      .filter((testCase) => !allowedTypes.has(testCase.type) || !allowedStatuses.has(testCase.status) || !hasText(testCase.storyId))
      .map((testCase) => testCase.id || "NO_DECLARADO");
    for (const issue of invalidCases) addIssue(issues, testCasesPath, "content.testCases", issue);
  }

  const testStrategyPath = ".agileagentcanvas-context/testing/test-strategy.json";
  const testStrategy = byPath.get(testStrategyPath);
  if (testStrategy) {
    validateMetadataEnvelope(issues, testStrategyPath, testStrategy, "test-strategy");
    if (!Array.isArray(testStrategy?.content?.coverageTargets)) {
      addIssue(issues, testStrategyPath, "content.coverageTargets", "must be an array");
    }
  }

  return {
    status: issues.length === 0 ? "PASS" : "FAIL",
    artifact_count: artifacts.length,
    parsed_artifact_count: artifacts.filter((artifact) => artifact.parsed).length,
    issue_count: issues.length,
    issues,
    schema_contract_passed: issues.length === 0,
    command_execution_exposed: false,
    live_executed: false,
    artifacts
  };
}

function reviewTaskQueue(repoRoot) {
  const taskQueuePath = path.join(repoRoot, TASK_QUEUE_PATH);
  const rows = parseCsv(fs.readFileSync(taskQueuePath, "utf8"));
  const taskIds = new Set(rows.map((row) => row.task_id).filter(Boolean));
  const duplicateTaskIds = findDuplicates(rows.map((row) => row.task_id));
  const missingDependencies = rows
    .filter((row) => row.dependency && row.dependency !== "none" && !taskIds.has(row.dependency))
    .map((row) => `${row.task_id}->${row.dependency}`);
  const missingLockKeys = rows
    .filter((row) => !row.lock_key)
    .map((row) => row.task_id || "NO_DECLARADO");
  const nonExecutedTasks = rows
    .filter((row) => row.status !== "EXECUTED_LOCAL_VALIDATED")
    .map((row) => `${row.task_id}:${row.status || "NO_DECLARADO"}`);

  const passed = duplicateTaskIds.length === 0
    && missingDependencies.length === 0
    && missingLockKeys.length === 0
    && nonExecutedTasks.length === 0;

  return {
    status: passed ? "PASS" : "FAIL",
    source: TASK_QUEUE_PATH,
    task_count: rows.length,
    executed_count: rows.filter((row) => row.status === "EXECUTED_LOCAL_VALIDATED").length,
    queued_count: rows.filter((row) => row.status === "QUEUED_READY").length,
    duplicate_task_ids: duplicateTaskIds,
    missing_dependencies: missingDependencies,
    missing_lock_keys: missingLockKeys,
    non_executed_tasks: nonExecutedTasks
  };
}

function readPacketField(text, field) {
  const match = text.match(new RegExp(`^- ${field}:\\s*(.+)$`, "m"));
  return match ? match[1].trim() : "";
}

function reviewLiveGatePackets(repoRoot) {
  const requiredFields = [
    "order_class",
    "preparer_agent",
    "reviewer_agent",
    "approver_role",
    "canon_as_of",
    "source_authority",
    "surface",
    "identity",
    "owner",
    "data_boundary",
    "allowed_actions",
    "blocked_actions",
    "rollback",
    "postcheck",
    "evidence",
    "validator",
    "expiration_rule",
    "stop_condition"
  ];
  const packets = LIVE_GATE_PACKET_PATHS.map((packetPath) => {
    const fullPath = path.join(repoRoot, packetPath);
    if (!fs.existsSync(fullPath)) {
      return {
        path: packetPath,
        exists: false,
        surface: "NO_ENCONTRADO",
        stop_condition: "order_packet_missing",
        missing_fields: requiredFields,
        pending_field_count: 0
      };
    }

    const text = fs.readFileSync(fullPath, "utf8");
    const missingFields = requiredFields.filter((field) => !readPacketField(text, field));
    const pendingFieldCount = requiredFields
      .map((field) => readPacketField(text, field))
      .filter((value) => value.includes("PENDING_")).length;
    return {
      path: packetPath,
      exists: true,
      surface: readPacketField(text, "surface") || "NO_DECLARADO",
      stop_condition: readPacketField(text, "stop_condition") || "NO_DECLARADO",
      missing_fields: missingFields,
      pending_field_count: pendingFieldCount,
      execution_boundary_declared: text.includes("## Execution Boundary"),
      live_execution_blocked: /does not|no ejecuta|no llama|does not call|does not write/i.test(text)
    };
  });

  const missingPackets = packets.filter((packet) => !packet.exists).map((packet) => packet.path);
  const packetsWithMissingFields = packets
    .filter((packet) => packet.missing_fields.length > 0)
    .map((packet) => `${packet.path}:${packet.missing_fields.join("|")}`);
  const packetsWithoutBoundary = packets
    .filter((packet) => packet.exists && !packet.execution_boundary_declared)
    .map((packet) => packet.path);
  const packetsWithoutLiveBlock = packets
    .filter((packet) => packet.exists && !packet.live_execution_blocked)
    .map((packet) => packet.path);
  const passed = missingPackets.length === 0
    && packetsWithMissingFields.length === 0
    && packetsWithoutBoundary.length === 0
    && packetsWithoutLiveBlock.length === 0;

  return {
    status: passed ? "PASS" : "FAIL",
    packet_count: packets.length,
    existing_packet_count: packets.filter((packet) => packet.exists).length,
    pending_field_count: packets.reduce((total, packet) => total + packet.pending_field_count, 0),
    missing_packets: missingPackets,
    packets_with_missing_fields: packetsWithMissingFields,
    packets_without_boundary: packetsWithoutBoundary,
    packets_without_live_block: packetsWithoutLiveBlock,
    packets
  };
}

function reviewBridgeContract(repoRoot) {
  const contractArtifact = readJsonArtifact(repoRoot, BRIDGE_CONTRACT_PATH);
  const contract = contractArtifact.parsed
    ? readJsonFile(repoRoot, BRIDGE_CONTRACT_PATH)
    : {};
  const routesPath = path.join(repoRoot, ROUTES_MATRIX_PATH);
  const routes = fs.existsSync(routesPath)
    ? parseCsv(fs.readFileSync(routesPath, "utf8"))
    : [];
  const routeIds = new Set(routes.map((row) => row.route_id).filter(Boolean));
  const allowedActionIds = contract?.localActions?.allowedActionIds || [];
  const blockedActions = contract?.localActions?.blockedActions || [];
  const requiredActionIds = getRequiredLocalActionIds();
  const missingAllowedActionIds = requiredActionIds
    .filter((actionId) => !allowedActionIds.includes(actionId))
    .sort();
  const requiredBlockedActions = [
    "execute_arbitrary_shell_from_dashboard",
    "live_provider_call",
    "secret_handling",
    "production_write"
  ];
  const missingBlockedActions = requiredBlockedActions
    .filter((action) => !blockedActions.includes(action))
    .sort();
  const missingRoutes = ["bridge.shell_status", "bridge.shell_command_blocked", "bridge.local_action_run"]
    .filter((routeId) => !routeIds.has(routeId));
  const unsafeRoutes = routes
    .filter((row) => {
      const blocked = String(row.blocked_actions || "");
      const externalBlocked = ["external_write", "teams_send", "graph_write", "live_call"]
        .some((action) => blocked.includes(action));
      const commandRouteBlocked = row.route_id !== "bridge.shell_command_blocked"
        || blocked.includes("execute_arbitrary_command");
      return row.status !== "ACTIVE_DEV" || !externalBlocked || !commandRouteBlocked;
    })
    .map((row) => row.route_id || "NO_DECLARADO");
  const missingContractFields = [
    ["transport", contract.transport === "http-loopback"],
    ["response.liveExecutedValue", contract?.response?.liveExecutedValue === false],
    ["shellConnector.commandExecutionExposed", contract?.shellConnector?.commandExecutionExposed === false],
    ["localActions.commandExecutionExposed", contract?.localActions?.commandExecutionExposed === false],
    ["localReadSurface.requiresLoopbackBindHost", contract?.localReadSurface?.requiresLoopbackBindHost === true],
    ["localReadSurface.blockedStatus", contract?.localReadSurface?.blockedStatus === 403]
  ]
    .filter(([, ok]) => !ok)
    .map(([field]) => field);
  const passed = contractArtifact.parsed
    && missingAllowedActionIds.length === 0
    && missingBlockedActions.length === 0
    && missingRoutes.length === 0
    && unsafeRoutes.length === 0
    && missingContractFields.length === 0;

  return {
    status: passed ? "PASS" : "FAIL",
    contract_path: BRIDGE_CONTRACT_PATH,
    route_matrix_path: ROUTES_MATRIX_PATH,
    transport: contract.transport || "NO_DECLARADO",
    allowed_action_count: allowedActionIds.length,
    missing_allowed_action_ids: missingAllowedActionIds,
    blocked_action_count: blockedActions.length,
    missing_blocked_actions: missingBlockedActions,
    route_count: routes.length,
    missing_routes: missingRoutes,
    unsafe_routes: unsafeRoutes,
    missing_contract_fields: missingContractFields,
    command_execution_exposed: contract?.localActions?.commandExecutionExposed === true
      || contract?.shellConnector?.commandExecutionExposed === true,
    live_executed: contract?.response?.liveExecutedValue === true
  };
}

function buildReviewCanvasWorkbench(repoRoot) {
  const prdArtifact = readJsonArtifact(repoRoot, ".agileagentcanvas-context/planning/prd.json");
  const activeLane = prdArtifact.parsed
    ? getActiveGovernedLane(readJsonFile(repoRoot, ".agileagentcanvas-context/planning/prd.json"))
    : {};
  return {
    active_governed_lane: {
      lane_id: activeLane.laneId || "NO_DECLARADO",
      status: activeLane.status || "NO_DECLARADO",
      owner_agent: activeLane.ownerAgent || "NO_DECLARADO",
      reviewer_agent: activeLane.reviewerAgent || "NO_DECLARADO",
      lock_key: activeLane.lockKey || "NO_DECLARADO",
      live_executed: activeLane.liveExecuted === true,
      external_sync: activeLane.externalSync === true
    }
  };
}

function readTaskQueueRows(repoRoot) {
  return parseCsv(fs.readFileSync(path.join(repoRoot, TASK_QUEUE_PATH), "utf8"));
}

function buildReviewLocalActions(repoRoot) {
  return buildLocalActions(buildReviewCanvasWorkbench(repoRoot), readTaskQueueRows(repoRoot));
}

function reviewDashboardIntegrity(repoRoot) {
  const taskQueueReview = reviewTaskQueue(repoRoot);
  const canvasLaneReview = reviewCanvasLane(repoRoot);
  const localActions = buildReviewLocalActions(repoRoot);
  const actionIds = localActions.map((action) => action.action_id);
  const requiredActionIds = getRequiredLocalActionIds();
  const missingRequiredActions = requiredActionIds.filter((actionId) => !actionIds.includes(actionId)).sort();
  const plans = requiredActionIds.map((actionId) => getLocalActionExecutionPlan(actionId));
  const nonReadyLocalActions = localActions
    .filter((action) => !["READY_LOCAL_GOVERNED", "EXECUTED_LOCAL_VALIDATED"].includes(action.status))
    .map((action) => `${action.action_id}:${action.status}`);
  const plansWithCommandExecution = plans
    .filter((plan) => plan.command_execution_exposed === true)
    .map((plan) => plan.action_id);
  const plansWithLiveExecution = plans
    .filter((plan) => plan.live_executed === true)
    .map((plan) => plan.action_id);
  const passed = taskQueueReview.status === "PASS"
    && canvasLaneReview.status === "PASS"
    && localActions.length === requiredActionIds.length
    && missingRequiredActions.length === 0
    && nonReadyLocalActions.length === 0
    && plansWithCommandExecution.length === 0
    && plansWithLiveExecution.length === 0;

  return {
    status: passed ? "PASS" : "FAIL",
    task_count: taskQueueReview.task_count,
    executed_task_count: taskQueueReview.executed_count,
    non_executed_tasks: taskQueueReview.non_executed_tasks,
    local_action_count: localActions.length,
    ready_local_action_count: localActions.filter((action) => action.status === "READY_LOCAL_GOVERNED").length,
    executed_local_action_count: localActions.filter((action) => action.status === "EXECUTED_LOCAL_VALIDATED").length,
    non_ready_local_actions: nonReadyLocalActions,
    canvas_artifact_count: canvasLaneReview.artifact_count,
    parsed_canvas_artifact_count: canvasLaneReview.parsed_artifact_count,
    active_lane_status: canvasLaneReview.lane_status,
    missing_required_actions: missingRequiredActions,
    command_execution_exposed: plansWithCommandExecution.length > 0,
    live_executed: canvasLaneReview.live_executed || plansWithLiveExecution.length > 0,
    plans_with_command_execution: plansWithCommandExecution,
    plans_with_live_execution: plansWithLiveExecution
  };
}

function reviewActionBoundary(repoRoot) {
  const localActions = buildReviewLocalActions(repoRoot);
  const requiredActionIds = getRequiredLocalActionIds();
  const actionIds = new Set(localActions.map((action) => action.action_id));
  const plans = requiredActionIds.map((actionId) => getLocalActionExecutionPlan(actionId));
  const actionsMissingStopCondition = localActions
    .filter((action) => !action.stop_condition)
    .map((action) => action.action_id);
  const actionsMissingBoundaryBlocks = localActions
    .filter((action) => !/live_provider_call|secret_handling|production_write|execute_arbitrary_shell_from_dashboard|dispatch_live_agents/.test(action.blocked_actions || ""))
    .map((action) => action.action_id);
  const plansWithCommandExecution = plans
    .filter((plan) => plan.command_execution_exposed === true)
    .map((plan) => plan.action_id);
  const plansWithLiveExecution = plans
    .filter((plan) => plan.live_executed === true)
    .map((plan) => plan.action_id);
  const unknownActions = localActions
    .filter((action) => !requiredActionIds.includes(action.action_id))
    .map((action) => action.action_id);
  const missingRequiredActions = requiredActionIds.filter((actionId) => !actionIds.has(actionId));
  const nonExecutableRequiredActions = plans
    .filter((plan) => !plan.execute_now)
    .map((plan) => plan.action_id);
  const passed = localActions.length === requiredActionIds.length
    && missingRequiredActions.length === 0
    && unknownActions.length === 0
    && actionsMissingStopCondition.length === 0
    && actionsMissingBoundaryBlocks.length === 0
    && plansWithCommandExecution.length === 0
    && plansWithLiveExecution.length === 0
    && nonExecutableRequiredActions.length === 0;

  return {
    status: passed ? "PASS" : "FAIL",
    action_count: localActions.length,
    plan_count: plans.length,
    executable_action_count: plans.filter((plan) => plan.execute_now).length,
    actions_missing_stop_condition: actionsMissingStopCondition,
    actions_missing_boundary_blocks: actionsMissingBoundaryBlocks,
    plans_with_command_execution: plansWithCommandExecution,
    plans_with_live_execution: plansWithLiveExecution,
    unknown_actions: unknownActions,
    missing_required_actions: missingRequiredActions,
    non_executable_required_actions: nonExecutableRequiredActions,
    command_execution_exposed: plansWithCommandExecution.length > 0,
    live_executed: plansWithLiveExecution.length > 0
  };
}

function reviewUiTranslationIntegrity(repoRoot) {
  const htmlPath = "local-agent-bridge/public/index.html";
  const html = fs.readFileSync(path.join(repoRoot, htmlPath), "utf8");
  const localActions = buildReviewLocalActions(repoRoot);
  const requiredTokens = [
    ...getRequiredLocalActionIds(),
    ...localActions.map((action) => action.surface),
    ...localActions.map((action) => action.stop_condition),
    "structured_local_review_no_shell",
    "live_executed"
  ];
  const missingTranslationTokens = [...new Set(requiredTokens)]
    .filter((token) => token && !html.includes(token))
    .sort();
  const missingResultRenderers = [
    "dashboard_integrity_review",
    "action_boundary_review",
    "readiness_bundle_review",
    "ui_translation_review",
    "task_lineage_review",
    "canvas_story_sync_review",
    "route_contract_sync_review",
    "server_endpoint_guard_review",
    "validator_coverage_review",
    "error_response_shape_review",
    "postcheck_allowlist_review",
    "shell_block_consistency_review",
    "dashboard_summary_consistency_review",
    "local_action_status_consistency_review",
    "readiness_component_coverage_review",
    "canvas_schema_health_review"
  ].filter((token) => !html.includes(token));
  const fileFallbackPresent = html.includes("renderFileFallback")
    && html.includes('window.location.protocol === "file:"');
  const passed = missingTranslationTokens.length === 0
    && missingResultRenderers.length === 0
    && fileFallbackPresent;

  return {
    status: passed ? "PASS" : "FAIL",
    html_path: htmlPath,
    required_token_count: [...new Set(requiredTokens)].length,
    missing_translation_tokens: missingTranslationTokens,
    missing_result_renderers: missingResultRenderers,
    file_fallback_present: fileFallbackPresent,
    command_execution_exposed: false,
    live_executed: false
  };
}

function reviewTaskLineage(repoRoot) {
  const rows = readTaskQueueRows(repoRoot);
  const taskIds = new Set(rows.map((row) => row.task_id).filter(Boolean));
  const duplicateTaskIds = findDuplicates(rows.map((row) => row.task_id));
  const missingDependencies = rows
    .filter((row) => row.dependency && row.dependency !== "none" && !taskIds.has(row.dependency))
    .map((row) => `${row.task_id}->${row.dependency}`);
  const dependencyCycles = [];
  for (const row of rows) {
    const seen = new Set([row.task_id]);
    let current = row.dependency;
    while (current && current !== "none") {
      if (seen.has(current)) {
        dependencyCycles.push(`${row.task_id}->${current}`);
        break;
      }
      seen.add(current);
      const parent = rows.find((candidate) => candidate.task_id === current);
      current = parent?.dependency;
    }
  }
  const branchlessCodexTasks = rows
    .filter((row) => row.branch && !row.branch.startsWith("codex/"))
    .map((row) => `${row.task_id}:${row.branch}`);
  const unlockedTasks = rows
    .filter((row) => !row.lock_key)
    .map((row) => row.task_id || "NO_DECLARADO");
  const unvalidatedTasks = rows
    .filter((row) => row.status !== "EXECUTED_LOCAL_VALIDATED")
    .map((row) => `${row.task_id}:${row.status || "NO_DECLARADO"}`);
  const passed = duplicateTaskIds.length === 0
    && missingDependencies.length === 0
    && dependencyCycles.length === 0
    && branchlessCodexTasks.length === 0
    && unlockedTasks.length === 0
    && unvalidatedTasks.length === 0;

  return {
    status: passed ? "PASS" : "FAIL",
    source: TASK_QUEUE_PATH,
    task_count: rows.length,
    duplicate_task_ids: duplicateTaskIds,
    missing_dependencies: missingDependencies,
    dependency_cycles: [...new Set(dependencyCycles)].sort(),
    branchless_codex_tasks: branchlessCodexTasks,
    unlocked_tasks: unlockedTasks,
    unvalidated_tasks: unvalidatedTasks,
    command_execution_exposed: false,
    live_executed: false
  };
}

function reviewCanvasStorySync(repoRoot) {
  const epicsPath = ".agileagentcanvas-context/planning/epics.json";
  const epics = readJsonFile(repoRoot, epicsPath);
  const stories = epics?.content?.epics?.flatMap((epic) => epic.stories || []) || [];
  const storyIds = stories.map((story) => story.id).filter(Boolean);
  const duplicateStoryIds = findDuplicates(storyIds);
  const declaredTotalStories = epics?.content?.overview?.totalStories;
  const totalStoriesMatches = declaredTotalStories === stories.length;
  const currentSyncStoryIds = new Set(["S-3.2", "S-3.21", "S-3.22", "S-3.23"]);
  const unfinishedDashboardStories = stories
    .filter((story) => currentSyncStoryIds.has(story.id) && story.status !== "hecho")
    .map((story) => `${story.id}:${story.status || "NO_DECLARADO"}`);
  const functionalStoryRefs = new Set(
    (epics?.content?.requirementsInventory?.functional || [])
      .flatMap((item) => item.relatedStories || [])
  );
  const missingFunctionalStoryRefs = storyIds
    .filter((storyId) => storyId.startsWith("S-3.") && !functionalStoryRefs.has(storyId))
    .sort();
  const taskQueue = readTaskQueueRows(repoRoot);
  const recentTaskIds = ["vsi.agent.task.031", "vsi.agent.task.032", "vsi.agent.task.033", "vsi.agent.task.034"];
  const missingRecentTasks = recentTaskIds
    .filter((taskId) => !taskQueue.some((row) => row.task_id === taskId));
  const passed = duplicateStoryIds.length === 0
    && totalStoriesMatches
    && unfinishedDashboardStories.length === 0
    && missingFunctionalStoryRefs.length === 0
    && missingRecentTasks.length === 0;

  return {
    status: passed ? "PASS" : "FAIL",
    epics_path: epicsPath,
    declared_total_stories: declaredTotalStories,
    actual_story_count: stories.length,
    total_stories_matches: totalStoriesMatches,
    duplicate_story_ids: duplicateStoryIds,
    unfinished_dashboard_stories: unfinishedDashboardStories,
    missing_functional_story_refs: missingFunctionalStoryRefs,
    missing_recent_tasks: missingRecentTasks,
    command_execution_exposed: false,
    live_executed: false
  };
}

function reviewRouteContractSync(repoRoot) {
  const contract = readJsonFile(repoRoot, BRIDGE_CONTRACT_PATH);
  const routes = parseCsv(fs.readFileSync(path.join(repoRoot, ROUTES_MATRIX_PATH), "utf8"));
  const allowedRoutes = contract.allowedRoutes || [];
  const matrixRoutes = routes.map((row) => `${row.http_method} ${row.path}`);
  const missing_allowed_routes = matrixRoutes
    .filter((route) => !allowedRoutes.includes(route))
    .sort();
  const extra_allowed_routes = allowedRoutes
    .filter((route) => !matrixRoutes.includes(route))
    .sort();
  const duplicate_matrix_routes = findDuplicates(matrixRoutes);
  const localActionRoute = routes.find((row) => row.route_id === "bridge.local_action_run") || {};
  const localActionRouteProtected = String(localActionRoute.blocked_actions || "").includes("execute_arbitrary_command")
    && String(localActionRoute.blocked_actions || "").includes("non_loopback_read")
    && String(localActionRoute.blocked_actions || "").includes("live_call");
  const missingValidators = routes
    .filter((row) => row.validator !== "scripts/validators/local_agent_bridge_validator.py")
    .map((row) => row.route_id || "NO_DECLARADO");
  const inactiveRoutes = routes
    .filter((row) => row.status !== "ACTIVE_DEV")
    .map((row) => `${row.route_id}:${row.status || "NO_DECLARADO"}`);
  const passed = missing_allowed_routes.length === 0
    && extra_allowed_routes.length === 0
    && duplicate_matrix_routes.length === 0
    && localActionRouteProtected
    && missingValidators.length === 0
    && inactiveRoutes.length === 0;

  return {
    status: passed ? "PASS" : "FAIL",
    contract_path: BRIDGE_CONTRACT_PATH,
    route_matrix_path: ROUTES_MATRIX_PATH,
    allowed_route_count: allowedRoutes.length,
    matrix_route_count: matrixRoutes.length,
    missing_allowed_routes,
    extra_allowed_routes,
    duplicate_matrix_routes,
    local_action_route_protected: localActionRouteProtected,
    missing_validators: missingValidators,
    inactive_routes: inactiveRoutes,
    command_execution_exposed: false,
    live_executed: false
  };
}

function reviewServerEndpointGuards(repoRoot) {
  const serverPath = "local-agent-bridge/src/server.mjs";
  const serverText = fs.readFileSync(path.join(repoRoot, serverPath), "utf8");
  const requiredEndpoints = [
    'req.method === "GET" && req.url === "/"',
    'req.method === "GET" && req.url === "/health"',
    'req.method === "GET" && req.url === "/api/dashboard"',
    'req.method === "GET" && req.url === "/api/shell/status"',
    'req.method === "POST" && req.url === "/api/local-actions/run"',
    'req.method === "POST" && req.url === "/v1/shell/command"',
    'req.method === "POST" && req.url === "/v1/sdu/route"'
  ];
  const missingEndpoints = requiredEndpoints.filter((endpoint) => !serverText.includes(endpoint));
  const loopbackGuardCount = (serverText.match(/assertLoopbackReadSurface\(host\)/g) || []).length;
  const devAuthGuardCount = (serverText.match(/assertDevAuth\(req\)/g) || []).length;
  const localActionBodyGuarded = serverText.includes("const payload = await readJsonBody(req);")
    && serverText.includes("const actionId = String(payload.action_id || \"\");")
    && serverText.includes("await runLocalAction(actionId, repoRoot)");
  const notFoundNoLive = serverText.includes('json(res, 404, { status: "not_found", live_executed: false })');
  const passed = missingEndpoints.length === 0
    && loopbackGuardCount >= 3
    && devAuthGuardCount >= 2
    && localActionBodyGuarded
    && notFoundNoLive;

  return {
    status: passed ? "PASS" : "FAIL",
    server_path: serverPath,
    required_endpoint_count: requiredEndpoints.length,
    missing_endpoints: missingEndpoints,
    loopback_guard_count: loopbackGuardCount,
    dev_auth_guard_count: devAuthGuardCount,
    local_action_body_guarded: localActionBodyGuarded,
    not_found_no_live: notFoundNoLive,
    command_execution_exposed: false,
    live_executed: false
  };
}

function reviewValidatorCoverage(repoRoot) {
  const validatorPath = "scripts/validators/local_agent_bridge_validator.py";
  const testPath = "local-agent-bridge/tests/mock_bridge_flow.mjs";
  const readmePath = "local-agent-bridge/README.md";
  const htmlPath = "local-agent-bridge/public/index.html";
  const validatorText = fs.readFileSync(path.join(repoRoot, validatorPath), "utf8");
  const testText = fs.readFileSync(path.join(repoRoot, testPath), "utf8");
  const readmeText = fs.readFileSync(path.join(repoRoot, readmePath), "utf8");
  const htmlText = fs.readFileSync(path.join(repoRoot, htmlPath), "utf8");
  const contract = readJsonFile(repoRoot, BRIDGE_CONTRACT_PATH);
  const allowedActionIds = contract?.localActions?.allowedActionIds || [];
  const requiredActionIds = getRequiredLocalActionIds();
  const missingContractActions = requiredActionIds.filter((actionId) => !allowedActionIds.includes(actionId));
  const missingValidatorActions = requiredActionIds.filter((actionId) => !validatorText.includes(actionId));
  const missingTestActions = requiredActionIds.filter((actionId) => !testText.includes(actionId));
  const missingReadmeActions = requiredActionIds.filter((actionId) => !readmeText.includes(actionId));
  const missingHtmlActions = requiredActionIds.filter((actionId) => !htmlText.includes(actionId));
  const requiredResultKeys = [
    "canvas_lane_review",
    "review_result",
    "gate_packet_review",
    "bridge_contract_review",
    "dashboard_integrity_review",
    "action_boundary_review",
    "readiness_bundle_review",
    "ui_translation_review",
    "task_lineage_review",
    "canvas_story_sync_review",
    "route_contract_sync_review",
    "server_endpoint_guard_review",
    "validator_coverage_review",
    "error_response_shape_review",
    "postcheck_allowlist_review",
    "shell_block_consistency_review",
    "dashboard_summary_consistency_review",
    "local_action_status_consistency_review",
    "readiness_component_coverage_review",
    "canvas_schema_health_review"
  ];
  const missingResultKeys = requiredResultKeys
    .filter((key) => !validatorText.includes(key) || !testText.includes(key) || !htmlText.includes(key))
    .sort();
  const passed = missingContractActions.length === 0
    && missingValidatorActions.length === 0
    && missingTestActions.length === 0
    && missingReadmeActions.length === 0
    && missingHtmlActions.length === 0
    && missingResultKeys.length === 0;

  return {
    status: passed ? "PASS" : "FAIL",
    action_count: requiredActionIds.length,
    result_key_count: requiredResultKeys.length,
    missing_contract_actions: missingContractActions,
    missing_validator_actions: missingValidatorActions,
    missing_test_actions: missingTestActions,
    missing_readme_actions: missingReadmeActions,
    missing_html_actions: missingHtmlActions,
    missing_result_keys: missingResultKeys,
    command_execution_exposed: false,
    live_executed: false
  };
}

function reviewErrorResponseShape(repoRoot) {
  const serverPath = "local-agent-bridge/src/server.mjs";
  const serverText = fs.readFileSync(path.join(repoRoot, serverPath), "utf8");
  const guardedErrorResponses = [...serverText.matchAll(/json\(res,\s*(400|403|404),\s*\{([^}]+)\}\)/g)]
    .map((match) => ({
      status_code: match[1],
      body: match[2],
      live_false: match[2].includes("live_executed: false"),
      blocked_or_not_found: /status:\s*"(blocked|not_found)"/.test(match[2])
    }));
  const responsesMissingLiveFalse = guardedErrorResponses
    .filter((response) => !response.live_false)
    .map((response) => response.status_code);
  const responsesMissingSafeStatus = guardedErrorResponses
    .filter((response) => !response.blocked_or_not_found)
    .map((response) => response.status_code);
  const bodySizeGuarded = serverText.includes("function readJsonBody(req, maxBytes = 2048)")
    && serverText.includes("request body too large")
    && serverText.includes("if (body.length > 4096) req.destroy()");
  const noStackLeak = !serverText.includes("error.stack") && !serverText.includes("stack:");
  const passed = guardedErrorResponses.length >= 5
    && responsesMissingLiveFalse.length === 0
    && responsesMissingSafeStatus.length === 0
    && bodySizeGuarded
    && noStackLeak;

  return {
    status: passed ? "PASS" : "FAIL",
    server_path: serverPath,
    guarded_error_response_count: guardedErrorResponses.length,
    responses_missing_live_false: responsesMissingLiveFalse,
    responses_missing_safe_status: responsesMissingSafeStatus,
    body_size_guarded: bodySizeGuarded,
    no_stack_leak: noStackLeak,
    command_execution_exposed: false,
    live_executed: false
  };
}

function reviewPostcheckAllowlist() {
  const commands = getPostcheckCommands();
  const expectedLabels = [
    "npm test",
    "bridge validator",
    "parallel governance",
    "capability hardening",
    "diff whitespace"
  ];
  const commandLabels = commands.map((command) => command.label);
  const missingExpectedLabels = expectedLabels.filter((label) => !commandLabels.includes(label));
  const extraLabels = commandLabels.filter((label) => !expectedLabels.includes(label));
  const safeCommandNames = new Set(["npm", "python", "powershell", "git"]);
  const unsafeCommands = commands
    .filter((command) => !safeCommandNames.has(command.command))
    .map((command) => `${command.label}:${command.command}`);
  const unsafeArgs = commands
    .filter((command) => command.args.some((arg) => /gh|curl|Invoke-|http|https|--force|reset|checkout/i.test(String(arg))))
    .map((command) => command.label);
  const passed = commands.length === expectedLabels.length
    && missingExpectedLabels.length === 0
    && extraLabels.length === 0
    && unsafeCommands.length === 0
    && unsafeArgs.length === 0;

  return {
    status: passed ? "PASS" : "FAIL",
    command_count: commands.length,
    expected_label_count: expectedLabels.length,
    missing_expected_labels: missingExpectedLabels,
    extra_labels: extraLabels,
    unsafe_commands: unsafeCommands,
    unsafe_args: unsafeArgs,
    command_execution_exposed: false,
    live_executed: false
  };
}

function reviewShellBlockConsistency(repoRoot) {
  const shellPath = "local-agent-bridge/src/shellConnector.mjs";
  const shellText = fs.readFileSync(path.join(repoRoot, shellPath), "utf8");
  const contract = readJsonFile(repoRoot, BRIDGE_CONTRACT_PATH);
  const routes = parseCsv(fs.readFileSync(path.join(repoRoot, ROUTES_MATRIX_PATH), "utf8"));
  const shellRoute = routes.find((row) => row.route_id === "bridge.shell_command_blocked") || {};
  const requiredShellBlocks = [
    "execute_arbitrary_command",
    "external_write",
    "secret_printing",
    "production",
    "permission_change",
    "destructive_action"
  ];
  const missingShellConnectorBlocks = requiredShellBlocks
    .filter((block) => !shellText.includes(`"${block}"`));
  const missingRouteBlocks = requiredShellBlocks
    .filter((block) => !String(shellRoute.blocked_actions || "").includes(block));
  const contractMatches = contract?.shellConnector?.mode === "status_only"
    && contract?.shellConnector?.commandExecutionExposed === false
    && contract?.shellConnector?.blockedStopCondition === "LOCAL_SHELL_COMMAND_EXECUTION_NOT_EXPOSED";
  const shellResponseBlocked = shellText.includes('status: "blocked"')
    && shellText.includes("shell command execution is not exposed by the local bridge")
    && shellText.includes("LOCAL_SHELL_COMMAND_EXECUTION_NOT_EXPOSED");
  const passed = missingShellConnectorBlocks.length === 0
    && missingRouteBlocks.length === 0
    && contractMatches
    && shellResponseBlocked;

  return {
    status: passed ? "PASS" : "FAIL",
    shell_path: shellPath,
    contract_path: BRIDGE_CONTRACT_PATH,
    route_matrix_path: ROUTES_MATRIX_PATH,
    missing_shell_connector_blocks: missingShellConnectorBlocks,
    missing_route_blocks: missingRouteBlocks,
    contract_matches: contractMatches,
    shell_response_blocked: shellResponseBlocked,
    command_execution_exposed: false,
    live_executed: false
  };
}

function getReadinessComponentNames() {
  return [
    "task_queue",
    "canvas_lane",
    "live_gate_packets",
    "bridge_contract",
    "dashboard_integrity",
    "action_boundary",
    "ui_translation_integrity",
    "task_lineage",
    "canvas_story_sync",
    "route_contract_sync",
    "server_endpoint_guards",
    "validator_coverage",
    "error_response_shape",
    "postcheck_allowlist",
    "shell_block_consistency",
    "dashboard_summary_consistency",
    "local_action_status_consistency",
    "readiness_component_coverage",
    "canvas_schema_health"
  ];
}

function reviewDashboardSummaryConsistency(repoRoot) {
  const agentInventory = parseCsv(fs.readFileSync(path.join(repoRoot, AGENT_OPERABILITY_INVENTORY_PATH), "utf8"));
  const semaphoreRows = parseCsv(fs.readFileSync(path.join(repoRoot, LIVE_SEMAPHORE_MATRIX_PATH), "utf8"));
  const gateQueue = parseCsv(fs.readFileSync(path.join(repoRoot, LIVE_GATE_QUEUE_PATH), "utf8"));
  const autonomousRows = parseCsv(fs.readFileSync(path.join(repoRoot, AUTONOMOUS_EXECUTION_MATRIX_PATH), "utf8"));
  const agileAgentCanvas = parseCsv(fs.readFileSync(path.join(repoRoot, AGILE_AGENT_CANVAS_GOVERNANCE_PATH), "utf8"));
  const taskQueue = readTaskQueueRows(repoRoot);
  const canvasWorkbench = buildReviewCanvasWorkbench(repoRoot);
  const localActions = buildReviewLocalActions(repoRoot);
  const summary = {
    agents: agentInventory.length,
    semaphores: semaphoreRows.length,
    gated_records: gateQueue.length,
    local_task_scoped_agents: autonomousRows.filter((row) => row.execution_mode === "local_task_scoped_agent").length,
    agile_agent_canvas_controls: agileAgentCanvas.length,
    agent_task_queue_records: taskQueue.length,
    queued_agent_tasks: taskQueue.filter((row) => row.status === "QUEUED_READY").length,
    executed_agent_tasks: taskQueue.filter((row) => String(row.status || "").startsWith("EXECUTED")).length,
    active_agile_canvas_lane: canvasWorkbench.active_governed_lane.status,
    local_actions_ready: localActions.filter((row) => row.status !== "NEEDS_REVIEW").length
  };
  const requiredActionCount = getRequiredLocalActionIds().length;
  const taskQueueBalanced = summary.queued_agent_tasks + summary.executed_agent_tasks === summary.agent_task_queue_records;
  const passed = summary.local_actions_ready === requiredActionCount
    && summary.agent_task_queue_records > 0
    && summary.queued_agent_tasks === 0
    && summary.executed_agent_tasks === summary.agent_task_queue_records
    && taskQueueBalanced
    && summary.active_agile_canvas_lane === "ACTIVE_LOCAL_GOVERNED_USE"
    && summary.agile_agent_canvas_controls === agileAgentCanvas.length
    && summary.gated_records > 0
    && summary.local_task_scoped_agents > 0;

  return {
    status: passed ? "PASS" : "FAIL",
    required_action_count: requiredActionCount,
    summary,
    task_queue_balanced: taskQueueBalanced,
    command_execution_exposed: false,
    live_executed: false
  };
}

function reviewLocalActionStatusConsistency(repoRoot) {
  const localActions = buildReviewLocalActions(repoRoot);
  const requiredActionIds = getRequiredLocalActionIds();
  const requiredActionSet = new Set(requiredActionIds);
  const actionIds = localActions.map((action) => action.action_id);
  const duplicateActionIds = findDuplicates(actionIds);
  const missingRequiredActions = requiredActionIds
    .filter((actionId) => !actionIds.includes(actionId));
  const unknownActions = actionIds
    .filter((actionId) => !requiredActionSet.has(actionId));
  const allowedStatuses = new Set(["READY_LOCAL_GOVERNED", "EXECUTED_LOCAL_VALIDATED"]);
  const invalidStatuses = localActions
    .filter((action) => !allowedStatuses.has(action.status))
    .map((action) => `${action.action_id}:${action.status || "NO_DECLARADO"}`);
  const postcheckActions = localActions
    .filter((action) => action.execution_mode === "postcheck_allowlist")
    .map((action) => action.action_id);
  const invalidStructuredModes = localActions
    .filter((action) => action.action_id !== POSTCHECK_ACTION_ID && action.execution_mode !== "structured_local_review")
    .map((action) => `${action.action_id}:${action.execution_mode || "NO_DECLARADO"}`);
  const missingRequiredFields = localActions
    .filter((action) => !action.owner_agent || !action.blocked_actions || !action.stop_condition || !action.allowed_now)
    .map((action) => action.action_id || "NO_DECLARADO");
  const passed = duplicateActionIds.length === 0
    && missingRequiredActions.length === 0
    && unknownActions.length === 0
    && invalidStatuses.length === 0
    && postcheckActions.length === 1
    && postcheckActions[0] === POSTCHECK_ACTION_ID
    && invalidStructuredModes.length === 0
    && missingRequiredFields.length === 0;

  return {
    status: passed ? "PASS" : "FAIL",
    action_count: localActions.length,
    required_action_count: requiredActionIds.length,
    duplicate_action_ids: duplicateActionIds,
    missing_required_actions: missingRequiredActions,
    unknown_actions: unknownActions,
    invalid_statuses: invalidStatuses,
    postcheck_actions: postcheckActions,
    invalid_structured_modes: invalidStructuredModes,
    missing_required_fields: missingRequiredFields,
    command_execution_exposed: false,
    live_executed: false
  };
}

function reviewReadinessComponentCoverage() {
  const expectedComponents = [
    "task_queue",
    "canvas_lane",
    "live_gate_packets",
    "bridge_contract",
    "dashboard_integrity",
    "action_boundary",
    "ui_translation_integrity",
    "task_lineage",
    "canvas_story_sync",
    "route_contract_sync",
    "server_endpoint_guards",
    "validator_coverage",
    "error_response_shape",
    "postcheck_allowlist",
    "shell_block_consistency",
    "dashboard_summary_consistency",
    "local_action_status_consistency",
    "readiness_component_coverage",
    "canvas_schema_health"
  ];
  const componentNames = getReadinessComponentNames();
  const duplicateComponents = findDuplicates(componentNames);
  const missingComponents = expectedComponents
    .filter((component) => !componentNames.includes(component));
  const extraComponents = componentNames
    .filter((component) => !expectedComponents.includes(component));
  const passed = componentNames.length === expectedComponents.length
    && duplicateComponents.length === 0
    && missingComponents.length === 0
    && extraComponents.length === 0
    && componentNames.includes("readiness_component_coverage")
    && componentNames.includes("canvas_schema_health");

  return {
    status: passed ? "PASS" : "FAIL",
    component_count: componentNames.length,
    expected_component_count: expectedComponents.length,
    duplicate_components: duplicateComponents,
    missing_components: missingComponents,
    extra_components: extraComponents,
    components: componentNames,
    command_execution_exposed: false,
    live_executed: false
  };
}

function reviewReadinessBundle(repoRoot) {
  const components = [
    ["task_queue", reviewTaskQueue(repoRoot)],
    ["canvas_lane", reviewCanvasLane(repoRoot)],
    ["live_gate_packets", reviewLiveGatePackets(repoRoot)],
    ["bridge_contract", reviewBridgeContract(repoRoot)],
    ["dashboard_integrity", reviewDashboardIntegrity(repoRoot)],
    ["action_boundary", reviewActionBoundary(repoRoot)],
    ["ui_translation_integrity", reviewUiTranslationIntegrity(repoRoot)],
    ["task_lineage", reviewTaskLineage(repoRoot)],
    ["canvas_story_sync", reviewCanvasStorySync(repoRoot)],
    ["route_contract_sync", reviewRouteContractSync(repoRoot)],
    ["server_endpoint_guards", reviewServerEndpointGuards(repoRoot)],
    ["validator_coverage", reviewValidatorCoverage(repoRoot)],
    ["error_response_shape", reviewErrorResponseShape(repoRoot)],
    ["postcheck_allowlist", reviewPostcheckAllowlist()],
    ["shell_block_consistency", reviewShellBlockConsistency(repoRoot)],
    ["dashboard_summary_consistency", reviewDashboardSummaryConsistency(repoRoot)],
    ["local_action_status_consistency", reviewLocalActionStatusConsistency(repoRoot)],
    ["readiness_component_coverage", reviewReadinessComponentCoverage()],
    ["canvas_schema_health", reviewCanvasSchemaHealth(repoRoot)]
  ].map(([component, result]) => ({
    component,
    status: result.status,
    live_executed: result.live_executed === true,
    command_execution_exposed: result.command_execution_exposed === true
  }));
  const failingComponents = components
    .filter((component) => component.status !== "PASS")
    .map((component) => `${component.component}:${component.status}`);
  const commandExecutionComponents = components
    .filter((component) => component.command_execution_exposed)
    .map((component) => component.component);
  const liveExecutionComponents = components
    .filter((component) => component.live_executed)
    .map((component) => component.component);
  const passed = failingComponents.length === 0
    && commandExecutionComponents.length === 0
    && liveExecutionComponents.length === 0;

  return {
    status: passed ? "PASS" : "FAIL",
    component_count: components.length,
    passing_components: components.filter((component) => component.status === "PASS").length,
    failing_components: failingComponents,
    command_execution_components: commandExecutionComponents,
    live_execution_components: liveExecutionComponents,
    command_execution_exposed: commandExecutionComponents.length > 0,
    live_executed: liveExecutionComponents.length > 0,
    components
  };
}

function trimOutput(value) {
  const text = String(value || "");
  if (text.length <= 4000) return text;
  return `${text.slice(0, 3800)}\n[output truncated]`;
}

function runCommand(spec, repoRoot) {
  return new Promise((resolve) => {
    let stdout = "";
    let stderr = "";
    let child;
    const spawnSpec = resolveSpawnSpec(spec);

    try {
      child = spawn(spawnSpec.command, spawnSpec.args, {
        cwd: repoRoot,
        shell: false,
        windowsHide: true
      });
    } catch (error) {
      resolve({
        label: spec.label,
        command: [spec.command, ...spec.args].join(" "),
        status: "FAIL",
        exit_code: null,
        stdout: "",
        stderr: trimOutput(error.message)
      });
      return;
    }

    child.stdout.on("data", (chunk) => {
      stdout += chunk.toString();
    });
    child.stderr.on("data", (chunk) => {
      stderr += chunk.toString();
    });
    child.on("error", (error) => {
      resolve({
        label: spec.label,
        command: [spec.command, ...spec.args].join(" "),
        status: "FAIL",
        exit_code: null,
        stdout: trimOutput(stdout),
        stderr: trimOutput(error.message)
      });
    });
    child.on("close", (code) => {
      resolve({
        label: spec.label,
        command: [spec.command, ...spec.args].join(" "),
        status: code === 0 ? "PASS" : "FAIL",
        exit_code: code,
        stdout: trimOutput(stdout),
        stderr: trimOutput(stderr)
      });
    });
  });
}

export function buildLocalActions(canvasWorkbench, agentTaskQueue) {
  const activeLane = canvasWorkbench.active_governed_lane;
  const latestTask = [...agentTaskQueue].reverse()
    .find((row) => row.status && row.status.startsWith("EXECUTED"));

  return [
    {
      action_id: CANVAS_LANE_REVIEW_ACTION_ID,
      title: "Inspeccionar carril Agile Canvas",
      status: "READY_LOCAL_GOVERNED",
      surface: "agileagentcanvas_context",
      owner_agent: activeLane.owner_agent,
      target: activeLane.lane_id,
      evidence: "structured canvas lane review available",
      execution_mode: "structured_local_review",
      allowed_now: "run_structured_canvas_lane_review|review_canvas_artifacts|review_allowlist",
      blocked_actions: "live_provider_call|secret_handling|external_sync",
      stop_condition: "canvas_lane_structured_review_failed"
    },
    {
      action_id: TASK_QUEUE_REVIEW_ACTION_ID,
      title: "Revisar cola local VSI",
      status: agentTaskQueue.every((row) => row.status === "EXECUTED_LOCAL_VALIDATED")
        ? "EXECUTED_LOCAL_VALIDATED"
        : "NEEDS_REVIEW",
      surface: "agent_task_queue_dashboard",
      owner_agent: "codex.workspace_guardian",
      target: `${agentTaskQueue.length} tareas`,
      evidence: latestTask ? latestTask.task_id : "NO_DECLARADO",
      execution_mode: "structured_local_review",
      allowed_now: "run_structured_queue_review|review_stop_conditions",
      blocked_actions: "dispatch_live_agents|change_status_values",
      stop_condition: "task_queue_structured_review_failed"
    },
    {
      action_id: POSTCHECK_ACTION_ID,
      title: "Preparar validacion local",
      status: "READY_LOCAL_GOVERNED",
      surface: "local_agent_bridge",
      owner_agent: "codex.workspace_guardian",
      target: "local validators",
      evidence: "npm test|bridge validator|governance validators",
      execution_mode: "postcheck_allowlist",
      allowed_now: "run_local_tests|run_local_validators|smoke_loopback_dashboard",
      blocked_actions: "execute_arbitrary_shell_from_dashboard|production_write|live_provider_call",
      stop_condition: "local_validator_fails"
    },
    {
      action_id: LIVE_GATE_PACKET_REVIEW_ACTION_ID,
      title: "Revisar paquetes live-gateados",
      status: "READY_LOCAL_GOVERNED",
      surface: "live_gate_packet_review",
      owner_agent: "codex.workspace_guardian",
      target: "Jira|OpenAI|Microsoft|Power Platform",
      evidence: "order packets local structured review",
      execution_mode: "structured_local_review",
      allowed_now: "read_order_packets|review_missing_fields|review_live_boundaries",
      blocked_actions: "live_provider_call|secret_handling|connector_auth|production_write",
      stop_condition: "live_gate_packet_review_failed"
    },
    {
      action_id: BRIDGE_CONTRACT_REVIEW_ACTION_ID,
      title: "Revisar contrato del bridge local",
      status: "READY_LOCAL_GOVERNED",
      surface: "local_agent_bridge_contract",
      owner_agent: "codex.workspace_guardian",
      target: "http-loopback contract",
      evidence: "structured bridge contract review available",
      execution_mode: "structured_local_review",
      allowed_now: "read_bridge_contract|review_loopback_boundary|review_action_allowlist",
      blocked_actions: "execute_arbitrary_shell_from_dashboard|live_provider_call|secret_handling|production_write",
      stop_condition: "bridge_contract_structured_review_failed"
    },
    {
      action_id: DASHBOARD_INTEGRITY_REVIEW_ACTION_ID,
      title: "Revisar integridad del tablero",
      status: "READY_LOCAL_GOVERNED",
      surface: "local_dashboard_integrity",
      owner_agent: "codex.workspace_guardian",
      target: "acciones|cola|canvas",
      evidence: "structured dashboard integrity review available",
      execution_mode: "structured_local_review",
      allowed_now: "review_dashboard_counts|review_action_allowlist|review_no_live_boundary",
      blocked_actions: "execute_arbitrary_shell_from_dashboard|live_provider_call|secret_handling|production_write",
      stop_condition: "dashboard_integrity_review_failed"
    },
    {
      action_id: ACTION_BOUNDARY_REVIEW_ACTION_ID,
      title: "Revisar frontera de acciones",
      status: "READY_LOCAL_GOVERNED",
      surface: "local_action_boundary",
      owner_agent: "codex.workspace_guardian",
      target: "local action plans",
      evidence: "structured action boundary review available",
      execution_mode: "structured_local_review",
      allowed_now: "review_action_plans|review_no_live_boundary|review_stop_conditions",
      blocked_actions: "execute_arbitrary_shell_from_dashboard|live_provider_call|secret_handling|production_write",
      stop_condition: "action_boundary_review_failed"
    },
    {
      action_id: READINESS_BUNDLE_REVIEW_ACTION_ID,
      title: "Revisar readiness agregado",
      status: "READY_LOCAL_GOVERNED",
      surface: "local_readiness_bundle",
      owner_agent: "codex.workspace_guardian",
      target: "dashboard readiness bundle",
      evidence: "structured readiness bundle review available",
      execution_mode: "structured_local_review",
      allowed_now: "review_readiness_bundle|review_component_status|review_no_live_boundary",
      blocked_actions: "execute_arbitrary_shell_from_dashboard|live_provider_call|secret_handling|production_write",
      stop_condition: "readiness_bundle_review_failed"
    },
    {
      action_id: UI_TRANSLATION_REVIEW_ACTION_ID,
      title: "Revisar traducciones del tablero",
      status: "READY_LOCAL_GOVERNED",
      surface: "local_ui_translation_integrity",
      owner_agent: "codex.workspace_guardian",
      target: "human dashboard labels",
      evidence: "structured UI translation review available",
      execution_mode: "structured_local_review",
      allowed_now: "review_human_labels|review_result_renderers|review_file_fallback",
      blocked_actions: "execute_arbitrary_shell_from_dashboard|live_provider_call|secret_handling|production_write",
      stop_condition: "ui_translation_review_failed"
    },
    {
      action_id: TASK_LINEAGE_REVIEW_ACTION_ID,
      title: "Revisar linaje de tareas",
      status: "READY_LOCAL_GOVERNED",
      surface: "local_task_lineage",
      owner_agent: "codex.workspace_guardian",
      target: "VSI task queue dependencies",
      evidence: "structured task lineage review available",
      execution_mode: "structured_local_review",
      allowed_now: "review_task_dependencies|review_lock_keys|review_codex_branches",
      blocked_actions: "execute_arbitrary_shell_from_dashboard|dispatch_live_agents|live_provider_call|secret_handling|production_write",
      stop_condition: "task_lineage_review_failed"
    },
    {
      action_id: CANVAS_STORY_SYNC_REVIEW_ACTION_ID,
      title: "Revisar sincronía historias-tareas",
      status: "READY_LOCAL_GOVERNED",
      surface: "local_canvas_story_sync",
      owner_agent: "codex.workspace_guardian",
      target: "Agile Canvas epics and task queue",
      evidence: "structured canvas story sync review available",
      execution_mode: "structured_local_review",
      allowed_now: "review_story_counts|review_functional_refs|review_task_story_sync",
      blocked_actions: "execute_arbitrary_shell_from_dashboard|live_provider_call|secret_handling|production_write|external_sync",
      stop_condition: "canvas_story_sync_review_failed"
    },
    {
      action_id: ROUTE_CONTRACT_SYNC_REVIEW_ACTION_ID,
      title: "Revisar sincronía contrato-rutas",
      status: "READY_LOCAL_GOVERNED",
      surface: "local_route_contract_sync",
      owner_agent: "codex.workspace_guardian",
      target: "bridge contract and route matrix",
      evidence: "structured route contract sync review available",
      execution_mode: "structured_local_review",
      allowed_now: "review_allowed_routes|review_route_matrix|review_route_blocks",
      blocked_actions: "execute_arbitrary_shell_from_dashboard|live_provider_call|secret_handling|production_write",
      stop_condition: "route_contract_sync_review_failed"
    },
    {
      action_id: SERVER_ENDPOINT_GUARD_REVIEW_ACTION_ID,
      title: "Revisar guards del servidor local",
      status: "READY_LOCAL_GOVERNED",
      surface: "local_server_endpoint_guards",
      owner_agent: "codex.workspace_guardian",
      target: "loopback and dev-auth endpoints",
      evidence: "structured server endpoint guard review available",
      execution_mode: "structured_local_review",
      allowed_now: "review_loopback_guards|review_dev_auth_guards|review_no_live_responses",
      blocked_actions: "execute_arbitrary_shell_from_dashboard|live_provider_call|secret_handling|production_write",
      stop_condition: "server_endpoint_guard_review_failed"
    },
    {
      action_id: VALIDATOR_COVERAGE_REVIEW_ACTION_ID,
      title: "Revisar cobertura de validadores",
      status: "READY_LOCAL_GOVERNED",
      surface: "local_validator_coverage",
      owner_agent: "codex.workspace_guardian",
      target: "contract|validator|test|README|UI",
      evidence: "structured validator coverage review available",
      execution_mode: "structured_local_review",
      allowed_now: "review_action_coverage|review_result_keys|review_docs_tests",
      blocked_actions: "execute_arbitrary_shell_from_dashboard|live_provider_call|secret_handling|production_write",
      stop_condition: "validator_coverage_review_failed"
    },
    {
      action_id: ERROR_RESPONSE_SHAPE_REVIEW_ACTION_ID,
      title: "Revisar forma de errores",
      status: "READY_LOCAL_GOVERNED",
      surface: "local_error_response_shape",
      owner_agent: "codex.workspace_guardian",
      target: "blocked and not_found responses",
      evidence: "structured error response shape review available",
      execution_mode: "structured_local_review",
      allowed_now: "review_error_shapes|review_no_live_responses|review_body_limits",
      blocked_actions: "execute_arbitrary_shell_from_dashboard|live_provider_call|secret_handling|production_write",
      stop_condition: "error_response_shape_review_failed"
    },
    {
      action_id: POSTCHECK_ALLOWLIST_REVIEW_ACTION_ID,
      title: "Revisar allowlist de postcheck",
      status: "READY_LOCAL_GOVERNED",
      surface: "local_postcheck_allowlist",
      owner_agent: "codex.workspace_guardian",
      target: "purpose-built postcheck commands",
      evidence: "structured postcheck allowlist review available",
      execution_mode: "structured_local_review",
      allowed_now: "review_postcheck_labels|review_safe_commands|review_no_external_calls",
      blocked_actions: "execute_arbitrary_shell_from_dashboard|live_provider_call|secret_handling|production_write|force_push",
      stop_condition: "postcheck_allowlist_review_failed"
    },
    {
      action_id: SHELL_BLOCK_CONSISTENCY_REVIEW_ACTION_ID,
      title: "Revisar bloqueo shell",
      status: "READY_LOCAL_GOVERNED",
      surface: "local_shell_block_consistency",
      owner_agent: "codex.workspace_guardian",
      target: "shell connector contract and route",
      evidence: "structured shell block consistency review available",
      execution_mode: "structured_local_review",
      allowed_now: "review_shell_block_contract|review_shell_route_blocks|review_no_shell_execution",
      blocked_actions: "execute_arbitrary_shell_from_dashboard|live_provider_call|secret_handling|production_write|destructive_action",
      stop_condition: "shell_block_consistency_review_failed"
    },
    {
      action_id: DASHBOARD_SUMMARY_CONSISTENCY_REVIEW_ACTION_ID,
      title: "Revisar resumen del tablero",
      status: "READY_LOCAL_GOVERNED",
      surface: "local_dashboard_summary_consistency",
      owner_agent: "codex.workspace_guardian",
      target: "dashboard summary counts",
      evidence: "structured dashboard summary consistency review available",
      execution_mode: "structured_local_review",
      allowed_now: "review_dashboard_summary_counts|review_queue_execution_counts|review_active_lane_status",
      blocked_actions: "execute_arbitrary_shell_from_dashboard|live_provider_call|secret_handling|production_write",
      stop_condition: "dashboard_summary_consistency_review_failed"
    },
    {
      action_id: LOCAL_ACTION_STATUS_CONSISTENCY_REVIEW_ACTION_ID,
      title: "Revisar estados de acciones",
      status: "READY_LOCAL_GOVERNED",
      surface: "local_action_status_consistency",
      owner_agent: "codex.workspace_guardian",
      target: "local action status and modes",
      evidence: "structured local action status consistency review available",
      execution_mode: "structured_local_review",
      allowed_now: "review_action_status_values|review_action_modes|review_action_required_fields",
      blocked_actions: "execute_arbitrary_shell_from_dashboard|live_provider_call|secret_handling|production_write",
      stop_condition: "local_action_status_consistency_review_failed"
    },
    {
      action_id: READINESS_COMPONENT_COVERAGE_REVIEW_ACTION_ID,
      title: "Revisar cobertura readiness",
      status: "READY_LOCAL_GOVERNED",
      surface: "local_readiness_component_coverage",
      owner_agent: "codex.workspace_guardian",
      target: "readiness component set",
      evidence: "structured readiness component coverage review available",
      execution_mode: "structured_local_review",
      allowed_now: "review_readiness_components|review_component_uniqueness|review_component_expected_set",
      blocked_actions: "execute_arbitrary_shell_from_dashboard|live_provider_call|secret_handling|production_write",
      stop_condition: "readiness_component_coverage_review_failed"
    },
    {
      action_id: CANVAS_SCHEMA_HEALTH_REVIEW_ACTION_ID,
      title: "Revisar salud schema Canvas",
      status: "READY_LOCAL_GOVERNED",
      surface: "local_canvas_schema_health",
      owner_agent: "codex.workspace_guardian",
      target: "Agile Agent Canvas JSON",
      evidence: "structured canvas schema health review available",
      execution_mode: "structured_local_review",
      allowed_now: "review_canvas_schema_contract|review_schema_drift|review_json_artifact_health",
      blocked_actions: "execute_arbitrary_shell_from_dashboard|live_provider_call|secret_handling|production_write|external_sync",
      stop_condition: "canvas_schema_health_review_failed"
    }
  ];
}

export function getLocalActionExecutionPlan(actionId) {
  if (getStructuredReviewActionIds().includes(actionId)) {
    return {
      action_id: actionId,
      execute_now: true,
      status: "READY_LOCAL_GOVERNED",
      command_execution_exposed: false,
      live_executed: false,
      shell_mode: "structured_local_review_no_shell",
      postcheck_commands: []
    };
  }

  if (actionId !== POSTCHECK_ACTION_ID) {
    return {
      action_id: actionId,
      execute_now: false,
      status: "GUIDED_READ_ONLY",
      command_execution_exposed: false,
      live_executed: false,
      postcheck_commands: []
    };
  }

  return {
    action_id: actionId,
    execute_now: true,
    status: "READY_LOCAL_GOVERNED",
    command_execution_exposed: false,
    live_executed: false,
    shell_mode: "purpose_built_postcheck_allowlist",
    postcheck_commands: getPostcheckCommands().map((spec) => spec.label)
  };
}

export async function runLocalAction(actionId, repoRoot) {
  const plan = getLocalActionExecutionPlan(actionId);
  if (actionId === CANVAS_SCHEMA_HEALTH_REVIEW_ACTION_ID) {
    const canvasSchemaHealthReview = reviewCanvasSchemaHealth(repoRoot);
    return {
      ...plan,
      status: canvasSchemaHealthReview.status,
      evidence: "structured canvas schema health review executed",
      canvas_schema_health_review: canvasSchemaHealthReview,
      stop_condition: canvasSchemaHealthReview.status === "PASS"
        ? "canvas_schema_health_review_passed"
        : "canvas_schema_health_review_failed"
    };
  }

  if (actionId === READINESS_BUNDLE_REVIEW_ACTION_ID) {
    const readinessBundleReview = reviewReadinessBundle(repoRoot);
    return {
      ...plan,
      status: readinessBundleReview.status,
      evidence: "structured readiness bundle review executed",
      readiness_bundle_review: readinessBundleReview,
      stop_condition: readinessBundleReview.status === "PASS"
        ? "readiness_bundle_review_passed"
        : "readiness_bundle_review_failed"
    };
  }

  if (actionId === READINESS_COMPONENT_COVERAGE_REVIEW_ACTION_ID) {
    const readinessComponentCoverageReview = reviewReadinessComponentCoverage();
    return {
      ...plan,
      status: readinessComponentCoverageReview.status,
      evidence: "structured readiness component coverage review executed",
      readiness_component_coverage_review: readinessComponentCoverageReview,
      stop_condition: readinessComponentCoverageReview.status === "PASS"
        ? "readiness_component_coverage_review_passed"
        : "readiness_component_coverage_review_failed"
    };
  }

  if (actionId === LOCAL_ACTION_STATUS_CONSISTENCY_REVIEW_ACTION_ID) {
    const localActionStatusConsistencyReview = reviewLocalActionStatusConsistency(repoRoot);
    return {
      ...plan,
      status: localActionStatusConsistencyReview.status,
      evidence: "structured local action status consistency review executed",
      local_action_status_consistency_review: localActionStatusConsistencyReview,
      stop_condition: localActionStatusConsistencyReview.status === "PASS"
        ? "local_action_status_consistency_review_passed"
        : "local_action_status_consistency_review_failed"
    };
  }

  if (actionId === DASHBOARD_SUMMARY_CONSISTENCY_REVIEW_ACTION_ID) {
    const dashboardSummaryConsistencyReview = reviewDashboardSummaryConsistency(repoRoot);
    return {
      ...plan,
      status: dashboardSummaryConsistencyReview.status,
      evidence: "structured dashboard summary consistency review executed",
      dashboard_summary_consistency_review: dashboardSummaryConsistencyReview,
      stop_condition: dashboardSummaryConsistencyReview.status === "PASS"
        ? "dashboard_summary_consistency_review_passed"
        : "dashboard_summary_consistency_review_failed"
    };
  }

  if (actionId === SHELL_BLOCK_CONSISTENCY_REVIEW_ACTION_ID) {
    const shellBlockConsistencyReview = reviewShellBlockConsistency(repoRoot);
    return {
      ...plan,
      status: shellBlockConsistencyReview.status,
      evidence: "structured shell block consistency review executed",
      shell_block_consistency_review: shellBlockConsistencyReview,
      stop_condition: shellBlockConsistencyReview.status === "PASS"
        ? "shell_block_consistency_review_passed"
        : "shell_block_consistency_review_failed"
    };
  }

  if (actionId === POSTCHECK_ALLOWLIST_REVIEW_ACTION_ID) {
    const postcheckAllowlistReview = reviewPostcheckAllowlist();
    return {
      ...plan,
      status: postcheckAllowlistReview.status,
      evidence: "structured postcheck allowlist review executed",
      postcheck_allowlist_review: postcheckAllowlistReview,
      stop_condition: postcheckAllowlistReview.status === "PASS"
        ? "postcheck_allowlist_review_passed"
        : "postcheck_allowlist_review_failed"
    };
  }

  if (actionId === ERROR_RESPONSE_SHAPE_REVIEW_ACTION_ID) {
    const errorResponseShapeReview = reviewErrorResponseShape(repoRoot);
    return {
      ...plan,
      status: errorResponseShapeReview.status,
      evidence: "structured error response shape review executed",
      error_response_shape_review: errorResponseShapeReview,
      stop_condition: errorResponseShapeReview.status === "PASS"
        ? "error_response_shape_review_passed"
        : "error_response_shape_review_failed"
    };
  }

  if (actionId === VALIDATOR_COVERAGE_REVIEW_ACTION_ID) {
    const validatorCoverageReview = reviewValidatorCoverage(repoRoot);
    return {
      ...plan,
      status: validatorCoverageReview.status,
      evidence: "structured validator coverage review executed",
      validator_coverage_review: validatorCoverageReview,
      stop_condition: validatorCoverageReview.status === "PASS"
        ? "validator_coverage_review_passed"
        : "validator_coverage_review_failed"
    };
  }

  if (actionId === SERVER_ENDPOINT_GUARD_REVIEW_ACTION_ID) {
    const serverEndpointGuardReview = reviewServerEndpointGuards(repoRoot);
    return {
      ...plan,
      status: serverEndpointGuardReview.status,
      evidence: "structured server endpoint guard review executed",
      server_endpoint_guard_review: serverEndpointGuardReview,
      stop_condition: serverEndpointGuardReview.status === "PASS"
        ? "server_endpoint_guard_review_passed"
        : "server_endpoint_guard_review_failed"
    };
  }

  if (actionId === ROUTE_CONTRACT_SYNC_REVIEW_ACTION_ID) {
    const routeContractSyncReview = reviewRouteContractSync(repoRoot);
    return {
      ...plan,
      status: routeContractSyncReview.status,
      evidence: "structured route contract sync review executed",
      route_contract_sync_review: routeContractSyncReview,
      stop_condition: routeContractSyncReview.status === "PASS"
        ? "route_contract_sync_review_passed"
        : "route_contract_sync_review_failed"
    };
  }

  if (actionId === CANVAS_STORY_SYNC_REVIEW_ACTION_ID) {
    const canvasStorySyncReview = reviewCanvasStorySync(repoRoot);
    return {
      ...plan,
      status: canvasStorySyncReview.status,
      evidence: "structured canvas story sync review executed",
      canvas_story_sync_review: canvasStorySyncReview,
      stop_condition: canvasStorySyncReview.status === "PASS"
        ? "canvas_story_sync_review_passed"
        : "canvas_story_sync_review_failed"
    };
  }

  if (actionId === TASK_LINEAGE_REVIEW_ACTION_ID) {
    const taskLineageReview = reviewTaskLineage(repoRoot);
    return {
      ...plan,
      status: taskLineageReview.status,
      evidence: "structured task lineage review executed",
      task_lineage_review: taskLineageReview,
      stop_condition: taskLineageReview.status === "PASS"
        ? "task_lineage_review_passed"
        : "task_lineage_review_failed"
    };
  }

  if (actionId === UI_TRANSLATION_REVIEW_ACTION_ID) {
    const uiTranslationReview = reviewUiTranslationIntegrity(repoRoot);
    return {
      ...plan,
      status: uiTranslationReview.status,
      evidence: "structured UI translation review executed",
      ui_translation_review: uiTranslationReview,
      stop_condition: uiTranslationReview.status === "PASS"
        ? "ui_translation_review_passed"
        : "ui_translation_review_failed"
    };
  }

  if (actionId === ACTION_BOUNDARY_REVIEW_ACTION_ID) {
    const actionBoundaryReview = reviewActionBoundary(repoRoot);
    return {
      ...plan,
      status: actionBoundaryReview.status,
      evidence: "structured local action boundary review executed",
      action_boundary_review: actionBoundaryReview,
      stop_condition: actionBoundaryReview.status === "PASS"
        ? "action_boundary_review_passed"
        : "action_boundary_review_failed"
    };
  }

  if (actionId === DASHBOARD_INTEGRITY_REVIEW_ACTION_ID) {
    const dashboardIntegrityReview = reviewDashboardIntegrity(repoRoot);
    return {
      ...plan,
      status: dashboardIntegrityReview.status,
      evidence: "structured dashboard integrity review executed",
      dashboard_integrity_review: dashboardIntegrityReview,
      stop_condition: dashboardIntegrityReview.status === "PASS"
        ? "dashboard_integrity_review_passed"
        : "dashboard_integrity_review_failed"
    };
  }

  if (actionId === BRIDGE_CONTRACT_REVIEW_ACTION_ID) {
    const bridgeContractReview = reviewBridgeContract(repoRoot);
    return {
      ...plan,
      status: bridgeContractReview.status,
      evidence: "structured bridge contract review executed",
      bridge_contract_review: bridgeContractReview,
      stop_condition: bridgeContractReview.status === "PASS"
        ? "bridge_contract_review_passed"
        : "bridge_contract_structured_review_failed"
    };
  }

  if (actionId === CANVAS_LANE_REVIEW_ACTION_ID) {
    const canvasLaneReview = reviewCanvasLane(repoRoot);
    return {
      ...plan,
      status: canvasLaneReview.status,
      evidence: "structured canvas lane review executed",
      canvas_lane_review: canvasLaneReview,
      stop_condition: canvasLaneReview.status === "PASS"
        ? "canvas_lane_review_passed"
        : "canvas_lane_structured_review_failed"
    };
  }

  if (actionId === LIVE_GATE_PACKET_REVIEW_ACTION_ID) {
    const packetReview = reviewLiveGatePackets(repoRoot);
    return {
      ...plan,
      status: packetReview.status,
      evidence: "structured live-gate packet review executed",
      gate_packet_review: packetReview,
      stop_condition: packetReview.status === "PASS"
        ? "live_gate_packet_review_passed"
        : "live_gate_packet_review_failed"
    };
  }

  if (actionId === TASK_QUEUE_REVIEW_ACTION_ID) {
    const reviewResult = reviewTaskQueue(repoRoot);
    return {
      ...plan,
      status: reviewResult.status,
      evidence: "structured local task queue review executed",
      review_result: reviewResult,
      stop_condition: reviewResult.status === "PASS"
        ? "task_queue_review_passed"
        : "task_queue_structured_review_failed"
    };
  }

  if (!plan.execute_now) {
    return {
      ...plan,
      status: "ok",
      evidence: "guided read-only action selected"
    };
  }

  const results = [];
  for (const spec of getPostcheckCommands()) {
    const result = await runCommand(spec, repoRoot);
    results.push(result);
    if (result.status !== "PASS") break;
  }

  const passed = results.every((result) => result.status === "PASS");
  return {
    ...plan,
    status: passed ? "PASS" : "FAIL",
    evidence: "purpose-built local postcheck allowlist executed",
    postcheck_results: results,
    stop_condition: passed ? "postcheck_passed" : "local_validator_fails"
  };
}
