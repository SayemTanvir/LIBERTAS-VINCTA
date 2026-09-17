extends "res://scripts/ui/image_state_menu.gd"
@export var pause_context: bool = false
@export var cinematic_stream: VideoStream
var menu_content: Control
var highlights: Array[ColorRect] = []
var button_spacing: Array[StyleBoxEmpty] = []
var selection_marks: Array[Label] = []
var selection_caption: Label
var caption_index := -1
var atmosphere_clock := 0.0
var reveal: Tween
var video_background: VideoStreamPlayer
const BACKGROUND := "res://assets/ui/menu/libertas_vincta_menu_background.png"
const VIDEO_BACKGROUND := "res://assets/ui/menu/PROJECT_Create_a_cinematic_ani.ogv"
const INTRO_FONT := preload("res://assets/fonts/horroroid/horroroid.ttf")

func _ready() -> void:
	theme = preload("res://scripts/ui/menu_typography.gd").menu_theme()
	preload("res://scripts/ui/menu_typography.gd").enlarge_body.call_deferred(self)
	if pause_context:
		preload("res://scripts/ui/menu_art.gd").main(self, true)
	else:
		_build_home()
		if not GameManager.checkpoint_error.is_empty():
			var error_label := _label(GameManager.checkpoint_error, Vector2(92, 490), 16, Color("efb2a7"))
			error_label.name = "CheckpointError"
			error_label.size = Vector2(540, 76)
			error_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			error_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	value_requested.connect(func(_index: int, direction: int):
		if entries[current_index].id == "rules" and direction > 0:
			selected.emit("controls"))

func layout_artwork() -> void:
	if pause_context:
		super.layout_artwork()
		return
	if design == null:
		return
	# Scenery covers the viewport; independent UI scaling keeps every action visible.
	var factor := minf(size.x / reference_size.x, size.y / reference_size.y)
	design.scale = Vector2.ONE * factor
	design.position = (size - reference_size * factor) * 0.5
	if menu_content != null:
		var ui_scale := minf(size.x / 1280.0, size.y / 720.0)
		menu_content.scale = Vector2.ONE * ui_scale
		menu_content.position = (size - Vector2(1280, 720) * ui_scale) * 0.5

func _build_home() -> void:
	var background := load(BACKGROUND) as Texture2D
	var items: Array[Dictionary] = []
	var ids := ["start", "continue", "settings", "rules", "credits", "quit"]
	var rows := [238, 292, 356, 410, 464, 534]
	for i in ids.size():
		items.append({"id": ids[i], "rect": Rect2(874, rows[i], 316, 44), "texture": null})
	build(background, items, false)
	cover_background(background)
	_setup_video_background()
	active_art.hide()
	artwork.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	var atmosphere := ShaderMaterial.new()
	atmosphere.shader = preload("res://shaders/horror_menu_backdrop.gdshader")
	artwork.material = atmosphere
	menu_content = Control.new()
	menu_content.name = "TransparentMenu"
	menu_content.mouse_filter = Control.MOUSE_FILTER_IGNORE
	menu_content.size = Vector2(1280, 720)
	add_child(menu_content)
	var eyebrow := _label("HOLLOWMERE ESTATE", Vector2(114, 216), 11, Color("aaa5a0"))
	eyebrow.add_theme_font_override("font", _tracked_font(get_theme_default_font(), 3))
	var seal := Control.new()
	seal.position = Vector2(94, 224)
	seal.mouse_filter = Control.MOUSE_FILTER_IGNORE
	menu_content.add_child(seal)
	seal.draw.connect(func():
		seal.draw_polyline(PackedVector2Array([Vector2(0, -6), Vector2(4, 0), Vector2(0, 6), Vector2(-4, 0), Vector2(0, -6)]), Color("a07860"), 1.0, true)
		seal.draw_line(Vector2(0, -11), Vector2(0, 11), Color("633538"), 1.0, true))
	_label("LIBERTAS", Vector2(84, 248), 68, Color("e5dfd5"))
	_label("VINCTA", Vector2(84, 322), 68, Color("e5dfd5"))
	var tagline := _label("Every freedom has a price.", Vector2(92, 432), 17, Color("b2a7a1"))
	tagline.add_theme_font_override("font", preload("res://scripts/ui/menu_typography.gd").BODY)
	_rule(Vector2(92, 419), 310)
	_rule(Vector2(1009, 344), 46)
	_rule(Vector2(1009, 521), 46)
	var labels := ["New Game", "Continue", "Settings", "How to Play", "Credits", "Exit"]
	var button_font := _tracked_font(preload("res://scripts/ui/menu_typography.gd").BODY, 1)
	var hover_material := ShaderMaterial.new()
	hover_material.shader = preload("res://shaders/menu_hover.gdshader")
	for i in buttons.size():
		var button := buttons[i]
		button.reparent(menu_content, false)
		button.text = labels[i]
		button.alignment = HORIZONTAL_ALIGNMENT_CENTER
		button.add_theme_font_override("font", button_font)
		button.add_theme_font_size_override("font_size", 26 if i < 2 else 24)
		for color_name in ["font_color", "font_focus_color", "font_hover_color", "font_pressed_color", "font_hover_pressed_color"]:
			button.add_theme_color_override(color_name, (Color("d7c9b9") if i < 2 else Color("b8aca0")) if color_name == "font_color" else Color("fff0e5"))
		var spacing := StyleBoxEmpty.new()
		spacing.content_margin_left = 16
		spacing.content_margin_right = 16
		button_spacing.append(spacing)
		for state in ["normal", "hover", "pressed", "focus", "hover_pressed"]:
			button.add_theme_stylebox_override(state, spacing)
		var glow := ColorRect.new()
		glow.name = "RedHover"
		glow.color = Color(0.43, 0.045, 0.065, 0.88)
		glow.material = hover_material
		glow.modulate.a = 0.0
		glow.show_behind_parent = true
		glow.mouse_filter = Control.MOUSE_FILTER_IGNORE
		button.add_child(glow)
		glow.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		highlights.append(glow)
		var mark := Label.new()
		mark.text = "\u203a"
		mark.position = Vector2(14, 5)
		mark.add_theme_font_size_override("font_size", 24)
		mark.add_theme_color_override("font_color", Color("d8afa2"))
		mark.mouse_filter = Control.MOUSE_FILTER_IGNORE
		mark.modulate.a = 0.0
		button.add_child(mark)
		selection_marks.append(mark)
		# Pointer exit restores transparency; keyboard/controller focus remains visible.
		button.mouse_exited.connect(func(): button.release_focus())
	selection_caption = _label("", Vector2(822, 615), 13, Color("a9a29c"))
	selection_caption.size = Vector2(420, 44)
	selection_caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	selection_caption.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_label("\u2191  \u2193   NAVIGATE     /     ENTER  SELECT", Vector2(886, 674), 11, Color("938c86"))
	layout_artwork()

func _label(text: String, at: Vector2, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = text
	label.position = at
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if font_size >= 50:
		label.add_theme_font_override("font", _tracked_font(INTRO_FONT, 2))
		while font_size > 40 and label.get_theme_font("font").get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x > 650:
			font_size -= 1
		label.add_theme_color_override("font_shadow_color", Color(0.24, 0.035, 0.045, 0.7))
		label.add_theme_constant_override("shadow_offset_x", 1)
		label.add_theme_constant_override("shadow_offset_y", 2)
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	menu_content.add_child(label)
	return label

func _setup_video_background() -> void:
	var stream := cinematic_stream if cinematic_stream != null else load(VIDEO_BACKGROUND) as VideoStream
	if stream == null:
		push_warning("Main menu cinematic could not be loaded; using the static background: " + VIDEO_BACKGROUND)
		return
	artwork.hide()
	video_background = VideoStreamPlayer.new()
	video_background.name = "CinematicBackground"
	video_background.stream = stream
	video_background.autoplay = true
	video_background.loop = true
	video_background.volume_db = -16.0
	video_background.expand = true
	video_background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	video_background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(video_background)
	move_child(video_background, 1)
	var readability := ColorRect.new()
	readability.name = "CinematicReadability"
	readability.color = Color(0.0, 0.0, 0.0, 0.28)
	readability.mouse_filter = Control.MOUSE_FILTER_IGNORE
	readability.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(readability)
	move_child(readability, 2)

func _tracked_font(base: Font, tracking: int) -> FontVariation:
	var font := FontVariation.new()
	font.base_font = base
	font.spacing_glyph = tracking
	return font

func _rule(at: Vector2, width: float) -> void:
	var gradient := Gradient.new()
	gradient.colors = PackedColorArray([Color("785548"), Color(0.3, 0.23, 0.2, 0.0)])
	var texture := GradientTexture2D.new()
	texture.gradient = gradient
	texture.fill_from = Vector2.ZERO
	texture.fill_to = Vector2.RIGHT
	var line := TextureRect.new()
	line.texture = texture
	line.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	line.position = at
	line.size = Vector2(width, 1)
	line.mouse_filter = Control.MOUSE_FILTER_IGNORE
	menu_content.add_child(line)

func update_visual_state() -> void:
	if pause_context:
		super.update_visual_state()

func focus_default() -> void:
	super.focus_default()
	if menu_content == null:
		return
	if reveal != null and reveal.is_valid():
		reveal.kill()
	menu_content.modulate.a = 0.0
	reveal = create_tween()
	reveal.tween_property(menu_content, "modulate:a", 1.0, 0.45).set_trans(Tween.TRANS_SINE)

func _process(delta: float) -> void:
	if video_background != null:
		video_background.paused = not is_visible_in_tree()
	if pause_context or not is_visible_in_tree():
		return
	atmosphere_clock += delta
	(artwork.material as ShaderMaterial).set_shader_parameter("atmosphere_clock", atmosphere_clock)
	for i in highlights.size():
		var active := i == current_index and (buttons[i].has_focus() or buttons[i].is_hovered())
		highlights[i].modulate.a = move_toward(highlights[i].modulate.a, 1.0 if active else 0.0, delta / 0.12)
		var amount := smoothstep(0.0, 1.0, highlights[i].modulate.a)
		selection_marks[i].modulate.a = amount
	if selection_caption != null:
		if caption_index != current_index:
			caption_index = current_index
			var captions := ["Begin Els Vantree's descent.", "Return to your last checkpoint." if GameManager.has_save() else "No checkpoint yet. Begin a new game.", "Adjust sound, display and atmosphere.", "Learn the rules of the estate.", "The people behind Hollowmere.", "Leave the estate behind."]
			selection_caption.text = captions[current_index]
			selection_caption.modulate.a = 0.0
		selection_caption.modulate.a = move_toward(selection_caption.modulate.a, 1.0, delta * 5.0)
