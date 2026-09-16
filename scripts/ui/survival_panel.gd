extends PanelContainer
## Compact native HUD; smooth bars retain exact numeric resource values.
var health_bar: ProgressBar
var charge_bar: ProgressBar
var health_value: Label
var charge_value: Label
var item_values: Dictionary = {}
const PANEL_SIZE := Vector2(344, 118)

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	position = Vector2(18, 16)
	size = PANEL_SIZE
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.035, 0.045, 0.05, 0.82)
	style.border_color = Color(0.42, 0.40, 0.35, 0.38)
	style.set_border_width_all(1)
	style.set_corner_radius_all(7)
	style.set_content_margin_all(0)
	style.shadow_color = Color(0, 0, 0, 0.22)
	style.shadow_size = 3
	add_theme_stylebox_override("panel", style)
	var content := Control.new()
	content.custom_minimum_size = PANEL_SIZE
	content.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(content)
	_label(content, "ELS VANTREE", Vector2(14, 8), 11, Color("c5bbaa"))
	_label(content, "[TAB] BAG   [H] GUIDE", Vector2(219, 9), 9, Color("a39d93"))
	_label(content, "HEALTH", Vector2(14, 32), 10, Color("bca8a3"))
	health_value = _label(content, "100 / 100", Vector2(94, 27), 14, Color("dfcfc5"))
	health_bar = _bar(content, Vector2(14, 50), Vector2(142, 4), Color("b57570"))
	_label(content, "FLASHLIGHT", Vector2(180, 32), 10, Color("a5b6af"))
	charge_value = _label(content, "100%", Vector2(293, 27), 14, Color("c4d7cd"))
	charge_value.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	charge_value.position.x = 283
	charge_value.size.x = 47
	charge_bar = _bar(content, Vector2(180, 50), Vector2(150, 4), Color("81aba0"))
	var divider := ColorRect.new()
	divider.color = Color(0.48, 0.46, 0.40, 0.18)
	divider.position = Vector2(14, 63)
	divider.size = Vector2(316, 1)
	divider.mouse_filter = Control.MOUSE_FILTER_IGNORE
	content.add_child(divider)
	var art := preload("res://scripts/levels/estate_art.gd").new()
	var i := 0
	for item in ["battery", "bottle", "clock", "lockpick"]:
		var icon := TextureRect.new()
		icon.texture = art.texture_for(item + "_pickup")
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.position = Vector2(14 + i * 80, 73)
		icon.size = Vector2(17, 20)
		icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
		content.add_child(icon)
		_label(content, item.to_upper(), Vector2(36 + i * 80, 69), 9, Color("a39d93"))
		item_values[item] = _label(content, "0", Vector2(36 + i * 80, 80), 14, Color("d7d0c5"))
		i += 1

func _label(parent: Node, text: String, at: Vector2, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = text
	label.position = at
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(label)
	return label

func _bar(parent: Node, at: Vector2, dimensions: Vector2, color: Color) -> ProgressBar:
	var bar := ProgressBar.new()
	bar.position = at
	bar.size = dimensions
	bar.show_percentage = false
	bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var backing := StyleBoxFlat.new()
	backing.bg_color = Color("253235")
	backing.set_corner_radius_all(3)
	var fill := backing.duplicate()
	fill.bg_color = color
	bar.add_theme_stylebox_override("background", backing)
	bar.add_theme_stylebox_override("fill", fill)
	parent.add_child(bar)
	# Assign after theme and percentage changes; the default bar minimum is taller.
	bar.size = dimensions
	return bar

func update_values(delta: float) -> void:
	var charge := FreedomLedger.flashlight_seconds / FreedomLedger.MAX_FLASHLIGHT_SECONDS * 100.0
	var health := FreedomLedger.hp / maxf(FreedomLedger.max_hp, 1.0) * 100.0
	var response := 1.0 - exp(-14.0 * delta)
	health_bar.value = lerpf(health_bar.value, health, response)
	charge_bar.value = lerpf(charge_bar.value, charge, response)
	health_value.text = "%d / %d" % [ceili(FreedomLedger.hp), ceili(FreedomLedger.max_hp)]
	charge_value.text = "%d%%" % floori(charge)
	for item in item_values:
		item_values[item].text = str(FreedomLedger.inventory.get(item, 0))
