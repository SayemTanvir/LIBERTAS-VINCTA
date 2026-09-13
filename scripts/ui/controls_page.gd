extends "res://scripts/ui/image_state_menu.gd"

func _ready() -> void:
	preload("res://scripts/ui/menu_art.gd").single(self, "06_Controls", "controls_screen_back_active", Rect2(646, 736, 389, 91))
	selected.connect(func(_id: String): back_requested.emit())
