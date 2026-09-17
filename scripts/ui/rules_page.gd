extends "res://scripts/ui/menu_sheet.gd"
signal controls_requested

func _ready() -> void:
	build_sheet("How to play", "A survival horror story about the price of freedom.", [
		{"id": "back", "label": "‹  Back", "rect": Rect2(84, 620, 160, 46)},
		{"id": "controls", "label": "Controls  ›", "rect": Rect2(270, 620, 208, 46)}])
	var first_paragraph := design.get_child_count()
	detail_label.text += " Scroll for room names grouped by floor."
	paragraph("01  Explore with care", "Search the estate for letters, tools and a way out. Stand near an object and use E when its prompt appears.", 84, 267)
	paragraph("02  Every freedom has a price", "Breaking a ward restores one of your senses and one of the Hound's. Read the letters before deciding what to unseal.", 684, 267)
	paragraph("03  Stay unheard, stay unseen", "Crouch to quiet your steps. Break line of sight, lower the flashlight and use hiding places. Sprinting makes noise and drains charge faster.", 84, 428)
	paragraph("04  Prepare for what follows", "Use cyan power stations to replenish charge. H toggles room names grouped by floor; open Els' Field Guide from the help bar for abilities and objectives.", 684, 428)
	var paragraphs := design.get_children().slice(first_paragraph)
	var scroll := ScrollContainer.new()
	scroll.name = "InstructionsAndRooms"
	scroll.position = Vector2(84, 253)
	scroll.size = Vector2(1112, 338)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	design.add_child(scroll)
	var content := VBoxContainer.new()
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_theme_constant_override("separation", 16)
	scroll.add_child(content)
	var instructions := Control.new()
	instructions.custom_minimum_size.y = 350
	content.add_child(instructions)
	for label in paragraphs:
		label.reparent(instructions, false)
		label.position -= Vector2(84, 253)
	var title := Label.new()
	title.text = "Rooms by floor  /  H toggles the help bar during play"
	title.add_theme_color_override("font_color", Style.BRASS)
	content.add_child(title)
	for group in preload("res://scripts/systems/field_guide.gd").room_groups():
		var floor_label := Label.new()
		floor_label.text = group.floor
		floor_label.add_theme_color_override("font_color", Style.BRASS)
		content.add_child(floor_label)
		var rooms := Label.new()
		rooms.text = group.rooms
		rooms.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		rooms.add_theme_font_size_override("font_size", 18)
		rooms.add_theme_color_override("font_color", Style.MUTED)
		content.add_child(rooms)
	selected.connect(func(id: String):
		if id == "controls": controls_requested.emit()
		else: back_requested.emit())
	value_requested.connect(func(_index: int, direction: int):
		if direction > 0: controls_requested.emit())

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		accept_event()
		controls_requested.emit()
