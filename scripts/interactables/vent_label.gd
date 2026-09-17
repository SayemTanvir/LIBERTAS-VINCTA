extends Node2D
## Floating label showing vent destination room name.
## Attached as a child of vent BaseInteractable nodes.

var destination_floor: String = ""
var entrance_id: String = ""
var _label: Label

func _ready() -> void:
	_label = Label.new()
	_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_label.position = Vector2(-100, -58)
	_label.size = Vector2(200, 22)
	_label.z_index = 50
	_label.add_theme_font_size_override("font_size", 14)
	_label.add_theme_color_override("font_color", Color("d8d5b9"))
	_label.add_theme_color_override("font_shadow_color", Color("171d19"))
	_label.add_theme_constant_override("shadow_offset_y", 1)
	add_child(_label)
	_resolve_destination_name()
	_position_label.call_deferred()

func _position_label() -> void:
	var sprite := get_parent().get_node_or_null("Visual/Sprite2D") as Sprite2D
	if sprite != null and sprite.texture != null:
		_label.position.y = sprite.position.y + (sprite.get_rect().position.y + sprite.offset.y) * sprite.scale.y - 25.0

func _resolve_destination_name() -> void:
	## Look up which room contains the entrance vent on the destination floor.
	var layout_path := "res://data/estate_layout.json"
	if not FileAccess.file_exists(layout_path):
		return
	var file := FileAccess.open(layout_path, FileAccess.READ)
	if file == null:
		return
	var data: Variant = JSON.parse_string(file.get_as_text())
	file.close()
	if data == null or not data is Dictionary:
		return
	var floor_data: Dictionary = data.get(destination_floor, {})
	var rooms: Array = floor_data.get("rooms", [])
	var props: Array = floor_data.get("props", [])
	# Find the entrance vent's x position
	var entrance_x := -1.0
	for prop in props:
		if prop is Array and prop.size() >= 3 and str(prop[1]) == entrance_id:
			entrance_x = float(prop[2])
			break
	if entrance_x < 0.0:
		return
	# Find which room contains that x position
	for room in rooms:
		if room is Dictionary and float(room.get("start", 0)) <= entrance_x and entrance_x < float(room.get("end", 0)):
			_label.text = "Vent to " + str(room.get("name", "Unknown"))
			return
