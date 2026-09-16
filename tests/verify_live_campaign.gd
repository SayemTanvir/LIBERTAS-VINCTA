extends Node
## Full Untouched -> Custodian's Rest via movement and E/Q. No teleport or AI disabling.
var checks := 0
var failures := 0
var main: Node2D
var player: CharacterBody2D

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().current_scene = null
	GameManager.save_path = "res://build/live_campaign_save.json"
	AudioServer.set_bus_mute(0, true)
	_run.call_deferred()

func check(ok: bool, message: String) -> bool:
	checks += 1
	if not ok:
		failures += 1
		push_error(message)
	return ok

func _run() -> void:
	GameManager.new_game()
	if not await zone("intro"): return finish()
	for id in ["IntroExit", "Flashlight", "LockpickTool", "IntroExit"]:
		if not await use(id): return finish()
	if not await zone("ground"): return finish()
	if not await use("FrontDoor"): return finish()
	if not await use("FrontDoor"): return finish()
	if not check(GameManager.ending == "untouched", "Live estate escape earns Untouched without detections"): return finish()
	print("LIVE CAMPAIGN: Untouched earned")
	await capture("untouched")
	# Same action as the outcome screen's Descend button; no progression mutation.
	GameManager.continue_to_part_two()
	if not await zone("roots"): return finish()
	if not await use("EchoThreshold"): return finish()
	check(FreedomLedger.flags.get("story_name_carving", false), "Walking through Roots triggers the name reveal")
	if not await zone("echoes"): return finish()
	for attempt in 7:
		if FreedomLedger.mechanic_uses >= 3: break
		Input.action_press("gadget")
		await get_tree().physics_frame
		await get_tree().physics_frame
		Input.action_release("gadget")
		await get_tree().create_timer(0.7, false).timeout
	if not check(FreedomLedger.mechanic_uses >= 3, "Actual Q inputs satisfy the three-use gate"): return finish()
	if not await use("NexusDescent"): return finish()
	if not await zone("nexus"): return finish()
	if not await use("NexusBell"): return finish()
	if not await approach("LnB"): return finish()
	Input.action_press("interact")
	var deadline := Time.get_ticks_msec() + 26000
	while GameManager.state == GameManager.State.PLAYING and Time.get_ticks_msec() < deadline:
		await get_tree().process_frame
	Input.action_release("interact")
	check(GameManager.ending == "custodian_rest", "Live campaign completes a real 20-second held-E ending")
	await capture("custodian_rest")
	finish()

func finish() -> void:
	release_movement()
	Input.action_release("interact")
	Input.action_release("gadget")
	# Let ending signal callbacks finish, then dispose the gameplay scene before exit.
	await get_tree().create_timer(1.5, true).timeout
	GameManager.go_home()
	for _frame in 6:
		await get_tree().process_frame
	print("LIVE CAMPAIGN: %d checks, %d failures; normal movement, real E/Q, live AI" % [checks, failures])
	get_tree().quit(0 if failures == 0 else 1)

func zone(expected: String) -> bool:
	var deadline := Time.get_ticks_msec() + 60000
	while Time.get_ticks_msec() < deadline:
		await get_tree().process_frame
		var scene := get_tree().current_scene
		if scene != null and scene.scene_file_path == "res://scenes/main/main.tscn" and scene.room.zone_id == expected and GameManager.state == GameManager.State.PLAYING:
			main = scene
			player = main.get_node("Entities/Player")
			print("LIVE CAMPAIGN: entered " + expected)
			return check(player.control_enabled, "Control returned in " + expected)
	return check(false, "Timed out entering " + expected)

func release_movement() -> void:
	for action in ["move_left", "move_right", "move_up", "move_down", "sprint"]:
		Input.action_release(action)

func approach(id: String) -> bool:
	var prop: BaseInteractable = main.room.props.get_node_or_null(NodePath(id))
	if not check(prop != null, "Live target exists: " + id): return false
	var best := Vector2.INF
	var best_length := INF
	var shape := RectangleShape2D.new()
	shape.size = Vector2(24, 14)
	var space: PhysicsDirectSpaceState2D = main.room.get_world_2d().direct_space_state
	for radius in [38.0, 48.0, 60.0]:
		for i in 16:
			var point: Vector2 = prop.global_position + Vector2.DOWN.rotated(TAU * i / 16.0) * radius
			if point.y < 370 or point.y > 620: continue
			var query := PhysicsShapeQueryParameters2D.new()
			query.shape = shape
			query.transform = Transform2D(0, point + Vector2(0, -7))
			query.collision_mask = 1
			if not space.intersect_shape(query).is_empty(): continue
			if not space.intersect_ray(PhysicsRayQueryParameters2D.create(point, prop.global_position, 1)).is_empty(): continue
			# Approach the intended E target, not the neighboring anchor's selection radius.
			var contested := false
			for other in get_tree().get_nodes_in_group("interactable"):
				if other == prop or not other.available(): continue
				for other_point in other.interaction_points():
					if point.distance_to(other_point) < radius + 12.0:
						contested = true
			if contested: continue
			var path: PackedVector2Array = main.room.find_path(player.global_position, point)
			if path.is_empty() or path[-1].distance_to(point) > 30: continue
			var length := 0.0
			var previous := player.global_position
			for step in path:
				length += previous.distance_to(step)
				previous = step
			if length < best_length:
				best_length = length
				best = point
	if not check(best != Vector2.INF, "Reachable approach to " + id): return false
	if not await walk_to(best): return false
	await get_tree().create_timer(0.18, false).timeout
	player._find_interactable()
	return check(player.target_interactable == prop, "Real E prompt selects " + id)

func walk_to(point: Vector2) -> bool:
	var path: PackedVector2Array = main.room.find_path(player.global_position, point)
	path.append(point)
	var deadline := Time.get_ticks_msec() + 120000
	for waypoint in path:
		while player.global_position.distance_to(waypoint) > 10.0:
			if GameManager.state != GameManager.State.PLAYING or Time.get_ticks_msec() > deadline:
				release_movement()
				return check(false, "Live path stalled at %s toward %s (waypoint %s)" % [player.position, point, waypoint])
			var offset := waypoint - player.global_position
			for axis in [["move_left", -offset.x], ["move_right", offset.x], ["move_up", -offset.y], ["move_down", offset.y]]:
				if axis[1] > 2.0:
					Input.action_press(axis[0], clampf(axis[1] / 22.0, 0.0, 1.0))
				else:
					Input.action_release(axis[0])
			Input.action_press("sprint")
			await get_tree().physics_frame
	release_movement()
	return true

func use(id: String) -> bool:
	if not await approach(id): return false
	var prop: BaseInteractable = player.target_interactable
	Input.action_press("interact")
	await get_tree().physics_frame
	await get_tree().physics_frame
	Input.action_release("interact")
	var deadline := Time.get_ticks_msec() + 20000
	while is_instance_valid(prop) and prop.busy and Time.get_ticks_msec() < deadline:
		await get_tree().process_frame
	await get_tree().process_frame
	print("LIVE CAMPAIGN: used " + id)
	return check(not is_instance_valid(prop) or not prop.busy, "Interaction completes: " + id)

func capture(label: String) -> void:
	if DisplayServer.get_name() == "headless": return
	await get_tree().create_timer(1.0, true).timeout
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png("res://build/live_campaign_" + label + ".png")
