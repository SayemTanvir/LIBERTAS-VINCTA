extends "res://scripts/ui/menu_sheet.gd"
var location: Label
var checkpoint_note: Label
var atmosphere_clock := 0.0

func _ready() -> void:
	build_sheet("A moment of stillness", "The estate waits while you pause.", [
		{"id": "resume", "label": "Resume  ›", "rect": Rect2(84, 289, 370, 54)},
		{"id": "settings", "label": "Settings", "rect": Rect2(84, 360, 370, 54)},
		{"id": "rules", "label": "How to play", "rect": Rect2(84, 431, 370, 54)},
		{"id": "home", "label": "Main menu", "rect": Rect2(84, 502, 370, 54)}], "LIBERTAS VINCTA  /  PAUSED")
	artwork.texture = preload("res://assets/ui/menu/libertas_vincta_pause_background.png")
	var atmosphere := ShaderMaterial.new()
	atmosphere.shader = preload("res://shaders/horror_menu_backdrop.gdshader")
	atmosphere.set_shader_parameter("atmosphere_strength", 0.5)
	artwork.material = atmosphere
	shade.color = Color(0.014, 0.019, 0.025, 0.35)
	reveal_seconds = 0.3
	reveal_background = true
	for button in buttons:
		button.add_theme_font_override("font", Typography.BODY)
		button.add_theme_font_size_override("font_size", 24)
		var transparent := StyleBoxEmpty.new()
		transparent.content_margin_left = 16
		for state in ["normal", "hover", "pressed", "focus", "hover_pressed"]:
			button.add_theme_stylebox_override(state, transparent)
	section("Current chapter", 684, 290)
	location = Style.label(design, "", Rect2(684, 329, 512, 70), 29, Style.PAPER)
	location.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	checkpoint_note = Style.label(design, "", Rect2(684, 415, 512, 84), 16, Style.MUTED)
	checkpoint_note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	Style.keycap(design, "H", Rect2(684, 529, 38, 30))
	Style.label(design, "Field guide available during play", Rect2(738, 529, 450, 32), 15, Style.MUTED)
	footer_label.text = "↑ ↓  Navigate     Enter  Select     Esc  Resume"
	value_requested.connect(func(_index: int, direction: int):
		if entries[current_index].id == "rules" and direction > 0:
			selected.emit("controls"))

func focus_default() -> void:
	location.text = "Part II · Degrees of Freedom" if FreedomLedger.current_part == 2 else "Part I · Hollowmere Estate"
	checkpoint_note.text = "Returning to the main menu keeps your last saved checkpoint."
	if not GameManager.has_save():
		checkpoint_note.text = "Your first checkpoint is saved after the awakening."
	super.focus_default()

func _process(delta: float) -> void:
	super._process(delta)
	if is_visible_in_tree():
		atmosphere_clock += delta
		(artwork.material as ShaderMaterial).set_shader_parameter("atmosphere_clock", atmosphere_clock)
