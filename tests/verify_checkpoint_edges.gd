extends Node
var checks := 0
var failures := 0

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error(message)

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().current_scene = null
	AudioServer.set_bus_mute(0, true)
	GameManager.save_path = "res://build/checkpoint_edges_save.json"
	_run.call_deferred()

func _run() -> void:
	FreedomLedger.reset()
	FreedomLedger.inventory.battery = 2
	check(not FreedomLedger.consume_item("battery", -1) and FreedomLedger.inventory.battery == 2, "Negative consumption cannot create inventory")
	FreedomLedger.damage(-20)
	check(FreedomLedger.hp == FreedomLedger.max_hp, "Negative damage cannot heal above cap")
	var snapshot: Dictionary = FreedomLedger.snapshot()
	snapshot.inventory = {"battery": -5}
	snapshot.flashlight_seconds = 900
	snapshot.hp = 999
	snapshot.entity_stage = 3
	FreedomLedger.restore_snapshot(snapshot)
	check(FreedomLedger.inventory.battery == 0, "Negative loaded inventory clamps to zero")
	check(FreedomLedger.flashlight_seconds == 90 and FreedomLedger.hp == FreedomLedger.max_hp, "Loaded health/charge respect caps")
	check(FreedomLedger.entity_stage == 0, "Stage derives from restored keys")
	FreedomLedger.reset()
	FreedomLedger.flags.intro_complete = true
	FreedomLedger.flags.flashlight = true
	GameManager.zone = "ground"
	GameManager.state = GameManager.State.PLAYING
	var saved_position := Vector2(1850, 500)
	GameManager.save_checkpoint(saved_position)
	check(GameManager.checkpoint_is_valid(JSON.parse_string(FileAccess.get_file_as_string(GameManager.save_path))), "Serialized JSON round trip remains a valid checkpoint")
	GameManager.go_home()
	await get_tree().process_frame
	await get_tree().process_frame
	GameManager.continue_game()
	var deadline := Time.get_ticks_msec() + 20000
	while Time.get_ticks_msec() < deadline:
		await get_tree().process_frame
		var scene := get_tree().current_scene
		if scene != null and scene.scene_file_path == "res://scenes/main/main.tscn":
			break
	var main := get_tree().current_scene
	check(main != null and main.scene_file_path == "res://scenes/main/main.tscn", "Continue reaches Main")
	if main != null and main.has_node("Entities/Player"):
		var player: Node2D = main.get_node("Entities/Player")
		check(player.position.distance_to(saved_position) < 1.0, "Continue restores exact checkpoint position")
		check(GameManager.checkpoint.position.distance_to(saved_position) < 1.0, "Continue does not overwrite saved location with entrance")
		var lines: Array[String] = []
		var listener := func(_speaker: String, line: String, _seconds: float): lines.append(line)
		EventBus.subtitle_requested.connect(listener)
		check(not player.use_gadget(), "Empty gadget action fails without spending")
		check(not lines.is_empty(), "Empty gadget action explains what happened")
		EventBus.subtitle_requested.disconnect(listener)
	GameManager._trigger_loop()
	GameManager.go_home()
	await get_tree().create_timer(0.6, true).timeout
	check(GameManager.state == GameManager.State.MENU, "Home cancels pending Loop callback")
	check(get_tree().current_scene.scene_file_path == "res://scenes/ui/front_end.tscn", "Cancelled Loop cannot reopen Main")
	if GameManager.has_method("checkpoint_is_valid"):
		await _corrupt_saves()
	else:
		check(false, "Checkpoint validates input before mutating state")
	await _enemy_lifecycle()
	print("CHECKPOINT EDGES: %d checks, %d failures" % [checks, failures])
	get_tree().quit(0 if failures == 0 else 1)

func _corrupt_saves() -> void:
	FreedomLedger.reset()
	var valid := {"zone": "ground", "position": [1850, 500], "ledger": FreedomLedger.snapshot()}
	check(GameManager.checkpoint_is_valid(valid), "Current save schema accepted")
	var partial := {"zone": "ground", "position": [300, 500], "ledger": {}}
	check(GameManager.checkpoint_is_valid(partial), "Legacy partial ledger defaults supported")
	var malformed: Array = [[], {"ledger": []}, {"zone": "../missing", "position": [0, 500], "ledger": {}},
		{"zone": "ground", "position": ["bad", 500], "ledger": {}},
		{"zone": "ground", "position": [INF, 500], "ledger": {}},
		{"zone": "ground", "position": [-500, 500], "ledger": {}},
		{"zone": "ground", "position": [500, 500], "ledger": {"inventory": null}},
		{"zone": "ground", "position": [500, 500], "ledger": {"flags": {"piano_seal_steps": []}}},
		{"zone": "ground", "position": [500, 500], "ledger": {"keys": ["memory"]}},
		{"zone": "ground", "position": [500, 500], "ledger": {"current_part": 2}},
		{"zone": "ground", "position": [500, 500], "ledger": {"hp": "bad"}}]
	for bad in malformed:
		check(not GameManager.checkpoint_is_valid(bad), "Malformed checkpoint rejected before mutation")
	var file := FileAccess.open(GameManager.save_path, FileAccess.WRITE)
	var corrupt := '{"ledger": [], "zone": "missing", "position": [0, 0]}'
	file.store_string(corrupt)
	file.close()
	GameManager.continue_game()
	await get_tree().process_frame
	await get_tree().process_frame
	check(GameManager.state == GameManager.State.MENU, "Corrupt save returns to usable home")
	check(FileAccess.get_file_as_string(GameManager.save_path) == corrupt, "Corrupt save preserved for recovery")
	check(not GameManager.checkpoint_error.is_empty(), "Corrupt save has user-facing explanation")
	if DisplayServer.get_name() != "headless":
		await get_tree().create_timer(0.6, true).timeout
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png("res://build/qa_checkpoint_error.png")

func _enemy_lifecycle() -> void:
	FreedomLedger.reset()
	GameManager.state = GameManager.State.PLAYING
	var room: Node2D = load("res://scenes/levels/ground_floor.tscn").instantiate()
	add_child(room)
	var enemy: CharacterBody2D = load("res://scenes/enemy/deprived_one.tscn").instantiate()
	room.add_child(enemy)
	enemy.set_physics_process(false)
	check(not enemy.can_see_player(), "Enemy with no player has no visible target")
	var player: CharacterBody2D = load("res://scenes/player/player.tscn").instantiate()
	room.add_child(player)
	player.position = Vector2(600, 500)
	player.set_physics_process(false)
	enemy._physics_process(0.016)
	check(enemy.player == player, "Enemy acquires a player created after itself")
	player.free()
	check(not enemy.can_see_player(), "Freed player cannot be dereferenced by vision")
	enemy._hidden("stale_signal")
	enemy._hear(Vector2.ZERO, 500, "GLASS")
	var replacement: CharacterBody2D = load("res://scenes/player/player.tscn").instantiate()
	room.add_child(replacement)
	replacement.position = Vector2(650, 500)
	replacement.set_physics_process(false)
	enemy._physics_process(0.016)
	check(enemy.player == replacement, "Enemy reacquires replacement target")
	FreedomLedger.restore_sense("hearing")
	enemy.noise_pings.clear()
	enemy._hear(enemy.global_position, 500, "GENERIC")
	check(enemy.state == enemy.State.INVESTIGATE, "One normal ping starts investigation")
	var pause_started := Time.get_ticks_msec()
	GameManager.pause_game()
	while Time.get_ticks_msec() - pause_started < 6500:
		await get_tree().process_frame
	GameManager.resume()
	enemy._hear(enemy.global_position, 500, "GENERIC")
	check(enemy.state == enemy.State.HUNT_AUDIO, "Pause freezes the six-second hearing memory window")
	enemy.noise_pings.clear()
	enemy.change_state(enemy.State.PATROL_AUDIO)
	enemy._hear(enemy.global_position, 500, "GENERIC")
	enemy._physics_process(6.1)
	enemy._hear(enemy.global_position, 500, "GENERIC")
	check(enemy.state == enemy.State.INVESTIGATE, "Hearing history expires after six seconds of active simulation")
	room.queue_free()
	await get_tree().process_frame
