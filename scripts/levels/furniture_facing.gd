extends Node
## Orientation changes presentation only. Physical placement remains owned by the room.
const INWARD := {"back": "down", "front": "up", "left": "right", "right": "left"}
const VECTORS := {"down": Vector2.DOWN, "up": Vector2.UP, "right": Vector2.RIGHT, "left": Vector2.LEFT}
var room: Node2D
var art: RefCounted
var entries: Array[Dictionary] = []
var zones: Array[Dictionary] = []

func configure(owner_room: Node2D, owner_art: RefCounted) -> void:
	room = owner_room
	art = owner_art
	entries = art.facing_entries
	zones = art.facing_zones
	refresh()

func _process(_delta: float) -> void:
	for entry in entries:
		if is_instance_valid(entry.anchor) and entry.anchor.global_transform != entry.get("last_transform"):
			_refresh_entry(entry)

func refresh() -> void:
	for entry in entries:
		if is_instance_valid(entry.anchor):
			_refresh_entry(entry)

func _refresh_entry(entry: Dictionary) -> void:
	var anchor: Node2D = entry.anchor
	var transform := room.global_transform.affine_inverse() * anchor.global_transform
	var footprint: Rect2 = transform * entry.footprint
	var facing := resolve(footprint, zones, room.blockers, entry.original_footprint)
	entry.last_transform = anchor.global_transform
	anchor.set_meta("furniture_facing", facing)
	var visual: Node2D = entry.visual
	var spec: Dictionary = visual.get_meta("furniture_spec")
	var profile: Dictionary = art.data.get("furniture_facing", {}).get(str(spec.asset), {})
	var native: String = profile.get("native", "authored")
	var variants: Dictionary = profile.get("variants", {})
	var sprite: Sprite2D = visual.get_node("Sprite2D")
	# Always restore the original before resolving, including after moving back from a variant.
	art._set_sprite(sprite, str(spec.asset), float(spec.width), entry.sprite_position, entry.tint)
	sprite.flip_h = bool(spec.get("flip", false))
	for detail in entry.details:
		detail.node.position = detail.position
	anchor.set_meta("furniture_facing_applied", native)
	anchor.remove_meta("missing_furniture_view")
	if facing == "authored" or facing == native:
		return
	if not variants.has(facing):
		anchor.set_meta("missing_furniture_view", str(spec.asset) + ":" + facing)
		return
	var variant: Dictionary = variants[facing]
	# Asymmetric tabletop details need explicit offsets in each new view.
	var offsets: Array = variant.get("detail_offsets", [])
	if not _view_exists(str(variant.get("asset", ""))) or offsets.size() != entry.details.size():
		anchor.set_meta("missing_furniture_view", str(spec.asset) + ":" + facing)
		return
	art._set_sprite(sprite, str(variant.asset), float(spec.width), entry.sprite_position, entry.tint)
	sprite.flip_h = false
	for i in offsets.size():
		entry.details[i].node.position = Vector2(offsets[i][0], offsets[i][1])
	anchor.set_meta("furniture_facing_applied", facing)

func _view_exists(key: String) -> bool:
	if not art.data.textures.has(key):
		return false
	var path: String = art.data.textures[key].get("file", "")
	if not path.begins_with("res://"):
		path = str(art.data.asset_root) + path
	return ResourceLoader.exists(path)

func missing_views() -> Dictionary:
	var missing := {}
	for entry in entries:
		if is_instance_valid(entry.anchor) and entry.anchor.has_meta("missing_furniture_view"):
			var key: String = entry.anchor.get_meta("missing_furniture_view")
			if not missing.has(key):
				missing[key] = []
			missing[key].append(str(entry.anchor.name))
	return missing

static func resolve(footprint: Rect2, facing_zones: Array[Dictionary], blockers: Array[Rect2], own_blocker: Rect2 = Rect2()) -> String:
	var candidates: Array[String] = []
	for zone in facing_zones:
		if INWARD.has(str(zone.wall)) and footprint.intersects(zone.rect):
			var facing: String = INWARD[str(zone.wall)]
			if facing not in candidates:
				candidates.append(facing)
	var selected := "authored"
	var best := -1.0
	# Stable tie order, independent of JSON ordering.
	for facing: String in ["down", "up", "right", "left"]:
		if facing not in candidates:
			continue
		var clearance := _clearance(footprint, VECTORS[facing], blockers, own_blocker)
		if clearance > best:
			best = clearance
			selected = facing
	return selected

static func _clearance(footprint: Rect2, direction: Vector2, blockers: Array[Rect2], own_blocker: Rect2) -> float:
	var free := 4096.0
	for blocker in blockers:
		if blocker == own_blocker:
			continue
		# Measure a corridor as wide as the furniture, from its inward-facing edge.
		if direction.x != 0.0:
			if blocker.end.y <= footprint.position.y or blocker.position.y >= footprint.end.y:
				continue
			var gap := blocker.position.x - footprint.end.x if direction.x > 0 else footprint.position.x - blocker.end.x
			if gap >= 0:
				free = minf(free, gap)
		else:
			if blocker.end.x <= footprint.position.x or blocker.position.x >= footprint.end.x:
				continue
			var gap := blocker.position.y - footprint.end.y if direction.y > 0 else footprint.position.y - blocker.end.y
			if gap >= 0:
				free = minf(free, gap)
	return free
