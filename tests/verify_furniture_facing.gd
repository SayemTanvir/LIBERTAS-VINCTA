extends Node
const Facing := preload("res://scripts/levels/furniture_facing.gd")
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
	var zones: Array[Dictionary] = [
		{"wall": "back", "rect": Rect2(0, 0, 400, 40)},
		{"wall": "front", "rect": Rect2(0, 360, 400, 40)},
		{"wall": "left", "rect": Rect2(0, 0, 40, 400)},
		{"wall": "right", "rect": Rect2(360, 0, 40, 400)}]
	var walls: Array[Rect2] = [Rect2(-10, -10, 420, 10), Rect2(-10, 400, 420, 10), Rect2(-10, 0, 10, 400), Rect2(400, 0, 10, 400)]
	for sample in [[Rect2(100, 10, 50, 20), "down"], [Rect2(100, 370, 50, 20), "up"],
		[Rect2(10, 170, 20, 20), "right"], [Rect2(370, 170, 20, 20), "left"],
		[Rect2(160, 170, 80, 50), "authored"], [Rect2(35, 170, 110, 20), "right"]]:
		check(Facing.resolve(sample[0], zones, walls) == sample[1], "All walls, freestanding and wide footprint: " + sample[1])
	check(Facing.resolve(Rect2(10, 10, 20, 20), zones, walls) == "down", "Corner ties are stable")
	walls.append(Rect2(0, 80, 100, 20))
	check(Facing.resolve(Rect2(10, 10, 20, 20), zones, walls) == "right", "Corner faces greater open clearance")
	var alcove: Array[Dictionary] = [{"wall": "right", "rect": Rect2(200, 100, 30, 80)}]
	check(Facing.resolve(Rect2(205, 120, 20, 20), alcove, walls) == "left", "Explicit local alcove zone needs no nearest-wall guess")
	check(Facing.resolve(Rect2(205, 220, 20, 20), alcove, walls) == "authored", "Outside alcove retains authored pose")
	FreedomLedger.reset()
	GameManager.state = GameManager.State.PLAYING
	var missing_report := {}
	for zone in ["intro", "ground", "upper", "basement", "roots", "echoes", "nexus"]:
		var room: Node2D = load("res://scenes/levels/" + zone + "_floor.tscn").instantiate()
		add_child(room)
		var facing: Node = room.get_node("FurnitureFacing")
		missing_report[zone] = facing.missing_views()
		for entry in facing.entries:
			check(entry.anchor.get_meta("furniture_facing") in ["up", "down", "left", "right", "authored"], "Every registered prop resolves")
			check(entry.visual.rotation == 0.0 and entry.visual.scale.x > 0 and entry.visual.scale.y > 0, "Upright art never rotates or inverts")
		for prop in room.props.get_children():
			if str(prop.get_meta("furniture_spec", {}).get("asset", "")) == "side_table":
				check(not prop.has_meta("furniture_facing"), "Round tables excluded")
		if zone == "ground":
			var bench: Node2D = room.props.get_node("Dressing_GF_03_1")
			var sprite: Sprite2D = bench.get_node("Sprite2D")
			var texture: Texture2D = sprite.texture
			var shadow_points: PackedVector2Array = bench.get_node("ContactShadow").polygon
			check(bench.get_meta("furniture_facing") == "up", "Existing foreground Music Room bench faces inward logically")
			check(bench.get_meta("missing_furniture_view") == "bench:up", "Missing rear art explicitly reported")
			var old_position := bench.position
			bench.position.y = 395
			await get_tree().process_frame
			await get_tree().process_frame
			check(bench.get_meta("furniture_facing") == "down" and not bench.has_meta("missing_furniture_view"), "Moving to back row recomputes automatically")
			bench.position.y = 500
			await get_tree().process_frame
			await get_tree().process_frame
			check(bench.get_meta("furniture_facing") == "authored", "Moving into center restores authored facing")
			check(sprite.texture == texture, "Missing views preserve original art")
			check(bench.get_node("ContactShadow").polygon == shadow_points, "Contact shadow unchanged")
			# A texture alias is a dispatch fixture only, not a claimed rear-view asset.
			room.estate_art.data.furniture_facing.bench.variants.up = {"asset": "bench"}
			bench.position = old_position
			facing.refresh()
			check(bench.get_meta("furniture_facing_applied") == "up" and not bench.has_meta("missing_furniture_view"), "Available explicit variant dispatches")
			room.estate_art.data.furniture_facing.bench.variants.up = {"asset": "missing_test_texture"}
			facing.refresh()
			check(bench.get_meta("missing_furniture_view") == "bench:up" and sprite.texture == texture, "Invalid variant safely restores native texture")
			room.estate_art.data.textures.missing_test_texture = {"file": "res://missing_furniture_test.png"}
			facing.refresh()
			check(bench.get_meta("missing_furniture_view") == "bench:up" and sprite.texture == texture, "Catalog entry with missing file also preserves native art")
			check(room.y_sort_enabled and room.props.y_sort_enabled, "Foot-based Y sorting preserved")
		room.queue_free()
		await get_tree().process_frame
	# Existing checkpoints contain flags, not furniture-facing state. Rebuild must recalculate.
	var snapshot: Dictionary = FreedomLedger.snapshot()
	FreedomLedger.restore_snapshot(snapshot)
	var reloaded: Node2D = load("res://scenes/levels/ground_floor.tscn").instantiate()
	add_child(reloaded)
	check(reloaded.props.get_node("Dressing_GF_03_1").get_meta("furniture_facing") == "up", "Old ledger + layout rebuild recalculates facing")
	var file := FileAccess.open("res://build/missing_furniture_views.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(missing_report, "  "))
	file.close()
	reloaded.queue_free()
	print("FURNITURE FACING: %d checks, %d failures" % [checks, failures])
	get_tree().quit(0 if failures == 0 else 1)
