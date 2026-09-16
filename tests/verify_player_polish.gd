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
	FreedomLedger.flags["flashlight"] = true
	FreedomLedger.set_flashlight_seconds(0)
	check(FreedomLedger.recharge_from_batteries(45) == 0, "No free charging")
	FreedomLedger.collect_item("battery", 2)
	check(FreedomLedger.battery_percentages() == [100.0, 100.0], "Every pickup gets its own full cell")
	FreedomLedger.recharge_from_batteries(22.5)
	check(FreedomLedger.battery_percentages() == [50.0, 100.0], "Partial charge retained on individual cell")
	var saved := FreedomLedger.snapshot()
	FreedomLedger.reset()
	FreedomLedger.restore_snapshot(JSON.parse_string(JSON.stringify(saved)))
	check(FreedomLedger.battery_percentages() == [50.0, 100.0], "Per-cell percentage survives serialized checkpoint")
	FreedomLedger.recharge_from_batteries(22.5)
	check(FreedomLedger.battery_percentages() == [100.0], "Empty cell disappears")
	FreedomLedger.set_flashlight_seconds(85)
	FreedomLedger.recharge_from_batteries(45)
	check(is_equal_approx(FreedomLedger.battery_percentages()[0], 88.88889), "Full torch preserves unused cell energy")
	saved.erase("battery_charges")
	FreedomLedger.restore_snapshot(saved)
	check(FreedomLedger.battery_percentages() == [100.0, 100.0], "Legacy count-only save migrates")
	saved.battery_charges = [-5.0]
	check(not FreedomLedger.snapshot_is_valid(saved), "Invalid charge rejected")
	GameManager.zone = "ground"
	GameManager.state = GameManager.State.PLAYING
	GameManager.save_path = "res://build/player_polish_save.json"
	var main := preload("res://scenes/main/main.tscn").instantiate()
	add_child(main)
	await get_tree().process_frame
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.set_physics_process(false)
	var player = main.get_node("Entities/Player")
	var piano = main.room.props.get_node("PianoSeal")
	var hud = main.get_node("UI")
	FreedomLedger.collect_item("lockpick", 2)
	player.position = piano.position + Vector2(0, 35)
	player.set_flashlight(false, false)
	await get_tree().physics_frame
	var before: Vector2 = player.position
	piano.interact(player)
	await get_tree().physics_frame
	check(player.position.distance_to(before) < 10.0, "Piano approach never teleports")
	var timeout := 5.0
	var performance: Node
	while timeout > 0:
		await get_tree().process_frame
		timeout -= get_process_delta_time()
		for child in main.room.props.get_children():
			if child.get_script() == preload("res://scripts/interactables/piano_performance.gd"):
				performance = child
		if is_instance_valid(performance) and performance.stage == "play":
			break
	check(is_instance_valid(performance) and performance.stage == "play", "Els reaches seated playing state")
	if is_instance_valid(performance):
		check(performance.sound != null and performance.sound.playing, "Piano sound accompanies playing")
		check(not player.visual.visible and performance.strips.size() == 3, "Seated rig replaces standing pose")
		if DisplayServer.get_name() != "headless":
			await RenderingServer.frame_post_draw
			get_viewport().get_texture().get_image().save_png("res://build/piano_seated.png")
	while piano.busy:
		await get_tree().process_frame
	check(piano.progress == 1 and player.control_enabled and player.visual.visible, "Piano finishes and restores control")
	player._find_interactable()
	check(player.target_interactable == piano, "Next piano step reachable from same position")
	piano.interact(player)
	await get_tree().create_timer(0.7).timeout
	FreedomLedger.damage(1.0)
	while piano.busy:
		await get_tree().process_frame
	check(piano.progress == 1 and player.visual.visible and player.control_enabled, "Damage cancels seated performance and restores actor")
	await piano.interact(player)
	await piano.interact(player)
	check(FreedomLedger.flags.get("piano_seal", false), "All three steps complete")
	check(FreedomLedger.inventory.lockpick == 1, "Piano consumes exactly one lockpick")
	var station: Node
	for prop in main.room.props.get_children():
		if prop is BaseInteractable and prop.kind == "recharge":
			station = prop
			break
	FreedomLedger.inventory.battery = 0
	FreedomLedger.set_flashlight_seconds(0)
	await station.interact(player)
	check(FreedomLedger.flashlight_seconds == 0 and player.control_enabled, "Station refuses battery-free charge")
	FreedomLedger.collect_item("battery")
	station.interact(player)
	await get_tree().create_timer(0.3).timeout
	station.interrupt_serial += 1
	await get_tree().physics_frame
	await get_tree().physics_frame
	check(FreedomLedger.flashlight_seconds > 0 and FreedomLedger.battery_percentages()[0] < 100.0, "Station drains stored cell")
	check(player.control_enabled, "Interrupted station releases control")
	check(hud.survival_panel.PANEL_SIZE == Vector2(480,159), "HUD footprint reduced without distorting plate")
	hud.show_letter("Inventory", "")
	check("Battery 1:" in hud.reader.battery_list.text, "Bag shows individual percentages")
	FreedomLedger.flags["vantree_memory_fragment_A"] = true
	hud.reader.open("Inventory", "")
	hud.reader.memory_button.grab_focus()
	var enter := InputEventAction.new()
	enter.action = "ui_accept"
	enter.pressed = true
	hud.reader._input(enter)
	check(hud.reader.document.visible and hud.reader.document.full_text == preload("res://scripts/systems/memory_fragment.gd").TEXT, "Memory fragment rereads with keyboard")
	hud.reader.open("Inventory", "")
	if DisplayServer.get_name() != "headless":
		await get_tree().create_timer(0.3, true).timeout
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png("res://build/battery_bag.png")
	FreedomLedger.collect_item("battery", 20)
	hud.reader.open("Inventory", "")
	await get_tree().process_frame
	await get_tree().process_frame
	var wheel := InputEventMouseButton.new()
	wheel.button_index = MOUSE_BUTTON_WHEEL_DOWN
	wheel.pressed = true
	hud.reader._input(wheel)
	check(hud.reader.battery_list.get_v_scroll_bar().value > 0, "Long battery list scrolls in inventory")
	hud.close_modal()
	print("PLAYER POLISH: %d checks, %d failures" % [checks, failures])
	get_tree().quit(0 if failures == 0 else 1)
