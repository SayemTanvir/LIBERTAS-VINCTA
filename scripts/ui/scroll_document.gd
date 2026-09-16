extends Control
## Original parchment art, animated unroll, shaped pages, and pause-safe typewriting.
signal close_requested
const PAPER := preload("res://assets/BG/01_Message_UI/collectible_letter_parchment_scroll.png")
const FONT_SIZE := 36
const TEXT_WIDTH := 754.0
const PAGE_HEIGHT := 510.0
var design: Control
var paper: TextureRect
var title_label: Label
var content: RichTextLabel
var page_label: Label
var previous: Button
var next: Button
var close_button: Button
var full_text := ""
var pages: Array[String] = []
var page_index := 0
var unroll := 0.0
var typing := false
var revealing := 0.0
var opening := false
var closing := false
var motion: Tween
var font := SystemFont.new()

func _ready() -> void:
	font.font_names = PackedStringArray(["Georgia", "Times New Roman"])
	mouse_filter = Control.MOUSE_FILTER_STOP
	design = Control.new()
	design.size = Vector2(1254, 1254)
	add_child(design)
	paper = TextureRect.new()
	paper.texture = PAPER
	paper.size = design.size
	paper.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	paper.mouse_filter = Control.MOUSE_FILTER_IGNORE
	design.add_child(paper)
	title_label = _label(Rect2(250, 276, 754, 94), 40)
	title_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content = RichTextLabel.new()
	content.position = Vector2(250, 390)
	content.size = Vector2(TEXT_WIDTH, PAGE_HEIGHT)
	content.scroll_active = false
	content.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_theme_font_override("normal_font", font)
	content.add_theme_font_size_override("normal_font_size", FONT_SIZE)
	content.add_theme_constant_override("line_separation", 0)
	content.add_theme_color_override("default_color", Color("302113"))
	content.add_theme_color_override("font_shadow_color", Color.TRANSPARENT)
	content.mouse_filter = Control.MOUSE_FILTER_IGNORE
	design.add_child(content)
	page_label = _label(Rect2(250, 906, 754, 38), 24)
	previous = _button("Previous", Rect2(242, 958, 225, 56), func(): turn_page(-1))
	next = _button("Next", Rect2(497, 958, 225, 56), func(): turn_page(1))
	close_button = _button("Close / Esc", Rect2(752, 958, 260, 56), request_close)
	resized.connect(_layout)
	_layout()

func _label(rect: Rect2, font_size: int) -> Label:
	var label := Label.new()
	label.position = rect.position
	label.size = rect.size
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_override("font", font)
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", Color("502b17"))
	label.add_theme_color_override("font_shadow_color", Color.TRANSPARENT)
	design.add_child(label)
	return label

func _button(text: String, rect: Rect2, callback: Callable) -> Button:
	var button := Button.new()
	button.text = text
	button.position = rect.position
	button.size = rect.size
	button.add_theme_font_override("font", font)
	button.add_theme_font_size_override("font_size", 27)
	for state in ["normal", "hover", "pressed", "focus"]:
		var box := StyleBoxFlat.new()
		box.bg_color = Color(0.22, 0.12, 0.05, 0.12 if state == "normal" else 0.3)
		button.add_theme_stylebox_override(state, box)
	button.add_theme_color_override("font_color", Color("3e2717"))
	button.add_theme_color_override("font_hover_color", Color("140d08"))
	button.add_theme_color_override("font_focus_color", Color("140d08"))
	button.pressed.connect(callback)
	design.add_child(button)
	return button

func _layout() -> void:
	var factor := maxf(0.1, minf(size.x / 1254.0, size.y / 1254.0))
	design.scale = Vector2.ONE * factor
	design.position = (size - design.size * factor) * 0.5

func open(title: String, text: String) -> void:
	if motion != null and motion.is_valid():
		motion.kill()
	title_label.text = title
	full_text = text.replace("\\n", "\n")
	pages.clear()
	var paragraph := TextParagraph.new()
	paragraph.width = TEXT_WIDTH
	paragraph.break_flags = TextServer.BREAK_MANDATORY | TextServer.BREAK_WORD_BOUND | TextServer.BREAK_GRAPHEME_BOUND
	paragraph.add_string(full_text, font, FONT_SIZE)
	var page_start := 0
	var height := 0.0
	for line in paragraph.get_line_count():
		var bounds := paragraph.get_line_range(line)
		var line_height := paragraph.get_line_size(line).y
		if height + line_height > PAGE_HEIGHT - font.get_height(FONT_SIZE) * 2.0 and bounds.x > page_start:
			pages.append(full_text.substr(page_start, bounds.x - page_start))
			page_start = bounds.x
			height = 0.0
		height += line_height
	pages.append(full_text.substr(page_start))
	page_index = 0
	closing = false
	opening = true
	typing = false
	unroll = 0.0
	_set_page(false)
	_update_roll()
	show()
	close_button.grab_focus()
	motion = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	motion.tween_property(self, "unroll", 1.0, 0.7)
	motion.tween_callback(func():
		opening = false
		typing = true)

func _update_roll() -> void:
	# The upper roll stays fixed while the lower roll unfurls downward.
	paper.scale.y = lerpf(0.12, 1.0, unroll)
	paper.position.y = 120.0 * (1.0 - paper.scale.y)
	for node in [title_label, content, page_label, previous, next, close_button]:
		node.modulate.a = smoothstep(0.8, 1.0, unroll)

func _set_page(typewrite := true) -> void:
	content.text = pages[page_index]
	content.visible_characters = 0
	revealing = 0.0
	typing = typewrite
	previous.disabled = page_index == 0
	next.disabled = page_index + 1 >= pages.size()
	page_label.text = "%d / %d   ·   Enter: reveal text   ·   ← →: pages" % [page_index + 1, pages.size()]

func turn_page(direction: int) -> void:
	if opening or closing:
		return
	var target := clampi(page_index + direction, 0, pages.size() - 1)
	if target != page_index:
		page_index = target
		_set_page()

func reveal_page() -> void:
	if opening or closing:
		return
	content.visible_characters = -1
	typing = false

func _process(delta: float) -> void:
	if not is_visible_in_tree():
		return
	_update_roll()
	if typing and not opening and not closing:
		revealing += delta * 55.0
		content.visible_characters = mini(int(revealing), content.get_total_character_count())
		if content.visible_characters >= content.get_total_character_count():
			typing = false

func request_close() -> void:
	if closing:
		return
	closing = true
	typing = false
	if motion != null and motion.is_valid():
		motion.kill()
	motion = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	motion.tween_property(self, "unroll", 0.0, 0.25)
	motion.tween_callback(func(): close_requested.emit())

func _input(event: InputEvent) -> void:
	if not is_visible_in_tree() or event is InputEventMouseMotion:
		return
	if event is InputEventMouseButton:
		if event.pressed and event.button_index in [MOUSE_BUTTON_WHEEL_UP, MOUSE_BUTTON_WHEEL_DOWN]:
			turn_page(-1 if event.button_index == MOUSE_BUTTON_WHEEL_UP else 1)
			get_viewport().set_input_as_handled()
		return
	get_viewport().set_input_as_handled()
	if event.is_echo():
		return
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("pause"):
		request_close()
	elif event.is_action_pressed("ui_right") or event.is_action_pressed("ui_down"):
		turn_page(1)
	elif event.is_action_pressed("ui_left") or event.is_action_pressed("ui_up"):
		turn_page(-1)
	elif event.is_action_pressed("interact") or event.is_action_pressed("ui_accept"):
		if typing:
			reveal_page()
		elif page_index + 1 < pages.size():
			turn_page(1)
		else:
			request_close()
