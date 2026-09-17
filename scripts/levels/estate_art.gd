extends RefCounted
## Art uses the same foot origins as gameplay; only explicit footprints add collision.
const ART_DATA := "res://data/estate_art.json"
const PickupMarker := preload("res://scripts/interactables/pickup_marker.gd")
const DoorPresentation := preload("res://scripts/interactables/door_presentation.gd")
const PowerStationVisual := preload("res://scripts/interactables/power_station_visual.gd")
var data: Dictionary
var textures: Dictionary = {}
var facing_entries: Array[Dictionary] = []
var facing_zones: Array[Dictionary] = []

func _init() -> void:
	data = JSON.parse_string(FileAccess.get_file_as_string(ART_DATA))

func texture_for(key: String) -> Texture2D:
	if textures.has(key):
		return textures[key]
	var spec: Dictionary = data.textures[key]
	var path: String = spec.file
	if not path.begins_with("res://"):
		path = str(data.asset_root) + path
	var source: Texture2D = load(path)
	if spec.get("mask_background", false):
		var r: Array = spec.region
		textures[key] = preload("res://scripts/levels/furniture_cutout.gd").texture(source, Rect2i(r[0], r[1], r[2], r[3]), spec.get("mask_seeds", []))
		return textures[key]
	var atlas := AtlasTexture.new()
	atlas.atlas = source
	if spec.has("region"):
		var r: Array = spec.region
		atlas.region = Rect2(r[0], r[1], r[2], r[3])
		if spec.get("trim", false):
			var bounds := source.get_image().get_region(Rect2i(atlas.region)).get_used_rect()
			atlas.region = Rect2(atlas.region.position + Vector2(bounds.position), Vector2(bounds.size))
	else:
		atlas.region = source.get_image().get_used_rect()
	atlas.filter_clip = true
	textures[key] = atlas
	return atlas

func build_backdrop(room: Node2D) -> void:
	var zone: Dictionary = data.zones[room.zone_id]
	var backdrop: Node2D = room.get_node("Backdrop")
	var art := Node2D.new()
	art.name = "ImportedArchitecture"
	backdrop.add_child(art)
	_rect(art, Rect2(-200, -100, room.room_width + 400, 900), Color("#151a19"))
	for section in zone.surfaces:
		var start := float(section[0])
		var width := float(section[1]) - start
		var wall_top := 0.0 if room.zone_id in ["roots", "echoes", "nexus"] else 110.0
		_tile_band(art, str(section[2]), Rect2(start, wall_top, width, 354.0 - wall_top), Vector2(300, 244), Color(zone.wall_tint))
		_tile_band(art, str(section[3]), Rect2(start, 354, width, 280), Vector2(240, 140), Color(zone.floor_tint))
		_rect(art, Rect2(start, wall_top, 8, 354.0 - wall_top), Color("#343c37"))
	if zone.get("carpet", false):
		_rect(art, Rect2(0, 354, room.room_width, 280), Color(0.21, 0.14, 0.19, 0.67))
		for y in [368, 620]:
			_rect(art, Rect2(0, y, room.room_width, 2), Color(0.59, 0.50, 0.40, 0.28))
	_rect(art, Rect2(0, 350, room.room_width, 7), Color("#232a26"))
	_rect(art, Rect2(0, 634, room.room_width, 16), Color("#252c28"))
	_rect(art, Rect2(0, 110, 12, 540), Color("#343c37"))
	_rect(art, Rect2(room.room_width - 12, 110, 12, 540), Color("#343c37"))
	if room.zone_id in ["intro", "ground", "upper"]:
		for x in range(500, int(room.room_width), 960):
			var clear_of_passages := true
			for prop in room.layout.props:
				if zone.passage_labels.has(str(prop[1])) and absf(float(prop[2]) - float(x + 45)) < 140.0:
					clear_of_passages = false
			if clear_of_passages:
				_window(art, Vector2(x, 169))

func dress(room: Node2D) -> void:
	var zone: Dictionary = data.zones[room.zone_id]
	var tint := Color(zone.prop_tint)
	for node_name in zone.furniture:
		var body: Node2D = room.props.get_node_or_null(NodePath(node_name))
		if body == null:
			continue
		body.get_node("PlaceholderVisual").hide()
		body.get_node("RaisedFacePlaceholder").hide()
		var visual := Node2D.new()
		visual.name = "Visual"
		body.add_child(visual)
		_furnish(visual, zone.furniture[node_name], tint)
		visual.scale = Vector2.ONE * float(data.furniture_scale)
		var size: Array = zone.furniture[node_name].footprint
		bind_facing(room, body, visual, Rect2(-float(size[0]) * 0.5, -float(size[1]), size[0], size[1]))
		if str(zone.furniture[node_name].asset) == "bench":
			visual.rotation_degrees = float(data.bench_rotation_degrees)
	for id in zone.get("interactables", {}):
		var prop: Node2D = room.props.get_node_or_null(NodePath(str(id).to_pascal_case()))
		if prop == null:
			continue
		if prop.kind in ["key", "letter", "flashlight", "tool", "item"]:
			# Pickup dressing owns the entire visual; do not leave old furniture shadows/details.
			continue
		var spec: Dictionary = zone.interactables[id]
		var visual: Node2D = prop.get_node("Visual")
		visual.get_node("PlaceholderVisual").hide()
		_furnish(visual, spec, tint, visual.get_node("Sprite2D"))
		visual.scale = Vector2.ONE * float(spec.get("scale", 1.0))
		if spec.has("sort_offset"):
			# A tabletop item sorts with its supporting furniture, without moving its E target.
			prop.y_sort_enabled = true
			visual.position = Vector2(spec.sort_offset[0], spec.sort_offset[1])
			for child in visual.get_children():
				if child is Node2D:
					child.position -= visual.position
		if spec.has("footprint"):
			var size := Vector2(spec.footprint[0], spec.footprint[1])
			# Leave the interaction origin in front of the body for the player's ray test.
			room._wall(str(id).to_pascal_case() + "Footprint", Rect2(prop.position - Vector2(size.x * 0.5, size.y + 8), size))
			bind_facing(room, prop, visual, Rect2(-size.x * 0.5, -size.y - 8, size.x, size.y))
	for child in room.props.get_children():
		if child is BaseInteractable:
			if child.interaction_id == "scratched_nameplate":
				continue # Its existing-texture fragments own the complete presentation.
			if child.kind in ["key", "letter", "flashlight", "tool", "item"]:
				_dress_pickup(child)
			elif child.kind in ["door", "locked_door", "exit"]:
				_dress_passage(child, zone.passage_labels.get(child.interaction_id, "Passage"))
			elif child.get_node("Visual/Sprite2D").texture == null:
				_dress_generic_interactable(child, tint)
			child.refresh()
			if child.kind == "recharge":
				_service_marker(child, "CHARGE + REST" if room.zone_id in ["roots", "echoes", "nexus"] else "CHARGE", Color("86d1d3"))
				room._wall(child.name + "Footprint", Rect2(child.position - Vector2(29, 27), Vector2(58, 19)))
			elif child.kind == "anchor":
				var titles := {"LN-A": "DESTROY\nKnife, Power and Blood Trap", "LN-B": "FLEE\nHold E for 20 seconds", "LN-C": "REMAIN\nHold E to begin again"}
				_service_marker(child, titles.get(child.interaction_id, "ANCHOR"), Color("dfc287"), -120.0)
	# Former charging tables remain ordinary furniture with no E target or marker.
	for entry in zone.get("plain_tables", []):
		var table := Node2D.new()
		table.name = str(entry[0]).to_pascal_case() + "Table"
		table.position = Vector2(entry[1], entry[2])
		room.props.add_child(table)
		_furnish(table, {"asset": "side_table", "width": 72.0}, tint)
		room._wall(table.name + "Footprint", Rect2(table.position - Vector2(29, 27), Vector2(58, 23)))
	var decoration_index := 0
	for entry in zone.decorations:
		var prop := Node2D.new()
		prop.name = str(entry[0]).to_pascal_case()
		var on_floor := float(entry[2]) >= 354.0
		prop.position = Vector2(entry[1], entry[2])
		prop.scale = Vector2.ONE * float(data.decoration_scale)
		if str(entry[0]) == "bench":
			prop.rotation_degrees = float(data.bench_rotation_degrees)
		room.props.add_child(prop)
		var spec := {"asset": entry[0], "width": entry[3]}
		if entry.size() > 4:
			spec.details = entry[4]
		_furnish(prop, spec, tint)
		if on_floor and data.decoration_footprints.has(str(entry[0])):
			var dimensions: Array = data.decoration_footprints[str(entry[0])]
			var footprint := Vector2(dimensions[0], dimensions[1])
			room._wall("WallFurniture" + str(decoration_index), Rect2(prop.position - Vector2(footprint.x * 0.5, footprint.y), footprint))
			bind_facing(room, prop, prop, Rect2(Vector2(-footprint.x * 0.5, -footprint.y) / prop.scale, footprint / prop.scale))
		decoration_index += 1
	preload("res://scripts/levels/room_dressing.gd").dress(room, self, tint)
	var orientation := preload("res://scripts/levels/furniture_facing.gd").new()
	orientation.name = "FurnitureFacing"
	room.add_child(orientation)
	orientation.configure(room, self)
	for light_spec in zone.get("ceiling_lights", []):
		for room_spec in room.layout.rooms:
			if str(room_spec.id) == str(light_spec.room):
				_ceiling_string_lights(room, room_spec, light_spec, tint)

func _ceiling_string_lights(room: Node2D, bounds: Dictionary, spec: Dictionary, tint: Color) -> void:
	var strand := Node2D.new()
	strand.name = "CeilingStringLights"
	strand.position = Vector2(float(bounds.start), float(spec.height))
	room.props.add_child(strand)
	var width := float(bounds.end) - float(bounds.start)
	var sag := float(spec.sag)
	var cable := Line2D.new()
	cable.name = "Cable"
	cable.width = 3.0
	cable.default_color = Color("252c2d")
	cable.antialiased = true
	# Both ends attach at ceiling height, with a smooth bend at the midpoint.
	for index in 65:
		var t := float(index) / 64.0
		cable.add_point(Vector2(width * t, 4.0 * sag * t * (1.0 - t)))
	strand.add_child(cable)
	var bulb_count := int(spec.bulbs)
	for index in bulb_count:
		var t := float(index + 1) / float(bulb_count + 1)
		var anchor := Vector2(width * t, 4.0 * sag * t * (1.0 - t))
		var socket := Line2D.new()
		socket.width = 6.0
		socket.default_color = cable.default_color
		socket.add_point(anchor)
		socket.add_point(anchor + Vector2(0, 6))
		strand.add_child(socket)
		var bulb := Sprite2D.new()
		bulb.name = "Bulb" + str(index + 1)
		strand.add_child(bulb)
		_set_sprite(bulb, "string_light_bulb", 18.0, anchor + Vector2(0, 24), tint)
		# Keep the existing warm glow and individual flicker on each bulb.
		bulb.set_meta("estate_asset", "string_lights")

func _dress_pickup(prop: BaseInteractable) -> void:
	var visual: Node2D = prop.get_node("Visual")
	var sprite: Sprite2D = visual.get_node("Sprite2D")
	var item_assets := {"battery": "battery_pickup", "bottle": "bottle_pickup", "clock": "clock_pickup", "lockpick": "lockpick_pickup", "knife": "lockpick_pickup", "power": "power_stone"}
	var asset: String = item_assets.get(prop.item_id, "tool_pouch") if prop.kind == "item" else {"key": "key", "letter": "letter", "flashlight": "flashlight_pickup", "tool": "tool_pouch"}[prop.kind]
	var width: float = {"key": 22.0, "letter": 25.0, "flashlight": 26.0, "tool": 29.0}.get(prop.kind, 23.0)
	if prop.kind == "item":
		width = {"battery": 16.0, "bottle": 17.0, "clock": 23.0, "lockpick": 24.0}.get(prop.item_id, 23.0)
	_set_sprite(sprite, asset, width, Vector2.ZERO, Color.WHITE)
	if prop.item_id == "power":
		sprite.self_modulate = Color(1.0, 0.2, 0.25)
	# Loose objects belong to the floor plane, below every character and piece of furniture.
	prop.z_index = -1
	visual.scale = Vector2.ONE
	visual.position = Vector2.ZERO
	visual.get_node("PlaceholderVisual").hide()
	visual.z_index = 0
	if prop.display_name.is_empty():
		prop.display_name = prop.sense.capitalize() + " Key" if prop.kind == "key" else {"letter": "Letter", "flashlight": "Flashlight", "tool": "Tool Kit", "item": prop.item_id.capitalize()}.get(prop.kind, "Item")
	var marker := Node2D.new()
	marker.name = "PickupMarker"
	marker.set_script(PickupMarker)
	marker.is_key = prop.kind == "key"
	marker.radius = width * 0.6
	visual.add_child(marker)
	visual.move_child(marker, 0)

func _dress_generic_interactable(prop: BaseInteractable, tint: Color) -> void:
	var visual: Node2D = prop.get_node("Visual")
	var sprite: Sprite2D = visual.get_node("Sprite2D")
	var mapping := {
		"hiding": ["screen", 112.0], "puzzle": ["sideboard", 125.0],
		"recharge": ["side_table", 72.0], "vent": ["serving_hatch", 62.0],
		"lore": ["book", 48.0], "forge": ["sigil_forge", 120.0],
		"anchor": ["nexus_anchor", 120.0]
	}
	var spec: Array = mapping.get(prop.kind, ["book", 42.0])
	if prop.interaction_id == "nexus_bell":
		spec = ["ritual_stone", 80.0]
	visual.get_node("PlaceholderVisual").hide()
	_furnish(visual, {"asset": spec[0], "width": spec[1]}, tint, sprite)
	if prop.interaction_id == "nexus_bell":
		var bell := Polygon2D.new()
		bell.name = "BrassBell"
		bell.color = Color("c39a4f")
		bell.polygon = PackedVector2Array([Vector2(-21, -44), Vector2(-15, -50), Vector2(-12, -70), Vector2(-5, -78), Vector2(5, -78), Vector2(12, -70), Vector2(15, -50), Vector2(21, -44)])
		visual.add_child(bell)
		var clapper := Polygon2D.new()
		clapper.color = Color("f4d69b")
		clapper.polygon = PackedVector2Array([Vector2(-4, -42), Vector2(4, -42), Vector2(0, -36)])
		visual.add_child(clapper)

func _service_marker(prop: BaseInteractable, caption: String, color: Color, height := -98.0) -> void:
	var label := Label.new()
	label.name = "ServiceLabel"
	label.text = caption
	label.position = Vector2(-115, height)
	label.size = Vector2(230, 40)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 12)
	label.add_theme_color_override("font_color", color)
	label.add_theme_color_override("font_shadow_color", Color.BLACK)
	label.add_theme_constant_override("shadow_offset_y", 2)
	prop.add_child(label)
	if prop.kind == "recharge":
		var machine := PowerStationVisual.new()
		machine.name = "PowerStation"
		machine.station = prop
		machine.position = Vector2(0, -42)
		prop.get_node("Visual").add_child(machine)
		var glow := Line2D.new()
		glow.name = "ChargeIndicator"
		glow.default_color = color
		glow.width = 2.0
		glow.points = PackedVector2Array([Vector2(-18, -4), Vector2(18, -4)])
		prop.get_node("Visual").add_child(glow)

func _dress_passage(prop: BaseInteractable, caption: String) -> void:
	var visual: Node2D = prop.get_node("Visual")
	var sprite: Sprite2D = visual.get_node("Sprite2D")
	# The Music Room lock must be within the standing character's hand reach.
	var width := 60.0 if prop.kind == "locked_door" else 80.0
	_set_sprite(sprite, "estate_door", width, Vector2.ZERO, Color("#bbc6bf"))
	visual.get_node("PlaceholderVisual").hide()
	var door_height := sprite.texture.get_height() * sprite.scale.y
	var darkness := Polygon2D.new()
	darkness.name = "DoorVoid"
	darkness.color = Color("#050808")
	var opening := width * 27.0 / 80.0
	darkness.polygon = PackedVector2Array([Vector2(-opening, -door_height + 8), Vector2(opening, -door_height + 8), Vector2(opening, -4), Vector2(-opening, -4)])
	darkness.z_index = -2
	visual.add_child(darkness)
	visual.move_child(darkness, 0)
	var open_frame := Sprite2D.new()
	open_frame.name = "OpenStairs" if "stairs" in prop.interaction_id else "OpenDoorFrame"
	_set_sprite(open_frame, "stair_door", width, Vector2.ZERO, Color("#aeb9b3"))
	open_frame.z_index = -1 if "stairs" in prop.interaction_id else -2
	darkness.z_index = -2 if "stairs" in prop.interaction_id else -1
	visual.add_child(open_frame)
	prop.display_name = caption
	var plaque := Label.new()
	plaque.name = "Destination"
	plaque.text = caption
	plaque.position = Vector2(-100, -sprite.texture.get_height() * sprite.scale.y - 25)
	plaque.size = Vector2(200, 22)
	plaque.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	plaque.add_theme_font_size_override("font_size", 14)
	plaque.add_theme_color_override("font_color", Color("#d8d5b9"))
	plaque.add_theme_color_override("font_shadow_color", Color("#171d19"))
	plaque.add_theme_constant_override("shadow_offset_y", 1)
	visual.add_child(plaque)
	var presentation := Node.new()
	presentation.name = "DoorPresentation"
	presentation.set_script(DoorPresentation)
	visual.add_child(presentation)
	presentation.configure(sprite, plaque)

func _furnish(parent: Node2D, spec: Dictionary, tint: Color, sprite: Sprite2D = null) -> void:
	parent.set_meta("furniture_spec", spec.duplicate(true))
	if str(spec.asset) == "settee" and not data.textures.settee.get("mask_background", false):
		# Follow the booth's solid plinth instead of a detached oval floor shadow.
		var shadow := Polygon2D.new()
		shadow.name = "ContactShadow"
		shadow.color = Color(0.025, 0.03, 0.025, 0.42)
		var width := float(spec.width)
		shadow.polygon = PackedVector2Array([
			Vector2(-0.47, -0.20) * width, Vector2(0.0, -0.015) * width,
			Vector2(0.47, -0.18) * width, Vector2(0.47, -0.15) * width,
			Vector2(0.0, 0.015) * width, Vector2(-0.47, -0.17) * width])
		parent.add_child(shadow)
	else:
		_shadow(parent, float(spec.width))
	if sprite == null:
		sprite = Sprite2D.new()
		sprite.name = "Sprite2D"
		parent.add_child(sprite)
	_set_sprite(sprite, str(spec.asset), float(spec.width), Vector2.ZERO, tint)
	sprite.flip_h = bool(spec.get("flip", false))
	for detail in spec.get("details", []):
		var accent := Sprite2D.new()
		accent.name = str(detail[0]).to_pascal_case()
		accent.set_meta("furniture_detail", true)
		parent.add_child(accent)
		_set_sprite(accent, str(detail[0]), float(detail[3]), Vector2(detail[1], detail[2]), tint)

func bind_facing(room: Node2D, anchor: Node2D, visual: Node2D, footprint: Rect2) -> void:
	var spec: Dictionary = visual.get_meta("furniture_spec", {})
	# Explicit opt-in excludes rugs, lights, art, round tables and loose details.
	if not data.get("furniture_facing", {}).has(str(spec.get("asset", ""))):
		return
	var sprite: Sprite2D = visual.get_node("Sprite2D")
	var details: Array[Dictionary] = []
	for child in visual.get_children():
		if child is Sprite2D and child.has_meta("furniture_detail"):
			details.append({"node": child, "position": child.position})
	var transform := room.global_transform.affine_inverse() * anchor.global_transform
	facing_entries.append({"anchor": anchor, "visual": visual, "footprint": footprint,
		"original_footprint": transform * footprint, "sprite_position": sprite.position,
		"tint": sprite.self_modulate, "details": details})

func _set_sprite(sprite: Sprite2D, key: String, width: float, foot: Vector2, tint: Color) -> void:
	sprite.texture = texture_for(key)
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	sprite.scale = Vector2.ONE * width / sprite.texture.get_width()
	sprite.position = foot
	sprite.offset = Vector2(0, -sprite.texture.get_height() * 0.5)
	sprite.self_modulate = tint
	sprite.set_meta("estate_asset", key)

func _shadow(parent: Node2D, width: float) -> void:
	var shadow := Polygon2D.new()
	shadow.name = "ContactShadow"
	shadow.color = Color(0.025, 0.03, 0.025, 0.27)
	var points := PackedVector2Array()
	for i in 16:
		var angle := TAU * float(i) / 16.0
		points.append(Vector2(cos(angle) * width * 0.46, sin(angle) * width * 0.025 - 1.5))
	shadow.polygon = points
	parent.add_child(shadow)
	parent.move_child(shadow, 0)

func _tile_band(parent: Node2D, key: String, rect: Rect2, tile: Vector2, tint: Color) -> void:
	for row in int(ceil(rect.size.y / tile.y)):
		for column in int(ceil(rect.size.x / tile.x)):
			var panel := TextureRect.new()
			panel.name = key.to_pascal_case()
			panel.texture = texture_for(key)
			panel.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			panel.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			panel.position = rect.position + Vector2(column * tile.x, row * tile.y)
			panel.size = Vector2(minf(tile.x, rect.end.x - panel.position.x), minf(tile.y, rect.end.y - panel.position.y))
			panel.self_modulate = tint
			panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
			parent.add_child(panel)

func _rect(parent: Node, rect: Rect2, color: Color) -> void:
	var panel := Polygon2D.new()
	panel.color = color
	panel.polygon = PackedVector2Array([rect.position, rect.position + Vector2(rect.size.x, 0), rect.end, rect.position + Vector2(0, rect.size.y)])
	parent.add_child(panel)

func _window(parent: Node2D, point: Vector2) -> void:
	var window := Sprite2D.new()
	window.name = "EstateWindow"
	_set_sprite(window, "window", 150, point + Vector2(45, 128), Color("#68767a"))
	parent.add_child(window)

func dress_surfaces(room: Node2D) -> void:
	var backdrop: Node2D = room.get_node("Backdrop")
	if room.zone_id == "ground":
		# Path B: retire the painted glass/safe-lane hints; ordinary flooring
		# and actual rugs communicate the existing surface rules honestly.
		backdrop.get_node("BrokenGlass").hide()
		backdrop.get_node("CarpetBypass").hide()
	elif room.zone_id == "basement":
		backdrop.get_node("Water").color = Color(0.13, 0.31, 0.31, 0.56)
		for x in range(920, 1980, 63):
			var y := 381.0 + float((x * 17) % 137)
			_rect(backdrop, Rect2(x, y, 23, 1), Color(0.45, 0.62, 0.57, 0.25))
		_rect(backdrop, Rect2(900, 543, 1100, 2), Color(0.29, 0.45, 0.39, 0.38))
	elif room.zone_id == "upper":
		backdrop.get_node("LinenShadowLane").hide()
		_tile_band(backdrop, "tile_floor", Rect2(2700, 550, 3600, 74), Vector2(116, 74), Color(0.28, 0.25, 0.31, 0.28))
		for x in [2650, 4300, 5950]:
			backdrop.get_node("Moonlight" + str(x)).hide()
			var light := ColorRect.new()
			light.position = Vector2(x, 355)
			light.size = Vector2(650, 180)
			light.mouse_filter = Control.MOUSE_FILTER_IGNORE
			var material := ShaderMaterial.new()
			material.shader = preload("res://shaders/floor_moonlight.gdshader")
			light.material = material
			backdrop.add_child(light)
