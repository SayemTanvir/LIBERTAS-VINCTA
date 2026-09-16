extends Node
var checks := 0
var failures := 0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	preload("res://tests/settings_fixture.gd").isolate()
	GameManager.save_path = "res://build/final_polish_save.json"
	AudioServer.set_bus_mute(0, true)
	_run.call_deferred()

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error(message)

func frames(count := 3) -> void:
	for _i in count:
		await get_tree().process_frame

func capture(label: String) -> void:
	if DisplayServer.get_name() == "headless":
		return
	await get_tree().create_timer(0.12, true).timeout
	await RenderingServer.frame_post_draw
	check(get_viewport().get_texture().get_image().save_png("res://build/final_polish_" + label + ".png") == OK, "Capture " + label)

func inspect(page: Control, label: String) -> void:
	# Observe emitted destinations without navigating or toggling display mid-matrix.
	var actions: Array = page.selected.get_connections()
	for action in actions:
		page.selected.disconnect(action.callable)
	var screen := Rect2(Vector2.ZERO, page.size)
	check(page.artwork.get_global_rect().grow(1).encloses(screen), label + " background covers viewport")
	for i in page.buttons.size():
		var button: Button = page.buttons[i]
		check(screen.grow(1).encloses(button.get_global_rect()), label + " hitbox is fully visible")
		var transform := button.get_global_transform()
		check(is_equal_approx(transform.get_scale().x, transform.get_scale().y), label + " uniform scaling")
		var point := transform * (button.size * 0.5)
		check(button.get_rect().has_point(button.get_parent().get_global_transform().affine_inverse() * point), label + " hitbox maps to artwork")
		page.set_selection(i, false)
		check(page.current_index == i and button.has_focus(), label + " focus and selection agree")
		var selected: Array[String] = []
		var listener := func(id: String): selected.append(id)
		page.selected.connect(listener)
		page.activate_selection()
		check(selected == [str(page.entries[i].id)], label + " correct selected action")
		page.selected.disconnect(listener)
	for action in actions:
		page.selected.connect(action.callable, action.flags)

func _run() -> void:
	var cinematic = preload("res://scripts/intro/estate_cinematic.gd").new()
	add_child(cinematic)
	cinematic.set_process(false)
	for item in cinematic.captions:
		check(not item.node.text.replace(" ", "").to_lower().contains("prologue"), "No prologue caption remains")
	check(cinematic.DURATION == 22.4, "Intro duration unchanged")
	cinematic.queue_free()
	await frames()
	for resolution in [Vector2i(1280, 720), Vector2i(1366, 768), Vector2i(1600, 900), Vector2i(1920, 1080)]:
		get_window().size = resolution
		await frames()
		for id in ["main_menu", "settings_page", "rules_page", "controls_page", "credits_page", "pause_page", "game_over", "chapter_complete"]:
			var page: Control = load("res://scenes/ui/" + id + ".tscn").instantiate()
			add_child(page)
			page.focus_default()
			await frames()
			inspect(page, id + str(resolution))
			if id in ["main_menu", "settings_page"]:
				page.set_selection(0, false)
				await get_tree().create_timer(0.5).timeout
				await capture(id + "_" + str(resolution.x))
			page.queue_free()
			await frames()
	if DisplayServer.get_name() != "headless":
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		await frames(10)
		check(DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN, "Real fullscreen entered")
		for id in ["main_menu", "settings_page", "rules_page", "controls_page", "credits_page", "pause_page", "game_over", "chapter_complete"]:
			var page: Control = load("res://scenes/ui/" + id + ".tscn").instantiate()
			add_child(page)
			page.focus_default()
			await frames()
			inspect(page, "fullscreen " + id)
			if id == "main_menu":
				page.set_selection(0, false)
				await get_tree().create_timer(0.5).timeout
				await capture("fullscreen_menu")
			page.queue_free()
			await frames()
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	get_window().size = Vector2i(1280, 720)
	await frames()
	FreedomLedger.reset()
	# A checkpoint from the former static clue must still allow the new assembly.
	FreedomLedger.flags["scratched_nameplate"] = true
	GameManager.zone = "ground"
	GameManager.entry = "start"
	GameManager.arrival_pending = false
	GameManager.respawn_pending = false
	GameManager.state = GameManager.State.PLAYING
	var main: Node2D = preload("res://scenes/main/main.tscn").instantiate()
	add_child(main)
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.set_physics_process(false)
	var player: CharacterBody2D = main.get_node("Entities/Player")
	var hud = main.get_node("UI")
	var plate: BaseInteractable = main.room.props.get_node("ScratchedNameplate")
	var fragments = plate.get_node("NameplateFragments")
	player.position = plate.position + Vector2(0, 28)
	player.get_node("Camera2D").snap_to_player()
	await frames(5)
	player._find_interactable()
	check(player.target_interactable == plate, "Nameplate reachable through normal targeting")
	check(fragments.fragments.size() == 3, "Three visible fragments before collection")
	check(plate.available() and fragments.fragments.all(func(piece: Sprite2D): return piece.visible), "Old inspection-only save allows first assembly")
	await capture("fragments_before")
	# A damage interruption during the initial reach must not consume anything.
	plate.interact(player)
	EventBus.player_hurt.emit(1.0)
	await get_tree().create_timer(0.65).timeout
	check(not plate.busy and plate.available() and player.control_enabled, "Interrupted reach is recoverable")
	check(not FreedomLedger.flags.get("nameplate_assembled", false), "Interrupted reach does not commit state")
	plate.interact(player)
	await get_tree().create_timer(0.7, true).timeout
	check(get_tree().paused and GameManager.state == GameManager.State.READING, "Assembly pauses the world")
	check(not hud.reader.visible and is_instance_valid(fragments.overlay), "Assembly precedes reading")
	var still_position := player.position
	plate.interact(player)
	check(plate.busy, "Repeated interaction cannot restart assembly")
	await capture("fragments_gathering")
	await get_tree().create_timer(1.05, true).timeout
	await capture("fragments_joined")
	await get_tree().create_timer(1.1, true).timeout
	check(hud.reader.visible and get_tree().paused, "Assembly opens existing paused document reader")
	check(player.position == still_position, "Player does not drift during assembly")
	check(FreedomLedger.flags.get("nameplate_assembled", false) and not plate.available(), "Assembly commits once")
	check(FreedomLedger.letters_found == 0, "Nameplate does not alter four-letter route requirement")
	for piece in fragments.fragments:
		check(not piece.visible, "Gathered floor piece disappears")
	check(hud.reader.document.full_text.contains("VANTREE"), "Reconstructed surname matches Els")
	await capture("nameplate_document")
	var saved: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(GameManager.save_path))
	check(saved.ledger.flags.get("nameplate_assembled", false), "Collected state persisted in checkpoint file")
	hud.close_modal()
	await frames()
	check(GameManager.state == GameManager.State.PLAYING and not get_tree().paused, "Close returns cleanly to gameplay")
	var restored_plate: BaseInteractable = preload("res://scenes/interactables/lore.tscn").instantiate()
	restored_plate.interaction_id = "scratched_nameplate"
	FreedomLedger.restore_snapshot(saved.ledger)
	add_child(restored_plate)
	check(not restored_plate.available(), "Restored checkpoint prevents recollection")
	for piece in restored_plate.get_node("NameplateFragments").fragments:
		check(not piece.visible, "Restored floor pieces stay consumed")
	restored_plate.queue_free()
	var note = main.room.props.get_node("TheNote")
	note.interact(player)
	check(hud.reader.visible and hud.reader.document.title_label.text == "The Foyer Note", "Foyer note uses document reader")
	hud.close_modal()
	var layout: Dictionary = preload("res://data/estate_layout.json").data
	var letter_count := 0
	for zone in layout:
		for prop in layout[zone].props:
			if prop[0] != "letter_pickup":
				continue
			letter_count += 1
			hud.show_letter(prop[4].title, prop[4].text)
			await frames()
			check(hud.reader.document.full_text == prop[4].text, "Complete letter body retained " + prop[1])
			check(hud.reader.document.content.size.x <= hud.reader.document.TEXT_WIDTH, "Letter wraps within reading area " + prop[1])
			check(not prop[4].title.begins_with("Vantree"), "Letter title does not assume family archive " + prop[1])
			hud.close_modal()
	check(letter_count == 13, "All thirteen letters reviewed and rendered")
	hud.show_letter("Long document", "A long account of the estate.\n\n".repeat(100))
	await frames()
	check(hud.reader.document.pages.size() > 1, "Long letters paginate")
	hud.close_modal()
	hud.subtitle_queue.clear()
	hud.active_message.dismiss()
	for _i in 8:
		hud.enqueue_subtitle("ELS", "The lock is still sealed.", 2.0)
	check(hud.subtitle_queue.size() == 1, "Repeated comments queue once")
	var camera = player.get_node("Camera2D")
	SessionSettings.set_screen_shake(false)
	camera.add_trauma(1.0)
	camera._process(0.016)
	check(camera.offset == Vector2.ZERO, "Disabled screen shake suppresses actual camera offset")
	SessionSettings.set_screen_shake(true)
	camera.add_trauma(1.0)
	camera._process(0.016)
	check(camera.offset.length() > 0.0, "Enabled screen shake retains existing behavior")
	main.queue_free()
	await frames()
	print("FINAL POLISH: %d checks, %d failures" % [checks, failures])
	get_tree().quit(0 if failures == 0 else 1)
