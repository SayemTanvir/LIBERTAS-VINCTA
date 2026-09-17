extends Node
## Singleton managing sequential letter discovery.
## Letters are hidden in furniture and revealed one at a time.
## Collecting letter N unlocks letter N+1 in its container.

var current_unlocked_index: int = 1  ## Letter I is active from game start
const KEY_SENSES := ["hearing", "sight", "memory"]
const KEY_REQUIREMENTS := ["piano_seal", "vanity_seal", "ritual_seal"]

## Returns true if the given letter ID is the currently active (discoverable) letter.
func is_currently_active(letter_id: String) -> bool:
	var index := _parse_index(letter_id)
	return index == current_unlocked_index

func is_letter_revealed(letter_id: String) -> bool:
	var index := _parse_index(letter_id)
	return index > 0 and index == current_unlocked_index

func is_next_key(sense: String) -> bool:
	var next_index := FreedomLedger.keys_collected.size()
	return next_index < KEY_SENSES.size() and KEY_SENSES[next_index] == sense

func is_key_revealed(sense: String) -> bool:
	var key_index := KEY_SENSES.find(sense)
	if key_index < 0 or sense in FreedomLedger.keys_collected:
		return false
	return bool(FreedomLedger.flags.get(KEY_REQUIREMENTS[key_index], false))

## Advance to the next letter in the sequence after collecting the current one.
func advance() -> void:
	current_unlocked_index += 1

## Parse the numeric index from a letter ID like "vantree_01" -> 1.
func _parse_index(id: String) -> int:
	var parts := id.split("_")
	if parts.size() >= 2:
		return int(parts[-1])
	return -1

## Reset for new game or loop.
func reset() -> void:
	current_unlocked_index = 1

## Checkpoint save support.
func snapshot() -> Dictionary:
	return {"current_unlocked_index": current_unlocked_index}

## Checkpoint restore support.
func restore_snapshot(data: Dictionary) -> void:
	current_unlocked_index = clampi(int(data.get("current_unlocked_index", 1)), 1, 14)
