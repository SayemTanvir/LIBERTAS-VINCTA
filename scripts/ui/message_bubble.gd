extends Control
## Shared paging with separate character speech and cinematic narration surfaces.
@export var narration: bool = false
const FONT_SIZE := 34
const PAGE_LINES := 4
var text_label: RichTextLabel
var design: Control
var bubble: TextureRect
var ornament: ColorRect
var page_hint: Label
var serif: SystemFont
var body: String = ""
var page_index: int = 0
var page_lines: int = PAGE_LINES
var pages: Array[String] = []
var follow_target: Node2D
var entrance: Tween
var exit_tween: Tween
var tail_on_right: bool = false

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	design = Control.new()
	design.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(design)
	bubble = TextureRect.new()
	bubble.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bubble.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bubble.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	design.add_child(bubble)
	if narration:
		var gradient := Gradient.new()
		gradient.offsets = PackedFloat32Array([0.0, 0.15, 0.5, 0.85, 1.0])
		gradient.colors = PackedColorArray([Color(0.02, 0.03, 0.04, 0.0), Color(0.02, 0.03, 0.04, 0.8), Color(0.02, 0.03, 0.04, 0.94), Color(0.02, 0.03, 0.04, 0.8), Color(0.02, 0.03, 0.04, 0.0)])
		var texture := GradientTexture2D.new()
		texture.gradient = gradient
		texture.width = 512
		texture.height = 32
		texture.fill_from = Vector2(0, 0.5)
		texture.fill_to = Vector2(1, 0.5)
		bubble.texture = texture
		ornament = ColorRect.new()
		ornament.color = Color("bda67c")
		ornament.mouse_filter = Control.MOUSE_FILTER_IGNORE
		design.add_child(ornament)
	else:
		bubble.texture = preload("res://scripts/ui/image_state_menu.gd").region(preload("res://assets/BG/01_Message_UI/dialogue_speech_bubbles_sprite_sheet.png"), Rect2(140, 535, 1170, 474))
		bubble.self_modulate = Color("d4d5c8")
	serif = SystemFont.new()
	serif.font_names = PackedStringArray(["Georgia", "Times New Roman"])
	text_label = RichTextLabel.new()
	text_label.scroll_active = false
	text_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	text_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	text_label.add_theme_color_override("default_color", Color("eee5d3") if narration else Color("251e17"))
	text_label.add_theme_color_override("font_shadow_color", Color.TRANSPARENT)
	text_label.add_theme_font_size_override("normal_font_size", FONT_SIZE)
	text_label.add_theme_font_override("normal_font", serif)
	design.add_child(text_label)
	page_hint = Label.new()
	page_hint.add_theme_font_size_override("font_size", 21)
	page_hint.add_theme_color_override("font_color", Color("bda67c") if narration else Color("665746"))
	page_hint.mouse_filter = Control.MOUSE_FILTER_IGNORE
	design.add_child(page_hint)
	resized.connect(_layout)
	show_text("", "")
	hide()

func _process(delta: float) -> void:
	if visible:
		_layout(delta)

func _content_width() -> float:
	var longest := 0.0
	for line in body.split("\n"):
		longest = maxf(longest, serif.get_string_size(line, HORIZONTAL_ALIGNMENT_LEFT, -1, FONT_SIZE).x)
	return clampf(longest + 12.0, 230.0, 1050.0 if narration else 620.0)

func _paginate() -> void:
	pages.clear()
	# Shape once, then split at actual wrapped line boundaries, including explicit newlines.
	var paragraph := TextParagraph.new()
	paragraph.width = _content_width()
	paragraph.break_flags = TextServer.BREAK_MANDATORY | TextServer.BREAK_WORD_BOUND | TextServer.BREAK_GRAPHEME_BOUND
	paragraph.add_string(body, serif, FONT_SIZE)
	for first_line in range(0, paragraph.get_line_count(), page_lines):
		var start := paragraph.get_line_range(first_line).x
		var last := mini(first_line + page_lines - 1, paragraph.get_line_count() - 1)
		var end := paragraph.get_line_range(last).y
		pages.append(body.substr(start, end - start).strip_edges())
	if pages.is_empty():
		pages.append("")
	page_index = mini(page_index, pages.size() - 1)

func _fit_bubble() -> void:
	text_label.text = pages[page_index]
	var width := _content_width()
	var text_height := serif.get_multiline_string_size(text_label.text, HORIZONTAL_ALIGNMENT_LEFT, width, FONT_SIZE).y + 12.0
	text_label.size = Vector2(width, text_height)
	text_height = maxf(text_height, text_label.get_content_height() + 8.0)
	text_label.size.y = text_height
	if narration:
		design.size = Vector2(width + 200.0, text_height + 90.0)
		text_label.position = Vector2(100, 38)
		ornament.position = Vector2(design.size.x * 0.5 - 45, 16)
		ornament.size = Vector2(90, 2)
	else:
		design.size = Vector2(width / 0.72, maxf(150.0, (text_height + 28.0) / 0.60))
		text_label.position = Vector2(design.size.x * 0.14, design.size.y * 0.13 + 10)
	bubble.size = design.size
	page_hint.text = "%d / %d" % [page_index + 1, pages.size()] if pages.size() > 1 else ""
	page_hint.position = Vector2(design.size.x * 0.5 - 24, design.size.y * (0.83 if narration else 0.73))
	_layout()

func _layout(delta: float = 0.0) -> void:
	if not is_instance_valid(design):
		return
	var factor := maxf(0.1, minf(size.x / 1280.0, size.y / 720.0) * (0.64 if narration else 0.55))
	design.scale = Vector2.ONE * factor
	var extent := design.size * factor
	var point := Vector2((size.x - extent.x) * 0.5, size.y - extent.y - 28)
	if not narration and is_instance_valid(follow_target):
		# Include camera tracking and zoom, then position the tail above the speaker.
		var head_offset := Vector2(0, -84)
		if follow_target.has_method("speech_anchor"):
			head_offset = follow_target.speech_anchor()
		var head := get_global_transform().affine_inverse() * (follow_target.get_global_transform_with_canvas() * head_offset)
		bubble.flip_h = tail_on_right
		var tail := 0.95 if tail_on_right else 0.05
		point = head - Vector2(extent.x * tail, extent.y + 4)
	point.x = clampf(point.x, 14.0, maxf(14.0, size.x - extent.x - 14))
	point.y = clampf(point.y, 94.0, maxf(94.0, size.y - extent.y - 16))
	design.position = design.position.lerp(point, 1.0 - exp(-20.0 * delta)) if delta > 0.0 and design.position.distance_to(point) < 240.0 else point

func show_text(speaker: String, content: String) -> void:
	body = (speaker + "\n" if not speaker.is_empty() and speaker != "ELS" else "") + content
	if is_instance_valid(follow_target):
		var head := get_global_transform().affine_inverse() * follow_target.get_global_transform_with_canvas().origin
		tail_on_right = head.x > size.x * 0.5
	page_index = 0
	page_lines = PAGE_LINES if narration else 3
	_paginate()
	_fit_bubble()
	if entrance != null and entrance.is_valid():
		entrance.kill()
	if exit_tween != null and exit_tween.is_valid():
		exit_tween.kill()
	design.modulate.a = 0.0
	show()
	entrance = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	entrance.tween_property(design, "modulate:a", 1.0, 0.16)

func dismiss() -> void:
	body = ""
	text_label.text = ""
	hide()

func fade_out(seconds: float) -> void:
	if exit_tween == null or not exit_tween.is_valid():
		exit_tween = create_tween()
		exit_tween.tween_property(design, "modulate:a", 0.0, seconds)

func advance_page() -> bool:
	if page_index + 1 >= pages.size():
		return false
	page_index += 1
	if exit_tween != null and exit_tween.is_valid():
		exit_tween.kill()
	_fit_bubble()
	design.modulate.a = 1.0
	return true
