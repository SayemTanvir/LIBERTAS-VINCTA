extends Control

signal selected(destination: String)

const MENU_BUTTON = preload("res://scenes/ui/components/menu_button.tscn")

@export var pause_context: bool = false
@export var logo_texture: Texture2D

var first_button: Button
var menu_shell: MarginContainer
var left_scrim: ColorRect
var scrim_edge: ColorRect
var entrance_played: bool = false

func _ready() -> void:
	_build_backdrop()
	_build_menu()
	_apply_responsive_layout()

func _build_backdrop() -> void:
	left_scrim = ColorRect.new()
	left_scrim.name = "LeftScrim"
	left_scrim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	left_scrim.color = Color(0.018, 0.02, 0.024, 0.82 if pause_context else 0.68)
	add_child(left_scrim)
	left_scrim.anchor_right = 0.47
	left_scrim.anchor_bottom = 1.0

	scrim_edge = ColorRect.new()
	scrim_edge.name = "ScrimEdge"
	scrim_edge.mouse_filter = Control.MOUSE_FILTER_IGNORE
	scrim_edge.color = Color(0.64, 0.54, 0.33, 0.22)
	add_child(scrim_edge)
	scrim_edge.anchor_left = 0.47
	scrim_edge.anchor_right = 0.47
	scrim_edge.anchor_bottom = 1.0
	scrim_edge.offset_right = 1.0

func _build_menu() -> void:
	menu_shell = MarginContainer.new()
	menu_shell.name = "MenuShell"
	add_child(menu_shell)
	menu_shell.anchor_left = 0.055
	menu_shell.anchor_right = 0.41
	menu_shell.anchor_top = 0.065
	menu_shell.anchor_bottom = 0.94

	var stack := VBoxContainer.new()
	stack.name = "MenuStack"
	stack.add_theme_constant_override("separation", 8)
	menu_shell.add_child(stack)

	var location := Label.new()
	location.text = "HOLLOWMERE ESTATE  /  2:47 A.M."
	location.theme_type_variation = "Eyebrow"
	stack.add_child(location)

	var title := Label.new()
	title.name = "GameTitle"
	title.text = "LIBERTAS\nVINCTA"
	title.theme_type_variation = "GameTitle"
	title.visible = logo_texture == null
	stack.add_child(title)

	var logo := TextureRect.new()
	logo.name = "LogoTexture"
	logo.texture = logo_texture
	logo.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	logo.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	logo.custom_minimum_size = Vector2(0, 130)
	logo.visible = logo_texture != null
	stack.add_child(logo)

	var tagline := Label.new()
	tagline.name = "Tagline"
	tagline.text = "GAME PAUSED" if pause_context else "SOME FREEDOMS SHOULD STAY LOST"
	tagline.theme_type_variation = "NarrativeAccent"
	stack.add_child(tagline)

	var title_rule := HSeparator.new()
	title_rule.name = "TitleRule"
	title_rule.custom_minimum_size.x = 270.0
	title_rule.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	stack.add_child(title_rule)

	var breathing_room := Control.new()
	breathing_room.custom_minimum_size.y = 18.0
	stack.add_child(breathing_room)

	var navigation := VBoxContainer.new()
	navigation.name = "Navigation"
	navigation.custom_minimum_size.x = 330.0
	navigation.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	navigation.add_theme_constant_override("separation", 5)
	stack.add_child(navigation)

	var choices := {
		"START GAME": "start",
		"STORY": "story",
		"CONTROLS": "controls",
		"SETTINGS": "settings",
		"CREDITS": "credits",
		"QUIT": "quit"
	}
	if not pause_context and GameManager.has_save():
		choices = {
			"CONTINUE": "continue",
			"START GAME": "start",
			"STORY": "story",
			"CONTROLS": "controls",
			"SETTINGS": "settings",
			"CREDITS": "credits",
			"QUIT": "quit"
		}
	if pause_context:
		choices = {
			"RESUME": "resume",
			"SETTINGS": "settings",
			"CONTROLS": "controls",
			"RESTART": "restart",
			"MAIN MENU": "home"
		}

	for caption: String in choices:
		if caption == "QUIT" and OS.has_feature("web"):
			continue
		var destination: String = choices[caption]
		var button: Button = MENU_BUTTON.instantiate()
		button.name = destination.capitalize().replace(" ", "") + "Button"
		button.caption = caption
		navigation.add_child(button)
		button.pressed.connect(func(): selected.emit(destination))
		if first_button == null:
			first_button = button

	var buttons := navigation.get_children()
	for index in range(buttons.size()):
		var button: Control = buttons[index]
		button.focus_neighbor_top = button.get_path_to(buttons[(index - 1 + buttons.size()) % buttons.size()])
		button.focus_neighbor_bottom = button.get_path_to(buttons[(index + 1) % buttons.size()])
		button.focus_previous = button.focus_neighbor_top
		button.focus_next = button.focus_neighbor_bottom

	var flexible_space := Control.new()
	flexible_space.size_flags_vertical = Control.SIZE_EXPAND_FILL
	stack.add_child(flexible_space)

	var footer := HBoxContainer.new()
	footer.name = "Footer"
	stack.add_child(footer)
	var studio := Label.new()
	studio.text = "TEAM 4'S COMPLIMENT"
	studio.theme_type_variation = "Eyebrow"
	footer.add_child(studio)
	var footer_space := Control.new()
	footer_space.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	footer.add_child(footer_space)
	var chapter := Label.new()
	chapter.text = "THE VANTREE HOUSE"
	chapter.theme_type_variation = "Small"
	footer.add_child(chapter)

func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED and is_instance_valid(menu_shell):
		_apply_responsive_layout()

func _apply_responsive_layout() -> void:
	var compact := size.x < 900.0
	menu_shell.anchor_right = 0.72 if compact else 0.41
	left_scrim.anchor_right = 0.78 if compact else 0.47
	scrim_edge.anchor_left = left_scrim.anchor_right
	scrim_edge.anchor_right = left_scrim.anchor_right

func focus_default() -> void:
	if first_button != null:
		first_button.grab_focus()
	if entrance_played:
		return
	entrance_played = true
	menu_shell.modulate.a = 0.0
	var tween := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(menu_shell, "modulate:a", 1.0, 0.5)
