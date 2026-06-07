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
import { getLocalActionExecutionPlan, runLocalAction } from "../src/localActions.mjs";

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
assert.equal(dashboard.canvas_workbench.active_governed_lane.lane_id, "agile_canvas_programming_lane");
assert.equal(dashboard.canvas_workbench.active_governed_lane.status, "ACTIVE_LOCAL_GOVERNED_USE");
assert.equal(dashboard.canvas_workbench.active_governed_lane.live_executed, false);
assert.equal(dashboard.canvas_workbench.active_governed_lane.external_sync, false);
assert.equal(dashboard.summary.active_agile_canvas_lane, "ACTIVE_LOCAL_GOVERNED_USE");
assert.equal(dashboard.local_actions.length, 11);
assert.equal(dashboard.summary.local_actions_ready, 11);
assert.ok(dashboard.local_actions.some(
  (row) => row.action_id === "local.action.inspect_canvas_lane" && row.execution_mode === "structured_local_review"
));
assert.ok(dashboard.local_actions.some((row) => row.action_id === "local.action.review_live_gate_packets"));
assert.ok(dashboard.local_actions.some((row) => row.action_id === "local.action.review_bridge_contract"));
assert.ok(dashboard.local_actions.some((row) => row.action_id === "local.action.review_dashboard_integrity"));
assert.ok(dashboard.local_actions.some((row) => row.action_id === "local.action.review_action_boundary"));
assert.ok(dashboard.local_actions.some((row) => row.action_id === "local.action.review_readiness_bundle"));
assert.ok(dashboard.local_actions.some((row) => row.action_id === "local.action.review_ui_translation_integrity"));
assert.ok(dashboard.local_actions.some((row) => row.action_id === "local.action.review_task_lineage"));
assert.ok(dashboard.local_actions.some((row) => row.action_id === "local.action.review_canvas_story_sync"));
assert.ok(dashboard.local_actions.some((row) => row.execution_mode === "structured_local_review"));
assert.ok(dashboard.local_actions.some((row) => row.execution_mode === "postcheck_allowlist"));
assert.ok(dashboard.local_actions.every((row) => !row.blocked_actions.includes("secret_handling") || row.status !== "NEEDS_REVIEW"));
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
assert.ok(dashboard.agent_task_queue.some((row) => row.task_id === "vsi.agent.task.012"));
assert.ok(dashboard.agent_task_queue.some((row) => row.task_id === "vsi.agent.task.013"));
assert.ok(dashboard.agent_task_queue.every((row) => row.status === "EXECUTED_LOCAL_VALIDATED"));
assert.match(dashboardHtml, /window\.location\.protocol === "file:"/);
assert.match(dashboardHtml, /renderFileFallback/);
assert.match(dashboardHtml, /Carril activo/);
assert.match(dashboardHtml, /Acciones locales/);
assert.match(dashboardHtml, /renderLocalAction/);
assert.match(dashboardHtml, /runLocalAction/);
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

const actionPlan = getLocalActionExecutionPlan("local.action.prepare_local_validation");
assert.equal(actionPlan.execute_now, true);
assert.equal(actionPlan.command_execution_exposed, false);
assert.equal(actionPlan.live_executed, false);
assert.ok(actionPlan.postcheck_commands.includes("npm test"));

const canvasLaneReviewPlan = getLocalActionExecutionPlan("local.action.inspect_canvas_lane");
assert.equal(canvasLaneReviewPlan.execute_now, true);
assert.equal(canvasLaneReviewPlan.command_execution_exposed, false);
assert.equal(canvasLaneReviewPlan.live_executed, false);
assert.equal(canvasLaneReviewPlan.shell_mode, "structured_local_review_no_shell");
const canvasLaneReview = await runLocalAction("local.action.inspect_canvas_lane", repoRoot);
assert.equal(canvasLaneReview.status, "PASS");
assert.equal(canvasLaneReview.command_execution_exposed, false);
assert.equal(canvasLaneReview.live_executed, false);
assert.equal(canvasLaneReview.canvas_lane_review.artifact_count, 4);
assert.equal(canvasLaneReview.canvas_lane_review.parsed_artifact_count, 4);
assert.equal(canvasLaneReview.canvas_lane_review.missing_allowlist_entries.length, 0);
assert.equal(canvasLaneReview.canvas_lane_review.missing_lane_fields.length, 0);
assert.equal(canvasLaneReview.canvas_lane_review.live_executed, false);
assert.equal(canvasLaneReview.canvas_lane_review.external_sync, false);

const bridgeContractReviewPlan = getLocalActionExecutionPlan("local.action.review_bridge_contract");
assert.equal(bridgeContractReviewPlan.execute_now, true);
assert.equal(bridgeContractReviewPlan.command_execution_exposed, false);
assert.equal(bridgeContractReviewPlan.live_executed, false);
assert.equal(bridgeContractReviewPlan.shell_mode, "structured_local_review_no_shell");
const bridgeContractReview = await runLocalAction("local.action.review_bridge_contract", repoRoot);
assert.equal(bridgeContractReview.status, "PASS");
assert.equal(bridgeContractReview.command_execution_exposed, false);
assert.equal(bridgeContractReview.live_executed, false);
assert.equal(bridgeContractReview.bridge_contract_review.transport, "http-loopback");
assert.equal(bridgeContractReview.bridge_contract_review.missing_allowed_action_ids.length, 0);
assert.equal(bridgeContractReview.bridge_contract_review.missing_blocked_actions.length, 0);
assert.equal(bridgeContractReview.bridge_contract_review.missing_routes.length, 0);
assert.equal(bridgeContractReview.bridge_contract_review.missing_contract_fields.length, 0);
assert.equal(bridgeContractReview.bridge_contract_review.command_execution_exposed, false);
assert.equal(bridgeContractReview.bridge_contract_review.live_executed, false);

const queueReviewPlan = getLocalActionExecutionPlan("local.action.review_task_queue");
assert.equal(queueReviewPlan.execute_now, true);
assert.equal(queueReviewPlan.command_execution_exposed, false);
assert.equal(queueReviewPlan.live_executed, false);
assert.equal(queueReviewPlan.shell_mode, "structured_local_review_no_shell");
const queueReview = await runLocalAction("local.action.review_task_queue", repoRoot);
assert.equal(queueReview.status, "PASS");
assert.equal(queueReview.command_execution_exposed, false);
assert.equal(queueReview.live_executed, false);
assert.equal(queueReview.review_result.task_count, dashboard.summary.agent_task_queue_records);
assert.equal(queueReview.review_result.duplicate_task_ids.length, 0);
assert.equal(queueReview.review_result.missing_dependencies.length, 0);

const gatePacketReviewPlan = getLocalActionExecutionPlan("local.action.review_live_gate_packets");
assert.equal(gatePacketReviewPlan.execute_now, true);
assert.equal(gatePacketReviewPlan.command_execution_exposed, false);
assert.equal(gatePacketReviewPlan.live_executed, false);
assert.equal(gatePacketReviewPlan.shell_mode, "structured_local_review_no_shell");
const gatePacketReview = await runLocalAction("local.action.review_live_gate_packets", repoRoot);
assert.equal(gatePacketReview.status, "PASS");
assert.equal(gatePacketReview.command_execution_exposed, false);
assert.equal(gatePacketReview.live_executed, false);
assert.equal(gatePacketReview.gate_packet_review.packet_count, 4);
assert.equal(gatePacketReview.gate_packet_review.existing_packet_count, 4);
assert.equal(gatePacketReview.gate_packet_review.missing_packets.length, 0);
assert.equal(gatePacketReview.gate_packet_review.packets_with_missing_fields.length, 0);
assert.ok(gatePacketReview.gate_packet_review.packets.some((packet) => packet.path.includes("POWER_PLATFORM")));

const dashboardIntegrityReviewPlan = getLocalActionExecutionPlan("local.action.review_dashboard_integrity");
assert.equal(dashboardIntegrityReviewPlan.execute_now, true);
assert.equal(dashboardIntegrityReviewPlan.command_execution_exposed, false);
assert.equal(dashboardIntegrityReviewPlan.live_executed, false);
assert.equal(dashboardIntegrityReviewPlan.shell_mode, "structured_local_review_no_shell");
const dashboardIntegrityReview = await runLocalAction("local.action.review_dashboard_integrity", repoRoot);
assert.equal(dashboardIntegrityReview.status, "PASS");
assert.equal(dashboardIntegrityReview.command_execution_exposed, false);
assert.equal(dashboardIntegrityReview.live_executed, false);
assert.equal(dashboardIntegrityReview.dashboard_integrity_review.task_count, dashboard.summary.agent_task_queue_records);
assert.equal(dashboardIntegrityReview.dashboard_integrity_review.local_action_count, 11);
assert.equal(dashboardIntegrityReview.dashboard_integrity_review.non_executed_tasks.length, 0);
assert.equal(dashboardIntegrityReview.dashboard_integrity_review.missing_required_actions.length, 0);
assert.equal(dashboardIntegrityReview.dashboard_integrity_review.command_execution_exposed, false);
assert.equal(dashboardIntegrityReview.dashboard_integrity_review.live_executed, false);

const actionBoundaryReviewPlan = getLocalActionExecutionPlan("local.action.review_action_boundary");
assert.equal(actionBoundaryReviewPlan.execute_now, true);
assert.equal(actionBoundaryReviewPlan.command_execution_exposed, false);
assert.equal(actionBoundaryReviewPlan.live_executed, false);
assert.equal(actionBoundaryReviewPlan.shell_mode, "structured_local_review_no_shell");
const actionBoundaryReview = await runLocalAction("local.action.review_action_boundary", repoRoot);
assert.equal(actionBoundaryReview.status, "PASS");
assert.equal(actionBoundaryReview.command_execution_exposed, false);
assert.equal(actionBoundaryReview.live_executed, false);
assert.equal(actionBoundaryReview.action_boundary_review.action_count, 11);
assert.equal(actionBoundaryReview.action_boundary_review.executable_action_count, 11);
assert.equal(actionBoundaryReview.action_boundary_review.actions_missing_stop_condition.length, 0);
assert.equal(actionBoundaryReview.action_boundary_review.plans_with_command_execution.length, 0);
assert.equal(actionBoundaryReview.action_boundary_review.plans_with_live_execution.length, 0);

const readinessBundleReviewPlan = getLocalActionExecutionPlan("local.action.review_readiness_bundle");
assert.equal(readinessBundleReviewPlan.execute_now, true);
assert.equal(readinessBundleReviewPlan.command_execution_exposed, false);
assert.equal(readinessBundleReviewPlan.live_executed, false);
assert.equal(readinessBundleReviewPlan.shell_mode, "structured_local_review_no_shell");
const readinessBundleReview = await runLocalAction("local.action.review_readiness_bundle", repoRoot);
assert.equal(readinessBundleReview.status, "PASS");
assert.equal(readinessBundleReview.command_execution_exposed, false);
assert.equal(readinessBundleReview.live_executed, false);
assert.equal(readinessBundleReview.readiness_bundle_review.component_count, 9);
assert.equal(readinessBundleReview.readiness_bundle_review.passing_components, 9);
assert.equal(readinessBundleReview.readiness_bundle_review.failing_components.length, 0);
assert.equal(readinessBundleReview.readiness_bundle_review.command_execution_exposed, false);
assert.equal(readinessBundleReview.readiness_bundle_review.live_executed, false);

const uiTranslationReviewPlan = getLocalActionExecutionPlan("local.action.review_ui_translation_integrity");
assert.equal(uiTranslationReviewPlan.execute_now, true);
assert.equal(uiTranslationReviewPlan.command_execution_exposed, false);
assert.equal(uiTranslationReviewPlan.live_executed, false);
assert.equal(uiTranslationReviewPlan.shell_mode, "structured_local_review_no_shell");
const uiTranslationReview = await runLocalAction("local.action.review_ui_translation_integrity", repoRoot);
assert.equal(uiTranslationReview.status, "PASS");
assert.equal(uiTranslationReview.command_execution_exposed, false);
assert.equal(uiTranslationReview.live_executed, false);
assert.equal(uiTranslationReview.ui_translation_review.missing_translation_tokens.length, 0);
assert.equal(uiTranslationReview.ui_translation_review.missing_result_renderers.length, 0);
assert.equal(uiTranslationReview.ui_translation_review.file_fallback_present, true);

const taskLineageReviewPlan = getLocalActionExecutionPlan("local.action.review_task_lineage");
assert.equal(taskLineageReviewPlan.execute_now, true);
assert.equal(taskLineageReviewPlan.command_execution_exposed, false);
assert.equal(taskLineageReviewPlan.live_executed, false);
assert.equal(taskLineageReviewPlan.shell_mode, "structured_local_review_no_shell");
const taskLineageReview = await runLocalAction("local.action.review_task_lineage", repoRoot);
assert.equal(taskLineageReview.status, "PASS");
assert.equal(taskLineageReview.command_execution_exposed, false);
assert.equal(taskLineageReview.live_executed, false);
assert.equal(taskLineageReview.task_lineage_review.task_count, dashboard.summary.agent_task_queue_records);
assert.equal(taskLineageReview.task_lineage_review.missing_dependencies.length, 0);
assert.equal(taskLineageReview.task_lineage_review.dependency_cycles.length, 0);
assert.equal(taskLineageReview.task_lineage_review.unlocked_tasks.length, 0);

const canvasStorySyncReviewPlan = getLocalActionExecutionPlan("local.action.review_canvas_story_sync");
assert.equal(canvasStorySyncReviewPlan.execute_now, true);
assert.equal(canvasStorySyncReviewPlan.command_execution_exposed, false);
assert.equal(canvasStorySyncReviewPlan.live_executed, false);
assert.equal(canvasStorySyncReviewPlan.shell_mode, "structured_local_review_no_shell");
const canvasStorySyncReview = await runLocalAction("local.action.review_canvas_story_sync", repoRoot);
assert.equal(canvasStorySyncReview.status, "PASS");
assert.equal(canvasStorySyncReview.command_execution_exposed, false);
assert.equal(canvasStorySyncReview.live_executed, false);
assert.equal(canvasStorySyncReview.canvas_story_sync_review.total_stories_matches, true);
assert.equal(canvasStorySyncReview.canvas_story_sync_review.missing_functional_story_refs.length, 0);
assert.equal(canvasStorySyncReview.canvas_story_sync_review.missing_recent_tasks.length, 0);

console.log("SDU_LOCAL_AGENT_BRIDGE_MOCK_FLOW_PASS");
