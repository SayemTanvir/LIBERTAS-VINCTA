extends Node
var checks := 0
var failures := 0

func _ready() -> void:
	_run.call_deferred()

func _run() -> void:
	FreedomLedger.reset()
	FreedomLedger.flags["flashlight"] = true
	GameManager.state = GameManager.State.PLAYING
	for zone in ["intro", "ground", "upper", "basement", "roots", "echoes", "nexus"]:
		GameManager.zone = zone
		var room: Node2D = load("res://scenes/levels/" + zone + "_floor.tscn").instantiate()
		add_child(room)
		var player: CharacterBody2D = preload("res://scenes/player/player.tscn").instantiate()
		add_child(player)
		player.set_physics_process(false)
		await get_tree().physics_frame
		await get_tree().physics_frame
		for prop in room.props.get_children():
			if not prop is BaseInteractable or prop.kind != "recharge":
				continue
			var reachable := false
			for offset: Vector2 in [Vector2(0, 28), Vector2(0, 48), Vector2(40, 20), Vector2(-40, 20), Vector2(65, 0), Vector2(-65, 0)]:
				var point: Vector2 = prop.position + offset
				var shape := CircleShape2D.new()
				shape.radius = 10.0
				var query := PhysicsShapeQueryParameters2D.new()
				query.shape = shape
				query.transform = Transform2D(0, point)
				query.collision_mask = 1
				if not room.get_world_2d().direct_space_state.intersect_shape(query).is_empty():
					continue
				var path: PackedVector2Array = room.find_path(Vector2(240, 490), point)
				if path.is_empty() or path[-1].distance_to(point) > 28.0:
					continue
				player.position = point
				player._find_interactable()
				if player.target_interactable == prop:
					reachable = true
					break
			checks += 1
			if not reachable:
				failures += 1
				push_error("Unreachable charging station: " + zone + "/" + prop.interaction_id)
			if zone == "intro" and prop.interaction_id == "gf_00_charge_1" and DisplayServer.get_name() != "headless":
				var camera := Camera2D.new()
				camera.position = prop.position + Vector2(0, -30)
				camera.zoom = Vector2(3, 3)
				add_child(camera)
				camera.make_current()
				await get_tree().process_frame
				await RenderingServer.frame_post_draw
				get_viewport().get_texture().get_image().save_png("res://build/power_station_in_game.png")
				for index in 3:
					preload("res://scripts/interactables/power_station_visual.gd").frames[index].get_image().save_png("res://build/power_station_frame_%d.png" % index)
				camera.queue_free()
		player.queue_free()
		room.queue_free()
		await get_tree().process_frame
		await get_tree().process_frame
	print("WARD ACCESS: %d stations checked, %d failures" % [checks, failures])
	get_tree().quit(0 if failures == 0 else 1)
