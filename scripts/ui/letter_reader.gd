extends Control
signal close_requested
const Style := preload("res://scripts/ui/ui_style.gd")
var design: Control
var title_label: Label
var content: RichTextLabel
var scroll: ScrollContainer
var closing: bool = false
var category: Label
var description: Label
var scroll_hint: Label
var close_button: Button
var inventory_grid: Control
var item_counts: Dictionary = {}
var inventory_summary: Label
var entrance: Tween
var document: Control
var memory_button: Button
var battery_list: RichTextLabel

func _ready() -> void:
	theme = preload("res://themes/libertas_ui_theme.tres")
	mouse_filter = Control.MOUSE_FILTER_STOP
	var dim := ColorRect.new()
	dim.color = Color(0.015, 0.022, 0.031, 0.94)
	dim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(dim)
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	design = Control.new()
	design.size = Vector2(1120, 640)
	design.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(design)
	var panel := Panel.new()
	panel.size = design.size
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_theme_stylebox_override("panel", Style.panel(Color("10171d"), Style.RULE))
	design.add_child(panel)
	# A faint paper grain retains the collected-letter character without a bright modal.
	var paper := TextureRect.new()
	paper.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	paper.texture = preload("res://scripts/ui/image_state_menu.gd").region(preload("res://assets/BG/01_Message_UI/collectible_letter_parchment_scroll.png"), Rect2(260, 320, 730, 570))
	paper.position = Vector2(368, 90)
	paper.size = Vector2(710, 440)
	paper.modulate = Color(0.38, 0.32, 0.24, 0.08)
	paper.mouse_filter = Control.MOUSE_FILTER_IGNORE
	design.add_child(paper)
	category = Style.label(design, "HOLLOWMERE  /  DOCUMENTS", Rect2(48, 32, 850, 30), 12, Style.BRASS)
	Style.rule(design, Rect2(48, 78, 1024, 1))
	Style.rule(design, Rect2(333, 110, 1, 399))
	title_label = Style.label(design, "", Rect2(48, 116, 253, 182), 32, Style.PAPER, true)
	title_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	description = Style.label(design, "", Rect2(48, 331, 246, 155), 16, Style.MUTED)
	description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	scroll = ScrollContainer.new()
	scroll.position = Vector2(400, 113)
	scroll.size = Vector2(648, 399)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	design.add_child(scroll)
	scroll.get_v_scroll_bar().custom_minimum_size.x = 6.0
	content = RichTextLabel.new()
	content.fit_content = true
	content.scroll_active = false
	content.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_theme_font_override("normal_font", Style.serif())
	content.add_theme_font_size_override("normal_font_size", 21)
	content.add_theme_color_override("default_color", Style.PAPER)
	content.add_theme_constant_override("line_separation", 8)
	scroll.add_child(content)
	Style.rule(design, Rect2(48, 538, 1024, 1))
	close_button = Button.new()
	close_button.text = "Close  /  Esc"
	close_button.position = Vector2(48, 560)
	close_button.size = Vector2(224, 44)
	close_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	close_button.add_theme_font_size_override("font_size", 17)
	close_button.add_theme_font_override("font", get_theme_default_font())
	for state in ["normal", "hover", "focus", "pressed"]:
		close_button.add_theme_stylebox_override(state, Style.panel(Color("372126") if state != "normal" else Style.INK, Style.BRASS if state != "normal" else Style.RULE))
	close_button.add_theme_color_override("font_color", Style.PAPER)
	design.add_child(close_button)
	close_button.pressed.connect(_request_close)
	scroll_hint = Style.label(design, "", Rect2(400, 562, 648, 44), 14, Style.MUTED)
	scroll_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_build_inventory()
	document = preload("res://scripts/ui/scroll_document.gd").new()
	add_child(document)
	document.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	document.close_requested.connect(_request_close)
	resized.connect(_layout)
	_layout()
	hide()

func _build_inventory() -> void:
	inventory_grid = Control.new()
	inventory_grid.mouse_filter = Control.MOUSE_FILTER_IGNORE
	design.add_child(inventory_grid)
	var art := preload("res://scripts/levels/estate_art.gd").new()
	var names := ["Batteries", "Bottles", "Clocks", "Lockpicks"]
	var items := ["battery", "bottle", "clock", "lockpick"]
	for i in items.size():
		var pos := Vector2(400 + (i % 2) * 336, 113 + (i / 2) * 135)
		var card := Panel.new()
		card.position = pos
		card.size = Vector2(312, 110)
		card.clip_contents = true
		card.mouse_filter = Control.MOUSE_FILTER_IGNORE
		card.add_theme_stylebox_override("panel", Style.panel(Color("151d23"), Style.RULE))
		inventory_grid.add_child(card)
		var icon := TextureRect.new()
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.texture = art.texture_for(items[i] + "_pickup")
		icon.position = Vector2(20, 24)
		icon.size = Vector2(46, 62)
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
		card.add_child(icon)
		Style.label(card, names[i], Rect2(91, 19, 200, 28), 16, Style.MUTED)
		item_counts[items[i]] = Style.label(card, "0", Rect2(91, 49, 200, 44), 30, Style.PAPER, true)
	battery_list = RichTextLabel.new()
	battery_list.position = Vector2(400, 385)
	battery_list.size = Vector2(648, 64)
	battery_list.add_theme_font_size_override("normal_font_size", 16)
	battery_list.add_theme_color_override("default_color", Style.PAPER)
	inventory_grid.add_child(battery_list)
	inventory_summary = Style.label(inventory_grid, "", Rect2(400, 458, 648, 65), 16, Style.MUTED)
	inventory_summary.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	inventory_grid.hide()
	memory_button = Button.new()
	memory_button.text = "Read Memory Fragment A"
	memory_button.position = Vector2(400, 564)
	memory_button.size = Vector2(310, 35)
	memory_button.add_theme_font_size_override("font_size", 16)
	memory_button.add_theme_font_override("font", get_theme_default_font())
	for state in ["normal", "hover", "focus", "pressed"]:
		memory_button.add_theme_stylebox_override(state, Style.panel(Style.INK, Style.BRASS if state != "normal" else Style.RULE))
	inventory_grid.add_child(memory_button)
	memory_button.pressed.connect(func():
		var fragment := preload("res://scripts/systems/memory_fragment.gd")
		open(fragment.TITLE, fragment.TEXT))

func _layout() -> void:
	var factor := minf((size.x - 32.0) / 1120.0, (size.y - 32.0) / 640.0)
	design.scale = Vector2.ONE * maxf(factor, 0.1)
	design.position = (size - design.size * design.scale) * 0.5

func open(title: String, text: String) -> void:
	title_label.text = title
	content.text = text.replace("\\n", "\n")
	scroll.scroll_vertical = 0
	closing = false
	var inventory := title == "Inventory"
	var guide := "Guide" in title
	inventory_grid.visible = inventory
	memory_button.visible = bool(FreedomLedger.flags.get("vantree_memory_fragment_A", false))
	scroll.visible = not inventory
	category.text = "ELS VANTREE  /  INVENTORY" if inventory else ("ELS VANTREE  /  FIELD GUIDE" if guide else "HOLLOWMERE  /  DOCUMENTS")
	description.text = "What you carry may buy you another moment." if inventory else ("Your current abilities, their costs, and the way forward." if guide else "Some words outlive the hands that wrote them.")
	for item in item_counts:
		item_counts[item].text = str(FreedomLedger.inventory.get(item, 0))
	var cells := FreedomLedger.battery_percentages()
	var cell_lines: Array[String] = []
	for i in cells.size():
		cell_lines.append("Battery %d: %.1f%%" % [i + 1, cells[i]])
	battery_list.text = "No batteries. Find a cell to recharge." if cells.is_empty() else "   ·   ".join(cell_lines)
	inventory_summary.text = "Letters collected: %d\n%s" % [FreedomLedger.letter_ids.size(), FreedomLedger.freedom_summary()]
	show()
	design.visible = inventory
	document.visible = not inventory
	if not inventory:
		document.open(title, text)
		return
	close_button.grab_focus()
	if entrance != null and entrance.is_valid():
		entrance.kill()
	design.modulate.a = 0.0
	entrance = create_tween()
	entrance.tween_property(design, "modulate:a", 1.0, 0.16)

func _process(_delta: float) -> void:
	if not visible:
		return
	var bar := scroll.get_v_scroll_bar()
	var maximum := maxf(0.0, bar.max_value - bar.page)
	if inventory_grid.visible:
		scroll_hint.text = "Esc  Close" if memory_button.visible else "E / Enter / Esc  Close"
	elif maximum > 1.0:
		scroll_hint.text = "%d%%   /   ↑ ↓ or wheel to read" % roundi(float(scroll.scroll_vertical) / maximum * 100.0)
	else:
		scroll_hint.text = "E / Enter / Esc  Close"

func _request_close() -> void:
	if closing:
		return
	closing = true
	EventBus.audio_requested.emit("ui_back")
	close_requested.emit()

func _input(event: InputEvent) -> void:
	if not is_visible_in_tree():
		return
	if document.visible:
		return
	if event is InputEventMouseMotion:
		return
	if event is InputEventMouseButton:
		if event.pressed and event.button_index in [MOUSE_BUTTON_WHEEL_UP, MOUSE_BUTTON_WHEEL_DOWN]:
			var distance := -90 if event.button_index == MOUSE_BUTTON_WHEEL_UP else 90
			if inventory_grid.visible:
				battery_list.get_v_scroll_bar().value += distance
			else:
				scroll.scroll_vertical += distance
			get_viewport().set_input_as_handled()
		return
	get_viewport().set_input_as_handled()
	if closing or event.is_echo():
		return
	if event.is_action_pressed("ui_accept") and memory_button.visible and memory_button.has_focus():
		memory_button.pressed.emit()
		return
	if memory_button.visible and (event.is_action_pressed("ui_down") or event.is_action_pressed("ui_up") or event.is_action_pressed("ui_focus_next")):
		if memory_button.has_focus():
			close_button.grab_focus()
		else:
			memory_button.grab_focus()
		return
	if event.is_action_pressed("interact") or event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_cancel") or event.is_action_pressed("pause"):
		_request_close()
	elif event.is_action_pressed("ui_down"):
		scroll.scroll_vertical += 90
	elif event.is_action_pressed("ui_up"):
		scroll.scroll_vertical -= 90
