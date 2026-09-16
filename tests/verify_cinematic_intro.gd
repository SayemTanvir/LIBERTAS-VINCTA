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

func wait_menu() -> void:
	var deadline := Time.get_ticks_msec() + 15000
	while Time.get_ticks_msec() < deadline:
		await frames(1)
		var scene := get_tree().current_scene
		if scene != null and scene.scene_file_path == "res://scenes/ui/front_end.tscn":
			check(GameManager.state == GameManager.State.MENU, "Cinematic finishes in menu state")
			check(scene.current_id == "menu", "Main menu is the first interactive page")
			check(get_tree().get_first_node_in_group("estate_cinematic") == null, "Exterior and its audio are removed")
			return
	check(false, "Main menu loading timed out")

func launch() -> Node:
	get_tree().paused = false
	var path: String = ProjectSettings.get_setting("application/run/main_scene")
	check(path == "res://scenes/intro/startup.tscn", "Application launches the startup scene")
	get_tree().change_scene_to_file(path)
	await frames(5)
	var cinematic := get_tree().get_first_node_in_group("estate_cinematic")
	check(cinematic != null, "Every launch creates the cinematic")
	check(GameManager.state == GameManager.State.INTRO, "Launch is in intro state")
	check(get_tree().get_nodes_in_group("player").is_empty(), "No gameplay runs behind the launch intro")
	return cinematic

func _run() -> void:
	var cinematic = await launch()
	if cinematic == null:
		get_tree().quit(1)
		return
	cinematic.set_process(false)
	for shot in [{"time": 4.6, "name": "establishing"}, {"time": 5.62, "name": "lightning"}, {"time": 14.4, "name": "title"}, {"time": 18.3, "name": "mist"}]:
		cinematic.elapsed = shot.time
		cinematic._update_presentation()
		await capture(shot.name)
	var viewport_size := get_window().size
	if DisplayServer.get_name() != "headless":
		get_window().size = Vector2i(1920, 1080)
		await frames(8)
		await capture("full_hd")
		get_window().size = Vector2i(1100, 800)
		await frames(8)
		check(cinematic.stage.position.y > 0.0, "Tall viewport letterboxes the composition")
		check(cinematic.stage.size.x * cinematic.stage.scale.x <= cinematic.size.x + 1.0, "Viewport fit avoids horizontal clipping")
		get_window().size = viewport_size
		await frames(8)
	cinematic.elapsed = 0.0
	cinematic.set_process(true)
	var cues := {"thunder": 0, "title": false}
	cinematic.finished.connect(func():
		cues.thunder = cinematic.thunder_count
		cues.title = cinematic.title_sounded)
	Engine.time_scale = 6.0
	await wait_menu()
	check(cues.thunder == 2 and cues.title, "Natural completion plays both thunder cues and title sting")
	Engine.time_scale = 1.0
	await capture("launch_menu")
	# Boot is independent of previous playthrough flags and never deletes a save.
	FreedomLedger.flags["estate_prologue_seen"] = true
	var save := FileAccess.open(GameManager.save_path, FileAccess.WRITE)
	save.store_string("launch preservation probe")
	save.close()
	cinematic = await launch()
	await get_tree().create_timer(0.7).timeout
	var key := InputEventKey.new()
	key.keycode = KEY_ENTER
	key.pressed = true
	Input.parse_input_event(key)
	await frames()
	check(cinematic.skip_elapsed >= 0.0, "Enter requests a smooth skip")
	key = key.duplicate()
	key.pressed = false
	Input.parse_input_event(key)
	await wait_menu()
	check(FileAccess.get_file_as_string(GameManager.save_path) == "launch preservation probe", "Launch and skip preserve the existing save")
	await frames(10)
	check(GameManager.state == GameManager.State.MENU, "Skip input does not activate New Game")
	# New Game begins Awakening without replaying the exterior.
	GameManager.new_game()
	if not await wait_main():
		get_tree().quit(1)
		return
	check(get_tree().get_first_node_in_group("estate_cinematic") == null, "New Game does not repeat the launch intro")
	check(main.get_node("Awakening").presentation == &"INTRO_PRONE", "New Game begins Els awakening")
	Engine.time_scale = 12.0
	await wait_playing()
	GameManager.save_checkpoint(main.get_node("Entities/Player").global_position)
	GameManager.go_home()
	await wait_menu()
	GameManager.continue_game()
	await frames(2)
	if not await wait_main():
		get_tree().quit(1)
		return
	check(get_tree().get_first_node_in_group("estate_cinematic") == null, "Continue loads gameplay directly")
	await wait_playing()
	GameManager.go_home()
	await wait_menu()
	Engine.time_scale = 1.0
	print("CINEMATIC INTRO: %d checks, %d failures" % [checks, failures])
	get_tree().quit(0 if failures == 0 else 1)
