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
	GameManager.save_path = "res://build/gap2_save.json"
	_run.call_deferred()
func _run() -> void:
	for ending in ["severance", "custodian_rest", "vessel"]:
		get_tree().paused = false
		FreedomLedger.reset()
		FreedomLedger.begin_part_two("untouched")
		GameManager.zone = "nexus"
		GameManager.entry = "start"
		GameManager.state = GameManager.State.PLAYING
		var main = preload("res://scenes/main/main.tscn").instantiate()
		add_child(main)
		var hud = main.get_node("UI")
		for enemy in get_tree().get_nodes_in_group("enemy"):
			enemy.set_physics_process(false)
		var chosen: BaseInteractable
		for prop in get_tree().get_nodes_in_group("interactable"):
			if prop.kind == "anchor":
				check(prop.channel_seconds == 20.0, "Anchor hold remains 20 seconds")
				if prop.ending_type == ending:
					chosen = prop
		FreedomLedger.cleanse_anchor(chosen.interaction_id)
		main.get_node("Entities/Player").position = chosen.position + Vector2(0, 20)
		GameManager.finish(ending)
		await get_tree().create_timer(2.0, true).timeout
		check(get_tree().paused and not hud.reader.visible, "Distinct sequence precedes end card")
		if DisplayServer.get_name() != "headless":
			await RenderingServer.frame_post_draw
			get_viewport().get_texture().get_image().save_png("res://build/ending_" + ending + ".png")
		await get_tree().create_timer(2.7, true).timeout
		check(hud.reader.visible, "Ending card opens")
		check(hud.reader.document.full_text.begins_with(preload("res://scripts/ui/ending_sequence.gd").CARDS[ending]), "Exact canonical card")
		hud.close_modal()
		check(hud.chapter_complete.visible and get_tree().paused, "Ending returns to result controls")
		main.queue_free()
		await get_tree().process_frame
	get_tree().paused = false
	print("GAP 2: %d checks, %d failures" % [checks, failures])
	get_tree().quit(0 if failures == 0 else 1)
