extends Node
## Regression coverage for real repeated E input, collected visuals, and speaker tracking.
var checks := 0
var failures: Array[String] = []
var main: Node2D
var player: CharacterBody2D
var hud: CanvasLayer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	AudioServer.set_bus_mute(0, true)
	GameManager.save_path = "res://build/gameplay_polish_test_save.json"
	get_tree().root.notification(MainLoop.NOTIFICATION_APPLICATION_FOCUS_IN)
	_run.call_deferred()

func check(value: bool, message: String) -> void:
	checks += 1
	if not value:
		failures.append(message)
		push_error(message)

func frames(count: int = 3) -> void:
	for _i in count:
		await get_tree().physics_frame
		await get_tree().process_frame

func press_e() -> void:
	var event := InputEventKey.new()
	event.keycode = KEY_E
	event.physical_keycode = KEY_E
	event.pressed = true
	Input.parse_input_event(event)
	await frames(2)
	event = event.duplicate()
	event.pressed = false
	Input.parse_input_event(event)
	await frames(2)

func capture(label: String) -> void:
	if DisplayServer.get_name() == "headless":
		return
	await get_tree().create_timer(0.25).timeout
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png("res://build/gameplay_polish_" + label + ".png")

func _setup(zone: String) -> void:
	if is_instance_valid(main):
		main.queue_free()
		await frames()
	FreedomLedger.reset()
	GameManager.zone = zone
	GameManager.state = GameManager.State.PLAYING
	GameManager.arrival_pending = false
	GameManager.respawn_pending = false
	main = preload("res://scenes/main/main.tscn").instantiate()
	add_child(main)
	player = main.get_node("Entities/Player")
	hud = main.get_node("UI")
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.set_physics_process(false)
	await frames()

func _puzzle(zone: String, id: String, offset: Vector2, required: String = "") -> void:
	await _setup(zone)
	if not required.is_empty():
		FreedomLedger.restore_sense("hearing")
		if required == "sight":
			FreedomLedger.restore_sense("sight")
	FreedomLedger.collect_item("lockpick", 3)
	var prop: BaseInteractable = main.room.props.get_node(id)
	player.position = prop.position + offset
	player.get_node("Camera2D").snap_to_player()
	await frames()
	var initial := player.position
	for step in prop.puzzle_steps:
		player._find_interactable()
		check(player.target_interactable == prop, id + " reachable for step " + str(step + 1))
		# A visible timed line must not consume an E press intended for this lock.
		hud._present_message("ELS", "The house is listening.")
		hud.subtitle_time = 3.0
		await press_e()
		check(prop.busy, id + " E begins action with ambient speech visible")
		check(player.position.distance_to(initial) < 0.1, id + " action never teleports Els")
		Input.action_press("move_right")
		await frames(2)
		Input.action_release("move_right")
		check(player.position.distance_to(initial) < 0.1, id + " feet stay planted during action")
		if step == 0:
			await capture(zone + "_puzzle")
		var deadline := Time.get_ticks_msec() + 5000
		while prop.busy and Time.get_ticks_msec() < deadline:
			await frames(1)
		check(prop.progress == step + 1, id + " exactly one step per E")
		check(player.control_enabled, id + " returns control")
		check(player.position.distance_to(initial) < 0.1, id + " next step needs no repositioning")
	check(not prop.available() and prop.visible, id + " solved furniture stays, interaction ends")
	check(FreedomLedger.inventory.lockpick == (2 if prop.consumes_lockpick else 3), id + " spends exactly the required lockpick")

func _run() -> void:
	await _puzzle("ground", "PianoSeal", Vector2(-78, -4))
	var key: BaseInteractable = main.room.props.get_node("HearingKey")
	player.position = key.position + Vector2(0, 28)
	player.animation_hold = 0.0
	await frames()
	await press_e()
	check(FreedomLedger.hearing_restored, "Hearing key collected through live E")
	check(not key.visible and not key.get_node("Visual/Sprite2D").is_visible_in_tree(), "Collected key and all artwork disappear immediately")
	var clock: BaseInteractable = main.room.props.get_node("SideClock")
	player.position = clock.position + Vector2(0, 28)
	player.animation_hold = 0.0
	await frames()
	var clock_sprite: Sprite2D = clock.get_node("Visual/Sprite2D")
	check(clock_sprite.texture.get_width() * clock_sprite.global_scale.x <= 24, "Clock is hand-sized")
	check(clock.z_index < player.z_index, "Floor accessories draw below Els")
	await capture("clock_before")
	await press_e()
	check(FreedomLedger.inventory.clock == 1, "Clock awarded once")
	check(not clock.get_node("Visual/PickupMarker").is_visible_in_tree(), "Collected clock marker disappears with sprite")
	player.animation_hold = 0.0
	await frames()
	await press_e()
	check(FreedomLedger.inventory.clock == 1, "Second E cannot duplicate a collected clock")
	await capture("clock_after")
	# Reload presentation against the existing ledger, as a return trip/checkpoint does.
	var revisited: Node2D = preload("res://scenes/levels/ground_floor.tscn").instantiate()
	add_child(revisited)
	check(not revisited.props.get_node("SideClock").visible and not revisited.props.get_node("HearingKey").visible, "Collected objects remain absent on room reload")
	revisited.queue_free()
	await frames()
	await _puzzle("upper", "VanitySeal", Vector2(0, 30), "hearing")
	await _puzzle("basement", "RitualSeal", Vector2(-92, 28), "sight")
	await _setup("ground")
	var partial: BaseInteractable = main.room.props.get_node("PianoSeal")
	FreedomLedger.collect_item("lockpick", 1)
	player.position = partial.position + Vector2(0, 30)
	await partial.interact(player)
	var returning: Node2D = preload("res://scenes/levels/ground_floor.tscn").instantiate()
	add_child(returning)
	var saved_piano: BaseInteractable = returning.props.get_node("PianoSeal")
	check(saved_piano.progress == 1 and saved_piano._can_play_action(), "Partly worked seal remembers its paid lockpick after a room reload")
	returning.queue_free()
	await frames()
	player.position = Vector2(1780, 510)
	player.get_node("Camera2D").snap_to_player()
	await frames()
	hud._present_message("ELS", "Something heard that.")
	hud.subtitle_time = 20
	await frames()
	check(hud.bubble.visible and not hud.narration.visible, "Els speaks in the cloud")
	var origin: Vector2 = hud.bubble.design.position
	var initial_tail: bool = hud.bubble.tail_on_right
	player.position.x += 55
	player.position.y += 20
	await frames(1)
	check(hud.bubble.design.position.distance_to(origin) > 10, "Cloud tracks moving speaker and camera")
	check(hud.bubble.tail_on_right == initial_tail, "Tail side remains stable during a line")
	await capture("speech")
	for viewport_size in [Vector2i(1280, 720), Vector2i(1600, 900), Vector2i(1920, 1080), Vector2i(1024, 768)]:
		get_tree().root.size = viewport_size
		await frames()
		hud._present_message("ELS", "A long word: " + "unbroken".repeat(18) + "\n" + "The house remembers every name. ".repeat(18))
		var rebuilt := ""
		while true:
			await frames(1)
			var label: RichTextLabel = hud.bubble.text_label
			check(label.get_content_height() <= label.size.y + 1, "Every wrapped page fits at " + str(viewport_size))
			var bounds: Rect2 = hud.bubble.design.get_global_rect()
			check(hud.root.get_global_rect().encloses(bounds), "Speech remains inside screen at " + str(viewport_size))
			rebuilt += label.text.replace(" ", "").replace("\n", "")
			if not hud.bubble.advance_page():
				break
		check(rebuilt == hud.bubble.body.replace(" ", "").replace("\n", ""), "Pagination retains every character")
	get_tree().root.size = Vector2i(1280, 720)
	hud._present_message("", "Custodian. Jailer. Vantree. Els Vantree - the final carving bears a date centuries old.")
	hud.subtitle_time = 20
	await frames()
	check(hud.narration.visible and not hud.bubble.visible, "Storyteller has a separate non-cloud surface")
	check(hud.narration.bubble.texture is GradientTexture2D, "Narration uses cinematic shading, not speech artwork")
	await capture("narration")
	hud.show_message("ELS", "Read this before returning to the room.")
	await frames()
	var before := player.position
	Input.action_press("move_right")
	await frames()
	Input.action_release("move_right")
	check(get_tree().paused and player.position == before, "Acknowledged message blocks movement")
	await press_e()
	check(not hud.acknowledged_message and not get_tree().paused, "E closes acknowledged message")
	player.animation_hold = 0
	player.play_animation("idle")
	player.is_crouching = false
	player.visual.scale = Vector2.ONE
	player.is_crouching = true
	player._update_body_presentation(1.0 / 60)
	player.play_animation("crouch_idle")
	check(is_equal_approx(player.visual.scale.y, 1.0) and String(player.sprite.animation).begins_with("crouch_idle_"), "Crouch uses bent-knee artwork without squashing the body")
	player.play_action("interact", 0.5)
	check(is_equal_approx(player.animation_hold, 0.5) and player.sprite.speed_scale > 1, "Action playback matches its duration")
	player.play_animation("walk")
	player.sprite.set_frame_and_progress(5, 0.4)
	player.play_animation("run")
	check(player.sprite.frame == 5 and is_equal_approx(player.sprite.frame_progress, 0.4), "Walk/run transition preserves gait phase")
	for direction in [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN]:
		player.facing = direction
		player.play_action("unlock", 1.1)
		check(String(player.sprite.animation).begins_with("unlock_") and player.animation_state == "unlock", "Unlock uses its dedicated lock-working clip: " + str(direction))
	player.position = Vector2(1000, 540)
	FreedomLedger.collect_item("bottle", 1)
	player.use_gadget()
	var escape_point := player.position
	Input.action_press("move_right")
	await frames()
	Input.action_release("move_right")
	check(player.position.x > escape_point.x, "Cosmetic gadget action never prevents an escape move")
	main.queue_free()
	await frames()
	print("GAMEPLAY POLISH: %d checks, %d failures" % [checks, failures.size()])
	get_tree().quit(0 if failures.is_empty() else 1)
