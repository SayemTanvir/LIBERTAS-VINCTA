extends Node
var checks := 0
var failures := 0
var count := 0
const CAPTURES := ["GF-00", "GF-01", "GF-02", "GF-03", "GF-06", "UF-01", "UF-02", "UF-03", "UF-05", "BS-02", "CR-02", "CE-04", "LN-CENTER"]

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error(message)

func _ready() -> void:
	AudioServer.set_bus_mute(0, true)
	_run.call_deferred()

func _run() -> void:
	for zone in ["intro", "ground", "upper", "basement", "roots", "echoes", "nexus"]:
		FreedomLedger.reset()
		GameManager.zone = zone
		GameManager.state = GameManager.State.PLAYING
		var room: Node2D = load("res://scenes/levels/" + zone + "_floor.tscn").instantiate()
		add_child(room)
		await get_tree().physics_frame
		await get_tree().physics_frame
		for prop in room.props.get_children():
			if prop.has_meta("dressing_room"):
				count += 1
				var body: StaticBody2D = room.geometry.get_node_or_null(str(prop.name) + "Footprint")
				check(body != null and body.collision_layer == 1, str(prop.name) + " has a solid footprint for Els and the Hound")
				check(prop.position.y < 435 or prop.position.y > 570, str(prop.name) + " preserves the main walking lane")
			if prop is BaseInteractable:
				check(_reachable(room, prop), zone + ": interaction remains reachable: " + prop.interaction_id)
		for rug: Rect2 in room.furnishing_rugs:
			check(room.surface_at(rug.get_center()) == "CARPET", "Visible rug softens footsteps")
		var camera := Camera2D.new()
		add_child(camera)
		camera.make_current()
		for section in room.layout.rooms:
			var furnished := 0
			for prop in room.props.get_children():
				furnished += int(prop.get_meta("dressing_room", "") == str(section.id))
			check(furnished >= 3, str(section.id) + " receives a meaningful furnishing group")
			if str(section.id) in CAPTURES and DisplayServer.get_name() != "headless":
				camera.position = Vector2((section.start + section.end) * 0.5, 335)
				var zoom := minf(1.125, 1280.0 / (float(section.end) - float(section.start) + 60.0))
				camera.zoom = Vector2.ONE * zoom
				await get_tree().process_frame
				await get_tree().process_frame
				await RenderingServer.frame_post_draw
				get_viewport().get_texture().get_image().save_png("res://build/furnished_" + str(section.id) + ".png")
		camera.queue_free()
		room.queue_free()
		await get_tree().process_frame
		await get_tree().process_frame
	print("ROOM DRESSING: %d furnishings; %d checks, %d failures" % [count, checks, failures])
	get_tree().quit(0 if failures == 0 else 1)

func _reachable(room: Node2D, prop: BaseInteractable) -> bool:
	var space := room.get_world_2d().direct_space_state
	var shape := CircleShape2D.new()
	shape.radius = 11.0
	for distance in [32.0, 48.0, 65.0]:
		for i in 16:
			var point: Vector2 = prop.position + Vector2.DOWN.rotated(TAU * i / 16.0) * distance
			if point.y < 368 or point.y > 620:
				continue
			var query := PhysicsShapeQueryParameters2D.new()
			query.shape = shape
			query.transform = Transform2D(0, point)
			query.collision_mask = 1
			if not space.intersect_shape(query).is_empty():
				continue
			var ray := PhysicsRayQueryParameters2D.create(point, prop.position, 1)
			if not space.intersect_ray(ray).is_empty():
				continue
			var path: PackedVector2Array = room.find_path(Vector2(240, 490), point)
			if not path.is_empty() and path[-1].distance_to(point) < 30.0:
				return true
	return false
