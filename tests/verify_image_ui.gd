extends Node
## Real viewport input, scene flow and optional rendered capture verification.
var checks: int = 0
var failures: Array[String] = []
var frontend: Control
var main: Node
var last_action: String = ""
var cues: Array[String] = []

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().current_scene = null
	get_tree().root.notification(MainLoop.NOTIFICATION_APPLICATION_FOCUS_IN)
	get_tree().root.notification(Node.NOTIFICATION_WM_MOUSE_ENTER)
	GameManager.save_path = "res://build/ui_test_save.json"
	EventBus.audio_requested.connect(func(cue: String): cues.append(cue))
	_run.call_deferred()

func check(value: bool, message: String) -> void:
	checks += 1
	if not value:
		failures.append(message)
		push_error(message)

func frames(count: int = 2) -> void:
	for _i in count:
		await get_tree().process_frame

func key(code: Key, echo: bool = false) -> void:
	var event := InputEventKey.new()
	event.keycode = code
	event.physical_keycode = code
	event.pressed = true
	event.echo = echo
	Input.parse_input_event(event)
	await frames()
	event = event.duplicate()
	event.pressed = false
	event.echo = false
	Input.parse_input_event(event)
	await frames()

func action(name: String) -> void:
	var event := InputEventAction.new()
	event.action = name
	event.pressed = true
	Input.parse_input_event(event)
	await frames()
	event = event.duplicate()
	event.pressed = false
	Input.parse_input_event(event)
	await frames()

func pointer(menu: Control, index: int, click: bool = false) -> void:
	var button: Button = menu.buttons[index]
	var point := button.get_global_transform() * (button.size * 0.5)
	var motion := InputEventMouseMotion.new()
	motion.position = point
	motion.global_position = point
	motion.relative = Vector2(1, 1)
	get_viewport().push_input(motion, true)
	await frames()
	if click:
		var press := InputEventMouseButton.new()
		press.button_index = MOUSE_BUTTON_LEFT
		press.position = point
		press.global_position = point
		press.pressed = true
		get_viewport().push_input(press, true)
		await frames()
		press = press.duplicate()
		press.pressed = false
		get_viewport().push_input(press, true)
		await frames()

func sync(menu: Control, index: int, context: String) -> void:
	check(menu.current_index == index, context + ": selection")
	check(menu.buttons[index].has_focus(), context + ": focus")
	if menu.get("native_ui") == true:
		check(not menu.active_art.visible and not menu.buttons[index].text.is_empty(), context + ": native selected control")
	elif menu.get("menu_content") != null:
		check(not menu.active_art.visible and menu.buttons[index].get_theme_stylebox("normal") is StyleBoxEmpty, context + ": transparent native button over scenery")
	else:
		check(menu.active_art.texture == menu.state_textures[index], context + ": artwork")

func capture(label: String) -> void:
	if DisplayServer.get_name() == "headless":
		return
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png("res://build/ui_" + label + ".png")

func _run() -> void:
	frontend = preload("res://scenes/ui/front_end.tscn").instantiate()
	get_tree().root.add_child(frontend)
	await frames()
	var menu: Control = frontend.pages.menu
	sync(menu, 0, "Initial Start")
	cues.clear()
	menu.set_selection(1)
	menu.set_selection(1)
	check(cues.count("ui_hover") == 1, "One selection sound; same focus stays silent")
	menu.set_selection(0)
	# Exercise the actual D-pad event type without requiring connected hardware.
	var pad := InputEventJoypadButton.new()
	pad.button_index = JOY_BUTTON_DPAD_DOWN
	pad.pressed = true
	Input.parse_input_event(pad)
	await frames()
	sync(menu, 1, "D-pad down")
	pad = pad.duplicate()
	pad.pressed = false
	Input.parse_input_event(pad)
	menu.set_selection(0)
	await key(KEY_UP)
	sync(menu, 5, "Up wraps")
	await key(KEY_DOWN)
	sync(menu, 0, "Down wraps")
	await key(KEY_DOWN)
	sync(menu, 1, "Short tap")
	await key(KEY_DOWN, true)
	sync(menu, 1, "Echo ignored")
	await pointer(menu, 3)
	sync(menu, 3, "Mouse selects Rules")
	await get_tree().create_timer(0.16).timeout
	check(is_equal_approx(menu.highlights[3].modulate.a, 1.0), "Hovered button fades to red")
	await capture("dark_menu_hover")
	var leave := InputEventMouseMotion.new()
	leave.position = Vector2(8, 8)
	leave.global_position = leave.position
	get_viewport().push_input(leave, true)
	await get_tree().create_timer(0.16).timeout
	for highlight in menu.highlights:
		check(is_zero_approx(highlight.modulate.a), "Pointer exit restores transparent buttons")
	await capture("dark_menu_neutral")
	await key(KEY_DOWN)
	sync(menu, 4, "Keyboard continues after mouse")
	await pointer(menu, 3)
	await key(KEY_DOWN)
	await get_tree().create_timer(0.16).timeout
	for i in menu.highlights.size():
		check(is_equal_approx(menu.highlights[i].modulate.a, 1.0 if i == 4 else 0.0), "Keyboard selection owns the highlight with pointer still over another row")
	await pointer(menu, 2, true)
	check(frontend.current_id == "settings", "Mouse click opens Settings")
	var settings: Control = frontend.current
	sync(settings, 0, "Settings initial row")
	check(settings.buttons.size() == 9, "Audio, display, accessibility and Back are available")
	for i in 3:
		settings.set_selection(i)
		var bus: String = ["Master", "Music", "SFX"][i]
		var before: float = SessionSettings.volumes[bus]
		await key(KEY_LEFT)
		check(is_equal_approx(SessionSettings.volumes[bus], before - 0.05), bus + " decreases")
		check(is_equal_approx(AudioServer.get_bus_volume_linear(AudioServer.get_bus_index(bus)), before - 0.05), bus + " reaches AudioServer")
		await key(KEY_RIGHT)
		check(is_equal_approx(SessionSettings.volumes[bus], before), bus + " increases")
	SessionSettings.set_volume("Master", 0)
	check(AudioServer.is_bus_mute(0), "Zero volume mutes")
	SessionSettings.set_volume("Master", 0.8)
	settings.set_selection(3)
	await key(KEY_RIGHT)
	check(SessionSettings.resolution == Vector2i(1600, 900), "Resolution applies")
	settings.set_selection(4)
	await key(KEY_SPACE)
	check(SessionSettings.fullscreen, "Accept toggles fullscreen")
	await key(KEY_LEFT)
	check(not SessionSettings.fullscreen, "Left toggles fullscreen off")
	settings.set_selection(5)
	await key(KEY_ENTER)
	check(not SessionSettings.screen_shake, "Screen shake disabled")
	await key(KEY_RIGHT)
	check(SessionSettings.screen_shake, "Screen shake enabled")
	await capture("settings")
	await key(KEY_ESCAPE)
	check(frontend.current_id == "menu", "Settings Escape returns")
	sync(menu, 2, "Returning restores Settings selection")
	await key(KEY_DOWN)
	await key(KEY_ENTER)
	check(frontend.current_id == "rules", "Enter opens Rules")
	await key(KEY_RIGHT)
	check(frontend.current_id == "controls", "Rules to Controls")
	await capture("controls")
	await key(KEY_SPACE)
	check(frontend.current_id == "rules", "Controls Back preserves context")
	await pointer(frontend.current, 0, true)
	check(frontend.current_id == "menu", "Rules mouse Back")
	await action("ui_down")
	sync(menu, 4, "Standard action navigation")
	await action("ui_accept")
	check(frontend.current_id == "credits", "Standard accept opens Credits")
	check(frontend.current.team_labels[3].text == "Assets / Implementation", "Ifat's full contribution credit is preserved")
	await capture("credits")
	await action("ui_cancel")
	for resolution in [Vector2i(1280, 720), Vector2i(1600, 900), Vector2i(1920, 1080), Vector2i(1024, 768)]:
		get_tree().root.size = resolution
		await frames(3)
		for id in frontend.pages:
			if id != "menu":
				frontend.navigate(id)
			var page: Control = frontend.current
			check(is_equal_approx(page.design.scale.x, page.design.scale.y), id + " preserves aspect ratio")
			for i in page.buttons.size():
				await pointer(page, i)
				sync(page, i, "%s %s hotspot %d" % [id, resolution, i])
				if resolution == Vector2i(1280, 720) and id in ["menu", "settings"]:
					await capture(id + "_state_" + str(i))
				for j in page.buttons.size():
					if i != j:
						check(not page.buttons[i].get_rect().intersects(page.buttons[j].get_rect()), "No overlapping hitboxes")
			if resolution != Vector2i(1024, 768):
				await capture(id + "_" + str(resolution.x))
			if id != "menu":
				frontend.back()
	get_tree().root.size = Vector2i(1280, 720)
	frontend.queue_free()
	await frames()
	GameManager.zone = "ground"
	GameManager.state = GameManager.State.PLAYING
	GameManager.entry = "start"
	main = preload("res://scenes/main/main.tscn").instantiate()
	get_tree().root.add_child(main)
	get_tree().current_scene = main
	await frames(5)
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.set_physics_process(false)
	var hud: Node = main.get_node("UI")
	var player: CharacterBody2D = main.get_node("Entities/Player")
	await key(KEY_TAB)
	check(hud.reader.visible and hud.reader.title_label.text == "Inventory" and get_tree().paused, "Tab opens existing inventory on parchment")
	await key(KEY_ESCAPE)
	await key(KEY_ESCAPE)
	check(get_tree().paused and hud.pause_menu.visible, "Gameplay Escape pauses")
	await key(KEY_DOWN)
	await key(KEY_ENTER)
	check(hud.pause_menu.current_id == "settings" and get_tree().paused, "Pause Settings stays paused")
	await key(KEY_ESCAPE)
	check(hud.pause_menu.current_id == "menu" and get_tree().paused, "Submenu Escape returns to Pause")
	sync(hud.pause_menu.current, 1, "Pause restores Settings focus")
	await key(KEY_DOWN)
	await key(KEY_ENTER)
	check(hud.pause_menu.current_id == "rules" and get_tree().paused, "Pause Rules stays paused")
	await key(KEY_RIGHT)
	await key(KEY_ESCAPE)
	check(hud.pause_menu.current_id == "rules" and get_tree().paused, "Controls returns to paused Rules")
	await key(KEY_ESCAPE)
	await capture("pause")
	await key(KEY_ESCAPE)
	check(not get_tree().paused and GameManager.state == GameManager.State.PLAYING, "Pause Escape resumes")
	var position := player.position
	hud.show_letter("Letter XIII", "The house remembers every name.\n\n".repeat(60))
	Input.action_press("move_right")
	await frames(10)
	check(player.position == position and get_tree().paused, "Letter blocks movement")
	Input.action_release("move_right")
	await key(KEY_DOWN)
	check(hud.reader.scroll.scroll_vertical > 0, "Long letter scrolls")
	await capture("letter")
	await key(KEY_E)
	check(not hud.reader.visible and not get_tree().paused, "E closes letter")
	# Hold the polling action across dismissal, as a real E key does.
	var nearby: BaseInteractable = preload("res://scenes/interactables/item_pickup.tscn").instantiate()
	nearby.interaction_id = "ui_leak_probe"
	nearby.item_id = "bottle"
	nearby.position = player.position
	main.add_child(nearby)
	hud.show_letter("Vantree", "A sealed note.")
	Input.action_press("interact")
	hud.close_modal()
	player._physics_process(1.0 / 60.0)
	check(not FreedomLedger.flags.get("ui_leak_probe", false), "Dismissal press cannot activate nearby pickup")
	Input.action_release("interact")
	nearby.queue_free()
	await frames(3)
	hud.show_message("ELS", "The lock remembers me.")
	await capture("speech")
	await key(KEY_ENTER)
	check(not hud.acknowledged_message and not get_tree().paused, "Acknowledged speech closes")
	hud.show_message("ELS", "The house remembers every name. ".repeat(70))
	await frames()
	await key(KEY_E)
	check(hud.acknowledged_message and hud.bubble.page_index == 1, "Long speech advances without overflowing or closing early")
	await key(KEY_ESCAPE)
	SessionSettings.screen_shake = false
	var camera: Camera2D = player.get_node("Camera2D")
	camera.add_trauma(1.0)
	await frames()
	check(camera.offset == Vector2.ZERO, "Screen shake affects actual camera")
	SessionSettings.screen_shake = true
	EventBus.player_caught.emit()
	var deadline := Time.get_ticks_msec() + 5000
	while not hud.game_over.visible and Time.get_ticks_msec() < deadline:
		await frames()
	check(hud.game_over.visible and get_tree().paused, "Capture opens Game Over")
	sync(hud.game_over, 0, "Game Over initial Retry")
	await key(KEY_DOWN)
	sync(hud.game_over, 1, "Game Over Main Menu highlight")
	await capture("game_over")
	await key(KEY_UP)
	await key(KEY_ENTER)
	deadline = Time.get_ticks_msec() + 5000
	while (not is_instance_valid(main) or get_tree().current_scene == main or GameManager.state != GameManager.State.PLAYING) and Time.get_ticks_msec() < deadline:
		await frames()
	main = get_tree().current_scene
	check(main != null and GameManager.state == GameManager.State.PLAYING and not get_tree().paused, "Retry restores checkpoint")
	hud = main.get_node("UI")
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.set_physics_process(false)
	GameManager.ending = "untouched"
	GameManager.state = GameManager.State.ENDING
	await frames()
	check(hud.reader.visible, "Ending narrative preserved on parchment")
	await key(KEY_ENTER)
	check(hud.chapter_complete.visible and get_tree().paused, "Chapter Complete displayed")
	await key(KEY_DOWN)
	sync(hud.chapter_complete, 1, "Chapter Main Menu state")
	await capture("chapter")
	await key(KEY_UP)
	await key(KEY_ENTER)
	await frames(15)
	check(GameManager.zone == "roots" and not get_tree().paused, "Continue uses existing Part II progression")
	main = get_tree().current_scene
	hud = main.get_node("UI")
	GameManager.ending = "severance"
	GameManager.state = GameManager.State.ENDING
	await frames()
	await key(KEY_ENTER)
	await key(KEY_DOWN)
	await key(KEY_ENTER)
	await frames(5)
	check(GameManager.state == GameManager.State.MENU and not get_tree().paused, "Result Main Menu clears pause and game state")
	frontend = get_tree().current_scene
	await pointer(frontend.current, 0, true)
	deadline = Time.get_ticks_msec() + 12000
	while GameManager.zone != "intro" or get_tree().current_scene == null or get_tree().current_scene.scene_file_path != "res://scenes/main/main.tscn":
		if Time.get_ticks_msec() > deadline:
			check(false, "Start loading timed out")
			get_tree().quit(1)
			return
		await frames()
	check(GameManager.zone == "intro", "Start click enters existing Awakening flow")
	main = get_tree().current_scene
	hud = main.get_node("UI")
	await key(KEY_ESCAPE)
	await pointer(hud.pause_menu.current, 3, true)
	await frames(5)
	check(GameManager.state == GameManager.State.MENU and not get_tree().paused, "Pause Main Menu cleans up safely")
	print("IMAGE UI CHECK: %d checks, %d failures" % [checks, failures.size()])
	get_tree().quit(0 if failures.is_empty() else 1)
