extends Node
var checks := 0
var failures := 0
var main: Node2D
var player: CharacterBody2D

func _ready() -> void:
	AudioServer.set_bus_mute(0, true)
	GameManager.save_path = "res://build/smooth_gameplay_save.json"
	_run.call_deferred()

func check(value: bool, message: String) -> void:
	checks += 1
	if not value:
		failures += 1
		push_error(message)

func wait_frames(count: int = 3) -> void:
	for index in count:
		await get_tree().physics_frame
		await get_tree().process_frame

func capture(label: String) -> void:
	if DisplayServer.get_name() == "headless":
		return
	player.get_node("Camera2D").snap_to_player()
	await wait_frames()
	await RenderingServer.frame_post_draw
	check(get_viewport().get_texture().get_image().save_png("res://build/smooth_" + label + ".png") == OK, "Capture " + label)

func _run() -> void:
	FreedomLedger.reset()
	GameManager.zone = "ground"
	GameManager.entry = "start"
	GameManager.state = GameManager.State.PLAYING
	GameManager.arrival_pending = false
	GameManager.respawn_pending = false
	main = preload("res://scenes/main/main.tscn").instantiate()
	add_child(main)
	player = main.get_node("Entities/Player")
	var enemy = get_tree().get_first_node_in_group("enemy")
	enemy.set_physics_process(false)
	enemy.position = Vector2(1700, 600)
	player.position = Vector2(1050, 610)
	Input.action_press("crouch")
	Input.action_press("move_left")
	await wait_frames(12)
	check(player.animation_state == "crouch_walk", "Crouch uses its actual gait")
	check(is_equal_approx(player.visual.scale.y, 1.0), "Crouch must not squash a standing body")
	check(player.sprite.sprite_frames.get_frame_texture(player.sprite.animation, player.sprite.frame).get_width() == 512, "Crouch uses new pose artwork")
	await capture("crouch_walk")
	Input.action_release("move_left")
	Input.action_release("crouch")
	await wait_frames(8)
	player.position = Vector2(1050, 600)
	var before := player.position
	var table: BaseInteractable = main.room.props.get_node("DiningTableHide")
	await table.interact(player)
	await get_tree().create_timer(0.75).timeout
	check(player.hidden_spot == table and player.sprite.is_visible_in_tree(), "Hiding retains the character sprite")
	check(is_equal_approx(player.visual.modulate.a, 1.0), "Hidden character is opaque")
	check(player.position.distance_to(table.position) < 12.0, "Character actually enters under the table")
	check(player.animation_state == "hide_table_hold" and not player.flashlight_enabled, "Hiding holds the dedicated low pose with no beam")
	await capture("under_table")
	player.leave_hiding()
	await get_tree().create_timer(0.6).timeout
	check(player.hidden_spot == null and player.position.distance_to(before) < 0.1, "Leaving returns to the safe approach position")
	check(player.collision_layer == 2 and player.collision_mask == 1, "Leaving restores collision")
	player.set_physics_process(false)
	FreedomLedger.flags.flashlight = true
	for direction in [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN]:
		player.facing = direction
		player.play_animation("walk")
		player.set_flashlight(true)
		check(player.animation_state == "torch_raise" and player.sprite.frame == 0, "Flashlight uses its own raise sequence")
		player.animation_hold = 0.0
		player.play_animation("walk")
		check(str(player.sprite.animation).begins_with("torch_walk_") and not player.flashlight_pose.visible, "Torch walking uses a complete animated body")
		await capture("light_" + str(direction))
		player.set_flashlight(false)
		check(not player.flashlight_pose.visible and not player.get_node("FlashlightFloor").visible, "Switch off removes holding pose and disables beam")
		check(not player.sprite.material.get_shader_parameter("holding_light"), "Switch off restores the normal upper body")
		check(player.animation_state == "torch_lower", "Switch off uses the lowering sequence")
		player.animation_hold = 0.0
		player.play_animation("walk")
		if direction == Vector2.RIGHT:
			await capture("light_off_walk")
	player.play_animation("idle")
	player.set_flashlight(true)
	check(player.animation_state == "torch_raise", "Light on raises the flashlight from standing")
	player.set_flashlight(false)
	check(not player.flashlight_pose.visible and player.animation_state == "torch_lower", "Light off lowers the flashlight from standing")
	var saved_charge: float = FreedomLedger.flashlight_seconds
	FreedomLedger.set_flashlight_seconds(0.1)
	player.set_flashlight(true)
	player._update_flashlight_charge(0.2)
	check(not player.flashlight_enabled and not player.flashlight_pose.visible and not player.sprite.material.get_shader_parameter("holding_light"), "An empty battery also restores the normal pose")
	FreedomLedger.set_flashlight_seconds(saved_charge)
	player.set_physics_process(true)
	for id in ["GroundBattery", "SideClock", "CoatLockpick"]:
		var item: BaseInteractable = main.room.props.get_node(id)
		player.position = item.position + Vector2(0, 25)
		player.animation_hold = 0.0
		await item.interact(player)
		check(not item.visible and not item.get_node("Visual").is_visible_in_tree(), id + " disappears completely")
		check(not item.available() and FreedomLedger.flags.get(item.interaction_id, false), id + " cannot be collected twice")
	var intro: Node2D = preload("res://scenes/levels/intro_floor.tscn").instantiate()
	add_child(intro)
	var bag: BaseInteractable = intro.props.get_node("LockpickTool")
	await bag.interact(player)
	check(not bag.visible and not bag.get_node("Visual").visible, "Tool bag and marker disappear")
	intro.queue_free()
	var reload_room: Node2D = preload("res://scenes/levels/ground_floor.tscn").instantiate()
	add_child(reload_room)
	for id in ["GroundBattery", "SideClock", "CoatLockpick"]:
		check(not reload_room.props.get_node(id).visible, id + " remains absent after reload")
	reload_room.queue_free()
	# Let the temporary rooms remove their physics bodies before testing line of sight.
	await wait_frames(2)
	check(main.room.props.get_node("PianoSeal")._action_animation() == "piano", "Piano has its own action")
	check(main.room.props.get_node("FrontDoor")._action_animation() != "pickup", "Door does not play key pickup")
	for action in ["collect", "pickup", "unlock", "door_open", "piano", "channel", "recharge", "read"]:
		player.play_action(action, 0.6)
		check(String(player.sprite.animation).begins_with(action + "_"), "Distinct action clip: " + action)
	var point: Vector2 = enemy.global_position + Vector2(120, 0)
	var previous: Vector2 = enemy.target
	enemy._hear(point, 300.0, "WOOD")
	check(enemy.target == previous, "Sealed hearing cannot track sound")
	FreedomLedger.restore_sense("hearing")
	enemy.path_clock = 0.25
	enemy._hear(point, 300.0, "WOOD")
	check(enemy.target == point and enemy.path_clock == 0.0 and enemy.facing.x > 0.9, "Restored hearing immediately faces and replans toward a sound")
	check("1 / 3" in FreedomLedger.freedom_summary() and "hearing" in FreedomLedger.freedom_summary(), "Freedom display communicates the released sense")
	FreedomLedger.restore_sense("sight")
	# Use the open corridor and a distance between standing and crouching reach.
	# The old y=600 line now crosses physical dining-room furniture.
	enemy.position = Vector2(1580, 500)
	player.position = enemy.position + Vector2(430, 0)
	enemy.facing = Vector2.RIGHT
	player.flashlight_enabled = false
	player.is_crouching = false
	check(enemy.can_see_player(), "Restored sight detects a standing player in range: enemy=%s player=%s exposed=%s clear=%s senses=%s" % [enemy.position, player.position, main.room.is_exposed(player.position), enemy.clear_sight(player.position), FreedomLedger.keys_collected])
	player.is_crouching = true
	check(not enemy.can_see_player(), "Crouching without a light reduces visual exposure")
	player.is_crouching = false
	player.position = Vector2(1500, 570)
	player.animation_hold = 0.0
	var hud = main.get_node("UI")
	hud._present_message("ELS", "Each bond I break gives it another way to find me.")
	hud.subtitle_time = 10.0
	await capture("speech")
	check(hud.bubble.design.scale.x <= 0.56, "Speech bubble is smaller")
	player.enter_hiding(table)
	await wait_frames(2)
	player._caught()
	check(player.hidden_spot == null and not player.hiding_transition_active, "Capture cancels a shelter transition")
	check(player.collision_layer == 2 and player.collision_mask == 1 and player.visual.modulate.a == 1.0, "Capture restores a visible body and collision")
	main.queue_free()
	await wait_frames()
	print("SMOOTH GAMEPLAY: %d checks, %d failures" % [checks, failures])
	get_tree().quit(0 if failures == 0 else 1)
