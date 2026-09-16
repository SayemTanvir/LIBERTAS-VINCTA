extends "res://tests/verify_full_playthrough.gd"

func _run() -> void:
	GameManager.save_path = "res://build/gap3_save.json"
	if not await _start_campaign():
		return
	for repeat in 2:
		await _solve("PianoSeal")
		await _use("HearingKey")
		await _use("UpperStairs")
		if not await _wait_zone("upper"): return
		await _solve("VanitySeal")
		await _use("SightKey")
		await _use("UpperStairs")
		if not await _wait_zone("ground"): return
		await _use("BasementStairs")
		if not await _wait_zone("basement"): return
		await _solve("RitualSeal")
		await _use("MemoryKey")
		await _use("GroundStairs")
		if not await _wait_zone("ground"): return
		await _use("FrontDoor")
		if repeat == 1:
			var deadline := Time.get_ticks_msec() + 15000
			while Time.get_ticks_msec() < deadline:
				await get_tree().process_frame
				var current := get_tree().current_scene
				if current != null and GameManager.state == GameManager.State.READING:
					main = current
					var hud = main.get_node("UI")
					_check(hud.reader.document.full_text == preload("res://scripts/systems/memory_fragment.gd").TEXT, "Second loop shows approved memory page")
					hud.close_modal()
					break
		if not await _wait_zone("ground"): return
		_check(FreedomLedger.loop_counter == repeat + 1, "Loop counter increments")
		_check(FreedomLedger.inventory.lockpick >= 2, "Two picks available after each Loop")
		_check(FreedomLedger.keys_collected.is_empty() and FreedomLedger.letter_ids.is_empty(), "Keys and letters reset")
		_check(FreedomLedger.flags.get("flashlight", false), "Flashlight ownership retained")
	_check(FreedomLedger.flags.get("vantree_memory_fragment_A", false), "Second-loop flag set")
	print("GAP 3: %d checks, %d failures" % [checks, failures.size()])
	get_tree().quit(0 if failures.is_empty() else 1)
