extends "res://scripts/ui/image_state_menu.gd"
## A consistent native page over the estate scenery. Input stays in ImageStateMenu.
const Style := preload("res://scripts/ui/ui_style.gd")
const Typography := preload("res://scripts/ui/menu_typography.gd")
var native_ui := true
var heading_label: Label
var detail_label: Label
var footer_label: Label
var highlights: Array[ColorRect] = []
var reveal: Tween
var shade: ColorRect
var reveal_seconds := 0.16
var reveal_background := false

func build_sheet(title: String, description: String, items: Array[Dictionary], eyebrow: String = "LIBERTAS VINCTA  /  HOLLOWMERE ESTATE") -> void:
	Typography.enlarge_body.call_deferred(self)
	theme = Typography.menu_theme()
	var base := GradientTexture2D.new()
	base.width = 1280
	base.height = 720
	base.gradient = Gradient.new()
	for item in items:
		item.texture = null
	build(base, items, false)
	active_art.hide()
	cover_background(preload("res://assets/ui/menu/hollowmere_dark_menu.png"))
	shade = ColorRect.new()
	shade.color = Color(0.018, 0.027, 0.037, 0.88)
	shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(shade)
	move_child(shade, 2)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	Style.label(design, eyebrow, Rect2(84, 49, 1050, 24), 11, Style.BRASS)
	heading_label = Style.label(design, title, Rect2(80, 95, 1100, 75), 52, Style.PAPER, true)
	heading_label.add_theme_font_override("font", Typography.TITLE)
	detail_label = Style.label(design, description, Rect2(84, 179, 1060, 46), 16, Style.MUTED)
	detail_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	Style.rule(design, Rect2(84, 236, 1112, 1))
	Style.rule(design, Rect2(84, 602, 1112, 1))
	footer_label = Style.label(design, "↑ ↓  Navigate     Enter  Select     Esc Back", Rect2(540, 631, 656, 28), 14, Style.MUTED)
	footer_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	for i in buttons.size():
		var button := buttons[i]
		button.text = str(items[i].get("label", items[i].id.capitalize()))
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.add_theme_font_override("font", get_theme_default_font())
		button.add_theme_font_size_override("font_size", 18)
		for state in ["normal", "hover", "pressed", "focus", "hover_pressed"]:
			button.add_theme_stylebox_override(state, Style.panel(Color(0.03, 0.04, 0.05, 0.35), Color(0.33, 0.29, 0.24, 0.5)))
		for color in ["font_color", "font_hover_color", "font_focus_color", "font_pressed_color", "font_hover_pressed_color"]:
			button.add_theme_color_override(color, Style.PAPER)
		var glow := ColorRect.new()
		glow.color = Color(0.43, 0.045, 0.065, 0.75)
		var material := ShaderMaterial.new()
		material.shader = preload("res://shaders/menu_hover.gdshader")
		glow.material = material
		glow.modulate.a = 0.0
		glow.mouse_filter = Control.MOUSE_FILTER_IGNORE
		glow.show_behind_parent = true
		button.add_child(glow)
		glow.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		highlights.append(glow)

func update_visual_state() -> void:
	pass

func focus_default() -> void:
	super.focus_default()
	if reveal != null and reveal.is_valid():
		reveal.kill()
	var target: Control = self if reveal_background else design
	target.modulate.a = 0.0
	reveal = create_tween()
	reveal.tween_property(target, "modulate:a", 1.0, reveal_seconds).set_trans(Tween.TRANS_SINE)

func _process(delta: float) -> void:
	if not is_visible_in_tree():
		return
	for i in highlights.size():
		var active := i == current_index and (buttons[i].has_focus() or buttons[i].is_hovered())
		highlights[i].modulate.a = move_toward(highlights[i].modulate.a, 1.0 if active else 0.0, delta / 0.12)

func section(title: String, x: float, y: float, width: float = 512) -> void:
	Style.label(design, title.to_upper(), Rect2(x, y, width, 26), 12, Style.BRASS)

func paragraph(title: String, body: String, x: float, y: float, width: float = 512) -> void:
	Style.label(design, title, Rect2(x, y, width, 32), 23, Style.PAPER)
	var text := Style.label(design, body, Rect2(x, y + 40, width, 86), 18, Style.MUTED)
	text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	text.add_theme_constant_override("line_spacing", 4)
