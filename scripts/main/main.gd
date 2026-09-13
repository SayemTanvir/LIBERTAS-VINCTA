extends Node2D
# Keep the foyer resource with Main; other rooms retain their existing flow.
const INTRO_ROOM := preload("res://scenes/levels/intro_floor.tscn")
const ENEMY := preload("res://scenes/enemy/deprived_one.tscn")
var room: Node2D

func _ready() -> void:
	var packed: PackedScene = INTRO_ROOM if GameManager.zone == "intro" else load("res://scenes/levels/" + GameManager.zone + "_floor.tscn")
	room = packed.instantiate()
	$World.add_child(room)
	var player := $Entities/Player
	# Recovery always wins over arrival so a stale passage flag cannot replay a door.
	var recovering := GameManager.respawn_pending
	var arriving := not recovering and GameManager.arrival_pending and GameManager.zone != "intro"
	var loop_waking := bool(FreedomLedger.flags.get("loop_wake", false))
	GameManager.arrival_pending = false
	var arrival_door: BaseInteractable = _passage_for_entry() if arriving else null
	var spawn: Vector2 = room.get_node("Markers/ReturnSpawn" if GameManager.entry == "end" else "Markers/PlayerSpawn").global_position
	if arrival_door != null:
		spawn = arrival_door.global_position + Vector2(0, 8)
	if recovering and not GameManager.checkpoint.is_empty():
		spawn = GameManager.checkpoint.position
		_close_passages_immediately()
	player.global_position = spawn
	var camera := player.get_node("Camera2D")
	camera.limit_left = 0
	camera.limit_right = int(room.room_width)
	camera.limit_top = 0
	camera.limit_bottom = 800
	camera.snap_to_player()
	if GameManager.zone == "intro":
		$Awakening.begin(player, $UI)
	else:
		GameManager.state = GameManager.State.INTRO if arrival_door != null or recovering or loop_waking else GameManager.State.PLAYING
		player.control_enabled = arrival_door == null and not recovering and not loop_waking
		if arrival_door == null and not recovering and not loop_waking:
			GameManager.save_checkpoint(spawn)
		if FreedomLedger.flags.get("flashlight", false):
			player.set_flashlight(false, false)
		var enemy := ENEMY.instantiate()
		var enemy_spawn: Vector2 = room.get_node("Markers/EnemySpawn").global_position
		if enemy_spawn.distance_to(spawn) < 650.0:
			enemy_spawn.x = spawn.x + 850.0 if spawn.x < room.room_width - 1000 else spawn.x - 850.0
			enemy_spawn = room.grid.get_point_position(room.nearest_cell(enemy_spawn))
		enemy.position = enemy_spawn
		$Entities.add_child(enemy)
		if arrival_door != null:
			_finish_arrival.call_deferred(player, arrival_door)
		elif recovering:
			_finish_checkpoint_respawn.call_deferred(player)
		elif loop_waking:
			_finish_loop_wake.call_deferred(player)

func _close_passages_immediately() -> void:
	for child in room.props.get_children():
		if child is BaseInteractable:
			var presentation: Node = child.get_node_or_null("Visual/DoorPresentation")
			if presentation != null:
				presentation.set_open_immediate(false)

func _passage_for_entry() -> BaseInteractable:
	if GameManager.entry not in ["start", "end", "checkpoint"]:
		for child in room.props.get_children():
			if child is BaseInteractable and child.interaction_id == GameManager.entry:
				return child
	var edge_x: float = float(room.room_width) if GameManager.entry == "end" else 0.0
	var nearest: BaseInteractable
	var distance := INF
	for child in room.props.get_children():
		if child is BaseInteractable and child.get_node_or_null("Visual/DoorPresentation") != null:
			var candidate: float = absf(child.position.x - edge_x)
			if candidate < distance:
				nearest = child
				distance = candidate
	return nearest

func _finish_arrival(player: CharacterBody2D, door: BaseInteractable) -> void:
	var presentation: Node = door.get_node_or_null("Visual/DoorPresentation")
	if presentation != null:
		await presentation.arrive(player)
	else:
		player.global_position = door.global_position + Vector2(0, 56)
		player.control_enabled = true
	GameManager.state = GameManager.State.PLAYING
	GameManager.save_checkpoint(player.global_position)

func _finish_loop_wake(player: CharacterBody2D) -> void:
	FreedomLedger.flags["loop_wake"] = false
	await player.play_respawn()
	GameManager.state = GameManager.State.PLAYING
	GameManager.save_checkpoint(player.global_position)

func _finish_checkpoint_respawn(player: CharacterBody2D) -> void:
	var hud := $UI
	hud.fade.color = Color.BLACK
	var reveal := create_tween()
	reveal.tween_property(hud.fade, "color:a", 0.0, 0.55)
	await player.play_respawn()
	GameManager.respawn_pending = false
	GameManager.state = GameManager.State.PLAYING
	player.control_enabled = true
