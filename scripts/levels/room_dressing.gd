extends RefCounted
## Authored room-specific furnishings. Every floor object has a physical footprint.
const DATA_PATH := "res://data/room_dressing.json"

static func dress(room: Node2D, art: RefCounted, tint: Color) -> void:
	# Supplemental decor must not prevent the estate or its inventory from opening.
	if not FileAccess.file_exists(DATA_PATH):
		push_warning("Optional room dressing data is missing: " + DATA_PATH)
		return
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(DATA_PATH))
	if not parsed is Dictionary:
		push_warning("Optional room dressing data must contain a JSON object: " + DATA_PATH)
		return
	var rooms: Dictionary = parsed
	for section in room.layout.rooms:
		if not rooms.has(str(section.id)):
			continue
		var spec: Dictionary = rooms[str(section.id)]
		for facing_zone in spec.get("facing_zones", []):
			var r: Array = facing_zone.rect
			art.facing_zones.append({"wall": str(facing_zone.wall),
				"rect": Rect2(float(section.start) + r[0], r[1], r[2], r[3])})
		# Dress existing ordinary tables without turning them into extra charging points.
		for table_entry in art.data.zones[room.zone_id].get("plain_tables", []):
			if float(table_entry[1]) < float(section.start) or float(table_entry[1]) >= float(section.end):
				continue
			var table: Node2D = room.props.get_node(str(table_entry[0]).to_pascal_case() + "Table")
			var detail := "book"
			if str(section.id) in ["GF-02", "GF-04"]:
				detail = "plates"
			elif str(section.id) == "UF-05":
				detail = "water_set"
			elif room.zone_id == "basement":
				detail = "bottles"
			elif str(section.id) in ["CR-01", "CR-04", "CE-01", "CE-03", "CE-05"]:
				detail = "candle"
			var accent := Sprite2D.new()
			accent.name = "TabletopDecoration"
			table.add_child(accent)
			art._set_sprite(accent, detail, 24.0 if detail != "candle" else 20.0, Vector2(0, -47), tint)
		for i in spec.furnishings.size():
			var entry: Array = spec.furnishings[i]
			var prop := Node2D.new()
			prop.name = "Dressing_" + str(section.id).replace("-", "_") + "_" + str(i)
			prop.position = Vector2(float(section.start) + entry[1], entry[2])
			prop.scale = Vector2.ONE * 0.75
			prop.set_meta("dressing_room", str(section.id))
			prop.set_meta("purpose", str(spec.purpose))
			room.props.add_child(prop)
			var furniture := {"asset": entry[0], "width": entry[3]}
			if entry.size() > 4:
				furniture.details = entry[4]
			art._furnish(prop, furniture, tint)
			var width := float(entry[3]) * 0.75
			var footprint := Vector2(width * 0.75, clampf(width * 0.22, 12.0, 28.0))
			room._wall(prop.name + "Footprint", Rect2(prop.position - Vector2(footprint.x * 0.5, footprint.y), footprint))
			art.bind_facing(room, prop, prop, Rect2(Vector2(-footprint.x * 0.5, -footprint.y) / prop.scale, footprint / prop.scale))
		for rug in spec.get("rugs", []):
			var textile := Node2D.new()
			textile.name = "Rug_" + str(section.id)
			textile.position = Vector2(float(section.start) + rug[0], rug[1])
			textile.z_index = -8
			room.add_child(textile)
			var span := Vector2(rug[2], rug[3])
			room.furnishing_rugs.append(Rect2(textile.position - span * 0.5, span))
			var color := Color(str(rug[4]))
			textile.draw.connect(func(): _draw_rug(textile, span, color))

static func _draw_rug(canvas: Node2D, span: Vector2, color: Color) -> void:
	var border := color.lightened(0.25)
	var half := span * 0.5
	canvas.draw_rect(Rect2(-half + Vector2(3, 3), span), Color(0.015, 0.012, 0.01, 0.35))
	canvas.draw_rect(Rect2(-half, span), color)
	canvas.draw_rect(Rect2(-half + Vector2(5, 4), span - Vector2(10, 8)), border, false, 1.2)
	canvas.draw_rect(Rect2(-half + Vector2(10, 8), span - Vector2(20, 16)), border.darkened(0.15), false, 1.0)
	for x in range(-int(half.x) + 21, int(half.x) - 12, 27):
		var diamond := PackedVector2Array([Vector2(x - 7, 0), Vector2(x, -half.y * 0.42), Vector2(x + 7, 0), Vector2(x, half.y * 0.42), Vector2(x - 7, 0)])
		canvas.draw_polyline(diamond, border, 1.0, true)
	for y in range(-int(half.y) + 4, int(half.y) - 3, 5):
		canvas.draw_line(Vector2(-half.x - 4, y), Vector2(-half.x, y), border, 1.0)
		canvas.draw_line(Vector2(half.x, y), Vector2(half.x + 4, y), border, 1.0)
