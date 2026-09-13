extends Control
## One selection owns artwork, focus, pointer and accepted action.
signal selected(destination: String)
signal back_requested
signal selection_changed(index: int)
signal value_requested(index: int, direction: int)
var current_index: int = 0
var buttons: Array[Button] = []
var entries: Array[Dictionary] = []
var state_textures: Array[Texture2D] = []
var design: Control
var artwork: TextureRect
var active_art: TextureRect
var reference_size: Vector2
var full_states: bool = true
var _selecting: bool = false
var _axis_down: Dictionary = {}

static func region(texture: Texture2D, rect: Rect2) -> AtlasTexture:
	var atlas := AtlasTexture.new()
	atlas.atlas = texture
	atlas.region = rect
	atlas.filter_clip = true
	return atlas

func texture_layer(texture: Texture2D, rect: Rect2) -> TextureRect:
	var layer := TextureRect.new()
	layer.texture = texture
	layer.position = rect.position
	layer.size = rect.size
	layer.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	design.add_child(layer)
	return layer

func build(base: Texture2D, items: Array[Dictionary], whole_images: bool = true) -> void:
	entries = items
	full_states = whole_images
	reference_size = base.get_size()
	mouse_filter = Control.MOUSE_FILTER_STOP
	var surround := ColorRect.new()
	surround.color = Color.BLACK
	surround.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(surround)
	surround.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	design = Control.new()
	design.name = "ArtworkAndHotspots"
	design.mouse_filter = Control.MOUSE_FILTER_IGNORE
	design.size = reference_size
	add_child(design)
	artwork = texture_layer(base, Rect2(Vector2.ZERO, reference_size))
	active_art = texture_layer(null, Rect2(Vector2.ZERO, reference_size))
	for i in entries.size():
		state_textures.append(entries[i].texture)
		var button := Button.new()
		button.name = entries[i].id.to_pascal_case() + "Hotspot"
		button.position = entries[i].rect.position
		button.size = entries[i].rect.size
		button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		for style in ["normal", "hover", "pressed", "focus", "disabled", "hover_pressed"]:
			button.add_theme_stylebox_override(style, StyleBoxEmpty.new())
		design.add_child(button)
		buttons.append(button)
		button.mouse_entered.connect(func():
			if is_visible_in_tree() and can_process():
				set_selection(i))
		button.focus_entered.connect(func(): set_selection(i))
		button.pressed.connect(func():
			set_selection(i)
			activate_selection())
	for i in buttons.size():
		buttons[i].focus_neighbor_top = buttons[i].get_path_to(buttons[wrapi(i - 1, 0, buttons.size())])
		buttons[i].focus_neighbor_bottom = buttons[i].get_path_to(buttons[(i + 1) % buttons.size()])
		buttons[i].focus_previous = buttons[i].focus_neighbor_top
		buttons[i].focus_next = buttons[i].focus_neighbor_bottom
	resized.connect(layout_artwork)
	layout_artwork()
	update_visual_state()

func layout_artwork() -> void:
	if design == null:
		return
	var factor := minf(size.x / reference_size.x, size.y / reference_size.y)
	design.scale = Vector2.ONE * factor
	design.position = (size - reference_size * factor) * 0.5

func set_selection(index: int, sound: bool = true) -> void:
	if _selecting or buttons.is_empty():
		return
	_selecting = true
	var next := wrapi(index, 0, buttons.size())
	var changed := next != current_index
	current_index = next
	update_visual_state()
	if is_visible_in_tree() and can_process():
		buttons[current_index].grab_focus()
	_selecting = false
	if changed:
		if sound:
			EventBus.audio_requested.emit("ui_hover")
		selection_changed.emit(current_index)

func update_visual_state() -> void:
	active_art.texture = state_textures[current_index]
	var rect: Rect2 = Rect2(Vector2.ZERO, reference_size) if full_states else entries[current_index].get("visual_rect", entries[current_index].rect)
	active_art.position = rect.position
	active_art.size = rect.size

func focus_default() -> void:
	_axis_down.clear()
	set_selection(current_index, false)

func activate_selection() -> void:
	EventBus.audio_requested.emit("ui_confirm")
	selected.emit(entries[current_index].id)

func _input(event: InputEvent) -> void:
	if not is_visible_in_tree() or not can_process():
		return
	if event is InputEventJoypadMotion:
		for action in ["ui_up", "ui_down", "ui_left", "ui_right"]:
			if not event.is_action(action):
				continue
			var down := event.is_action_pressed(action)
			var was_down: bool = _axis_down.get(action, false)
			_axis_down[action] = down
			if down and not was_down:
				_perform_action(action)
		get_viewport().set_input_as_handled()
		return
	# Consume echoes too so the GUI cannot perform a second focus movement.
	for action in ["ui_up", "ui_down", "ui_left", "ui_right", "ui_accept", "ui_cancel", "ui_focus_next", "ui_focus_prev", "pause"]:
		if event.is_action(action):
			get_viewport().set_input_as_handled()
			if not event.is_action_pressed(action) or event.is_echo():
				return
			_perform_action(action)
			return

func _perform_action(action: String) -> void:
	match action:
		"ui_up", "ui_focus_prev": set_selection(current_index - 1)
		"ui_down", "ui_focus_next": set_selection(current_index + 1)
		"ui_left": value_requested.emit(current_index, -1)
		"ui_right": value_requested.emit(current_index, 1)
		"ui_accept": activate_selection()
		"ui_cancel", "pause":
			EventBus.audio_requested.emit("ui_back")
			back_requested.emit()
