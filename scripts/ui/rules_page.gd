extends "res://scripts/ui/image_state_menu.gd"
signal controls_requested

func _ready() -> void:
	preload("res://scripts/ui/menu_art.gd").single(self, "05_Rules", "rules_screen_back_active", Rect2(673, 850, 326, 78))
	selected.connect(func(_id: String): back_requested.emit())
	# No Controls button exists in the art. Right opens the companion page.
	value_requested.connect(func(_index: int, direction: int):
		if direction > 0:
			controls_requested.emit())

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		accept_event()
		controls_requested.emit()
