extends "res://scripts/ui/image_state_menu.gd"
@export var chapter: bool = false

func _ready() -> void:
	preload("res://scripts/ui/menu_art.gd").result(self, chapter)
