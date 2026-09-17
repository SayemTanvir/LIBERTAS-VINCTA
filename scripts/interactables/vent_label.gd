extends Node2D
## Floating label showing vent destination room name.
## Attached as a child of vent BaseInteractable nodes.

var destination_floor: String = ""
var entrance_id: String = ""
var _label: Label
var _player: CharacterBody2D
const VISIBLE_RANGE := 200.0  # Same as interaction prompt range

func _ready() -> void:
	_label = Label.new()
	_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_label.position = Vector2(-80, -58)
	_label.z_index = 50
	_label.add_theme_font_size_override("font_size", 15)
	_label.add_theme_color_override("font_color", Color("f7f3d6"))
	_label.modulate = Color(1.0, 0.96, 0.82, 1.0)
	_label.visible = false
	add_child(_label)
	_resolve_destination_name()

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
			_label.text = "To: " + str(room.get("name", "Unknown"))
			return

func _process(_delta: float) -> void:
	if _player == null:
		_player = get_tree().get_first_node_in_group("player") as CharacterBody2D
	if _player == null or not is_instance_valid(_player):
		_label.visible = false
		return
	var dist := global_position.distance_to(_player.global_position)
	_label.visible = dist <= VISIBLE_RANGE and _label.text != ""
