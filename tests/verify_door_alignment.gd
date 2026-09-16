extends Node
var checks := 0
var failures := 0

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error(message)

func _ready() -> void:
	_run.call_deferred()

func _run() -> void:
	FreedomLedger.reset()
	GameManager.zone = "intro"
	GameManager.state = GameManager.State.PLAYING
	AudioServer.set_bus_mute(0, true)
	var room := preload("res://scenes/levels/intro_floor.tscn").instantiate()
	add_child(room)
	var player := preload("res://scenes/player/player.tscn").instantiate()
	add_child(player)
	var door: BaseInteractable = room.props.get_node("IntroExit")
	player.position = door.position + Vector2(-65, 34)
	await get_tree().physics_frame
	await door.interact(player)
	check(absf(player.position.x - door.position.x) < 1.0, "Side approach aligns with door before interaction")
	check(player.facing.dot(Vector2.UP) > 0.99, "Els faces the door")
	check(FreedomLedger.flags.get("intro_door_tried", false), "Aligned attempt reaches the lock")
	var presentation: Node = door.get_node("Visual/DoorPresentation")
	for kind in ["locked_door", "door"]:
		door.kind = kind
		player.position = door.position + Vector2(0, 5)
		var close_stance: Vector2 = player.position
		check(await presentation.align_for_interaction(player), "Close approach accepted for " + kind)
		check(player.position.distance_to(close_stance) < 0.01, "No backward restaging when already at the handle: " + kind)
	door.kind = "locked_door"
	var leaf: Sprite2D = presentation.door_sprite
	var hinge_x: float = leaf.position.x + leaf.texture.get_width() * leaf.scale.x * 0.5
	var frame: Node2D = door.get_node("Visual/StationaryDoorFrame")
	var fixed_frame: Array[Transform2D] = []
	for part in frame.get_children():
		fixed_frame.append(part.transform)
	FreedomLedger.flags["lockpick_tool"] = true
	FreedomLedger.flags["flashlight"] = true
	player.position = door.position + Vector2(-300, 100)
	await door.interact(player)
	check(not door.busy and not FreedomLedger.flags.get("intro_complete", false) and player.animation_state != "unlock", "Remote call cannot operate the door")
	# A blocked approach must neither teleport through furniture nor start the key clip.
	room._wall("AlignmentTestBlocker", Rect2(door.position + Vector2(22, 10), Vector2(16, 62)))
	player.position = door.position + Vector2(64, 34)
	await get_tree().physics_frame
	await get_tree().physics_frame
	await door.interact(player)
	check(player.position.x > door.position.x + 38 and player.control_enabled and not door.busy, "Blocked approach stops and restores control")
	check(player.animation_state != "unlock" and not FreedomLedger.flags.get("intro_complete", false), "Obstruction prevents remote key animation and unlock")
	room.geometry.get_node("AlignmentTestBlocker").queue_free()
	await get_tree().physics_frame
	player.position = door.position + Vector2(-65, 34)
	var action_start := {"aligned": false}
	EventBus.interaction_started.connect(func(prop):
		if prop == door:
			action_start.aligned = absf(player.position.x - door.position.x) < 1.0
	)
	door.interact(player)
	var deadline := Time.get_ticks_msec() + 4000
	while player.animation_state != "unlock" and Time.get_ticks_msec() < deadline:
		await get_tree().physics_frame
	check(action_start.aligned and player.animation_state == "unlock", "Actual key animation begins only after aligning")
	check(String(player.sprite.animation) == "unlock_n", "Key action faces into the door rather than beside it")
	check(player.sprite.flip_h and presentation.LOCK_SIDE < 0.0, "Key hand matches the visible left-side lock")
	var planted: Vector2 = player.position
	await get_tree().create_timer(0.2, false).timeout
	check(player.position.distance_to(planted) < 0.01 and not player.control_enabled, "Feet remain planted while using the key")
	if DisplayServer.get_name() != "headless":
		var camera := Camera2D.new()
		camera.position = door.position + Vector2(0, -30)
		camera.zoom = Vector2(3, 3)
		add_child(camera)
		camera.make_current()
		await get_tree().process_frame
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png("res://build/door_key_aligned.png")
	deadline = Time.get_ticks_msec() + 4000
	while not presentation.is_open and Time.get_ticks_msec() < deadline:
		await get_tree().physics_frame
	await get_tree().create_timer(0.5, false).timeout
	check(presentation.is_open, "Key completion opens the door before entering")
	check(player.position.distance_to(planted) < 0.01, "Door opens from the exact planted key stance")
	check(leaf.position.x > presentation.closed_position.x, "Left lock edge opens toward the opposite hinge")
	check(absf(leaf.position.x + leaf.texture.get_width() * leaf.scale.x * 0.5 - hinge_x) < 0.01, "Right hinge stays fixed throughout the swing")
	for i in frame.get_child_count():
		check(frame.get_child(i).transform == fixed_frame[i], "Door frame and threshold stay stationary")
	if DisplayServer.get_name() != "headless":
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png("res://build/door_open_from_key.png")
	# Isolate departure from scene travel so each movement step can be checked.
	GameManager.transition_epoch += 1
	presentation.depart(player)
	var previous_y: float = player.position.y
	var moved_backward := false
	deadline = Time.get_ticks_msec() + 1500
	while player.get_node("Visual").modulate.a > 0.001 and Time.get_ticks_msec() < deadline:
		await get_tree().process_frame
		moved_backward = moved_backward or player.position.y > previous_y + 0.001
		previous_y = player.position.y
	check(not moved_backward and player.position.y < planted.y - 15.0, "Entry proceeds forward from the key stance without a backward step")
	deadline = Time.get_ticks_msec() + 3000
	while door.busy and Time.get_ticks_msec() < deadline:
		await get_tree().process_frame
	presentation.set_open_immediate(false)
	player.position = planted
	player.control_enabled = true
	player.get_node("Visual").modulate.a = 1.0
	var interrupted := {"hello": false}
	EventBus.subtitle_requested.connect(func(_speaker, line, _seconds):
		if line == "Hello?":
			interrupted.hello = true)
	door.interact(player)
	deadline = Time.get_ticks_msec() + 3000
	while not presentation.is_open and Time.get_ticks_msec() < deadline:
		await get_tree().physics_frame
	GameManager.state = GameManager.State.CAUGHT
	GameManager.transition_epoch += 1
	await get_tree().create_timer(0.5, false).timeout
	check(not interrupted.hello and not FreedomLedger.flags.get("intro_complete", false), "Death during opening cancels dialogue and successful transition")
	check(player.position.distance_to(planted) < 0.01 and not door.busy, "Interrupted opening never moves the player through the door")
	print("DOOR ALIGNMENT: %d checks, %d failures" % [checks, failures])
	get_tree().quit(0 if failures == 0 else 1)
