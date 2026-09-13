extends Control
## Timed story speech and acknowledged messages share the same supplied bubble.
var text_label: RichTextLabel
var design: Control
var bubble: TextureRect
var serif: SystemFont
const FONT_SIZE := 34
var body: String = ""
var page_index: int = 0
var page_lines: int = 4

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	design = Control.new()
	design.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(design)
	bubble = TextureRect.new()
	bubble.texture = preload("res://scripts/ui/image_state_menu.gd").region(preload("res://assets/BG/01_Message_UI/dialogue_speech_bubbles_sprite_sheet.png"), Rect2(140, 535, 1170, 474))
	bubble.size = Vector2(1170, 474)
	bubble.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bubble.mouse_filter = Control.MOUSE_FILTER_IGNORE
	design.add_child(bubble)
	text_label = RichTextLabel.new()
	text_label.position = Vector2(150, 98)
	text_label.size = Vector2(870, 235)
	text_label.scroll_active = false
	text_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	text_label.add_theme_color_override("default_color", Color(0.1, 0.07, 0.04))
	text_label.add_theme_color_override("font_shadow_color", Color.TRANSPARENT)
	text_label.add_theme_font_size_override("normal_font_size", FONT_SIZE)
	serif = SystemFont.new()
	serif.font_names = PackedStringArray(["Georgia", "Times New Roman"])
	text_label.add_theme_font_override("normal_font", serif)
	design.add_child(text_label)
	resized.connect(_layout)
	_fit_bubble()
	hide()

func _layout() -> void:
	# Keep the original text scale, independently of the bubble's fitted size.
	var factor := minf(size.x * 0.9 / 1170.0, size.y * 0.36 / 474.0)
	design.scale = Vector2.ONE * factor
	design.position = Vector2((size.x - design.size.x * factor) * 0.5, size.y - design.size.y * factor - 14)

func _fit_bubble() -> void:
	var natural_width := 0.0
	for line in body.split("\n"):
		natural_width = maxf(natural_width, serif.get_string_size(line, HORIZONTAL_ALIGNMENT_LEFT, -1, FONT_SIZE).x)
	var content_width := clampf(natural_width + 20.0, 240.0, 870.0)
	text_label.size = Vector2(content_width, 235)
	var measured := serif.get_multiline_string_size(body, HORIZONTAL_ALIGNMENT_LEFT, content_width, FONT_SIZE)
	var lines := clampi(ceili(measured.y / serif.get_height(FONT_SIZE)), 1, page_lines)
	var height := 170.0 + (lines - 1) * (304.0 / 3.0)
	design.size = Vector2(content_width / (870.0 / 1170.0), height)
	bubble.size = design.size
	var text_height := 235.0 if lines == page_lines else minf(measured.y + 12.0, 235.0)
	text_label.position = Vector2((design.size.x - content_width) * 0.5, (height * 0.8 - text_height) * 0.5)
	text_label.size.y = text_height
	_layout()

func show_text(speaker: String, content: String) -> void:
	body = (speaker + "\n" if not speaker.is_empty() else "") + content
	text_label.text = body
	page_index = 0
	_fit_bubble()
	text_label.scroll_to_line(0)
	show()

func advance_page() -> bool:
	if (page_index + 1) * page_lines < text_label.get_line_count():
		page_index += 1
		text_label.scroll_to_line(page_index * page_lines)
		return true
	return false
