extends Control
signal close_requested
var design: Control
var title_label: Label
var content: RichTextLabel
var scroll: ScrollContainer
var closing: bool = false

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	design = Control.new()
	design.size = Vector2(1254, 1254)
	add_child(design)
	var paper := TextureRect.new()
	paper.texture = preload("res://assets/BG/01_Message_UI/collectible_letter_parchment_scroll.png")
	paper.size = design.size
	paper.mouse_filter = Control.MOUSE_FILTER_IGNORE
	design.add_child(paper)
	var font := SystemFont.new()
	font.font_names = PackedStringArray(["Georgia", "Times New Roman"])
	title_label = Label.new()
	title_label.position = Vector2(250, 290)
	title_label.size = Vector2(754, 80)
	title_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.add_theme_font_override("font", font)
	title_label.add_theme_font_size_override("font_size", 42)
	title_label.add_theme_color_override("font_color", Color(0.24, 0.08, 0.035))
	title_label.add_theme_color_override("font_shadow_color", Color.TRANSPARENT)
	design.add_child(title_label)
	scroll = ScrollContainer.new()
	scroll.position = Vector2(250, 390)
	scroll.size = Vector2(754, 535)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
	design.add_child(scroll)
	content = RichTextLabel.new()
	content.fit_content = true
	content.scroll_active = false
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_theme_font_override("normal_font", font)
	content.add_theme_font_size_override("normal_font_size", 36)
	content.add_theme_color_override("default_color", Color(0.12, 0.065, 0.03))
	content.add_theme_color_override("font_shadow_color", Color.TRANSPARENT)
	scroll.add_child(content)
	var hint := Label.new()
	hint.text = "E / ENTER / ESC  ·  Close      ↑ / ↓ / Wheel  ·  Read"
	hint.position = Vector2(250, 943)
	hint.size = Vector2(754, 50)
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.add_theme_font_override("font", font)
	hint.add_theme_font_size_override("font_size", 24)
	hint.add_theme_color_override("font_color", Color(0.24, 0.13, 0.06))
	hint.add_theme_color_override("font_shadow_color", Color.TRANSPARENT)
	design.add_child(hint)
	resized.connect(_layout)
	_layout()
	hide()

func _layout() -> void:
	var factor := minf(size.x / 1254.0, size.y / 1254.0)
	design.scale = Vector2.ONE * factor
	design.position = (size - design.size * factor) * 0.5

func open(title: String, text: String) -> void:
	title_label.text = title
	content.text = text.replace("\\n", "\n")
	scroll.scroll_vertical = 0
	closing = false
	show()

func _input(event: InputEvent) -> void:
	if not is_visible_in_tree():
		return
	# Keep wheel events available to the scroll container; all game actions stop here.
	if event is InputEventMouseMotion:
		return
	if event is InputEventMouseButton:
		if event.pressed and event.button_index in [MOUSE_BUTTON_WHEEL_UP, MOUSE_BUTTON_WHEEL_DOWN]:
			scroll.scroll_vertical += -90 if event.button_index == MOUSE_BUTTON_WHEEL_UP else 90
		get_viewport().set_input_as_handled()
		return
	get_viewport().set_input_as_handled()
	if closing or event.is_echo():
		return
	if event.is_action_pressed("interact") or event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_cancel") or event.is_action_pressed("pause"):
		closing = true
		close_requested.emit()
	elif event.is_action_pressed("ui_down"):
		scroll.scroll_vertical += 90
	elif event.is_action_pressed("ui_up"):
		scroll.scroll_vertical -= 90
