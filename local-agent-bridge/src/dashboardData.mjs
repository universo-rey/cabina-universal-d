import fs from "node:fs";
import path from "node:path";
import { buildLocalActions } from "./localActions.mjs";

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

function readCsv(repoRoot, relativePath) {
  const fullPath = path.join(repoRoot, relativePath);
  return parseCsv(fs.readFileSync(fullPath, "utf8"));
}

function readJsonArtifact(repoRoot, relativePath) {
  const fullPath = path.join(repoRoot, relativePath);
  try {
    const parsed = JSON.parse(fs.readFileSync(fullPath, "utf8"));
    return {
      path: relativePath,
      exists: true,
      parses: true,
      project_name: parsed?.metadata?.projectName || parsed?.content?.productName || "NO_DECLARADO",
      artifact_type: parsed?.metadata?.artifactType || "NO_DECLARADO",
      status: parsed?.metadata?.status || "NO_DECLARADO"
    };
  } catch (error) {
    return {
      path: relativePath,
      exists: fs.existsSync(fullPath),
      parses: false,
      project_name: "NO_DECLARADO",
      artifact_type: "NO_DECLARADO",
      status: "INVALID_JSON",
      error: error.message
    };
  }
}

function readJson(repoRoot, relativePath) {
  const fullPath = path.join(repoRoot, relativePath);
  try {
    return JSON.parse(fs.readFileSync(fullPath, "utf8"));
  } catch {
    return null;
  }
}

function getActiveGovernedLane(prd) {
  return prd?.metadata?.customFields?.activeGovernedLane || prd?.content?.activeGovernedLane;
}

function countBy(rows, field) {
  return rows.reduce((counts, row) => {
    const key = row[field] || "NO_DECLARADO";
    counts[key] = (counts[key] ?? 0) + 1;
    return counts;
  }, {});
}

function firstRows(rows, count) {
  return rows.slice(0, count);
}

function summarizeCanvasWorkbench(repoRoot, agileAgentCanvas) {
  const artifactPaths = [
    ".agileagentcanvas-context/vision.json",
    ".agileagentcanvas-context/discovery/product-brief.json",
    ".agileagentcanvas-context/planning/prd.json",
    ".agileagentcanvas-context/planning/epics.json"
  ];
  const artifacts = artifactPaths.map((artifactPath) => readJsonArtifact(repoRoot, artifactPath));
  const seedControl = agileAgentCanvas.find((row) => row.control_id === "aac.canvas.seed_package");
  const pendingGates = agileAgentCanvas
    .filter((row) => row.gate && row.gate !== "none" && !row.status.startsWith("EXECUTED"))
    .map((row) => ({
      control_id: row.control_id,
      surface: row.surface,
      gate: row.gate,
      status: row.status
    }));

  const expectedProject = "Cabina Universal Agent Control";
  const parsedCount = artifacts.filter((artifact) => artifact.parses).length;
  const cabinaArtifactCount = artifacts.filter((artifact) => artifact.project_name === expectedProject).length;
  const prd = readJson(repoRoot, ".agileagentcanvas-context/planning/prd.json");
  const activeLane = getActiveGovernedLane(prd);
  const status = seedControl && parsedCount === artifacts.length && cabinaArtifactCount === artifacts.length
    ? "ACTIVE_LOCAL_WORKBENCH"
    : "NEEDS_REVIEW";

  return {
    status,
    project_name: expectedProject,
    artifact_count: artifacts.length,
    parsed_artifacts: parsedCount,
    cabina_artifacts: cabinaArtifactCount,
    seed_control_status: seedControl?.status || "NO_ENCONTRADO",
    live_executed: false,
    active_governed_lane: activeLane
      ? {
        lane_id: activeLane.laneId || "NO_DECLARADO",
        status: activeLane.status || "NO_DECLARADO",
        owner_agent: activeLane.ownerAgent || "NO_DECLARADO",
        reviewer_agent: activeLane.reviewerAgent || "NO_DECLARADO",
        lock_key: activeLane.lockKey || "NO_DECLARADO",
        write_allowlist_count: Array.isArray(activeLane.writeAllowlist) ? activeLane.writeAllowlist.length : 0,
        validator_count: Array.isArray(activeLane.validators) ? activeLane.validators.length : 0,
        live_executed: activeLane.liveExecuted === true,
        external_sync: activeLane.externalSync === true
      }
      : {
        lane_id: "NO_ENCONTRADO",
        status: "NO_ENCONTRADO",
        owner_agent: "NO_DECLARADO",
        reviewer_agent: "NO_DECLARADO",
        lock_key: "NO_DECLARADO",
        write_allowlist_count: 0,
        validator_count: 0,
        live_executed: false,
        external_sync: false
      },
    pending_gates: pendingGates,
    artifacts
  };
}

function gateNextAction(row) {
  const surface = row.surface || "";
  const gate = row.gate || row.gate_required || "";
  if (String(row.status || row.observed_state || "").includes("SUSPENDED")) return "suspendido por operador";
  if (surface === "jira_integration") return "preparar paquete Jira existente";
  if (surface === "skill_catalogue") return "usar catalogo local workspace";
  if (surface === "graphify_commands") return "mantener plan manual gateado";
  if (gate.includes("GATE_OPENAI_LIVE")) return "preparar gate OpenAI live";
  if (gate.includes("GATE_MICROSOFT_LIVE_WRITE")) return "preparar gate Microsoft live";
  return row.allowed_preparation || row.allowed_now || "preparacion local gobernada";
}

function buildVisibleGateLane(gateQueue, agileAgentCanvas) {
  const canvasItems = agileAgentCanvas
    .filter((row) => row.gate && row.gate !== "none" && !String(row.status || row.observed_state || "").includes("SUSPENDED"))
    .map((row) => ({
      source: "agile_agent_canvas",
      gate: row.gate,
      surface: row.surface,
      status: row.status,
      owner_agent: row.owner_agent,
      next_action: gateNextAction(row),
      blocked_actions: row.blocked_without_gate,
      target: row.control_id,
      validator: row.validator,
      stop_condition: row.stop_condition
    }));
  const queueItems = gateQueue.map((row) => ({
    source: "global_gate_queue",
    gate: row.gate_required,
    surface: row.target_artifact,
    status: row.status,
    owner_agent: row.gate_owner,
    next_action: gateNextAction(row),
    blocked_actions: row.blocked_execution,
    target: row.queue_id,
    validator: row.validator,
    stop_condition: row.stop_condition
  }));
  const items = [...canvasItems, ...queueItems];

  return {
    status: items.length > 0 ? "ACTIVE_VISIBLE_GATE_LANE" : "NO_VISIBLE_GATES",
    item_count: items.length,
    canvas_gate_count: canvasItems.length,
    queue_gate_count: queueItems.length,
    ready_preparation_count: items.filter((item) => item.next_action).length,
    blocked_live_count: items.filter((item) => item.blocked_actions).length,
    live_executed: false,
    items
  };
}

function summarizeAacNativeAgents(aacNativeAgents) {
  const availableRows = aacNativeAgents.filter((row) => row.status === "AVAILABLE_NATIVE_AAC_AGENT");
  const activeRows = aacNativeAgents.filter((row) => row.activation_status === "ACTIVE_AAC_NATIVE_TEAM_GOVERNED");
  return {
    roster_id: "AAC_NATIVE_AGENTS_20260608",
    source: ".agents/codex/matrices/AAC_NATIVE_AGENTS_20260608.csv",
    status: activeRows.length === aacNativeAgents.length ? "ACTIVE_AAC_NATIVE_TEAM_GOVERNED" : "NEEDS_REVIEW",
    team_role: "native_aac_team_not_cabina_authority",
    record_count: aacNativeAgents.length,
    available_record_count: availableRows.length,
    active_record_count: activeRows.length,
    activation_mode: "repo_local_board_activation",
    direct_invocation_from_codex: false,
    agents: aacNativeAgents.map((row) => ({
      native_agent_id: row.native_agent_id,
      display_name: row.display_name,
      title: row.title,
      module: row.module,
      agent_class: row.agent_class,
      authority_boundary: row.authority_boundary,
      activation_status: row.activation_status,
      activation_mode: row.activation_mode,
      direct_invocation_from_codex: row.direct_invocation_from_codex === "true",
      stop_condition: row.stop_condition
    })),
    live_executed: false,
    external_sync: false
  };
}

function summarizeCabinaGovernanceAgents(cabinaGovernanceAgents) {
  const activeRows = cabinaGovernanceAgents.filter((row) => row.status === "ACTIVE_LOCAL_GOVERNED_USE");
  return {
    roster_id: "CABINA_GOVERNANCE_AGENTS_FOR_VSI_20260608",
    source: ".agents/codex/matrices/CABINA_GOVERNANCE_AGENTS_FOR_VSI_20260608.csv",
    status: activeRows.length === cabinaGovernanceAgents.length ? "ACTIVE_CABINA_GOVERNED_WORK_LAYER" : "NEEDS_REVIEW",
    record_count: cabinaGovernanceAgents.length,
    active_record_count: activeRows.length,
    relation: "cabina_governed_work_agent_not_native_aac_team",
    authority: "cabina_governs_vsi_agile_agent_canvas_board",
    work_layer: "cabina_agents_work_on_board_and_govern_it",
    agents: cabinaGovernanceAgents.map((row) => ({
      agent_id: row.agent_id,
      cabina_role: row.cabina_role,
      story_ids: row.story_ids,
      execution_mode: row.execution_mode,
      dispatch_tool: row.dispatch_tool,
      stop_condition: row.stop_condition
    })),
    live_executed: false,
    external_sync: false
  };
}

function buildBoardBoundary(agentTaskQueue, visibleGateLane, aacNativeAgents, cabinaGovernanceAgents) {
  const nativeSummary = summarizeAacNativeAgents(aacNativeAgents);
  const governanceSummary = summarizeCabinaGovernanceAgents(cabinaGovernanceAgents);
  return {
    status: "BOARD_BOUNDARY_DECLARED",
    live_executed: false,
    primary_board: {
      board_id: "vsi_agile_agent_canvas_mother_board",
      label: "Tablero principal madre VSI",
      explicit_name: "Agile Agent Canvas",
      board_kind: "agile_agent_canvas_creation_planning_board",
      authority_role: "primary_mother_board",
      surface: "vscode_insiders_agile_agent_canvas",
      source: ".agileagentcanvas-context/planning/epics.json|.agileagentcanvas-context/bmm/sprint-status.json",
      purpose: "Fuente primaria visual para leer, crear y organizar tareas antes de matriz, rama, PR o gate live.",
      governance_policy: "Los agentes Cabina trabajan sobre este tablero y lo gobiernan; los agentes nativos AAC son un equipo nativo colaborador.",
      not_this_board: "control_agentes_cabina_queue_board",
      agent_task_records: agentTaskQueue.length,
      native_agents: nativeSummary,
      governance_agents: governanceSummary,
      write_policy: "uso local gobernado dentro de allowlist VSI; sin live write ni shell arbitrario",
      stop_condition: "vsi_mother_board_boundary_drift"
    },
    auxiliary_board: {
      board_id: "control_agentes_cabina",
      label: "Tablero de cola Control de Agentes de Cabina",
      explicit_name: "Control de Agentes de Cabina",
      board_kind: "agent_control_queue_board",
      authority_role: "auxiliary_queue_control_board",
      surface: "loopback_dashboard_local",
      source: "local-agent-bridge|VSCODE_INSIDERS_AGENT_TASK_QUEUE_20260606.csv|AGENTS_SDK_LIVE_AGENT_GLOBAL_OPERABILITY_GATE_QUEUE_20260605.csv",
      purpose: "Tablero auxiliar de control, readiness, gates visibles y postchecks; no es la fuente primaria de creacion.",
      not_this_board: "vsi_agile_agent_canvas_mother_board",
      agent_task_records: agentTaskQueue.length,
      visible_gate_records: visibleGateLane.item_count,
      write_policy: "lectura local y reviews estructuradas; acciones guiadas sin shell arbitrario ni writes live",
      stop_condition: "agent_control_queue_board_boundary_drift"
    },
    external_website_queue: {
      queue_id: "cola_sitio_web",
      label: "Cola del sitio web",
      surface: "sitio_web_externo",
      source: "NO_CONECTADA_EN_CONTROL_AGENTES_CABINA",
      purpose: "Entrada operativa desde un sitio web o producto publicado.",
      records_visible_here: 0,
      write_policy: "requiere target owner rollback postcheck y gate live separado",
      stop_condition: "website_queue_target_missing"
    }
  };
}

export function resolveRepoRoot(startPath = process.cwd()) {
  const normalized = path.resolve(startPath);
  if (path.basename(normalized) === "local-agent-bridge") {
    return path.dirname(normalized);
  }
  return normalized;
}

export function collectDashboardData(startPath = process.cwd()) {
  const repoRoot = resolveRepoRoot(startPath);
  const matricesRoot = ".agents/codex/matrices";
  const paths = {
    operability: `${matricesRoot}/AGENTS_GLOBAL_OPERABILITY_INVENTORY_20260605.csv`,
    semaphore: `${matricesRoot}/AGENTS_SDK_LIVE_AGENT_GLOBAL_OPERABILITY_SEMAPHORE_MATRIX_20260605.csv`,
    gateQueue: `${matricesRoot}/AGENTS_SDK_LIVE_AGENT_GLOBAL_OPERABILITY_GATE_QUEUE_20260605.csv`,
    autonomous: `${matricesRoot}/AUTONOMOUS_AGENT_EXECUTION_MATRIX_20260602.csv`,
    agileAgentCanvas: `${matricesRoot}/VSCODE_INSIDERS_AGILE_AGENT_CANVAS_GOVERNANCE_20260606.csv`,
    agentTaskQueue: `${matricesRoot}/VSCODE_INSIDERS_AGENT_TASK_QUEUE_20260606.csv`,
    aacNativeAgents: `${matricesRoot}/AAC_NATIVE_AGENTS_20260608.csv`,
    cabinaGovernanceAgents: `${matricesRoot}/CABINA_GOVERNANCE_AGENTS_FOR_VSI_20260608.csv`
  };

  const operability = readCsv(repoRoot, paths.operability);
  const semaphore = readCsv(repoRoot, paths.semaphore);
  const gateQueue = readCsv(repoRoot, paths.gateQueue);
  const autonomous = readCsv(repoRoot, paths.autonomous);
  const agileAgentCanvas = readCsv(repoRoot, paths.agileAgentCanvas);
  const agentTaskQueue = readCsv(repoRoot, paths.agentTaskQueue);
  const aacNativeAgents = readCsv(repoRoot, paths.aacNativeAgents);
  const cabinaGovernanceAgents = readCsv(repoRoot, paths.cabinaGovernanceAgents);
  const canvasWorkbench = summarizeCanvasWorkbench(repoRoot, agileAgentCanvas);
  const localActions = buildLocalActions(canvasWorkbench, agentTaskQueue);
  const visibleGateLane = buildVisibleGateLane(gateQueue, agileAgentCanvas);
  const boardBoundary = buildBoardBoundary(agentTaskQueue, visibleGateLane, aacNativeAgents, cabinaGovernanceAgents);

  return {
    status: "ok",
    live_executed: false,
    repo_root: repoRoot,
    generated_at: new Date().toISOString(),
    sources: paths,
    summary: {
      operability_records: operability.length,
      agile_agent_canvas_controls: agileAgentCanvas.length,
      canvas_artifacts_ready: canvasWorkbench.parsed_artifacts,
      active_agile_canvas_lane: canvasWorkbench.active_governed_lane.status,
      local_actions_ready: localActions.filter((row) => row.status !== "NEEDS_REVIEW").length,
      agent_task_queue_records: agentTaskQueue.length,
      aac_native_agent_records: aacNativeAgents.length,
      cabina_governance_agent_records: cabinaGovernanceAgents.length,
      queued_agent_tasks: agentTaskQueue.filter((row) => row.status === "QUEUED_READY").length,
      executed_agent_tasks: agentTaskQueue.filter((row) => row.status.startsWith("EXECUTED")).length,
      autonomous_records: autonomous.length,
      local_task_scoped_agents: autonomous.filter((row) => row.execution_mode === "local_task_scoped_agent").length,
      codex_cloud_ready_records: autonomous.filter((row) => row.status === "ACTIVE_CODEX_CLOUD_READY").length,
      gated_records: gateQueue.length,
      visible_gate_records: visibleGateLane.item_count,
      semaphore: countBy(semaphore, "color")
    },
    semaphores: semaphore,
    gate_queue: gateQueue,
    visible_gate_lane: visibleGateLane,
    board_boundary: boardBoundary,
    agile_agent_canvas: agileAgentCanvas,
    canvas_workbench: canvasWorkbench,
    aac_native_agents: aacNativeAgents,
    cabina_governance_agents_for_vsi: cabinaGovernanceAgents,
    local_actions: localActions,
    agent_task_queue: agentTaskQueue,
    operability: firstRows(operability, 40),
    autonomous: firstRows(autonomous, 60)
  };
}
