extends Node
## Live ledger, checkpoint resync, pause, responsive bounds and rendered reference QA.
var checks := 0
var failures: Array[String] = []

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	AudioServer.set_bus_mute(0, true)
	GameManager.save_path = "res://build/reference_hud_test_save.json"
	_run.call_deferred()

func check(ok: bool, description: String) -> void:
	checks += 1
	if not ok:
		failures.append(description)
		push_error(description)

func frames(count := 3) -> void:
	for i in count:
		await get_tree().process_frame

func capture(label: String) -> void:
	if DisplayServer.get_name() == "headless":
		return
	await frames(5)
	await RenderingServer.frame_post_draw
	check(get_viewport().get_texture().get_image().save_png("res://build/reference_" + label + ".png") == OK, "Capture " + label)

func _run() -> void:
	FreedomLedger.reset()
	GameManager.state = GameManager.State.PLAYING
	GameManager.zone = "ground"
	var panel := preload("res://scripts/ui/survival_panel.gd").new()
	add_child(panel)
	check(panel.health_bar.value == 100 and panel.charge_bar.value == 100, "Fresh HUD starts full, without a false empty animation")
	FreedomLedger.damage(30)
	FreedomLedger.set_flashlight_seconds(62.1)
	panel.update_values(0.05)
	check(panel.health_value.text == "70 / 100" and panel.charge_value.text == "69%", "Exact live numbers update before smoothed meter movement")
	check(panel.health_bar.value > 70 and panel.health_bar.value < 100, "Damage animates rather than snapping")
	check(panel.health_trail.value > panel.health_bar.value, "Delayed trail shows damage amount")
	for i in 120:
		panel.update_values(1.0 / 60.0)
	check(is_equal_approx(panel.charge_bar.value, 69.0), "Fractional interpolation reaches exact charge percentage")
	check(is_equal_approx(panel.health_bar.value, 70.0), "Health meter settles exactly")
	FreedomLedger.collect_item("lockpick", 3)
	FreedomLedger.collect_item("battery", 2)
	panel.update_values(0.1)
	check(panel.item_values.lockpick.text == "3" and panel.item_values.battery.text == "2", "Real inventory acquisitions update individual counters")
	check(panel.item_pulses.battery > 0, "Pickup highlights animate")
	FreedomLedger.consume_item("battery")
	panel.update_values(0.1)
	check(panel.item_values.battery.text == "1", "Consumption updates counter")
	FreedomLedger.set_flashlight_seconds(80)
	panel.update_values(0.1)
	check(panel.charging_glow > 0, "Recharge creates moving meter highlight")
	get_tree().paused = true
	var clock := panel.visual_clock
	var charge := panel.charge_bar.value
	panel.update_values(3.0)
	check(panel.visual_clock == clock and panel.charge_bar.value == charge, "Pause freezes progress presentation")
	get_tree().paused = false
	FreedomLedger.restore_sense("hearing")
	FreedomLedger.begin_part_two("vantree")
	panel.hide()
	panel.update_values(0)
	panel.show()
	check(panel.health_value.text == "80 / 80" and panel.health_bar.value == 100, "Branch maximum and hidden checkpoint resync use the real ledger")
	FreedomLedger.hp = 0
	FreedomLedger.set_flashlight_seconds(0)
	for i in 100:
		panel.update_values(0.1)
	check(panel.health_bar.value == 0 and panel.charge_bar.value == 0, "Empty meters reach zero")
	panel.queue_free()
	await frames()
	FreedomLedger.reset()
	FreedomLedger.flags.flashlight = true
	FreedomLedger.collect_item("lockpick", 3)
	FreedomLedger.set_flashlight_seconds(62.1)
	GameManager.state = GameManager.State.PLAYING
	GameManager.zone = "ground"
	GameManager.entry = "start"
	GameManager.arrival_pending = false
	GameManager.respawn_pending = false
	var main := preload("res://scenes/main/main.tscn").instantiate()
	add_child(main)
	var player: CharacterBody2D = main.get_node("Entities/Player")
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.set_physics_process(false)
	var hud: CanvasLayer = main.get_node("UI")
	for resolution in [Vector2i(1280, 720), Vector2i(800, 600), Vector2i(1920, 1080), Vector2i(2560, 1080)]:
		get_tree().root.size = resolution
		await frames(8)
		check(hud.root.get_global_rect().encloses(hud.survival_panel.get_global_rect()), "Panel fits " + str(resolution))
		for child in hud.survival_panel.get_children():
			if child is Label:
				check(hud.survival_panel.get_global_rect().encloses(child.get_global_rect()), "Label fits plate: " + child.text)
		if resolution == Vector2i(1280, 720):
			await capture("hud_1280")
		FreedomLedger.current_part = 2
		FreedomLedger.part2_seed = {"blood_magic": true}
		await frames()
		check(not hud.survival_panel.get_global_rect().intersects(hud.objective_label.get_global_rect()), "Objective clears large panel " + str(resolution))
		check(not hud.objective_label.get_global_rect().intersects(hud.ability_label.get_global_rect()), "Objective and ability remain separate")
		check(hud.root.get_global_rect().encloses(hud.ability_label.get_global_rect()), "Ability remains visible")
		if resolution == Vector2i(800, 600):
			await capture("hud_800")
		FreedomLedger.current_part = 1
	get_tree().root.size = Vector2i(1280, 720)
	FreedomLedger.hp = 20
	FreedomLedger.flashlight_seconds = 12
	await get_tree().create_timer(0.8).timeout
	await capture("hud_low")
	main.queue_free()
	await frames()
	var menu := preload("res://scenes/ui/front_end.tscn").instantiate()
	add_child(menu)
	await frames(15)
	var found := 0
	for label in menu.find_children("*", "Label", true, false):
		if label.text in ["LIBERTAS", "VINCTA"]:
			var font: Font = label.get_theme_font("font")
			check(font is FontVariation and font.base_font.resource_path.ends_with("horroroid.ttf"), "Main title uses supplied Horroroid")
			found += 1
	check(found == 2, "Both title lines use supplied font")
	await capture("horroroid_menu")
	menu.queue_free()
	await frames()
	var intro := preload("res://scripts/intro/estate_cinematic.gd").new()
	add_child(intro)
	intro.set_process(false)
	intro.elapsed = 15.0
	intro._update_presentation()
	var title: Label = intro.stage.get_node("HorroroidTitle")
	check(title.get_theme_font("font").resource_path.ends_with("horroroid.ttf"), "Opening cinematic uses supplied font")
	check(title.get_minimum_size().x <= 565, "Intro title fits its composition")
	await capture("horroroid_intro")
	intro.queue_free()
	await frames()
	print("REFERENCE HUD: %d checks, %d failures" % [checks, failures.size()])
	get_tree().quit(0 if failures.is_empty() else 1)
