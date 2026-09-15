extends Node
var checks := 0
var failures := 0
var main: Node

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().current_scene = null
	AudioServer.set_bus_mute(0, true)
	GameManager.save_path = "res://build/cinematic_test_save.json"
	_run.call_deferred()

func check(value: bool, message: String) -> void:
	checks += 1
	if not value:
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
	check(get_viewport().get_texture().get_image().save_png("res://build/intro_" + label + ".png") == OK, "Capture " + label)

func wait_main() -> bool:
	var deadline := Time.get_ticks_msec() + 20000
	while Time.get_ticks_msec() < deadline:
		await frames(1)
		main = get_tree().current_scene
		if main != null and main.scene_file_path == "res://scenes/main/main.tscn":
			return true
	check(false, "Main scene loading timed out")
	return false

func wait_playing() -> void:
	var deadline := Time.get_ticks_msec() + 15000
	while GameManager.state != GameManager.State.PLAYING and Time.get_ticks_msec() < deadline:
		await frames(1)
	check(GameManager.state == GameManager.State.PLAYING, "Awakening returns to gameplay")
	check(main.get_node("Entities/Player").control_enabled, "Player controls restored")
	check(main.get_node("UI").fade.color.a < 0.01, "Transition clears its black overlay")
	check(get_tree().get_first_node_in_group("estate_cinematic") == null, "Cinematic and local audio cleaned up")

func _run() -> void:
	GameManager.new_game()
	if not await wait_main():
		get_tree().quit(1)
		return
	var cinematic = get_tree().get_first_node_in_group("estate_cinematic")
	check(cinematic != null, "Fresh Start launches the cinematic")
	if cinematic == null:
		get_tree().quit(1)
		return
	var hud = main.get_node("UI")
	var player = main.get_node("Entities/Player")
	check(main.get_node("Awakening").presentation == &"INTRO_CINEMATIC", "Opening presentation state")
	check(not player.control_enabled, "Gameplay locked during cinematic")
	check(cinematic.get_index() > hud.fade.get_index() and cinematic.get_index() < hud.pause_menu.get_index(), "Cinematic covers gameplay and remains below pause UI")
	cinematic.set_process(false)
	for shot in [{"time": 4.6, "name": "establishing"}, {"time": 5.62, "name": "lightning"}, {"time": 14.4, "name": "title"}, {"time": 18.3, "name": "mist"}]:
		cinematic.elapsed = shot.time
		cinematic._update_presentation()
		await capture(shot.name)
	var viewport_size := get_window().size
	if DisplayServer.get_name() != "headless":
		get_window().size = Vector2i(1100, 800)
		await frames(8)
		check(cinematic.stage.position.y > 0.0, "Tall viewport letterboxes the composition")
		check(cinematic.stage.size.x * cinematic.stage.scale.x <= cinematic.size.x + 1.0, "Viewport fit avoids horizontal clipping")
		await capture("tall_viewport")
		get_window().size = viewport_size
		await frames(8)
	cinematic.elapsed = 4.0
	cinematic.set_process(true)
	GameManager.pause_game()
	hud.show_pause()
	var frozen: float = cinematic.elapsed
	await get_tree().create_timer(0.25, true).timeout
	check(is_equal_approx(cinematic.elapsed, frozen), "Pause freezes timeline and weather")
	cinematic.request_skip()
	check(cinematic.skip_elapsed < 0.0, "Cannot skip behind pause menu")
	await capture("paused")
	hud.pause_menu.resume_game()
	await frames(4)
	check(cinematic.elapsed > frozen, "Resume continues the cinematic")
	var key := InputEventKey.new()
	key.keycode = KEY_ENTER
	key.pressed = true
	Input.parse_input_event(key)
	await frames()
	check(cinematic.skip_elapsed >= 0.0, "Enter requests a smooth skip")
	key.pressed = false
	Input.parse_input_event(key)
	Engine.time_scale = 12.0
	await wait_playing()
	check(FreedomLedger.flags.get("estate_prologue_seen", false), "Seen state persisted in ledger")
	# Repeat the fresh-start path to exercise natural completion, not just skip.
	GameManager.new_game()
	if not await wait_main():
		get_tree().quit(1)
		return
	cinematic = get_tree().get_first_node_in_group("estate_cinematic")
	check(cinematic != null, "New Game resets the seen state")
	var cues := {"thunder": 0, "title": false}
	cinematic.finished.connect(func():
		cues.thunder = cinematic.thunder_count
		cues.title = cinematic.title_sounded
	)
	await wait_playing()
	check(cues.thunder == 2 and cues.title, "Natural playback delivers both thunder cues and title sting")
	# Existing saves must not replay the exterior even if created before this feature.
	FreedomLedger.flags.erase("estate_prologue_seen")
	GameManager.save_checkpoint(main.get_node("Entities/Player").global_position)
	GameManager.continue_game()
	await frames(2)
	if not await wait_main():
		get_tree().quit(1)
		return
	check(get_tree().get_first_node_in_group("estate_cinematic") == null, "Continue bypasses exterior for legacy checkpoints")
	await wait_playing()
	# Leaving during the cinematic must cancel its audio and never change the menu state later.
	GameManager.new_game()
	await frames(2)
	if not await wait_main():
		get_tree().quit(1)
		return
	GameManager.go_home()
	await get_tree().create_timer(2.4, true).timeout
	check(GameManager.state == GameManager.State.MENU, "Home cancels the opening flow")
	check(get_tree().get_first_node_in_group("estate_cinematic") == null, "Home removes cinematic children")
	Engine.time_scale = 1.0
	print("CINEMATIC INTRO: %d checks, %d failures" % [checks, failures])
	get_tree().quit(0 if failures == 0 else 1)
