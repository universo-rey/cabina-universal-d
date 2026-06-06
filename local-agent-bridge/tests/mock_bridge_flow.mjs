import assert from "node:assert/strict";
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { assertSyntheticRequest } from "../src/policy.mjs";
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
