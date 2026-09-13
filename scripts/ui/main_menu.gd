extends "res://scripts/ui/image_state_menu.gd"
@export var pause_context: bool = false

func _ready() -> void:
	preload("res://scripts/ui/menu_art.gd").main(self, pause_context)
	value_requested.connect(func(_index: int, direction: int):
		if entries[current_index].id == "rules" and direction > 0:
			selected.emit("controls"))

func layout_artwork() -> void:
	if pause_context:
		super.layout_artwork()
		return
	if design == null:
		return
	# Uniform scaling preserves the artwork's proportions and covers every edge.
	# The regenerated widescreen scene supplies the formerly missing top/bottom.
	var factor := maxf(size.x / reference_size.x, size.y / reference_size.y)
	design.scale = Vector2.ONE * factor
	design.position = (size - reference_size * factor) * 0.5
