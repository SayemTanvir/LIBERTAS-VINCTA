extends "res://scripts/ui/image_state_menu.gd"
const Art = preload("res://scripts/ui/menu_art.gd")
var values: Control

func _ready() -> void:
	var base := Art.texture("04_Settings/restored/settings_clean_controls.png")
	var control_art := Art.texture("04_Settings/restored/settings_wide_resolution_active.png")
	var highlights := Art.texture("04_Settings/restored/settings_highlight_regions.png")
	var ids := ["master_volume", "music", "sfx", "resolution", "fullscreen", "screen_shake", "back"]
	var ys := [292, 357, 421, 522, 589, 654, 730]
	var heights := [65, 64, 70, 67, 65, 69, 91]
	var items: Array[Dictionary] = []
	for i in ids.size():
		var rect := Rect2(560, ys[i], 550, heights[i]) if i < 6 else Rect2(654, 730, 365, 91)
		items.append({"id": ids[i], "rect": rect, "texture": region(control_art if i == 3 else highlights, rect)})
	build(base, items, false)
	var neutral := texture_layer(region(base, Rect2(560, 522, 550, 67)), Rect2(560, 522, 550, 67))
	design.move_child(neutral, 1)
	Art.blend_regions(self, neutral)
	# Extend scenery to the viewport edges at other aspect ratios as well.
	var backdrop := TextureRect.new()
	backdrop.texture = base
	backdrop.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	backdrop.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	backdrop.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(backdrop)
	move_child(backdrop, 1)
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	values = preload("res://scripts/ui/settings_values.gd").new()
	values.source = control_art
	values.paper_source = base
	values.size = reference_size
	design.add_child(values)
	value_requested.connect(adjust)
	selected.connect(_accept)
	for i in buttons.size() - 1:
		buttons[i].gui_input.connect(_pointer_value.bind(i))

func layout_artwork() -> void:
	if design == null:
		return
	# Keep the parchment full-height; narrower screens crop only side scenery.
	# The extended backdrop fills any additional width on ultrawide screens.
	var factor := size.y / reference_size.y
	design.scale = Vector2.ONE * factor
	design.position = (size - reference_size * factor) * 0.5

func focus_default() -> void:
	values.queue_redraw()
	super.focus_default()

func adjust(index: int, direction: int) -> void:
	match index:
		0, 1, 2:
			var bus: String = ["Master", "Music", "SFX"][index]
			SessionSettings.set_volume(bus, float(SessionSettings.volumes[bus]) + direction * 0.05)
		3:
			var current := SessionSettings.RESOLUTIONS.find(SessionSettings.resolution)
			SessionSettings.set_resolution(SessionSettings.RESOLUTIONS[wrapi(current + direction, 0, SessionSettings.RESOLUTIONS.size())])
		4: SessionSettings.set_fullscreen(not SessionSettings.fullscreen)
		5: SessionSettings.set_screen_shake(not SessionSettings.screen_shake)
	values.queue_redraw()

func _accept(id: String) -> void:
	if id == "back":
		back_requested.emit()
	elif current_index in [4, 5]:
		adjust(current_index, 1)

func _pointer_value(event: InputEvent, index: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		set_selection(index)
		var point: Vector2 = buttons[index].position + event.position
		if event.button_index in [MOUSE_BUTTON_WHEEL_UP, MOUSE_BUTTON_WHEEL_DOWN]:
			adjust(index, 1 if event.button_index == MOUSE_BUTTON_WHEEL_UP else -1)
			buttons[index].accept_event()
		elif event.button_index == MOUSE_BUTTON_LEFT:
			if index < 3 and point.x >= 790:
				SessionSettings.set_volume(["Master", "Music", "SFX"][index], (point.x - 802) / 196.0)
			elif index == 3:
				adjust(index, -1 if point.x < 941 else 1)
			values.queue_redraw()
