extends CanvasLayer
const FieldGuide := preload("res://scripts/systems/field_guide.gd")
const UIStyle := preload("res://scripts/ui/ui_style.gd")
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
var narration: Control
var active_message: Control
var reader: Control
var game_over: Control
var chapter_complete: Control
var result_busy: bool = false
var acknowledged_message: bool = false
var anchor_status: Label
var fade: ColorRect
var pulse: ColorRect
var atmosphere_overlay: ColorRect
var objective_label: Label
var ability_label: Label
var activity_meter: ProgressBar
var survival_panel: Control

var subtitle_queue: Array[Dictionary] = []
var subtitle_time: float = 0.0
var modal_mode: String = ""
var ending_shown: bool = false
var nexus_narrating := false
var threat_state: String = "CALM"
var threat_clock: float = 0.0
var displayed_room_id: String = ""
var room_reveal: Tween

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	add_to_group("hud")
	root = Control.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.theme = ui_theme
	add_child(root)
	_build_peripheral()
	survival_panel = preload("res://scripts/ui/survival_panel.gd").new()
	root.add_child(survival_panel)
	senses = survival_panel.summary_label
	vitals = make_label("", 15)
	vitals.position = Vector2(28, 50)
	root.add_child(vitals)
	objective_label = make_label("", 15)
	objective_label.position = Vector2(28, 183)
	objective_label.size = Vector2(880, 40)
	root.add_child(objective_label)
	ability_label = make_label("", 15)
	ability_label.position = Vector2(28, 209)
	ability_label.add_theme_color_override("font_color", Color("a7ceca"))
	root.add_child(ability_label)
	room_name = make_label("", 15)
	room_name.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
	room_name.offset_left = -330
	room_name.offset_right = -28
	room_name.offset_top = 22
	room_name.offset_bottom = 46
	room_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	room_name.add_theme_color_override("font_color", Color("c5b58f"))
	root.add_child(room_name)
	prompt = make_label("[E]", 16)
	prompt.add_theme_color_override("font_color", UIStyle.PAPER)
	prompt.add_theme_stylebox_override("normal", UIStyle.panel(Color(0.025, 0.035, 0.046, 0.94), UIStyle.RULE, 12))
	root.add_child(prompt)
	bubble = preload("res://scenes/ui/message_bubble.tscn").instantiate()
	root.add_child(bubble)
	narration = preload("res://scenes/ui/message_bubble.tscn").instantiate()
	narration.narration = true
	narration.name = "Narration"
	root.add_child(narration)
	active_message = bubble
	subtitle = bubble.text_label
	anchor_status = make_label("", 17)
	anchor_status.set_anchors_and_offsets_preset(Control.PRESET_CENTER_BOTTOM)
	anchor_status.offset_left = -350
	anchor_status.offset_right = 350
	anchor_status.offset_top = -94
	anchor_status.offset_bottom = -67
	anchor_status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	root.add_child(anchor_status)
	activity_meter = ProgressBar.new()
	activity_meter.set_anchors_and_offsets_preset(Control.PRESET_CENTER_BOTTOM)
	activity_meter.offset_left = -160
	activity_meter.offset_right = 160
	activity_meter.offset_top = -60
	activity_meter.offset_bottom = -53
	activity_meter.show_percentage = false
	activity_meter.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var fill := StyleBoxFlat.new()
	fill.bg_color = Color("b6cfc2")
	activity_meter.add_theme_stylebox_override("fill", fill)
	var track := StyleBoxFlat.new()
	track.bg_color = Color("272e31")
	activity_meter.add_theme_stylebox_override("background", track)
	activity_meter.size.y = 7
	activity_meter.hide()
	root.add_child(activity_meter)
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
	anchor_status.text = ""
	activity_meter.hide()
	create_tween().tween_property(fade, "color:a", 1.0, 1.0)

func _anchor_cleansed(_id: String, _total: int) -> void:
	anchor_status.text = ""
	activity_meter.hide()

func _build_peripheral() -> void:
	atmosphere_overlay = ColorRect.new()
	atmosphere_overlay.name = "HorrorVignette"
	atmosphere_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	atmosphere_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var effect := ShaderMaterial.new()
	effect.shader = preload("res://shaders/horror_vignette.gdshader")
	atmosphere_overlay.material = effect
	root.add_child(atmosphere_overlay)

func make_label(text: String, size: int = 18) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", Color(0.85, 0.87, 0.86))
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return label

func _process(delta: float) -> void:
	if not get_tree().paused:
		threat_clock += delta
	_layout_for_viewport()
	var message_visible := not subtitle.text.is_empty() and (SessionSettings.subtitles_enabled or acknowledged_message or nexus_narrating) and not reader.visible and not pause_menu.visible and not game_over.visible and not chapter_complete.visible
	bubble.visible = active_message == bubble and message_visible
	narration.visible = active_message == narration and message_visible
	var playing_hud := GameManager.zone != "intro" and GameManager.state != GameManager.State.ENDING and not reader.visible and not pause_menu.visible and not game_over.visible
	senses.visible = playing_hud
	vitals.visible = false
	survival_panel.visible = playing_hud
	survival_panel.update_values(delta)
	room_name.visible = playing_hud
	vitals.text = "Charge %02d  |  HP %03d  |  Batteries %d  ·  Bottles %d  ·  Clocks %d" % [
		ceili(FreedomLedger.flashlight_charge), ceili(FreedomLedger.hp),
		int(FreedomLedger.inventory.get("battery", 0)), int(FreedomLedger.inventory.get("bottle", 0)), int(FreedomLedger.inventory.get("clock", 0))]
	var room = get_tree().get_first_node_in_group("room")
	if room != null and room.current_room_id != displayed_room_id:
		displayed_room_id = room.current_room_id
		for section in room.layout.rooms:
			if section.id == displayed_room_id:
				room_name.text = str(section.name).to_upper()
				if room_reveal != null and room_reveal.is_valid():
					room_reveal.kill()
				room_name.modulate.a = 0.0
				room_reveal = create_tween()
				room_reveal.tween_property(room_name, "modulate:a", 1.0, 0.5)
				break
	var player = get_tree().get_first_node_in_group("player")
	objective_label.visible = FreedomLedger.current_part == 2 and playing_hud
	ability_label.visible = objective_label.visible
	if objective_label.visible and player != null:
		objective_label.text = FieldGuide.objective(room)
		ability_label.text = FieldGuide.ability_status(player)
	prompt.visible = false
	var strain := 0.0
	if player != null:
		strain = clampf((player.breath_seconds - 4.0) / 2.0, 0.0, 1.0) if player.holding_breath else 0.0
	var threat_edge := 0.0
	if room != null and room.zone_id == "nexus" and room.alarm_seconds > 0.0:
		pulse.color = Color(0.9, 0.015, 0.02, minf(1.0, room.alarm_seconds) * (0.12 + 0.18 * (0.5 + 0.5 * sin(room.alarm_seconds * 9.0))))
	elif not get_tree().paused:
		pulse.color.a = move_toward(pulse.color.a, 0.0, delta)
	if threat_state == "SEARCHING":
		threat_edge = 0.045 + (sin(threat_clock * 3.2) + 1.0) * 0.018
	elif threat_state == "CHASE":
		threat_edge = 0.12 + (sin(threat_clock * 7.0) + 1.0) * 0.055
	atmosphere_overlay.material.set_shader_parameter("danger", maxf(strain * 0.62, threat_edge * 3.0))
	atmosphere_overlay.material.set_shader_parameter("elapsed", threat_clock)
	if player != null and GameManager.state == GameManager.State.PLAYING:
		prompt.visible = is_instance_valid(player.target_interactable) or player.hidden_spot != null
		var target: Node2D = player.hidden_spot if player.hidden_spot != null else player.target_interactable
		prompt.text = "[E]"
		if player.hidden_spot != null:
			prompt.text = "[E] Leave hiding"
		elif is_instance_valid(target) and not target.display_name.is_empty():
			prompt.text += " " + target.display_name
			if target.kind == "puzzle":
				prompt.text += "  ·  %d/%d" % [target.progress, target.puzzle_steps]
		prompt.size = prompt.get_minimum_size()
		var point: Vector2 = player.get_global_transform_with_canvas().origin
		prompt.position = Vector2(clampf(point.x - prompt.size.x * 0.5, 12, root.size.x - prompt.size.x - 12), clampf(point.y + 12, 96, root.size.y - prompt.size.y - 12))
	if not get_tree().paused:
		subtitle_time -= delta
		if subtitle_time <= 0.0:
			if not subtitle.text.is_empty() and active_message.advance_page():
				subtitle_time = _reading_seconds()
			elif not subtitle_queue.is_empty():
				var item: Dictionary = subtitle_queue.pop_front()
				_present_message(item.speaker, item.text)
				subtitle_time = maxf(item.duration, _reading_seconds())
			else:
				active_message.dismiss()
		elif subtitle_time < 0.2 and active_message.page_index + 1 >= active_message.pages.size() and subtitle_queue.is_empty():
			active_message.fade_out(subtitle_time)
	if GameManager.state == GameManager.State.ENDING and not ending_shown:
		ending_shown = true
		show_ending()

func _layout_for_viewport() -> void:
	# canvas_items scales logical pixels down in small windows. Preserve readable
	# physical HUD text rather than making the enlarged panel tiny again at 800px.
	var pixel_scale := maxf(get_viewport().get_stretch_transform().get_scale().x, 0.01)
	var display_width := root.size.x * pixel_scale
	var margin := 20.0 / pixel_scale
	var panel_width := minf(clampf(display_width * 0.32, 400.0, 480.0), display_width - 40.0)
	survival_panel.position = Vector2(margin, margin)
	survival_panel.scale = Vector2.ONE * panel_width / (survival_panel.PANEL_SIZE.x * pixel_scale)
	var panel_bottom := survival_panel.position.y + survival_panel.size.y * survival_panel.scale.y
	var panel_right := survival_panel.position.x + survival_panel.size.x * survival_panel.scale.x
	var right_space := root.size.x - panel_right - margin * 2.0
	var narrow := right_space * pixel_scale < 400.0
	objective_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	ability_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	var width := minf(680.0 / pixel_scale, root.size.x - 36.0) if narrow else minf(520.0 / pixel_scale, right_space)
	var caption_below := display_width < 1000.0
	objective_label.add_theme_font_size_override("font_size", maxi(15, ceili(13.0 / pixel_scale)))
	ability_label.add_theme_font_size_override("font_size", maxi(15, ceili(13.0 / pixel_scale)))
	objective_label.position = Vector2(margin if narrow else root.size.x - width - margin, panel_bottom + (46.0 if caption_below else 14.0) / pixel_scale if narrow else margin + 42.0 / pixel_scale)
	objective_label.size = Vector2(width, 1)
	ability_label.position = Vector2(objective_label.position.x, objective_label.position.y + objective_label.get_minimum_size().y + 12)
	ability_label.size = Vector2(width, 1)
	room_name.offset_right = -margin
	room_name.offset_left = -margin - 310.0
	room_name.offset_top = panel_bottom + 10.0 / pixel_scale if caption_below else margin
	room_name.offset_bottom = room_name.offset_top + 24.0
	# Narration and a live charge/ritual indicator occupy separate rows.
	var bottom := 94.0
	if narration.visible:
		bottom = maxf(bottom, root.size.y - narration.design.get_global_rect().position.y + 48.0)
	anchor_status.offset_top = -bottom
	anchor_status.offset_bottom = -bottom + 27
	activity_meter.offset_top = -bottom + 34
	activity_meter.offset_bottom = -bottom + 41

func status(sense: String) -> String:
	return "restored" if sense in FreedomLedger.keys_collected else "sealed"

func enqueue_subtitle(speaker: String, text: String, duration: float) -> void:
	if text.strip_edges().is_empty():
		return
	# Repeated attempts at a sealed passage must not queue the same comment forever.
	if subtitle_queue.any(func(item: Dictionary): return item.speaker == speaker and item.text == text):
		return
	var message_body := (speaker + "\n" if not speaker.is_empty() and speaker != "ELS" and speaker not in ["NARRATOR", "STORYTELLER", "STORY TELLER"] else "") + text
	if is_instance_valid(active_message) and active_message.visible and active_message.body == message_body:
		return
	subtitle_queue.append({"speaker": speaker, "text": text, "duration": duration})

func _present_message(speaker: String, text: String) -> void:
	bubble.dismiss()
	narration.dismiss()
	var is_narrator := speaker.strip_edges().to_upper() in ["", "NARRATOR", "STORYTELLER", "STORY TELLER"]
	active_message = narration if is_narrator else bubble
	if not is_narrator:
		var group := "enemy" if speaker == "THE DEPRIVED" else "player"
		bubble.follow_target = get_tree().get_first_node_in_group(group)
	active_message.show_text("" if is_narrator else speaker, text)
	subtitle = active_message.text_label

func _reading_seconds() -> float:
	return clampf(float(subtitle.text.length()) / 22.0, 1.5, 8.0)

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
	var label: String = {"LN-A": "Severance — hold E", "LN-B": "Custodian's Rest — hold E", "LN-C": "Vessel — hold E"}.get(id, id)
	anchor_status.text = "%s  %02d / %02ds" % [label, floori(seconds), ceili(required)] if seconds > 0.0 else ""
	activity_meter.visible = seconds > 0.0
	activity_meter.value = seconds / maxf(required, 0.01) * 100.0
	if id.begins_with("Charging"):
		var percent := FreedomLedger.flashlight_charge
		anchor_status.text = "CHARGING  %d%%   /   Move to cancel" % floori(percent)
		activity_meter.value = percent

func _input(event: InputEvent) -> void:
	if reader.visible or pause_menu.visible or game_over.visible or chapter_complete.visible:
		return
	if event.is_echo():
		return
	if event is InputEventKey and event.pressed and (event.physical_keycode == KEY_H or event.keycode == KEY_H) and GameManager.state == GameManager.State.PLAYING:
		get_viewport().set_input_as_handled()
		GameManager.block_ui_input()
		show_letter("Els' Field Guide", FieldGuide.guide_text())
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
	elif active_message.visible and (event.is_action_pressed("interact") or event.is_action_pressed("ui_accept")):
		# Ambient comments must not eat the next lockpick/pickup/hiding press.
		if not acknowledged_message and event.is_action_pressed("interact") and GameManager.state == GameManager.State.PLAYING:
			var player = get_tree().get_first_node_in_group("player")
			if player != null:
				player._find_interactable()
				if is_instance_valid(player.target_interactable) or player.hidden_spot != null:
					return
		get_viewport().set_input_as_handled()
		GameManager.block_ui_input()
		if not active_message.advance_page():
			if acknowledged_message:
				close_message()
			else:
				active_message.dismiss()
				subtitle_time = 0.0
		else:
			subtitle_time = _reading_seconds()

func show_pause() -> void:
	pause_menu.open()

func show_letter(title: String, text: String) -> void:
	GameManager.read_letter()
	modal_mode = "letter"
	reader.open(title, text)

func show_message(speaker: String, text: String) -> void:
	GameManager.read_letter()
	acknowledged_message = true
	_present_message(speaker, text)

func close_message() -> void:
	acknowledged_message = false
	active_message.dismiss()
	subtitle_time = 0.0
	GameManager.block_ui_input()
	GameManager.resume()

func close_modal() -> void:
	reader.hide()
	GameManager.block_ui_input()
	if modal_mode == "ending":
		modal_mode = ""
		if GameManager.ending == "flee":
			GameManager.finish_flee_to_menu.call_deferred()
			return
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
	game_over.focus_default()

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
	if GameManager.ending in ["destroy", "flee"]:
		nexus_narrating = true
		subtitle_queue.clear()
		fade.color.a = 0.55
		var copy := preload("res://scripts/ui/nexus_narration.gd")
		var text: String = copy.FLEE if GameManager.ending == "flee" else copy.DESTROY
		_present_message("", text)
		subtitle_time = _reading_seconds()
		# Existing cinematic strip paginates the complete copy; E/Enter advances.
		while not subtitle.text.is_empty():
			await get_tree().process_frame
		nexus_narrating = false
		get_tree().paused = true
		fade.color.a = 0.88
		modal_mode = "ending"
		reader.open("FLEE" if GameManager.ending == "flee" else "DESTROY", text)
		return
	if GameManager.ending in ["severance", "custodian_rest", "vessel"]:
		get_tree().paused = true
		var sequence := preload("res://scripts/ui/ending_sequence.gd").new()
		get_tree().get_first_node_in_group("room").add_child(sequence)
		await sequence.play(GameManager.ending, self)
	fade.color.a = 0.88
	var titles := {
		"untouched": "UNTOUCHED", "partial_mercy": "PARTIAL MERCY", "vantree": "VANTREE",
		"severance": "SEVERANCE", "custodian_rest": "CUSTODIAN'S REST", "vessel": "VESSEL"
	}
	var texts := {
		"untouched": "The front door opens before the house learns her shape.\nEvery stolen sense remains sealed.",
		"partial_mercy": "Cold water gives way to older stone.\nTwo seals broken. One left dormant.",
		"vantree": "The conduit recognizes her name.\nBlood and stone carry it downward.",
		"severance": "The captive and the bond are destroyed.",
		"custodian_rest": "Els Vantree becomes the living ward.",
		"vessel": "The prison waits in another key."
	}
	get_tree().paused = true
	modal_mode = "ending"
	var closing := ""
	if GameManager.ending in ["severance", "custodian_rest", "vessel"]:
		closing = "\n\nFreedom was never lost in this house.\nIt was only ever moved from one hand to another.\n\nThe only question was ever whose hand was empty\nwhen the counting stopped."
	reader.open(titles.get(GameManager.ending, "LIBERTAS VINCTA"), texts.get(GameManager.ending, "") + closing)
