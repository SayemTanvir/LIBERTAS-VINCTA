extends Node
## Singleton managing sequential letter discovery.
## Letters are hidden in furniture and revealed one at a time.
## Collecting letter N unlocks letter N+1 in its container.

var current_unlocked_index: int = 1  ## Letter I is active from game start

## Returns true if the given letter ID is the currently active (discoverable) letter.
func is_currently_active(letter_id: String) -> bool:
	var index := _parse_index(letter_id)
	return index == current_unlocked_index

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
