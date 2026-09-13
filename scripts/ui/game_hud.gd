extends CanvasLayer
## Runtime status, reading, pause, transition, and ending presentation.

@export var ui_theme: Theme = preload("res://themes/libertas_ui_theme.tres")
var pause_menu: Control
var root: Control
var senses: Label
var vitals: Label
var room_name: Label
var prompt: Label
var subtitle: RichTextLabel
var bubble: Control
var reader: Control
var game_over: Control
var chapter_complete: Control
var result_busy: bool = false
var acknowledged_message: bool = false
var anchor_status: Label
var fade: ColorRect
var pulse: ColorRect
var peripheral: Array[ColorRect] = []

var subtitle_queue: Array[Dictionary] = []
var subtitle_time: float = 0.0
var modal_mode: String = ""
var ending_shown: bool = false
var threat_state: String = "CALM"
var threat_clock: float = 0.0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	add_to_group("hud")
	root = Control.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.theme = ui_theme
	add_child(root)
	senses = make_label("", 16)
	senses.position = Vector2(28, 22)
	root.add_child(senses)
	vitals = make_label("", 15)
	vitals.position = Vector2(28, 50)
	root.add_child(vitals)
	room_name = make_label("", 15)
	room_name.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
	room_name.offset_left = -330
	room_name.offset_right = -28
	room_name.offset_top = 22
	room_name.offset_bottom = 46
	room_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	root.add_child(room_name)
	prompt = make_label("[E]", 19)
	root.add_child(prompt)
	bubble = preload("res://scenes/ui/message_bubble.tscn").instantiate()
	root.add_child(bubble)
	subtitle = bubble.text_label
	anchor_status = make_label("", 17)
	anchor_status.set_anchors_and_offsets_preset(Control.PRESET_CENTER_TOP)
	anchor_status.offset_left = -160
	anchor_status.offset_right = 160
	anchor_status.offset_top = 72
	anchor_status.offset_bottom = 100
	anchor_status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	root.add_child(anchor_status)
	_build_peripheral()
	pulse = ColorRect.new()
	pulse.color = Color(0.45, 0.52, 0.56, 0.0)
	pulse.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	pulse.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(pulse)
	fade = ColorRect.new()
	fade.color = Color(0.015, 0.018, 0.024, 0.0)
	fade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(fade)
	reader = preload("res://scenes/ui/letter_reader.tscn").instantiate()
	root.add_child(reader)
	reader.close_requested.connect(close_modal)
	game_over = preload("res://scenes/ui/game_over.tscn").instantiate()
	game_over.hide()
	game_over.process_mode = Node.PROCESS_MODE_DISABLED
	root.add_child(game_over)
	game_over.selected.connect(_result_action)
	chapter_complete = preload("res://scenes/ui/chapter_complete.tscn").instantiate()
	chapter_complete.hide()
	chapter_complete.process_mode = Node.PROCESS_MODE_DISABLED
	root.add_child(chapter_complete)
	chapter_complete.selected.connect(_result_action)
	pause_menu = preload("res://scenes/ui/pause_menu.tscn").instantiate()
	root.add_child(pause_menu)
	EventBus.subtitle_requested.connect(enqueue_subtitle)
	EventBus.sense_restored.connect(transaction)
	EventBus.tension_changed.connect(_set_threat_state)
	EventBus.player_detected.connect(_detection_impact)
	EventBus.player_caught.connect(_caught_fade)
	EventBus.anchor_progress.connect(_anchor_progress)
	EventBus.anchor_cleansed.connect(_anchor_cleansed)

func _caught_fade() -> void:
	create_tween().tween_property(fade, "color:a", 1.0, 1.0)

func _anchor_cleansed(_id: String, _total: int) -> void:
	anchor_status.text = ""

func _build_peripheral() -> void:
	var specs := [
		[0.0, 0.0, 1.0, 0.12], [0.0, 0.88, 1.0, 1.0],
		[0.0, 0.12, 0.08, 0.88], [0.92, 0.12, 1.0, 0.88]
	]
	for spec in specs:
		var edge := ColorRect.new()
		edge.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		edge.anchor_left = spec[0]
		edge.anchor_top = spec[1]
		edge.anchor_right = spec[2]
		edge.anchor_bottom = spec[3]
		edge.color = Color(0.16, 0.018, 0.025, 0.0)
		edge.mouse_filter = Control.MOUSE_FILTER_IGNORE
		root.add_child(edge)
		peripheral.append(edge)

func make_label(text: String, size: int = 18) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", Color(0.85, 0.87, 0.86))
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return label

func _process(delta: float) -> void:
	threat_clock += delta
	_layout_for_viewport()
	bubble.visible = not subtitle.text.is_empty() and (SessionSettings.subtitles_enabled or acknowledged_message) and not reader.visible and not pause_menu.visible and not game_over.visible and not chapter_complete.visible
	var playing_hud := GameManager.zone != "intro" and GameManager.state != GameManager.State.ENDING
	senses.visible = playing_hud
	vitals.visible = playing_hud
	room_name.visible = playing_hud
	senses.text = "  /  ".join(["Hearing " + status("hearing"), "Sight " + status("sight"), "Memory " + status("memory")])
	vitals.text = "Charge %02d  |  HP %03d  |  B %d  G %d  C %d" % [
		ceili(FreedomLedger.flashlight_seconds), ceili(FreedomLedger.hp),
		int(FreedomLedger.inventory.get("battery", 0)), int(FreedomLedger.inventory.get("bottle", 0)), int(FreedomLedger.inventory.get("clock", 0))]
	var room = get_tree().get_first_node_in_group("room")
	room_name.text = room.current_room_id if room != null else ""
	var player = get_tree().get_first_node_in_group("player")
	prompt.visible = false
	var strain := 0.0
	if player != null:
		strain = clampf((player.breath_seconds - 4.0) / 2.0, 0.0, 1.0) if player.holding_breath else 0.0
	var threat_edge := 0.0
	if threat_state == "SEARCHING":
		threat_edge = 0.045 + (sin(threat_clock * 3.2) + 1.0) * 0.018
	elif threat_state == "CHASE":
		threat_edge = 0.12 + (sin(threat_clock * 7.0) + 1.0) * 0.055
	for edge in peripheral:
		edge.color.a = maxf(strain * 0.62, threat_edge)
	if player != null and GameManager.state == GameManager.State.PLAYING:
		prompt.visible = is_instance_valid(player.target_interactable) or player.hidden_spot != null
		var target: Node2D = player.hidden_spot if player.hidden_spot != null else player.target_interactable
		prompt.text = "[E]"
		if is_instance_valid(target) and not target.display_name.is_empty():
			prompt.text += " " + target.display_name
		prompt.size = prompt.get_minimum_size()
		var point: Vector2 = player.get_global_transform_with_canvas().origin
		prompt.position = Vector2(clampf(point.x - prompt.size.x * 0.5, 12, root.size.x - prompt.size.x - 12), point.y - 98)
	if not get_tree().paused:
		subtitle_time -= delta
		if subtitle_time <= 0.0:
			if bubble.visible and bubble.advance_page():
				subtitle_time = 4.0
			elif not subtitle_queue.is_empty():
				var item: Dictionary = subtitle_queue.pop_front()
				bubble.show_text(item.speaker, item.text)
				subtitle_time = item.duration
			else:
				subtitle.text = ""
	if GameManager.state == GameManager.State.ENDING and not ending_shown:
		ending_shown = true
		show_ending()

func _layout_for_viewport() -> void:
	var narrow := root.size.x < 900.0
	room_name.offset_top = 78.0 if narrow else 22.0
	room_name.offset_bottom = room_name.offset_top + 24.0

func status(sense: String) -> String:
	return "restored" if sense in FreedomLedger.keys_collected else "sealed"

func enqueue_subtitle(speaker: String, text: String, duration: float) -> void:
	subtitle_queue.append({"speaker": speaker, "text": text, "duration": duration})

func transaction(_sense: String) -> void:
	pulse.color = Color(0.38, 0.07, 0.08, 0.16)
	pulse.color.a = 0.16
	create_tween().tween_property(pulse, "color:a", 0.0, 0.65)

func _set_threat_state(next: String) -> void:
	threat_state = next

func _detection_impact(_source: Node) -> void:
	pulse.color = Color(0.5, 0.025, 0.035, 0.24)
	create_tween().tween_property(pulse, "color:a", 0.0, 0.42)

func _anchor_progress(id: String, seconds: float, required: float) -> void:
	anchor_status.text = "%s  %02d / %02d" % [id, floori(seconds), floori(required)] if seconds > 0.0 else ""

func _input(event: InputEvent) -> void:
	if reader.visible or pause_menu.visible or game_over.visible or chapter_complete.visible:
		return
	if event.is_echo():
		return
	if event.is_action_pressed("inventory") and GameManager.state == GameManager.State.PLAYING:
		get_viewport().set_input_as_handled()
		var lines: PackedStringArray = []
		for item in FreedomLedger.inventory:
			lines.append("%s: %d" % [str(item).capitalize(), int(FreedomLedger.inventory[item])])
		lines.append("\nLetters collected: %d" % FreedomLedger.letter_ids.size())
		lines.append("\nRestored senses: " + (", ".join(FreedomLedger.keys_collected) if not FreedomLedger.keys_collected.is_empty() else "None"))
		show_letter("Inventory", "\n".join(lines))
	elif event.is_action_pressed("pause") or event.is_action_pressed("ui_cancel"):
		if acknowledged_message:
			close_message()
		elif GameManager.state in [GameManager.State.PLAYING, GameManager.State.INTRO]:
			GameManager.pause_game()
			show_pause()
		get_viewport().set_input_as_handled()
	elif bubble.visible and (event.is_action_pressed("interact") or event.is_action_pressed("ui_accept")):
		get_viewport().set_input_as_handled()
		GameManager.block_ui_input()
		if not bubble.advance_page():
			if acknowledged_message:
				close_message()
			else:
				subtitle.text = ""
				subtitle_time = 0.0

func show_pause() -> void:
	pause_menu.open()

func show_letter(title: String, text: String) -> void:
	GameManager.read_letter()
	modal_mode = "letter"
	reader.open(title, text)

func show_message(speaker: String, text: String) -> void:
	GameManager.read_letter()
	acknowledged_message = true
	bubble.show_text(speaker, text)

func close_message() -> void:
	acknowledged_message = false
	subtitle.text = ""
	GameManager.block_ui_input()
	GameManager.resume()

func close_modal() -> void:
	reader.hide()
	GameManager.block_ui_input()
	if modal_mode == "ending":
		modal_mode = ""
		chapter_complete.process_mode = Node.PROCESS_MODE_INHERIT
		chapter_complete.show()
		chapter_complete.focus_default()
	else:
		modal_mode = ""
		GameManager.resume()

func show_game_over() -> void:
	subtitle.text = ""
	game_over.process_mode = Node.PROCESS_MODE_INHERIT
	game_over.show()
	game_over.set_selection(0, false)

func _result_action(id: String) -> void:
	if result_busy:
		return
	result_busy = true
	GameManager.block_ui_input()
	match id:
		"home": GameManager.go_home.call_deferred()
		"retry": GameManager.restart_checkpoint.call_deferred()
		"continue":
			if GameManager.ending in ["untouched", "partial_mercy", "vantree"]:
				GameManager.continue_to_part_two.call_deferred()
			else:
				GameManager.new_game.call_deferred()

func show_ending() -> void:
	fade.color.a = 0.88
	var titles := {
		"untouched": "UNTOUCHED", "partial_mercy": "PARTIAL MERCY", "vantree": "VANTREE",
		"severance": "SEVERANCE", "custodian_rest": "CUSTODIAN'S REST", "vessel": "VESSEL"
	}
	var texts := {
		"untouched": "The front door opens before the house learns her shape.\nEvery stolen sense remains sealed.",
		"partial_mercy": "Cold water gives way to older stone.\nTwo seals broken. One left dormant.",
		"vantree": "The conduit recognizes her name.\nBlood and stone carry it downward.",
		"severance": "The last bond breaks. The Deprived One is gone.",
		"custodian_rest": "Els takes the empty place and becomes the living ward.",
		"vessel": "The prison closes around a new key. An unseen hand carries it away."
	}
	get_tree().paused = true
	modal_mode = "ending"
	var closing := ""
	if GameManager.ending in ["severance", "custodian_rest", "vessel"]:
		closing = "\n\nFreedom was never lost in this house.\nIt was only ever moved from one hand to another.\n\nThe only question was ever whose hand was empty\nwhen the counting stopped."
	reader.open(titles.get(GameManager.ending, "LIBERTAS VINCTA"), texts.get(GameManager.ending, "") + closing)
