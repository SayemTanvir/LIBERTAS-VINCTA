extends "res://scripts/ui/menu_sheet.gd"
var values: Control
var dragging: int = -1
const IDS := ["master_volume", "music", "sfx", "resolution", "fullscreen", "screen_shake", "ambience", "subtitles", "back"]
const AUDIO := {0: "Master", 1: "Music", 2: "SFX", 6: "Ambience"}

func _ready() -> void:
	var labels := ["Master volume", "Music", "Sound effects", "Resolution", "Fullscreen", "Screen shake", "Ambience", "Dialogue subtitles", "‹  Back"]
	var items: Array[Dictionary] = []
	for i in IDS.size():
		var row := i if i < 3 else (3 if i in [6, 7] else i - 3)
		var rect := Rect2(84 if AUDIO.has(i) else 684, 292 + row * 64, 512, 52)
		if i == 8:
			rect = Rect2(84, 620, 160, 46)
		items.append({"id": IDS[i], "label": labels[i], "rect": rect})
	build_sheet("Settings", "Make the estate your own. Changes apply immediately for this session.", items)
	section("Audio", 84, 258)
	section("Display & accessibility", 684, 258)
	values = preload("res://scripts/ui/settings_values.gd").new()
	values.size = reference_size
	values.menu = self
	design.add_child(values)
	value_requested.connect(adjust)
	selected.connect(_accept)
	for i in buttons.size() - 1:
		buttons[i].gui_input.connect(_pointer_value.bind(i))
	footer_label.text = "← →  Adjust    /    Drag sliders    /    Esc  Back"

func focus_default() -> void:
	values.queue_redraw()
	super.focus_default()

func adjust(index: int, direction: int) -> void:
	if AUDIO.has(index):
		var bus: String = AUDIO[index]
		SessionSettings.set_volume(bus, float(SessionSettings.volumes[bus]) + direction * 0.05)
	else:
		match IDS[index]:
			"resolution":
				var current := SessionSettings.RESOLUTIONS.find(SessionSettings.resolution)
				SessionSettings.set_resolution(SessionSettings.RESOLUTIONS[wrapi(current + direction, 0, SessionSettings.RESOLUTIONS.size())])
			"fullscreen": SessionSettings.set_fullscreen(not SessionSettings.fullscreen)
			"screen_shake": SessionSettings.set_screen_shake(not SessionSettings.screen_shake)
			"subtitles": SessionSettings.set_subtitles(not SessionSettings.subtitles_enabled)
	values.queue_redraw()

func _accept(id: String) -> void:
	if id == "back":
		back_requested.emit()
	elif id in ["fullscreen", "screen_shake", "subtitles"]:
		adjust(current_index, 1)

func _slider(index: int, local_x: float) -> void:
	SessionSettings.set_volume(AUDIO[index], (local_x - 228.0) / 192.0)
	values.queue_redraw()

func _pointer_value(event: InputEvent, index: int) -> void:
	if event is InputEventMouseMotion and dragging == index:
		_slider(index, event.position.x)
	elif event is InputEventMouseButton:
		if not event.pressed:
			dragging = -1
			return
		set_selection(index)
		if event.button_index in [MOUSE_BUTTON_WHEEL_UP, MOUSE_BUTTON_WHEEL_DOWN]:
			adjust(index, 1 if event.button_index == MOUSE_BUTTON_WHEEL_UP else -1)
			buttons[index].accept_event()
		elif event.button_index == MOUSE_BUTTON_LEFT:
			if AUDIO.has(index) and event.position.x >= 215:
				dragging = index
				_slider(index, event.position.x)
			elif index == 3:
				adjust(index, -1 if event.position.x < 365 else 1)
