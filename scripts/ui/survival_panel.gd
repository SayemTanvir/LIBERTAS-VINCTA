extends Control
## Reference-matched metal plate with live labels, resource meters and inventory.
const PANEL_SIZE := Vector2(480, 159)
const CONTENT_LEFT := 22.0
const CONTENT_RIGHT := 458.0
const METER_WIDTH := 206.0
const ITEM_PITCH := 109.0
const PLATE := preload("res://assets/ui/hud/hollowmere_metal_plate.png")
const METER_SHADER := preload("res://shaders/hud_resource_meter.gdshader")
const INK := Color("e7ddce")
const MUTED := Color("b7aa95")
var health_bar: ProgressBar
var charge_bar: ProgressBar
var health_value: Label
var charge_value: Label
var summary_label: Label
var health_trail: ProgressBar
var item_values: Dictionary = {}
var item_icons: Dictionary = {}
var item_previous: Dictionary = {}
var item_pulses: Dictionary = {}
var meter_materials: Array[ShaderMaterial] = []
var visual_clock := 0.0
var initialized := false
var last_hp := 0.0
var last_charge := 0.0
var damage_hold := 0.0
var charging_glow := 0.0

func _ready() -> void:
	name = "SurvivalPanel"
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	position = Vector2(18, 16)
	size = PANEL_SIZE
	scale = Vector2(1.08, 1.08)
	texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	var backing := TextureRect.new()
	backing.name = "WeatheredMetal"
	backing.texture = PLATE
	backing.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	backing.stretch_mode = TextureRect.STRETCH_SCALE
	backing.size = PANEL_SIZE
	backing.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var patina := ShaderMaterial.new()
	patina.shader = preload("res://shaders/hud_plate_patina.gdshader")
	backing.material = patina
	add_child(backing)
	var detail := Control.new()
	detail.name = "MetalFittings"
	detail.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(detail)
	detail.draw.connect(_draw_fittings.bind(detail))
	_label("ELS VANTREE", Rect2(CONTENT_LEFT, 14, 210, 23), 17)
	var shortcuts := _label("[TAB] BAG    [H] GUIDE", Rect2(250, 14, 208, 23), 12)
	shortcuts.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	shortcuts.add_theme_color_override("font_color", MUTED)
	_label("HEALTH", Rect2(CONTENT_LEFT, 44, 90, 25), 12).add_theme_color_override("font_color", MUTED)
	health_value = _label("", Rect2(112, 44, 116, 25), 18)
	health_value.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_label("FLASHLIGHT", Rect2(252, 44, 120, 25), 12).add_theme_color_override("font_color", MUTED)
	charge_value = _label("", Rect2(380, 44, 78, 25), 18)
	charge_value.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	health_trail = _bar(Vector2(CONTENT_LEFT, 74), Vector2(METER_WIDTH, 8), Color("ad8a5d"))
	health_bar = _bar(Vector2(CONTENT_LEFT, 74), Vector2(METER_WIDTH, 8), Color("974851"), true)
	charge_bar = _bar(Vector2(252, 74), Vector2(METER_WIDTH, 8), Color("7fa8a2"))
	var art := preload("res://scripts/levels/estate_art.gd").new()
	var i := 0
	for item in ["battery", "bottle", "clock", "lockpick"]:
		var x := 36.0 + i * ITEM_PITCH
		var icon := TextureRect.new()
		icon.name = item.to_pascal_case() + "Icon"
		icon.texture = art.texture_for(item + "_pickup")
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.position = Vector2(x - 9, 99)
		icon.size = Vector2(18, 24)
		icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(icon)
		item_icons[item] = icon
		var caption := _label(item.to_upper(), Rect2(x + 21, 93, 73, 18), 11)
		caption.add_theme_color_override("font_color", MUTED)
		item_values[item] = _label("0", Rect2(x + 21, 111, 73, 23), 17)
		item_pulses[item] = 0.0
		i += 1
	summary_label = _label("", Rect2(CONTENT_LEFT, 137, CONTENT_RIGHT - CONTENT_LEFT, 18), 11)
	summary_label.name = "FreedomSummary"
	summary_label.add_theme_color_override("font_color", MUTED)
	update_values(0.0)

func _draw_fittings(canvas: Control) -> void:
	for y in [40.0, 89.0, 134.0]:
		canvas.draw_line(Vector2(CONTENT_LEFT, y), Vector2(CONTENT_RIGHT, y), Color(0.56, 0.48, 0.35, 0.38), 1.0)
	for bounds in [Rect2(20, 72, 210, 12), Rect2(250, 72, 210, 12)]:
		var groove := StyleBoxFlat.new()
		groove.bg_color = Color("161d19")
		groove.border_color = Color("625944")
		groove.set_border_width_all(1)
		groove.set_corner_radius_all(5)
		groove.shadow_color = Color(0, 0, 0, 0.7)
		groove.shadow_size = 2
		canvas.draw_style_box(groove, bounds)
	for i in 4:
		var center := Vector2(36 + i * ITEM_PITCH, 111)
		canvas.draw_circle(center + Vector2(0, 1), 15, Color(0, 0, 0, 0.65), true, -1, true)
		canvas.draw_circle(center, 14, Color("504a3b"), true, -1, true)
		canvas.draw_arc(center, 14, PI, TAU, 32, Color("948369"), 1.0, true)
		canvas.draw_circle(center, 12, Color("111c1c"), true, -1, true)
		for offset in [Vector2(0, -14), Vector2(0, 14)]:
			_rivet(canvas, center + offset, 1.1)

func _rivet(canvas: Control, at: Vector2, radius: float) -> void:
	canvas.draw_circle(at + Vector2(0, 0.8), radius + 0.6, Color("23281f"), true, -1, true)
	canvas.draw_circle(at, radius, Color("89876a"), true, -1, true)
	canvas.draw_circle(at + Vector2(-0.6, -0.6), radius * 0.42, Color("c1b48b"), true, -1, true)

func _label(text: String, rect: Rect2, font_size: int) -> Label:
	var label := Label.new()
	label.text = text
	label.position = rect.position
	label.size = rect.size
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", INK)
	label.add_theme_color_override("font_shadow_color", Color(0.015, 0.02, 0.025, 0.85))
	label.add_theme_constant_override("shadow_offset_x", 0)
	label.add_theme_constant_override("shadow_offset_y", 1)
	add_child(label)
	# Reset after font overrides/theme inheritance to discard the default font's
	# larger minimum height (especially important for the compact footer).
	label.size = rect.size
	return label

func _bar(at: Vector2, dimensions: Vector2, color: Color, clear_track := false) -> ProgressBar:
	var bar := ProgressBar.new()
	bar.step = 0.0
	bar.position = at
	bar.show_percentage = false
	bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var track := StyleBoxFlat.new()
	track.bg_color = Color.TRANSPARENT if clear_track else Color("15201c")
	track.set_corner_radius_all(4)
	track.set_content_margin_all(0)
	var fill := StyleBoxFlat.new()
	fill.bg_color = color
	fill.set_corner_radius_all(4)
	fill.set_content_margin_all(0)
	bar.add_theme_stylebox_override("background", track)
	bar.add_theme_stylebox_override("fill", fill)
	var material := ShaderMaterial.new()
	material.shader = METER_SHADER
	bar.material = material
	meter_materials.append(material)
	add_child(bar)
	bar.size = dimensions
	return bar

func _fit_text(label: Label, maximum: int, available: float) -> void:
	var font := label.get_theme_font("font")
	var font_size := maximum
	while font_size > 11 and font.get_string_size(label.text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x > available:
		font_size -= 1
	label.add_theme_font_size_override("font_size", font_size)

func update_values(delta: float) -> void:
	if health_bar == null:
		return
	var running := not get_tree().paused and GameManager.state == GameManager.State.PLAYING
	var step := delta if running else 0.0
	visual_clock += step
	var charge := clampf(FreedomLedger.flashlight_charge, 0, 100)
	var health := clampf(FreedomLedger.hp / maxf(FreedomLedger.max_hp, 1.0) * 100.0, 0, 100)
	var snap := not initialized or not is_visible_in_tree()
	if snap:
		health_bar.value = health
		health_trail.value = health
		charge_bar.value = charge
	else:
		if health < last_hp:
			damage_hold = 0.35
		damage_hold = maxf(0, damage_hold - step)
		var response := 1.0 - exp(-14.0 * step)
		health_bar.value = lerpf(health_bar.value, health, response)
		charge_bar.value = lerpf(charge_bar.value, charge, response)
		if health >= health_trail.value:
			health_trail.value = health_bar.value
		elif damage_hold <= 0:
			health_trail.value = lerpf(health_trail.value, health, 1.0 - exp(-4.0 * step))
		if absf(health_bar.value - health) < 0.05:
			health_bar.value = health
		if absf(charge_bar.value - charge) < 0.05:
			charge_bar.value = charge
	charging_glow = 1.0 if initialized and charge > last_charge + 0.001 else move_toward(charging_glow, 0, step * 2.0)
	health_value.text = "%d / %d" % [ceili(FreedomLedger.hp), ceili(FreedomLedger.max_hp)]
	charge_value.text = "%d%%" % floori(charge)
	health_value.add_theme_color_override("font_color", Color("e7a294") if health <= 25 else INK)
	charge_value.add_theme_color_override("font_color", Color("e7a294") if charge <= 20 else INK)
	for item in item_values:
		var amount := int(FreedomLedger.inventory.get(item, 0))
		if initialized and amount > int(item_previous.get(item, amount)):
			item_pulses[item] = 1.0
		item_pulses[item] = maxf(0.0, float(item_pulses[item]) - step * 1.6)
		item_values[item].text = str(amount)
		_fit_text(item_values[item], 17, 73)
		item_icons[item].self_modulate = Color.WHITE.lerp(Color("ffe2a7"), float(item_pulses[item]))
		item_previous[item] = amount
	for material in meter_materials:
		material.set_shader_parameter("clock", visual_clock)
	(health_bar.material as ShaderMaterial).set_shader_parameter("pulse", 0.35 if health <= 25 else 0.0)
	(charge_bar.material as ShaderMaterial).set_shader_parameter("pulse", 0.35 if charge <= 20 else 0.0)
	(charge_bar.material as ShaderMaterial).set_shader_parameter("replenishing", charging_glow)
	summary_label.text = FreedomLedger.freedom_summary().replace("Degrees of freedom: ", "Freedom: ").replace(" bonds released", " bonds").replace("  |  [H] Field guide", "")
	_fit_text(summary_label, 11, CONTENT_RIGHT - CONTENT_LEFT)
	last_hp = health
	last_charge = charge
	initialized = true
