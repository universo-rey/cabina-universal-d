import assert from "node:assert/strict";
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { assertLoopbackReadSurface, assertSyntheticRequest, isLoopbackHost } from "../src/policy.mjs";
import { selectRoute } from "../src/router.mjs";
import { buildEvidence } from "../src/evidenceAdapter.mjs";
import { resolveConnection } from "../src/mcpRegistry.mjs";
import { collectDashboardData } from "../src/dashboardData.mjs";
import { buildShellCommandBlockedResponse, getShellConnectorStatus } from "../src/shellConnector.mjs";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const repoRoot = path.resolve(__dirname, "..", "..");
const fixturePath = path.join(repoRoot, "tests", "sdu-agent-runtime", "fixtures", "mock_teams_activity.json");
const payload = JSON.parse(fs.readFileSync(fixturePath, "utf8"));

assertSyntheticRequest(payload);
assert.equal(isLoopbackHost("127.0.0.1"), true);
assert.equal(isLoopbackHost("localhost"), true);
assert.equal(isLoopbackHost("0.0.0.0"), false);
assert.throws(() => assertLoopbackReadSurface("0.0.0.0"), /loopback host required/);

const route = selectRoute(payload.text);
assert.equal(route.route_id, "teams.route.codex_cloud");

const connection = resolveConnection(route.connection_id, repoRoot);
assert.equal(connection.status, "TEMPLATE_ONLY");
assert.equal(connection.gated, false);

const evidence = buildEvidence(route, payload);
assert.equal(evidence.live_executed, false);
assert.equal(evidence.sanitized, true);
assert.ok(evidence.blocked_surfaces.includes("codex_cloud_apply"));

const dashboard = collectDashboardData(repoRoot);
const dashboardHtml = fs.readFileSync(path.join(repoRoot, "local-agent-bridge", "public", "index.html"), "utf8");
const workspaceSettingsPath = path.join(repoRoot, ".vscode", "settings.json");
const workspaceSettings = fs.existsSync(workspaceSettingsPath)
  ? JSON.parse(fs.readFileSync(workspaceSettingsPath, "utf8"))
  : {};
const userCataloguePacket = fs.readFileSync(
  path.join(repoRoot, ".agents", "codex", "orders", "ORDER_VSI_AGILE_AGENT_CANVAS_USER_CATALOGUE_20260606.md"),
  "utf8"
);
const canvasVision = JSON.parse(fs.readFileSync(path.join(repoRoot, ".agileagentcanvas-context", "vision.json"), "utf8"));
const canvasPrd = JSON.parse(fs.readFileSync(path.join(repoRoot, ".agileagentcanvas-context", "planning", "prd.json"), "utf8"));
const canvasEpics = JSON.parse(fs.readFileSync(path.join(repoRoot, ".agileagentcanvas-context", "planning", "epics.json"), "utf8"));
assert.equal(dashboard.status, "ok");
assert.equal(dashboard.live_executed, false);
assert.ok(dashboard.summary.local_task_scoped_agents > 0);
assert.ok(dashboard.summary.gated_records > 0);
assert.equal(dashboard.summary.agile_agent_canvas_controls, dashboard.agile_agent_canvas.length);
assert.equal(dashboard.summary.canvas_artifacts_ready, 4);
assert.equal(dashboard.canvas_workbench.status, "ACTIVE_LOCAL_WORKBENCH");
assert.equal(dashboard.canvas_workbench.project_name, "Cabina Universal Agent Control");
assert.ok(dashboard.agile_agent_canvas.some((row) => row.control_id === "aac.canvas.seed_package"));
assert.ok(dashboard.semaphores.every((row) => row.color));
assert.equal(dashboard.summary.agent_task_queue_records, dashboard.agent_task_queue.length);
assert.ok(dashboard.summary.queued_agent_tasks >= 0);
assert.ok(dashboard.summary.executed_agent_tasks > 0);
assert.equal(
  dashboard.summary.queued_agent_tasks + dashboard.summary.executed_agent_tasks,
  dashboard.summary.agent_task_queue_records
);
assert.ok(dashboard.agent_task_queue.some((row) => row.task_id === "vsi.agent.task.002"));
assert.ok(dashboard.agent_task_queue.some((row) => row.task_id === "vsi.agent.task.011"));
assert.ok(dashboard.agent_task_queue.every((row) => row.status === "EXECUTED_LOCAL_VALIDATED"));
assert.match(dashboardHtml, /window\.location\.protocol === "file:"/);
assert.match(dashboardHtml, /renderFileFallback/);
assert.equal(canvasVision.content.activeGovernedLane.status, "ACTIVE_LOCAL_GOVERNED_USE");
assert.equal(canvasVision.content.activeGovernedLane.liveExecuted, false);
assert.equal(canvasPrd.content.activeGovernedLane.lockKey, "lock.vsi.aac_programming_lane");
assert.equal(canvasPrd.content.activeGovernedLane.liveExecuted, false);
assert.ok(canvasPrd.content.activeGovernedLane.writeAllowlist.includes(".agileagentcanvas-context/vision.json"));
assert.equal(canvasEpics.content.activeGovernedLane.linkedStory, "S-1.4");
assert.equal(canvasEpics.content.activeGovernedLane.externalSync, false);
assert.equal(Object.hasOwn(workspaceSettings, "agileagentcanvas.skillRepos"), false);
if (fs.existsSync(workspaceSettingsPath)) {
  assert.equal(workspaceSettings["agileagentcanvas.userCataloguePath"], ".agents/skills");
  assert.equal(workspaceSettings["agileagentcanvas.autoSync"], false);
}
assert.match(userCataloguePacket, /applied_setting: \.vscode\/settings\.json::agileagentcanvas\.userCataloguePath=\.agents\/skills/);

const shellStatus = getShellConnectorStatus(repoRoot);
assert.equal(shellStatus.connector_id, "local.shell.connector.governed");
assert.equal(shellStatus.mode, "status_only");
assert.equal(shellStatus.live_executed, false);
assert.ok(shellStatus.blocked_actions.includes("execute_arbitrary_command"));

const shellBlocked = buildShellCommandBlockedResponse(repoRoot);
assert.equal(shellBlocked.status, "blocked");
assert.equal(shellBlocked.live_executed, false);
assert.equal(shellBlocked.stop_condition, "LOCAL_SHELL_COMMAND_EXECUTION_NOT_EXPOSED");

console.log("SDU_LOCAL_AGENT_BRIDGE_MOCK_FLOW_PASS");
