extends Node

var checks := 0
var failures := 0

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error(message)

func _ready() -> void:
	_run()

func _run() -> void:
	FreedomLedger.reset()
	check(not CollectibleManager.is_key_revealed("hearing"), "Hearing key should wait for the piano seal")
	check(not CollectibleManager.is_key_revealed("sight") and not CollectibleManager.is_key_revealed("memory"), "Later keys should start hidden")
	check(CollectibleManager.is_next_key("hearing"), "First key should be current")
	check(not CollectibleManager.is_next_key("sight") and not CollectibleManager.is_next_key("memory"), "Only the first key should be current")
	check(CollectibleManager.is_letter_revealed("vantree_01"), "First letter should be active at the start")
	check(not CollectibleManager.is_letter_revealed("vantree_02"), "Second letter should start hidden")

	FreedomLedger.flags["piano_seal"] = true
	check(CollectibleManager.is_key_revealed("hearing"), "Hearing key should appear after the piano seal")
	check(FreedomLedger.restore_sense("hearing"), "First key should collect")
	check(CollectibleManager.is_next_key("sight"), "Second key should be next")
	check(not CollectibleManager.is_next_key("hearing") and not CollectibleManager.is_next_key("memory"), "Only the second key should be current")

	check(FreedomLedger.collect_letter("vantree_01"), "First letter should collect")
	CollectibleManager.advance()
	check(CollectibleManager.is_letter_revealed("vantree_02"), "Second letter should appear after the first is read")
	check(not CollectibleManager.is_key_revealed("sight"), "Sight key should wait for the vanity seal")
	FreedomLedger.flags["vanity_seal"] = true
	check(CollectibleManager.is_key_revealed("sight"), "Sight key should appear after the vanity seal")
	check(not CollectibleManager.is_key_revealed("memory"), "Memory key should remain hidden")
	check(not CollectibleManager.is_letter_revealed("vantree_01"), "Read letter should no longer be current")
	check(CollectibleManager.is_next_key("sight"), "Second key remains current until collected")

	check(FreedomLedger.restore_sense("sight"), "Second key should collect")
	check(not CollectibleManager.is_key_revealed("sight"), "Collected Sight key should disappear")
	check(CollectibleManager.is_letter_revealed("vantree_02"), "Second letter should reveal after second key")
	check(not CollectibleManager.is_letter_revealed("vantree_03"), "Third letter should remain hidden")
	check(CollectibleManager.is_next_key("memory"), "Third key should be next")

	print("KEY/LETTER SEQUENCE: %d checks, %d failures" % [checks, failures])
	get_tree().quit(0 if failures == 0 else 1)
