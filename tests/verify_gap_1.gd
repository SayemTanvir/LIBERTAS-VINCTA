extends Node
var checks := 0
var failures := 0
func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error(message)
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_run.call_deferred()
func _run() -> void:
	var reader = preload("res://scenes/ui/letter_reader.tscn").instantiate()
	add_child(reader)
	var layout: Dictionary = preload("res://data/estate_layout.json").data
	for zone in layout:
		for prop in layout[zone].props:
			if prop[0] != "letter_pickup":
				continue
			GameManager.state = GameManager.State.PLAYING
			GameManager.read_letter()
			reader.open(prop[4].title, prop[4].text)
			check(get_tree().paused, "Reading pauses world")
			check(reader.document.pages.size() > 1, prop[1] + " has multiple pages")
			check("".join(reader.document.pages) == prop[4].text, prop[1] + " retains exact full text")
			check(reader.document.content.visible_characters == 0, "Text waits for unroll")
			await get_tree().create_timer(0.85, true).timeout
			check(reader.document.content.visible_characters > 0, "Typewriter begins after unroll")
			reader.document.reveal_page()
			check(not reader.document.typing, "Typing can be skipped")
			for i in reader.document.pages.size():
				reader.document.page_index = i
				reader.document._set_page()
				await get_tree().process_frame
				check(reader.document.content.get_content_height() <= reader.document.PAGE_HEIGHT, "Page fits parchment")
			reader.document.turn_page(-1)
			check(reader.document.page_index < reader.document.pages.size() - 1, "Back paging works")
			if DisplayServer.get_name() != "headless" and prop[1] == "vantree_01":
				reader.document.reveal_page()
				await RenderingServer.frame_post_draw
				get_viewport().get_texture().get_image().save_png("res://build/scroll_reader.png")
			reader.hide()
			GameManager.resume()
	FreedomLedger.reset()
	FreedomLedger.restore_sense("hearing")
	for i in range(8, 14):
		FreedomLedger.collect_letter("vantree_%02d" % i)
	check(not FreedomLedger.eligible("vantree"), "Lower letters cannot satisfy estate gate")
	for i in range(1, 4):
		FreedomLedger.collect_letter("vantree_%02d" % i)
	check(not FreedomLedger.eligible("vantree"), "Three estate letters do not satisfy gate")
	FreedomLedger.collect_letter("vantree_04")
	check(FreedomLedger.eligible("vantree"), "Exactly four estate letters satisfy gate")
	reader.queue_free()
	print("GAP 1: %d checks, %d failures" % [checks, failures])
	get_tree().quit(0 if failures == 0 else 1)
