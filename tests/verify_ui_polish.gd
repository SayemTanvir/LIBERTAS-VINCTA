extends Node
var failures: Array[String] = []
var checks := 0

func check(value: bool, description: String) -> void:
	checks += 1
	if not value:
		failures.append(description)
		push_error(description)

func _ready() -> void:
	preload("res://tests/settings_fixture.gd").isolate()
	get_tree().root.notification(MainLoop.NOTIFICATION_APPLICATION_FOCUS_IN)
	get_tree().root.notification(Node.NOTIFICATION_WM_MOUSE_ENTER)
	_run.call_deferred()

func _run() -> void:
	var bubble = preload("res://scenes/ui/message_bubble.tscn").instantiate()
	add_child(bubble)
	bubble.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bubble.show_text("", "Entering Hollowmere...")
	await get_tree().process_frame
	var short_size: Vector2 = bubble.design.size
	var short_scale: Vector2 = bubble.design.scale
	check(bubble.text_label.get_theme_font_size("normal_font_size") == 34, "Message font size stays unchanged")
	check(bubble.text_label.get_content_height() <= bubble.text_label.size.y, "Short message is not clipped")
	check(not bubble.advance_page(), "Short message has only one page")
	bubble.show_text("ELS", "The house remembers every name. ".repeat(70))
	await get_tree().process_frame
	check(bubble.design.size.x > short_size.x and bubble.design.size.y > short_size.y, "Short messages use a smaller boundary")
	check(bubble.design.scale.is_equal_approx(short_scale), "Short messages do not enlarge the text scale")
	check(bubble.advance_page(), "Long messages still paginate")
	check(bubble.page_index == 1, "Long message advances to the next page")
	bubble.show_text("", "A small message.\nWith a second line.")
	await get_tree().process_frame
	check(bubble.page_index == 0, "New message resets pagination")
	check(bubble.text_label.get_content_height() <= bubble.text_label.size.y, "Explicit line breaks fit inside bubble")
	bubble.queue_free()
	await get_tree().process_frame
	var settings = preload("res://scenes/ui/settings_page.tscn").instantiate()
	add_child(settings)
	settings.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	await get_tree().process_frame
	for value in [0.0, 0.5, 1.0]:
		var point: Vector2 = settings.buttons[0].get_global_transform() * Vector2(228 + 192 * value, 26)
		var motion := InputEventMouseMotion.new()
		motion.position = point
		motion.global_position = point
		get_viewport().push_input(motion, true)
		await get_tree().process_frame
		var press := InputEventMouseButton.new()
		press.position = point
		press.global_position = point
		press.button_index = MOUSE_BUTTON_LEFT
		press.pressed = true
		get_viewport().push_input(press, true)
		await get_tree().process_frame
		press = press.duplicate()
		press.pressed = false
		get_viewport().push_input(press, true)
		check(is_equal_approx(SessionSettings.volumes.Master, value), "Actual pointer sets slider to " + str(value))
	check(ResourceLoader.exists("res://assets/BG/10_Credits/credits_contributions.png"), "Renamed credits texture resolves")
	check(not FileAccess.file_exists("res://assets/BG/10_Credits/credits_ifat_implementation.png"), "Old named credits asset is gone")
	print("UI POLISH CHECK: %d checks, %d failures" % [checks, failures.size()])
	get_tree().quit(0 if failures.is_empty() else 1)
