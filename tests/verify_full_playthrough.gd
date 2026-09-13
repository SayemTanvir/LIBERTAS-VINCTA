extends Node

var checks := 0
var failures: Array[String] = []
var main: Node2D

func _ready() -> void:
	get_tree().current_scene = null
	Engine.time_scale = 20.0
	AudioServer.set_bus_mute(0, true)
	GameManager.save_path = "res://build/full_playthrough_test_save.json"
	_run.call_deferred()

func _check(value: bool, message: String) -> void:
	checks += 1
	if not value:
		failures.append(message)
		push_error(message)

func _faces_target(player: CharacterBody2D, prop: Node2D) -> bool:
	var direction := prop.global_position - player.global_position
	return direction.length_squared() > 0.001 and player.facing.dot(direction.normalized()) > 0.999

func _wait_zone(zone: String) -> bool:
	var deadline := Time.get_ticks_msec() + 20000
	while Time.get_ticks_msec() < deadline:
		await get_tree().process_frame
		var current := get_tree().current_scene
		if current != null and current.scene_file_path == "res://scenes/main/main.tscn" and current.room.zone_id == zone and GameManager.state == GameManager.State.PLAYING:
			main = current
			for enemy in get_tree().get_nodes_in_group("enemy"):
				enemy.set_physics_process(false)
			return true
	_check(false, "Transition or recovery timed out: " + zone)
	get_tree().quit(1)
	return false

func _use(id: String) -> void:
	var prop: BaseInteractable = main.room.props.get_node_or_null(NodePath(id))
	_check(prop != null, "Missing interaction " + id)
	if prop == null:
		return
	var player: CharacterBody2D = main.get_node("Entities/Player")
	player.position = prop.position + Vector2(0, 30)
	player.velocity = Vector2.ZERO
	await get_tree().physics_frame
	player._find_interactable()
	_check(player.target_interactable == prop, "Cannot select " + id)
	await prop.interact(player)
	if GameManager.state == GameManager.State.READING:
		main.get_node("UI").close_modal()
		await get_tree().process_frame

func _solve(id: String) -> void:
	var prop: BaseInteractable = main.room.props.get_node(NodePath(id))
	for _step in prop.puzzle_steps:
		await _use(id)
	_check(FreedomLedger.flags.get(prop.interaction_id, false), id + " did not complete")
	_check(not prop.available() and prop.visible, id + " remained actionable or disappeared after completion")

func _start_campaign() -> bool:
	GameManager.new_game()
	if not await _wait_zone("intro"):
		return false
	var tool: BaseInteractable = main.room.props.get_node("LockpickTool")
	_check(tool._action_animation() == "interact", "Tool pouch uses the key-pickup animation")
	await _use("IntroExit")
	await _use("Flashlight")
	await _use("LockpickTool")
	await _use("IntroExit")
	return await _wait_zone("ground")

func _visit_roots_story() -> void:
	var player: CharacterBody2D = main.get_node("Entities/Player")
	var carving_lines: Array[String] = []
	var listener := func(_speaker: String, line: String, _seconds: float):
		if "final carving" in line:
			carving_lines.append(line)
	EventBus.subtitle_requested.connect(listener)
	for x in [1500.0, 2500.0, 3550.0, 4600.0, 5550.0]:
		player.position = Vector2(x, 500)
		await get_tree().physics_frame
	player.position = Vector2(2500, 500)
	await get_tree().physics_frame
	player.position = Vector2(3550, 500)
	await get_tree().physics_frame
	EventBus.subtitle_requested.disconnect(listener)
	_check(carving_lines == ["Custodian. Jailer. Vantree. Els Vantree - the final carving bears a date centuries old."], "CR-04 reveal was missing, changed, or repeated")
	_check(not main.room.props.get_node("VantreeAltar").available(), "Automatic CR-04 reveal can be replayed manually")

func _to_echoes() -> bool:
	await _use("EchoThreshold")
	if not await _wait_zone("echoes"):
		return false
	_check(FreedomLedger.flags.get("mechanic_intro_seen", false), "CE-01 mechanic tutorial did not trigger")
	_check(not main.room.props.get_node("MechanicIntro").available(), "CE-01 mechanic tutorial can be repeated")
	return true

func _run_untouched() -> bool:
	if not await _start_campaign():
		return false
	await _use("FrontDoor")
	_check(FreedomLedger.flags.get("door_tested", false), "Untouched first door test was not recorded")
	await _use("FrontDoor")
	_check(GameManager.ending == "untouched" and GameManager.state == GameManager.State.ENDING, "Untouched ending failed through the actual front door")
	GameManager.continue_to_part_two()
	if not await _wait_zone("roots"):
		return false
	_check(not main.room.threat_active_at(Vector2(500, 500)), "Untouched CR-01 was not safe")
	await _visit_roots_story()
	if not await _to_echoes():
		return false
	var player: CharacterBody2D = main.get_node("Entities/Player")
	for _i in 3:
		_check(player.use_gadget(), "Untouched resonance gadget failed")
	_check(FreedomLedger.mechanic_uses == 3, "Untouched three-use Echo gate failed")
	await _use("NexusDescent")
	if not await _wait_zone("nexus"):
		return false
	FreedomLedger.flags["automation_channel"] = true
	await _use("LnB")
	_check(GameManager.ending == "custodian_rest", "Custodian's Rest anchor failed")
	return true

func _run_partial_mercy() -> bool:
	if not await _start_campaign():
		return false
	await _solve("PianoSeal")
	await _use("HearingKey")
	await _use("UpperStairs")
	if not await _wait_zone("upper"):
		return false
	await _solve("VanitySeal")
	var player: CharacterBody2D = main.get_node("Entities/Player")
	_check(_faces_target(player, main.room.props.get_node("VanitySeal")) and player.global_position.distance_to(Vector2(1664, 448)) < 1.0, "Vanity animation pose or angle is misaligned")
	await _use("SightKey")
	await _use("UpperStairs")
	if not await _wait_zone("ground"):
		return false
	await _use("BasementStairs")
	if not await _wait_zone("basement"):
		return false
	await _use("MaintenanceExit")
	_check(GameManager.ending == "partial_mercy", "Partial Mercy exit failed")
	GameManager.continue_to_part_two()
	if not await _wait_zone("roots"):
		return false
	await _visit_roots_story()
	if not await _to_echoes():
		return false
	_check(FreedomLedger.flags.get("part2_ability_unlocked", false), "Partial sigil did not unlock in CE-01")
	player = main.get_node("Entities/Player")
	for _i in 3:
		player.sigil_cooldown = 0.0
		_check(player.use_sigil(), "Partial sigil use failed")
	_check(FreedomLedger.mechanic_uses == 3, "Partial Mercy three-use Echo gate failed")
	await _use("NexusDescent")
	if not await _wait_zone("nexus"):
		return false
	FreedomLedger.flags["automation_channel"] = true
	await _use("LnC")
	_check(GameManager.ending == "vessel", "Vessel anchor failed")
	return true

func _run_loop_and_recovery() -> bool:
	if not await _start_campaign():
		return false
	var player: CharacterBody2D = main.get_node("Entities/Player")
	var first_room_checkpoint: Vector2 = GameManager.checkpoint.position
	var door_cues: Array[String] = []
	var door_listener := func(cue: String):
		if cue == "door":
			door_cues.append(cue)
	EventBus.audio_requested.connect(door_listener)
	Engine.time_scale = 1.0
	EventBus.player_caught.emit()
	await get_tree().process_frame
	_check(GameManager.state == GameManager.State.CAUGHT and player.animation_state == "death", "First-room capture did not begin correctly")
	if not await _wait_zone("ground"):
		return false
	Engine.time_scale = 20.0
	EventBus.audio_requested.disconnect(door_listener)
	player = main.get_node("Entities/Player")
	var entry_presentation: Node = main.room.props.get_node("FrontDoor/Visual/DoorPresentation")
	_check(player.global_position.distance_to(first_room_checkpoint) < 1.0, "First-room respawn moved Els away from the arrival checkpoint")
	_check(not bool(entry_presentation.get("arrival_completed")), "Respawn replayed the first door arrival/closing animation")
	_check(door_cues.is_empty(), "Respawn emitted an irrelevant door-closing sound")
	_check(entry_presentation.door_sprite.position.is_equal_approx(entry_presentation.closed_position) and entry_presentation.door_sprite.scale.is_equal_approx(entry_presentation.closed_scale), "Respawn did not initialize the first door directly in its closed state")
	var position_before_input := player.global_position
	Input.action_press("move_right")
	for _frame in 3:
		await get_tree().physics_frame
	Input.action_release("move_right")
	_check(player.global_position.x > position_before_input.x, "Movement control did not resume after checkpoint recovery")
	var hearing_key: BaseInteractable = main.room.props.get_node("HearingKey")
	player.play_animation("idle")
	await hearing_key.interact(player)
	_check(player.animation_state == "idle" and not FreedomLedger.hearing_restored, "Sealed key played a successful pickup animation")
	await _solve("PianoSeal")
	_check(_faces_target(player, main.room.props.get_node("PianoSeal")), "Piano interaction does not face the lock at its actual angle")
	await _use("HearingKey")
	var checkpoint_position: Vector2 = GameManager.checkpoint.position
	var checkpoint_state: Dictionary = GameManager.checkpoint.ledger.duplicate(true)
	FreedomLedger.collect_item("clock")
	FreedomLedger.record_detection()
	FreedomLedger.damage(20.0)
	Engine.time_scale = 1.0
	EventBus.player_caught.emit()
	await get_tree().process_frame
	_check(GameManager.state == GameManager.State.CAUGHT and player.animation_state == "death" and not player.control_enabled, "Capture did not play and hold the death animation")
	Engine.time_scale = 20.0
	if not await _wait_zone("ground"):
		return false
	player = main.get_node("Entities/Player")
	_check(player.global_position.distance_to(checkpoint_position) < 1.0, "Respawn moved Els away from the checkpoint")
	_check(FreedomLedger.snapshot().inventory == checkpoint_state.inventory and is_equal_approx(FreedomLedger.hp, float(checkpoint_state.hp)), "Respawn did not restore checkpoint inventory and health")
	_check(not GameManager.respawn_pending and player.control_enabled and player.animation_state == "idle", "Respawn recovery did not finish cleanly")
	_check(not main.room.props.get_node("PianoSeal").available(), "Solved piano became actionable after respawn")
	await _use("UpperStairs")
	if not await _wait_zone("upper"):
		return false
	await _solve("VanitySeal")
	await _use("SightKey")
	await _use("UpperStairs")
	if not await _wait_zone("ground"):
		return false
	await _use("BasementStairs")
	if not await _wait_zone("basement"):
		return false
	player = main.get_node("Entities/Player")
	var lockpicks_before := int(FreedomLedger.inventory.get("lockpick", 0))
	await _solve("RitualSeal")
	_check(_faces_target(player, main.room.props.get_node("RitualSeal")), "Ritual-seal interaction does not face the seal at its actual angle")
	_check(int(FreedomLedger.inventory.get("lockpick", 0)) == lockpicks_before, "Cracked ritual seal consumed a lockpick")
	await _use("MemoryKey")
	await _use("GroundStairs")
	if not await _wait_zone("ground"):
		return false
	await _use("FrontDoor")
	if not await _wait_zone("ground"):
		return false
	var deadline := Time.get_ticks_msec() + 5000
	while FreedomLedger.flags.get("loop_wake", false) and Time.get_ticks_msec() < deadline:
		await get_tree().process_frame
	player = main.get_node("Entities/Player")
	_check(FreedomLedger.loop_counter == 1 and FreedomLedger.keys_collected.is_empty() and FreedomLedger.part2_seed.is_empty(), "Loop failed to reset without generating Part II")
	_check(not FreedomLedger.flags.get("loop_wake", false) and player.animation_state == "idle" and player.control_enabled, "Loop awakening did not recover from the prone pose")
	return true

func _run() -> void:
	if await _run_untouched():
		print("PLAYED Untouched -> Custodian's Rest")
	if await _run_partial_mercy():
		print("PLAYED Partial Mercy -> Vessel")
	if await _run_loop_and_recovery():
		print("PLAYED three-key Loop with capture/respawn")
	var active_scene := get_tree().current_scene
	if active_scene != null and active_scene != self:
		active_scene.queue_free()
	for _frame in 8:
		await get_tree().process_frame
	if FileAccess.file_exists(GameManager.save_path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(GameManager.save_path))
	print("FULL PLAYTHROUGH: %s checks, %s failures. Alternate routes, recovery, puzzle poses, and endings verified." % [checks, failures.size()])
	get_tree().quit(0 if failures.is_empty() else 1)
