from sdu_runtime_common import main_guard, read_csv, read_json, read_text, require_columns, require_files


def validate() -> None:
    require_files(
        [
            "local-agent-bridge/README.md",
            "local-agent-bridge/package.json",
            "local-agent-bridge/contracts/local-agent-bridge.contract.json",
            "local-agent-bridge/matrices/routes_matrix.csv",
            "local-agent-bridge/policies/security_policy.md",
            "local-agent-bridge/schemas/evidence.schema.json",
            "local-agent-bridge/src/server.mjs",
            "local-agent-bridge/src/router.mjs",
            "local-agent-bridge/src/policy.mjs",
            "local-agent-bridge/src/evidenceAdapter.mjs",
            "local-agent-bridge/src/mcpRegistry.mjs",
            "local-agent-bridge/src/shellConnector.mjs",
            "local-agent-bridge/src/localActions.mjs",
            "local-agent-bridge/tests/mock_bridge_flow.mjs",
            ".agents/codex/orders/ORDER_VSI_POWER_PLATFORM_DRY_RUN_20260607.md",
            ".agents/codex/matrices/AAC_NATIVE_AGENTS_20260608.csv",
            ".agents/codex/matrices/AAC_NATIVE_AGENT_USE_FOR_VSI_20260608.csv",
            ".agents/codex/matrices/CABINA_GOVERNANCE_AGENTS_FOR_VSI_20260608.csv",
            "scripts/validators/agile_canvas_identity_drift_validator.py",
            "scripts/validators/agile_canvas_task_ops_validator.py",
        ]
    )
    package = read_json("local-agent-bridge/package.json")
    if package["scripts"]["test"] != "node tests/mock_bridge_flow.mjs":
        raise AssertionError("local bridge test script mismatch")

    contract = read_json("local-agent-bridge/contracts/local-agent-bridge.contract.json")
    if contract["transport"] != "http-loopback" or contract["response"]["liveExecutedValue"] is not False:
        raise AssertionError("local bridge contract must remain loopback and no-live")
    if contract.get("shellConnector", {}).get("commandExecutionExposed") is not False:
        raise AssertionError("shell connector command execution must not be exposed")
    local_actions = contract.get("localActions", {})
    if local_actions.get("commandExecutionExposed") is not False:
        raise AssertionError("local actions must not expose arbitrary command execution")
    for action_id in (
        "local.action.inspect_canvas_lane",
        "local.action.review_task_queue",
        "local.action.prepare_local_validation",
        "local.action.review_live_gate_packets",
        "local.action.review_bridge_contract",
        "local.action.review_dashboard_integrity",
        "local.action.review_action_boundary",
        "local.action.review_readiness_bundle",
        "local.action.review_ui_translation_integrity",
        "local.action.review_task_lineage",
        "local.action.review_canvas_story_sync",
        "local.action.review_route_contract_sync",
        "local.action.review_server_endpoint_guards",
        "local.action.review_validator_coverage",
        "local.action.review_error_response_shape",
        "local.action.review_postcheck_allowlist",
        "local.action.review_shell_block_consistency",
        "local.action.review_dashboard_summary_consistency",
        "local.action.review_local_action_status_consistency",
        "local.action.review_readiness_component_coverage",
        "local.action.review_canvas_schema_health",
    ):
        if action_id not in local_actions.get("allowedActionIds", []):
            raise AssertionError(f"local action allowlist missing {action_id}")
    if "execute_arbitrary_shell_from_dashboard" not in local_actions.get("blockedActions", []):
        raise AssertionError("local actions must block arbitrary shell from dashboard")
    if contract.get("localReadSurface", {}).get("requiresLoopbackBindHost") is not True:
        raise AssertionError("local read surface must require loopback bind host")
    if contract.get("localReadSurface", {}).get("blockedStatus") != 403:
        raise AssertionError("non-loopback local reads must be blocked with 403")

    routes_path = "local-agent-bridge/matrices/routes_matrix.csv"
    routes = read_csv(routes_path)
    require_columns(routes, ["route_id", "http_method", "path", "assigned_agent", "blocked_actions", "status"], routes_path)
    for row in routes:
        if row["status"] != "ACTIVE_DEV":
            raise AssertionError(f"{row['route_id']} must be ACTIVE_DEV")
        if "external_write" not in row["blocked_actions"] and "teams_send" not in row["blocked_actions"]:
            raise AssertionError(f"{row['route_id']} missing write block")
    route_ids = {row["route_id"] for row in routes}
    for route_id in ("bridge.shell_status", "bridge.shell_command_blocked", "bridge.local_action_run"):
        if route_id not in route_ids:
            raise AssertionError(f"missing governed local route: {route_id}")

    native_path = ".agents/codex/matrices/AAC_NATIVE_AGENTS_20260608.csv"
    native_agents = read_csv(native_path)
    require_columns(
        native_agents,
        [
            "native_agent_id",
            "display_name",
            "title",
            "module",
            "native_manifest_path",
            "native_agent_path",
            "surface",
            "agent_class",
            "authority_boundary",
            "available_in_board",
            "governance_relation",
            "status",
            "activation_status",
            "activation_mode",
            "direct_invocation_from_codex",
            "activation_evidence",
            "stop_condition",
        ],
        native_path,
    )
    expected_native_agents = {
        "master",
        "canvas-integrator",
        "analyst",
        "architect",
        "dev",
        "pm",
        "qa",
        "quick-flow-solo-dev",
        "sm",
        "tech-writer",
        "ux-designer",
        "agent-builder",
        "module-builder",
        "workflow-builder",
        "tea",
        "brainstorming-coach",
        "creative-problem-solver",
        "design-thinking-coach",
        "innovation-strategist",
        "presentation-master",
        "storyteller",
    }
    native_ids = {row["native_agent_id"] for row in native_agents}
    if native_ids != expected_native_agents:
        raise AssertionError(f"AAC native agent mismatch: {sorted(native_ids)}")
    for row in native_agents:
        if row["agent_class"] != "native_aac_agent":
            raise AssertionError(f"{row['native_agent_id']} must remain native_aac_agent")
        if row["authority_boundary"] != "tablero_native_not_cabina_authority":
            raise AssertionError(f"{row['native_agent_id']} has wrong authority boundary")
        if row["status"] != "AVAILABLE_NATIVE_AAC_AGENT":
            raise AssertionError(f"{row['native_agent_id']} must be AVAILABLE_NATIVE_AAC_AGENT")
        if row["activation_status"] != "ACTIVE_AAC_NATIVE_TEAM_GOVERNED":
            raise AssertionError(f"{row['native_agent_id']} must be ACTIVE_AAC_NATIVE_TEAM_GOVERNED")
        if row["activation_mode"] != "repo_local_board_activation":
            raise AssertionError(f"{row['native_agent_id']} must use repo-local AAC activation")
        if row["direct_invocation_from_codex"] != "false":
            raise AssertionError(f"{row['native_agent_id']} must not claim direct Codex invocation")

    governance_path = ".agents/codex/matrices/CABINA_GOVERNANCE_AGENTS_FOR_VSI_20260608.csv"
    governance_agents = read_csv(governance_path)
    require_columns(
        governance_agents,
        [
            "governance_agent_id",
            "board_relation",
            "agent_id",
            "cabina_role",
            "story_ids",
            "source_order_ids",
            "authority_source",
            "execution_mode",
            "dispatch_tool",
            "governance_tool",
            "allowed_actions",
            "blocked_actions",
            "status",
            "stop_condition",
        ],
        governance_path,
    )
    expected_governance_agents = {
        "rey.control_plane_orchestrator",
        "codex.workspace_guardian",
        "court.seshat_evidence",
        "court.thot_schema",
        "rey.repo_cartographer",
        "rey.frontier_guardian",
        "court.sdu_gate",
    }
    governance_ids = {row["agent_id"] for row in governance_agents}
    if governance_ids != expected_governance_agents:
        raise AssertionError(f"Cabina governance agent mismatch: {sorted(governance_ids)}")
    overlap = native_ids.intersection(governance_ids)
    if overlap:
        raise AssertionError(f"AAC native and Cabina governance agents must not overlap: {sorted(overlap)}")
    for row in governance_agents:
        if row["board_relation"] != "cabina_governed_work_agent_not_native_aac_team":
            raise AssertionError(f"{row['governance_agent_id']} must remain Cabina governed board work")
        if row["execution_mode"] != "local_task_scoped_agent":
            raise AssertionError(f"{row['governance_agent_id']} must remain local_task_scoped_agent")
        if row["dispatch_tool"] != "multi_agent_v1.spawn_agent":
            raise AssertionError(f"{row['governance_agent_id']} must use multi_agent_v1.spawn_agent")
        if row["status"] != "ACTIVE_LOCAL_GOVERNED_USE":
            raise AssertionError(f"{row['governance_agent_id']} must be ACTIVE_LOCAL_GOVERNED_USE")

    server = read_text("local-agent-bridge/src/server.mjs")
    if '127.0.0.1' not in server:
        raise AssertionError("local bridge must default to loopback")
    if "live_executed: false" not in server:
        raise AssertionError("local bridge must report no live execution")
    if "assertLoopbackReadSurface(host)" not in server:
        raise AssertionError("dashboard and shell status must be loopback-gated")
    if '"/api/local-actions/run"' not in server:
        raise AssertionError("local action endpoint must be declared")
    policy = read_text("local-agent-bridge/src/policy.mjs")
    if "0.0.0.0" in policy:
        raise AssertionError("policy should not allow non-loopback wildcard hosts")
    if "assertLoopbackReadSurface" not in policy:
        raise AssertionError("policy must expose loopback read surface guard")
    shell_connector = read_text("local-agent-bridge/src/shellConnector.mjs")
    if "execute_arbitrary_command" not in shell_connector:
        raise AssertionError("shell connector must block arbitrary command execution")
    if "status_only" not in shell_connector:
        raise AssertionError("shell connector must remain status_only")
    local_actions_text = read_text("local-agent-bridge/src/localActions.mjs")
    dashboard_data_text = read_text("local-agent-bridge/src/dashboardData.mjs")
    dashboard_html = read_text("local-agent-bridge/public/index.html")
    native_use_path = ".agents/codex/matrices/AAC_NATIVE_AGENT_USE_FOR_VSI_20260608.csv"
    native_use_rows = read_csv(native_use_path)
    require_columns(
        native_use_rows,
        [
            "usage_id",
            "board_id",
            "story_id",
            "native_agent_id",
            "support_native_agents",
            "cabina_governed_work_agents",
            "callable_from_codex_now",
            "status",
            "stop_condition",
        ],
        native_use_path,
    )
    expected_native_use_stories = {"EPIC-6", "S-6.1", "S-6.2", "S-6.3", "S-6.4", "S-6.5"}
    native_use_stories = {row["story_id"] for row in native_use_rows}
    if native_use_stories != expected_native_use_stories:
        raise AssertionError(f"AAC native use story mismatch: {sorted(native_use_stories)}")
    for row in native_use_rows:
        if row["board_id"] != "vsi_agile_agent_canvas_mother_board":
            raise AssertionError(f"{row['usage_id']} must target VSI mother board")
        if row["native_agent_id"] not in native_ids:
            raise AssertionError(f"{row['usage_id']} references unknown native AAC agent")
        if row["status"] != "ACTIVE_AAC_NATIVE_TEAM_GOVERNED":
            raise AssertionError(f"{row['usage_id']} must activate native AAC team status")
        if row["callable_from_codex_now"] != "NO_DISPONIBLE_DIRECT_EXTENSION_CALL":
            raise AssertionError(f"{row['usage_id']} must keep native extension call boundary explicit")
        cabina_agents = set(row["cabina_governed_work_agents"].split("|"))
        if not cabina_agents or not cabina_agents.issubset(governance_ids):
            raise AssertionError(f"{row['usage_id']} references unknown Cabina governed work agent")
    if "visible_gate_lane" not in dashboard_data_text or "ACTIVE_VISIBLE_GATE_LANE" not in dashboard_data_text:
        raise AssertionError("dashboard data must expose a visible gate lane from existing gates")
    if "renderVisibleGate" not in dashboard_html or "visible-gate-lane" not in dashboard_html:
        raise AssertionError("dashboard UI must render the visible gate lane")
    if "board_boundary" not in dashboard_data_text or "BOARD_BOUNDARY_DECLARED" not in dashboard_data_text:
        raise AssertionError("dashboard data must declare the VSI mother-board vs auxiliary-board boundary")
    for token in (
        "AAC_NATIVE_AGENTS_20260608",
        "CABINA_GOVERNANCE_AGENTS_FOR_VSI_20260608",
        "aacNativeAgents",
        "cabinaGovernanceAgents",
        "native_agents",
        "governance_agents",
        "aac_native_agent_records",
        "cabina_governance_agent_records",
        "ACTIVE_AAC_NATIVE_TEAM_GOVERNED",
        "repo_local_board_activation",
        "direct_invocation_from_codex",
        "native_aac_team_not_cabina_authority",
        "ACTIVE_CABINA_GOVERNED_WORK_LAYER",
        "cabina_governed_work_agent_not_native_aac_team",
        "cabina_governs_vsi_agile_agent_canvas_board",
        "cabina_agents_work_on_board_and_govern_it",
    ):
        if token not in dashboard_data_text:
            raise AssertionError(f"dashboard agent separation missing {token}")
    for forbidden_token in (
        "VSI_BOARD_AGENT_ROSTER_20260608",
        "boardAgentRoster",
        "agent_roster",
        "board_agent_roster_records",
    ):
        if forbidden_token in dashboard_data_text:
            raise AssertionError(f"dashboard must not expose ambiguous roster token {forbidden_token}")
    for token in (
        "vsi_agile_agent_canvas_mother_board",
        "Tablero principal madre VSI",
        "Agile Agent Canvas",
        "agile_agent_canvas_creation_planning_board",
        "primary_mother_board",
        "vscode_insiders_agile_agent_canvas",
        "control_agentes_cabina_queue_board",
        "vsi_mother_board_boundary_drift",
        "control_agentes_cabina",
        "Tablero de cola Control de Agentes de Cabina",
        "agent_control_queue_board",
        "auxiliary_queue_control_board",
        "agent_control_queue_board_boundary_drift",
        "cola_sitio_web",
        "NO_CONECTADA_EN_CONTROL_AGENTES_CABINA",
        "website_queue_target_missing",
    ):
        if token not in dashboard_data_text:
            raise AssertionError(f"dashboard board boundary missing {token}")
    if "Frontera de tableros" not in dashboard_html or "renderBoardBoundaryItem" not in dashboard_html:
        raise AssertionError("dashboard UI must render the board boundary")
    if "no es" not in dashboard_html or "board_kind" not in dashboard_html:
        raise AssertionError("dashboard UI must distinguish board identity and non-equivalence")
    if "native_agents" not in dashboard_html or "governance_agents" not in dashboard_html:
        raise AssertionError("dashboard UI must render native and Cabina governed work agents separately")
    if "agentes cabina" not in dashboard_html or "agentes gobierno" in dashboard_html:
        raise AssertionError("dashboard UI must label Cabina agents as board work agents, not only governance")
    if "execute_arbitrary_shell_from_dashboard" not in local_actions_text:
        raise AssertionError("local actions must block arbitrary shell execution")
    if "purpose_built_postcheck_allowlist" not in local_actions_text:
        raise AssertionError("local actions must use purpose-built postcheck allowlist")
    if "scripts/validators/agile_canvas_task_ops_validator.py" not in local_actions_text:
        raise AssertionError("local postcheck must run Agile Canvas task ops validator")
    if "structured_local_review_no_shell" not in local_actions_text:
        raise AssertionError("local actions must support structured no-shell review")
    for result_key in (
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
        "canvas_schema_health_review",
    ):
        if result_key not in local_actions_text:
            raise AssertionError(f"local actions must expose structured {result_key}")
    if "ORDER_VSI_POWER_PLATFORM_DRY_RUN_20260607.md" not in local_actions_text:
        raise AssertionError("local actions must review Power Platform dry-run packet")
    identity_validator = read_text("scripts/validators/agile_canvas_identity_drift_validator.py")
    if "AGILE_CANVAS_IDENTITY_DRIFT_VALIDATOR" not in identity_validator:
        raise AssertionError("Agile Canvas identity drift validator must be declared")
    if "Cabina Universal Agent Control" not in identity_validator:
        raise AssertionError("Agile Canvas identity drift validator must require Cabina identity")
    task_ops_validator = read_text("scripts/validators/agile_canvas_task_ops_validator.py")
    if "AGILE_CANVAS_TASK_OPS_VALIDATOR" not in task_ops_validator:
        raise AssertionError("Agile Canvas task ops validator must be declared")
    if "EXECUTED_LOCAL_VALIDATED" not in task_ops_validator:
        raise AssertionError("Agile Canvas task ops validator must require executed local validation")


if __name__ == "__main__":
    main_guard("LOCAL_AGENT_BRIDGE_VALIDATOR", validate)
