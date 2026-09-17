extends Node

var checks := 0
var failures: Array[String] = []

func check(condition: bool, message: String) -> void:
	checks += 1
	if not condition:
		failures.append(message)
		push_error(message)

func _ready() -> void:
	_run.call_deferred()

func _run() -> void:
	FreedomLedger.reset()
	GameManager.state = GameManager.State.PLAYING
	GameManager.zone = "ground"

	var room: Node2D = load("res://scenes/levels/ground_floor.tscn").instantiate()
	add_child(room)
	await get_tree().physics_frame

	var player: CharacterBody2D = preload("res://scenes/player/player.tscn").instantiate()
	player.position = Vector2(500, 500)
	add_child(player)
	await get_tree().physics_frame

	# 1. Test Clock Distraction visual and image asset
	var clock_scene = preload("res://scenes/interactables/clock_distraction.tscn")
	var clock_inst = clock_scene.instantiate()
	add_child(clock_inst)
	check(clock_inst.is_in_group("distraction_object"), "Clock distraction is in distraction_object group")
	var clock_sprite: Sprite2D = clock_inst.get_node_or_null("ClockSprite")
	check(clock_sprite != null, "Clock distraction has ClockSprite node")
	check(clock_sprite != null and clock_sprite.texture != null, "Clock distraction has valid texture from assets")
	clock_inst.queue_free()

	# 2. Test Bottle dropping in-place (no travel distance)
	player.position = Vector2(600, 500)
	FreedomLedger.inventory["bottle"] = 1
	player.use_gadget()
	await get_tree().physics_frame
	var distractions := get_tree().get_nodes_in_group("distraction_object")
	check(not distractions.is_empty(), "Bottle spawned a distraction object")
	var bottle_distraction = distractions[0] if not distractions.is_empty() else null
	check(bottle_distraction != null and bottle_distraction.global_position.distance_to(player.global_position) < 5.0, "Bottle breaks in-place at player position where Q was pressed")
	if bottle_distraction != null:
		bottle_distraction.queue_free()

	# 3. Test Hound AI tracking distraction out of CHASE and 5-second hold
	var enemy: CharacterBody2D = preload("res://scenes/enemy/deprived_one.tscn").instantiate()
	enemy.position = Vector2(1200, 500)
	add_child(enemy)
	await get_tree().physics_frame

	FreedomLedger.restore_sense("hearing")
	FreedomLedger.restore_sense("sight")

	# Put enemy in CHASE state
	enemy.change_state(enemy.State.CHASE)
	check(enemy.state == enemy.State.CHASE, "Enemy is in CHASE state")

	# Drop a clock distraction at Vector2(900, 500)
	var distraction = clock_scene.instantiate()
	distraction.global_position = Vector2(900, 500)
	add_child(distraction)

	# Trigger distraction noise
	EventBus.noise_created.emit(distraction.global_position, 576.0, "CLOCK")

	check(enemy.state == enemy.State.INVESTIGATE, "Distraction broke CHASE state and transitioned to INVESTIGATE")
	check(enemy.is_distracted, "Enemy flagged as is_distracted")
	check(enemy.distraction_target == Vector2(900, 500), "Enemy distraction target is the distraction position")

	# Verify vision does not re-acquire player while distracted
	player.position = enemy.global_position + Vector2(-50, 0)
	enemy._update_vision(0.5)
	check(enemy.state == enemy.State.INVESTIGATE, "Vision re-acquisition suppressed while enemy is distracted")

	# Simulate enemy arriving at distraction
	enemy.global_position = Vector2(900, 500)
	enemy._update_state(0.016)
	check(enemy.distraction_arrived, "Enemy recognized arrival at distraction")
	check(is_equal_approx(enemy.distraction_stay_timer, 5.0), "Enemy initialized 5-second hold timer at distraction")

	# Simulate 2 seconds of stay
	enemy._update_state(2.0)
	enemy._move(2.0)
	check(is_equal_approx(enemy.distraction_stay_timer, 3.0), "Enemy timer ticked down to 3 seconds")
	check(enemy.velocity == Vector2.ZERO, "Enemy velocity remains ZERO during 5s hold")
	check(enemy.state == enemy.State.INVESTIGATE, "Enemy stays in INVESTIGATE at the distraction location")

	# Simulate another 3.1 seconds of stay (total > 5.0s)
	enemy._update_state(3.1)
	check(not enemy.is_distracted, "Enemy finished distraction after 5 seconds")
	check(enemy.state != enemy.State.CHASE, "Enemy returned to patrol instead of chase after 5s hold")

	distraction.queue_free()
	enemy.queue_free()
	player.queue_free()
	room.queue_free()

	print("DISTRACTION TRACKING: %d checks, %d failures" % [checks, failures.size()])
	get_tree().quit(0 if failures.is_empty() else 1)
