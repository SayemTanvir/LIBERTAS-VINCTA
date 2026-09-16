extends "res://scripts/ui/menu_sheet.gd"
signal controls_requested

func _ready() -> void:
	build_sheet("How to play", "A survival horror story about the price of freedom.", [
		{"id": "back", "label": "‹  Back", "rect": Rect2(84, 620, 160, 46)},
		{"id": "controls", "label": "Controls  ›", "rect": Rect2(270, 620, 208, 46)}])
	paragraph("01  Explore with care", "Search the estate for letters, tools and a way out. Stand near an object and use E when its prompt appears.", 84, 267)
	paragraph("02  Every freedom has a price", "Breaking a ward restores one of your senses and one of the Hound's. Read the letters before deciding what to unseal.", 684, 267)
	paragraph("03  Stay unheard, stay unseen", "Crouch to quiet your steps. Break line of sight, lower the flashlight and use hiding places. Sprinting makes noise and drains charge faster.", 84, 428)
	paragraph("04  Prepare for what follows", "Use cyan power stations to replenish charge. Open the field guide with H for the abilities and objectives available on your route.", 684, 428)
	selected.connect(func(id: String):
		if id == "controls": controls_requested.emit()
		else: back_requested.emit())
	value_requested.connect(func(_index: int, direction: int):
		if direction > 0: controls_requested.emit())

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		accept_event()
		controls_requested.emit()
