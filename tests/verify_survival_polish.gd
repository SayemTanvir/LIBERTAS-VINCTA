extends Node
var checks := 0
var failures := 0
var main: Node2D
var player: CharacterBody2D
var enemy: CharacterBody2D
var deaths := 0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	AudioServer.set_bus_mute(0, true)
	GameManager.save_path = "res://build/survival_polish_save.json"
	EventBus.player_caught.connect(func(): deaths += 1)
	_run.call_deferred()

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error(message)

func frames(count := 3) -> void:
	for i in count:
		await get_tree().physics_frame
		await get_tree().process_frame

func setup(zone: String, part_two := false) -> void:
	get_tree().paused = false
	GameManager.transition_epoch += 1
	if is_instance_valid(main):
		main.queue_free()
		await frames()
	FreedomLedger.reset()
	FreedomLedger.restore_sense("hearing")
	FreedomLedger.restore_sense("sight")
	if part_two:
		FreedomLedger.begin_part_two("partial_mercy")
	FreedomLedger.flags["flashlight"] = true
	GameManager.zone = zone
	GameManager.entry = "start"
	GameManager.arrival_pending = false
	GameManager.respawn_pending = false
	GameManager.state = GameManager.State.PLAYING
	main = preload("res://scenes/main/main.tscn").instantiate()
	add_child(main)
	player = main.get_node("Entities/Player")
	enemy = get_tree().get_first_node_in_group("enemy")
	enemy.set_physics_process(false)
	await frames()

func capture(label: String) -> void:
	if DisplayServer.get_name() == "headless":
		return
	await frames()
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png("res://build/survival_" + label + ".png")

func _run() -> void:
	await setup("ground")
	player.position = Vector2(650, 530)
	enemy.position = Vector2(570, 530)
	enemy.facing = Vector2.LEFT
	check(enemy.can_see_player(), "Close uncovered player is visible outside the forward cone")
	enemy._update_vision(0.13)
	check(enemy.state == enemy.State.CHASE, "Close sight promptly starts a chase")
	enemy.position = Vector2(250, 530)
	enemy.facing = Vector2.RIGHT
	enemy.target = player.position
	var start_distance: float = enemy.position.distance_to(player.position)
	var flips := 0
	var previous: bool = enemy.sprite.flip_h
	for i in 50:
		enemy._move(1.0 / 60.0)
		flips += int(previous != enemy.sprite.flip_h)
		previous = enemy.sprite.flip_h
		await get_tree().physics_frame
	check(enemy.position.distance_to(player.position) < start_distance - 180.0, "Chase closes the distance instead of stalling at grid centers")
	check(flips <= 1, "Straight pursuit does not oscillate left/right")
	main.room._wall("SightTest", Rect2(570, 490, 24, 70))
	main.room._build_grid()
	enemy.position = Vector2(530, 530)
	await frames()
	check(not enemy.can_see_player(), "Solid cover still blocks stronger sight")
	check(not enemy._clear_motion_to(player.position), "Direct pursuit respects the full collision body")
	enemy.path_clock = 0.0
	for i in 150:
		enemy._move(1.0 / 60.0)
		await get_tree().physics_frame
	check(enemy.position.distance_to(player.position) < 40.0 and enemy.state == enemy.State.CHASE, "Chase routes around cover without abandoning a nearby target")
	main.room.geometry.get_node("SightTest").queue_free()
	await frames()
	# Ordinary tables now physically stop movement.
	var table = main.room.props.get_node("Gf01Charge2Table")
	player.position = table.position + Vector2(0, 25)
	var hit := player.move_and_collide(Vector2(0, -70))
	check(hit != null and player.position.y > table.position.y - 4.0, "Player cannot walk through an ordinary table")
	# A lethal hit during the vent delay must win over its pending room travel.
	var vent: BaseInteractable
	for prop in main.room.props.get_children():
		if prop is BaseInteractable and prop.kind == "vent":
			vent = prop
			break
	check(vent != null, "Vent exists for simultaneous death regression")
	player.position = vent.position + Vector2(0, 30)
	player.hurt_cooldown = 0.0
	vent.interact(player)
	await get_tree().create_timer(0.05, false).timeout
	var before_deaths := deaths
	player.take_hit(999.0)
	player.take_hit(999.0)
	await get_tree().create_timer(0.65, false).timeout
	check(GameManager.state == GameManager.State.CAUGHT and GameManager.zone == "ground" and FreedomLedger.hp == 0.0, "Death cancels pending vent travel and cannot restore health")
	check(deaths == before_deaths + 1 and player.animation_state == "death", "Lethal contact emits a single death presentation")
	await setup("echoes", true)
	before_deaths = deaths
	for i in 3:
		player.hurt_cooldown = 0.0
		player.take_hit(30.0)
		check(player.animation_state == "hurt" and not player.death_started, "Nonfatal Resonance Hall hit flinches rather than killing")
	check(deaths == before_deaths, "Nonfatal hits do not emit death audio events")
	player.hurt_cooldown = 0.0
	player.take_hit(30.0)
	check(deaths == before_deaths + 1, "Final fatal hit emits death once")
	await setup("echoes", true)
	FreedomLedger.part2_seed.touch_mutation = true
	enemy.state = enemy.State.HUNT_AUDIO
	enemy.position = Vector2(2450, 580)
	player.position = Vector2(2600, 580)
	enemy.target = Vector2(2200, 580)
	enemy._detect_touch()
	check(enemy.target == player.position and enemy.state_clock == 0.0, "Touch pursuit refreshes a nearby moving target instead of stopping at stale noise")
	await setup("upper")
	for section in main.room.layout.rooms:
		player.position = Vector2((section.start + section.end) * 0.5, 540)
		player.get_node("Camera2D").snap_to_player()
		await capture(str(section.id))
	await setup("ground")
	for id in ["GF-05", "GF-06"]:
		for section in main.room.layout.rooms:
			if section.id == id:
				player.position = Vector2((section.start + section.end) * 0.5, 540)
				player.get_node("Camera2D").snap_to_player()
				await capture(id)
	var station: BaseInteractable = main.room.props.get_node("GroundRecharge")
	player.position = station.position + Vector2(0, 30)
	player.get_node("Camera2D").snap_to_player()
	FreedomLedger.set_flashlight_seconds(18.0)
	station.interact(player)
	await get_tree().create_timer(0.5, false).timeout
	var hud = main.get_node("UI")
	var first: String = hud.anchor_status.text
	check("%" in first and "CHARGING" in first, "Charging displays battery percentage")
	await get_tree().create_timer(0.5, false).timeout
	check(hud.anchor_status.text != first, "Displayed charging percentage increases during charging")
	await capture("charging_hud")
	Input.action_press("move_left")
	await frames()
	Input.action_release("move_left")
	get_window().size = Vector2i(800, 600)
	await capture("hud_800")
	check(hud.survival_panel.position.x + hud.survival_panel.size.x * hud.survival_panel.scale.x < hud.root.size.x, "HUD fits a narrow viewport")
	print("SURVIVAL POLISH: %d checks, %d failures" % [checks, failures])
	get_tree().quit(0 if failures == 0 else 1)
