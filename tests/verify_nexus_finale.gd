extends Node
var checks := 0
var failures := 0
var main: Node2D
var player: CharacterBody2D
var enemy: CharacterBody2D
var room: Node2D

func _ready() -> void:
	AudioServer.set_bus_mute(0, true)
	GameManager.save_path = "user://nexus_validation.json"
	_run.call_deferred()

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error(message)

func setup(branch: String) -> void:
	get_tree().paused = false
	if is_instance_valid(main):
		main.queue_free()
		await get_tree().process_frame
	FreedomLedger.reset()
	FreedomLedger.begin_part_two(branch)
	FreedomLedger.flags["flashlight"] = true
	GameManager.zone = "nexus"
	GameManager.entry = "start"
	GameManager.ending = ""
	GameManager.arrival_pending = false
	GameManager.respawn_pending = false
	GameManager.state = GameManager.State.PLAYING
	main = preload("res://scenes/main/main.tscn").instantiate()
	add_child(main)
	room = main.room
	player = main.get_node("Entities/Player")
	enemy = get_tree().get_first_node_in_group("enemy")
	player.set_physics_process(false)
	enemy.set_physics_process(false)
	await get_tree().physics_frame

func prop(id: String) -> BaseInteractable:
	for child in room.props.get_children():
		if child is BaseInteractable and child.interaction_id == id:
			return child
	return null

func use(id: String, close_reader: bool = true) -> void:
	var target := prop(id)
	player.position = target.position + Vector2(0, 30)
	await get_tree().physics_frame
	await target.interact(player)
	if close_reader and GameManager.state == GameManager.State.READING:
		main.get_node("UI").close_modal()

func _run() -> void:
	await setup("untouched")
	check(room.room_width == 4200.0, "Wide arena footprint")
	check(prop("nexus_bell") == null, "Ward Bell removed")
	check(InputMap.has_action("blood_trap"), "Blood Trap has a key binding")
	check(prop("LN-A").position.distance_to(prop("LN-B").position) > 1280.0, "Runes exceed camera width")
	check(not prop("nexus_power").available() and not prop("nexus_power").visible, "Power hidden before Guide")
	check(not prop("nexus_ending_door").available() and not prop("nexus_ending_door").visible, "Door hidden until resolution")
	var points: Array[Vector2] = []
	for i in 10:
		var point: Vector2 = room.patrol_target(0, i)
		points.append(point)
		check(not room.find_path(player.position, point).is_empty(), "Patrol waypoint reachable %d" % i)
	check(points[0].x < 700 and points[6].x > 3500, "Patrol spans the arena")
	check(enemy.state == enemy.State.NEXUS_ROAM, "Untouched Hound starts roaming")
	await use("nexus_guide")
	check(FreedomLedger.flags.get("nexus_guide_read", false), "Guide read flag")
	check(CollectibleManager.current_unlocked_index == 1, "Guide does not advance estate letter chain")
	check(prop("nexus_power").available() and prop("nexus_power").visible and prop("nexus_power").get_node("Visual").visible, "Reading reveals visible Power pickup")
	await use("nexus_knife")
	await use("nexus_power")
	check(FreedomLedger.inventory.get("knife", 0) == 1 and FreedomLedger.inventory.get("power", 0) == 1, "Knife and Power collected")
	FreedomLedger.collect_item("bottle", 2)
	FreedomLedger.collect_item("clock", 2)
	FreedomLedger.collect_item("battery", 1)
	FreedomLedger.set_flashlight_charge(40.0)
	check(player.use_gadget() and FreedomLedger.inventory.power == 1, "Low charge battery precedes Power")
	check(not player.use_gadget() and FreedomLedger.inventory.bottle >= 2, "Power precedes bottles and is retained on failure")
	enemy.position = Vector2(3000, 550)
	player.position = Vector2(600, 550)
	var hp := FreedomLedger.hp
	check(not player.use_blood_trap() and FreedomLedger.hp == hp and player.blood_trap_cooldown == 0.0, "Out of range costs nothing")
	await use("LN-A")
	check(room.alarm_active and enemy.nexus_hunting and enemy.target.distance_to(player.position) < 1.0, "First rune forces hunt")
	check(not enemy.detection_active, "Alarm trail alone is not confirmed detection")
	check(room.outcome.is_empty(), "Destroy rune cannot skip item chain")
	player.position = Vector2(2850, 550)
	enemy.position = Vector2(2950, 550)
	await get_tree().physics_frame
	check(player.use_blood_trap(), "Blood Trap succeeds on Untouched branch")
	check(FreedomLedger.hp == hp - 40.0, "Blood Trap costs exactly 40 HP")
	check(enemy.blood_trap_seconds == 18.0 and enemy.stun_seconds == 18.0, "Blood Trap binds for 18 seconds")
	check(not enemy.detection_active and not enemy._strike_pending, "Trap cancels attacks and detection")
	GameManager.pause_game()
	await get_tree().create_timer(0.1, true).timeout
	check(enemy.blood_trap_seconds == 18.0 and room.alarm_seconds > 0.0, "Pause freezes trap and alarm")
	GameManager.resume()
	player.position = enemy.position + Vector2(-40, 0)
	FreedomLedger.inventory.knife = 0
	check(not room.place_power(player) and FreedomLedger.inventory.power == 1, "Knife is required and failure retains Power")
	FreedomLedger.inventory.knife = 1
	check(room.place_power(player), "Trap placement completes Destroy")
	check(enemy.nexus_defeated and FreedomLedger.inventory.power == 0 and FreedomLedger.inventory.knife == 1, "Destroy kills Hound and consumes only Power")
	check(prop("nexus_ending_door").visible and FreedomLedger.eligible("destroy"), "Destroy door and ending unlocked")
	check(not prop("LN-B").available() and not room.place_power(player), "Resolution prevents a second ending")
	await use("nexus_ending_door", false)
	check(GameManager.ending == "destroy", "Destroy door ends the game")
	check(GameManager.state == GameManager.State.READING and main.get_node("UI").reader.visible, "Destroy door shows the winning letter before leaving")
	main.get_node("UI").close_modal()
	await get_tree().process_frame
	check(GameManager.state == GameManager.State.MENU, "Closing the winning letter returns to the main menu")
	# Test full length holds and each interruption using the real interaction coroutine.
	await setup("partial_mercy")
	Engine.time_scale = 8.0
	var rune := prop("LN-B")
	player.position = rune.position + Vector2(0, 30)
	Input.action_press("interact")
	rune.interact(player)
	await get_tree().create_timer(1.0, false).timeout
	GameManager.pause_game()
	var meter: float = main.get_node("UI").activity_meter.value
	await get_tree().create_timer(0.2, true).timeout
	check(is_equal_approx(meter, main.get_node("UI").activity_meter.value) and rune.busy, "Pause freezes active hold")
	GameManager.resume()
	FreedomLedger.damage(1.0)
	await get_tree().physics_frame
	await get_tree().physics_frame
	check(not rune.busy and room.outcome.is_empty() and player.control_enabled, "Damage resets hold and restores control")
	for interrupt in ["release", "move", "detect", "displace"]:
		Input.action_press("interact")
		rune.interact(player)
		await get_tree().create_timer(0.4, false).timeout
		match interrupt:
			"release": Input.action_release("interact")
			"move": Input.action_press("move_right")
			"detect": EventBus.player_detected.emit(enemy)
			"displace": player.position.x += 10.0
		await get_tree().physics_frame
		await get_tree().physics_frame
		check(not rune.busy and room.outcome.is_empty(), interrupt + " resets hold")
		Input.action_release("move_right")
	Input.action_press("interact")
	await rune.interact(player)
	Input.action_release("interact")
	check(room.outcome == "flee" and prop("nexus_ending_door").visible, "Twenty second Flee hold opens door")
	await use("nexus_ending_door")
	check(GameManager.ending == "flee", "Flee door resolves correct ending")
	check(preload("res://scripts/ui/nexus_narration.gd").FLEE.count("\n\n") == 6, "All seven narration paragraphs retained")
	await setup("vantree")
	await use("nexus_guide")
	player.position = Vector2(600, 550)
	enemy.position = Vector2(700, 550)
	await get_tree().physics_frame
	check(player.use_blood_trap() and FreedomLedger.hp == 40.0, "Vantree also pays flat 40 HP from 80")
	player.blood_trap_cooldown = 0.0
	enemy.blood_trap_seconds = 0.0
	check(not player.use_blood_trap() and FreedomLedger.hp == 40.0, "Trap cannot kill its caster")
	enemy.detection_active = false
	Input.action_press("interact")
	await use("LN-C")
	Input.action_release("interact")
	check(room.outcome == "remain" and FreedomLedger.eligible("remain"), "Remain hold opens restart door")
	await use("nexus_ending_door")
	check(GameManager.zone == "ground" and FreedomLedger.current_part == 1 and FreedomLedger.loop_counter == 1, "Remain reuses Loop reset to ground")
	check(FreedomLedger.letter_ids.is_empty() and FreedomLedger.inventory.get("power", 0) == 0 and not FreedomLedger.flags.has("nexus_outcome"), "Loop clears finale progress and inventory")
	Engine.time_scale = 1.0
	print("NEXUS FINALE: %d checks, %d failures" % [checks, failures])
	get_tree().quit(0 if failures == 0 else 1)
