extends Node
var main: Node2D
var player: CharacterBody2D
var enemy: CharacterBody2D
var checks := 0
var failures := 0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	AudioServer.set_bus_mute(0, true)
	GameManager.save_path = "res://build/finishability_test_save.json"
	_run.call_deferred()

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error(message)

func frames(count := 3) -> void:
	for i in count:
		await get_tree().process_frame

func capture(label: String) -> void:
	if DisplayServer.get_name() == "headless":
		return
	await frames()
	await RenderingServer.frame_post_draw
	check(get_viewport().get_texture().get_image().save_png("res://build/finishability_" + label + ".png") == OK, "Capture " + label)

func setup(branch: String, zone: String) -> void:
	get_tree().paused = false
	if is_instance_valid(main):
		main.queue_free()
		await frames()
	# Headless capture does not yield: the outgoing ending UI may pause on its final
	# cleanup frame. Reset pause after removing it before testing the next route.
	get_tree().paused = false
	FreedomLedger.reset()
	if branch != "untouched":
		FreedomLedger.restore_sense("hearing")
	if branch == "partial_mercy":
		FreedomLedger.restore_sense("sight")
	FreedomLedger.begin_part_two(branch)
	FreedomLedger.flags["flashlight"] = true
	FreedomLedger.flags["part2_ability_unlocked"] = true
	GameManager.zone = zone
	GameManager.entry = "start"
	GameManager.state = GameManager.State.PLAYING
	GameManager.ending = ""
	GameManager.arrival_pending = false
	GameManager.respawn_pending = false
	main = preload("res://scenes/main/main.tscn").instantiate()
	main.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(main)
	player = main.get_node("Entities/Player")
	enemy = get_tree().get_first_node_in_group("enemy")
	await frames()

func release_movement() -> void:
	for action in ["move_left", "move_right", "move_up", "move_down", "sprint"]:
		Input.action_release(action)

func walk_to(point: Vector2) -> bool:
	var path: PackedVector2Array = main.room.find_path(player.global_position, point)
	path.append(point)
	var deadline := Time.get_ticks_msec() + 18000
	for waypoint in path:
		while player.global_position.distance_to(waypoint) > 13.0:
			if Time.get_ticks_msec() > deadline or GameManager.state != GameManager.State.PLAYING:
				release_movement()
				check(false, "Live movement could not reach " + str(point) + " from " + str(player.position))
				return false
			var offset := waypoint - player.global_position
			for entry in [["move_left", -offset.x], ["move_right", offset.x], ["move_up", -offset.y], ["move_down", offset.y]]:
				if entry[1] > 2.0:
					Input.action_press(entry[0], clampf(entry[1] / 22.0, 0.0, 1.0))
				else:
					Input.action_release(entry[0])
			Input.action_press("sprint")
			if FreedomLedger.part2_seed.get("blood_magic", false) and player.global_position.distance_to(enemy.global_position) < 185.0 and player.stun_cooldown <= 0.0:
				player.use_stun()
			await get_tree().physics_frame
	release_movement()
	await get_tree().physics_frame
	return true

func _run() -> void:
	await setup("partial_mercy", "echoes")
	enemy.set_physics_process(false) # Isolated ability / charging checks below.
	player.position = Vector2(4700, 515)
	enemy.position = player.position + Vector2(110, 0)
	var key := InputEventKey.new()
	key.physical_keycode = KEY_H
	key.pressed = true
	Input.parse_input_event(key)
	await frames()
	check(get_tree().paused and main.get_node("UI").reader.visible, "H opens a readable guide and pauses danger")
	check("Blocks Hearing" in main.get_node("UI").reader.content.text and "4 HP" in main.get_node("UI").reader.content.text, "Partial guide explains its real effect and cost")
	await capture("field_guide")
	main.get_node("UI").close_modal()
	await frames(4)
	check(player.use_sigil(), "Partial sigil casts")
	check(enemy._sense_blocked("hearing") and not enemy._sense_blocked("sight"), "Partial sigil blocks active Hearing but leaves Sight")
	var sigil = get_tree().get_first_node_in_group("silencing_sigil")
	var age: float = sigil.age
	GameManager.pause_game()
	await get_tree().create_timer(0.2, true).timeout
	check(is_equal_approx(sigil.age, age), "Pause freezes the actual sigil effect")
	GameManager.resume()
	await capture("partial_sigil")
	sigil.age = sigil.lifetime
	check(not enemy._sense_blocked("hearing"), "Expired sigil no longer blocks hearing")
	var station: BaseInteractable
	for prop in main.room.props.get_children():
		if prop is BaseInteractable and prop.kind == "recharge" and prop.position.x > 4400:
			station = prop
	player.position = station.position + Vector2(0, 30)
	FreedomLedger.hp = 20.0
	FreedomLedger.set_flashlight_seconds(0.0)
	await frames()
	check(station.get_node("Visual/PowerStation").state == 0, "Power station shows idle artwork when charge is needed")
	await capture("power_station_idle")
	player.animation_hold = 0.0
	station.interact(player)
	var charging_position: Vector2 = player.position
	await get_tree().create_timer(0.55, false).timeout
	check(player.position.distance_to(charging_position) < 0.01 and player.velocity == Vector2.ZERO, "Charging keeps Els planted")
	check(player.animation_state == "recharge" and player.sprite.sprite_frames.get_frame_count(player.sprite.animation) == 1 and not player.is_crouching, "Charging uses a still standing pose")
	check(station.get_node("Visual/PowerStation").state == 1, "Power station shows active charging artwork")
	await capture("power_station_charging")
	check(FreedomLedger.hp > 20.0 and FreedomLedger.flashlight_seconds > 0.0, "Ward lantern gradually restores HP and charge")
	Input.action_press("move_left")
	await frames(8)
	Input.action_release("move_left")
	check(not station.busy and player.control_enabled and player.animation_hold <= 0.0, "Movement immediately cancels recharge without a control lock")
	check(FreedomLedger.hp < FreedomLedger.max_hp and FreedomLedger.flashlight_seconds < 90.0, "Early cancellation keeps partial gains")
	station.interact(player)
	await get_tree().create_timer(0.2, false).timeout
	FreedomLedger.damage(1.0)
	await frames(6)
	check(not station.busy and player.control_enabled, "Damage interrupts charging and restores control")
	FreedomLedger.set_flashlight_seconds(FreedomLedger.MAX_FLASHLIGHT_SECONDS)
	FreedomLedger.heal(FreedomLedger.max_hp)
	await frames()
	check(station.get_node("Visual/PowerStation").state == 2, "Power station shows full-charge artwork")
	await capture("power_station_full")
	var hide: BaseInteractable = main.room.props.get_node("NexusDescentAlcove")
	player.position = hide.position + Vector2(0, 25)
	await hide.interact(player)
	await get_tree().create_timer(0.3, false).timeout
	check(player.hidden_spot == hide and player.visual.modulate.a == 1.0, "Nexus Descent shelter keeps Els visible in her crouched pose")
	await capture("nexus_descent_hide")
	player.leave_hiding()
	await get_tree().create_timer(0.25, false).timeout
	# The finale keeps real AI, steering and held-E channels active.
	Engine.time_scale = 3.0
	await setup("untouched", "nexus")
	player.set_physics_process(false)
	player.position = Vector2(100, 500)
	var min_x := enemy.position.x
	var max_x := enemy.position.x
	for i in 500:
		await get_tree().create_timer(0.12, false).timeout
		min_x = minf(min_x, enemy.position.x)
		max_x = maxf(max_x, enemy.position.x)
	check(min_x < 700.0 and max_x > 3500.0, "Live patrol covers both ends of wide arena")
	check(enemy.is_physics_processing(), "Arena Hound uses its live AI")
	var guide: BaseInteractable = main.room.props.get_node("NexusGuide")
	player.position = guide.position + Vector2(0, 30)
	await guide.interact(player)
	main.get_node("UI").close_modal()
	player.position = Vector2(3600, 550)
	enemy.position = Vector2(3500, 550)
	await get_tree().physics_frame
	check(player.use_blood_trap(), "Live Hound can be trapped")
	var bound_at := enemy.position
	await get_tree().create_timer(1.0, false).timeout
	check(enemy.position.distance_to(bound_at) < 1.0 and enemy.blood_trap_seconds > 16.0, "Bound Hound cannot move or attack")
	await capture("blood_trap")
	# Freeze time with pause, then let the real 18-second trap expire.
	GameManager.pause_game()
	var held: float = enemy.blood_trap_seconds
	await get_tree().create_timer(0.3, true).timeout
	check(enemy.blood_trap_seconds == held, "Pause freezes live trap timer")
	GameManager.resume()
	player.position = Vector2(2100, 530)
	await get_tree().create_timer(18.0, false).timeout
	check(enemy.blood_trap_seconds == 0.0 and enemy.nexus_hunting, "Trap expires and permanent hunt resumes")
	check(enemy.position.distance_to(bound_at) > 1.0, "Hound moves again after release")
	# A distant decoy trail buys a full hold while AI stays active.
	enemy.position = Vector2(4100, 550)
	enemy.target = Vector2(4100, 550)
	enemy.change_state(enemy.State.INVESTIGATE_LAST_SEEN)
	var rune: BaseInteractable = main.room.props.get_node("LnB")
	player.position = rune.position + Vector2(0, 30)
	player.blood_trap_cooldown = 0.0
	FreedomLedger.heal(FreedomLedger.max_hp)
	# Cast at the far side, then cover the arena through normal movement.
	player.position = Vector2(3960, 550)
	await get_tree().physics_frame
	check(player.use_blood_trap(), "Second prepared trap buys escape time")
	player.animation_hold = 0.0
	player.set_physics_process(true)
	check(await walk_to(rune.position + Vector2(0, 30)), "Rune reached by normal sprint after binding")
	Input.action_press("interact")
	rune.interact(player)
	var deadline := Time.get_ticks_msec() + 14000
	while rune.busy and Time.get_ticks_msec() < deadline:
		await frames(1)
	Input.action_release("interact")
	check(main.room.outcome == "flee", "Live Hound allows a prepared 20-second Flee hold")
	await capture("nexus_flee_door")
	Engine.time_scale = 1.0
	release_movement()
	get_tree().paused = false
	print("FINISHABILITY: %d checks, %d failures" % [checks, failures])
	get_tree().quit(0 if failures == 0 else 1)
