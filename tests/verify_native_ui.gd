extends Node
## Rendered layout, pointer-drag, reading, and contextual outcome coverage.
var checks := 0
var failures: Array[String] = []
var captures := 0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	GameManager.save_path = "res://build/native_ui_test_save.json"
	AudioServer.set_bus_mute(0, true)
	get_tree().root.notification(MainLoop.NOTIFICATION_APPLICATION_FOCUS_IN)
	get_tree().root.notification(Node.NOTIFICATION_WM_MOUSE_ENTER)
	_run.call_deferred()

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures.append(message)
		push_error(message)

func frames(count: int = 3) -> void:
	for _i in count:
		await get_tree().process_frame

func capture(label: String) -> void:
	if DisplayServer.get_name() == "headless":
		return
	await get_tree().create_timer(0.22).timeout
	await RenderingServer.frame_post_draw
	check(get_viewport().get_texture().get_image().save_png("res://build/native_ui_" + label + ".png") == OK, "Capture " + label)
	captures += 1

func inspect_page(page: Control, label: String) -> void:
	var screen := Rect2(Vector2.ZERO, get_viewport().get_visible_rect().size)
	for button in page.buttons:
		check(screen.grow(1).encloses(button.get_global_rect()), label + " action fits: " + button.text)
		check(button.size.y * page.design.scale.y >= 30, label + " usable action height")
	for node in page.design.find_children("*", "Label", true, false):
		var text: Label = node
		check(screen.grow(1).encloses(text.get_global_rect()), label + " label fits: " + text.text.left(32))
		check(text.size.y + 1 >= text.get_minimum_size().y, label + " text height fits")
		check(not "?" in text.text, label + " no lost text glyphs")

func pointer(control: Control, point: Vector2, pressed: bool, move_only: bool = false) -> void:
	var position := control.get_global_transform() * point
	var motion := InputEventMouseMotion.new()
	motion.position = position
	motion.global_position = position
	motion.relative = Vector2(1, 0)
	motion.button_mask = MOUSE_BUTTON_MASK_LEFT if pressed else 0
	get_viewport().push_input(motion, true)
	if not move_only:
		var event := InputEventMouseButton.new()
		event.position = position
		event.global_position = position
		event.button_index = MOUSE_BUTTON_LEFT
		event.pressed = pressed
		get_viewport().push_input(event, true)
	await frames()

func _run() -> void:
	var frontend: Control = preload("res://scenes/ui/front_end.tscn").instantiate()
	add_child(frontend)
	await frames()
	for resolution in [Vector2i(1280, 720), Vector2i(1024, 768), Vector2i(1920, 1080), Vector2i(2560, 1080), Vector2i(800, 600)]:
		get_tree().root.size = resolution
		await frames()
		for id in ["settings", "rules", "controls", "credits"]:
			frontend.navigate(id)
			await frames()
			inspect_page(frontend.current, id + " " + str(resolution))
			if resolution in [Vector2i(1280, 720), Vector2i(800, 600)]:
				await capture(id + "_" + str(resolution.x))
			frontend.back()
	get_tree().root.size = Vector2i(1280, 720)
	frontend.navigate("settings")
	await frames()
	var settings: Control = frontend.current
	await pointer(settings.buttons[0], Vector2(228, 26), true)
	await pointer(settings.buttons[0], Vector2(324, 26), true, true)
	check(is_equal_approx(SessionSettings.volumes.Master, 0.5), "Dragging changes live volume midway")
	await pointer(settings.buttons[0], Vector2(420, 26), true, true)
	await pointer(settings.buttons[0], Vector2(420, 26), false)
	check(is_equal_approx(SessionSettings.volumes.Master, 1.0), "Drag reaches full volume and releases")
	var ambience: float = SessionSettings.volumes.Ambience
	settings.adjust(6, -1)
	check(is_equal_approx(SessionSettings.volumes.Ambience, ambience - 0.05), "Ambience has an independent control")
	settings.adjust(6, 1)
	await pointer(settings.buttons[7], settings.buttons[7].size * 0.5, true)
	await pointer(settings.buttons[7], settings.buttons[7].size * 0.5, false)
	check(not SessionSettings.subtitles_enabled, "Pointer toggles subtitles exactly once")
	settings.adjust(7, 1)
	frontend.back()
	frontend.navigate("rules")
	await frames()
	await pointer(frontend.current.buttons[1], Vector2(100, 23), true)
	await pointer(frontend.current.buttons[1], Vector2(100, 23), false)
	check(frontend.current_id == "controls", "Visible Controls button opens companion page")
	frontend.queue_free()
	await frames()
	for name in ["pause_page", "game_over", "chapter_complete"]:
		var page: Control = load("res://scenes/ui/" + name + ".tscn").instantiate()
		add_child(page)
		GameManager.ending = "untouched"
		page.focus_default()
		await frames()
		inspect_page(page, name)
		await capture(name)
		if name == "chapter_complete":
			check(page.buttons[0].text.contains("Part II"), "Part I outcome explains next chapter")
			GameManager.ending = "severance"
			page.focus_default()
			check(page.buttons[0].text.contains("Begin again"), "Final outcome describes restart accurately")
			await capture("final_outcome")
		page.queue_free()
		await frames()
	var reader: Control = preload("res://scenes/ui/letter_reader.tscn").instantiate()
	add_child(reader)
	reader.open("Els' Field Guide", preload("res://scripts/systems/field_guide.gd").guide_text())
	await frames()
	check(reader.scroll.get_v_scroll_bar().max_value > reader.scroll.size.y, "Field guide scrolls")
	check(reader.scroll.get_v_scroll_bar().visible and reader.scroll.get_v_scroll_bar().size.x >= 5, "Long reading has a visible scrollbar")
	check(reader.content.text.contains("WASD"), "Full guide text retained")
	await capture("field_guide")
	FreedomLedger.collect_item("bottle", 3)
	reader.open("Inventory", "Inventory")
	await frames()
	check(reader.inventory_grid.visible and not reader.scroll.visible, "Inventory has its own item view")
	check(reader.item_counts.bottle.text == "3", "Inventory uses actual ledger quantities")
	for icon in reader.inventory_grid.find_children("*", "TextureRect", true, false):
		check(icon.size.x <= 64 and icon.size.y <= 72, "Inventory icons retain compact dimensions")
		check(icon.get_parent().get_global_rect().encloses(icon.get_global_rect()), "Inventory art stays inside its card")
	for paper in reader.design.find_children("*", "TextureRect", true, false):
		# Hidden ScrollContainer fade masks are engine internals, not inventory art.
		if not paper.is_visible_in_tree():
			continue
		check(reader.design.get_global_rect().encloses(paper.get_global_rect()), "Reading texture stays within modal: %s %s in %s" % [paper.get_path(), paper.get_global_rect(), reader.design.get_global_rect()])
	await capture("inventory")
	var closed := [false]
	reader.close_requested.connect(func(): closed[0] = true)
	await pointer(reader.close_button, Vector2(70, 22), true)
	await pointer(reader.close_button, Vector2(70, 22), false)
	check(closed[0], "Mouse Close works without keyboard")
	reader.queue_free()
	await frames()
	FreedomLedger.reset()
	GameManager.zone = "echoes"
	FreedomLedger.restore_sense("hearing")
	FreedomLedger.begin_part_two("vantree")
	GameManager.state = GameManager.State.PLAYING
	GameManager.arrival_pending = false
	GameManager.respawn_pending = false
	var main: Node2D = preload("res://scenes/main/main.tscn").instantiate()
	add_child(main)
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.set_physics_process(false)
	var hud: CanvasLayer = main.get_node("UI")
	var player: CharacterBody2D = main.get_node("Entities/Player")
	player.position = Vector2(1780, 520)
	player.get_node("Camera2D").snap_to_player()
	for resolution in [Vector2i(1280, 720), Vector2i(800, 600)]:
		get_tree().root.size = resolution
		await frames(5)
		check(not hud.objective_label.get_global_rect().intersects(hud.ability_label.get_global_rect()), "Objective and ability text do not overlap " + str(resolution))
		check(hud.root.get_global_rect().encloses(hud.ability_label.get_global_rect()), "Ability text stays inside screen")
		check(hud.survival_panel.health_bar.size.y <= 8, "Health meter stays slim")
		await capture("hud_" + str(resolution.x))
	get_tree().root.size = Vector2i(1280, 720)
	hud._present_message("NARRATOR", "The house remembers every name.")
	hud.subtitle_time = 20.0
	hud._anchor_progress("LN-A", 5, 20)
	await frames()
	check(not hud.narration.design.get_global_rect().intersects(hud.anchor_status.get_global_rect()), "Narration and ritual text remain separated")
	await capture("narration_and_progress")
	main.queue_free()
	await frames()
	GameManager.ending = ""
	if DisplayServer.get_name() != "headless":
		var loading: Control = preload("res://scenes/ui/loading_screen.tscn").instantiate()
		loading.display_seconds = 15
		add_child(loading)
		await capture("loading")
		loading.queue_free()
		await frames()
	print("NATIVE UI: %d checks, %d failures, %d rendered captures" % [checks, failures.size(), captures])
	get_tree().quit(0 if failures.is_empty() else 1)
