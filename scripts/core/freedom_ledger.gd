extends Node
## Persistent game-state authority for both parts of LIBERTAS VINCTA.

const SENSES := ["hearing", "sight", "memory"]
const MAX_FLASHLIGHT_SECONDS := 90.0
const BASE_MAX_HP := 100.0
const CELL_SECONDS := 45.0

var keys_collected: Array[String] = []
var letter_ids: Array[String] = []
var flags: Dictionary = {}
var inventory: Dictionary = {}
var battery_charges: Array[float] = []
var hiding_usage: Dictionary = {}
var detections: int = 0
var loop_counter: int = 0
var ending_type: String = ""
var part2_seed: Dictionary = {}
var current_part: int = 1
var entity_stage: int = 0
var flashlight_seconds: float = MAX_FLASHLIGHT_SECONDS
var max_hp: float = BASE_MAX_HP
var hp: float = BASE_MAX_HP
var mechanic_uses: int = 0
var anchors_cleansed: Array[String] = []

var hearing_restored: bool:
	get: return "hearing" in keys_collected
var sight_restored: bool:
	get: return "sight" in keys_collected
var memory_restored: bool:
	get: return "memory" in keys_collected
var letters_found: int:
	get: return letter_ids.size()
var estate_letters_found: int:
	get:
		var count := 0
		for i in range(1, 8):
			if "vantree_%02d" % i in letter_ids:
				count += 1
		return count
var current_stage: int:
	get: return entity_stage

func reset() -> void:
	battery_charges.clear()
	keys_collected.clear()
	letter_ids.clear()
	flags.clear()
	inventory = {"battery": 0, "bottle": 0, "clock": 0, "lockpick": 0}
	hiding_usage.clear()
	detections = 0
	loop_counter = 0
	ending_type = ""
	part2_seed.clear()
	current_part = 1
	entity_stage = 0
	flashlight_seconds = MAX_FLASHLIGHT_SECONDS
	max_hp = BASE_MAX_HP
	hp = max_hp
	mechanic_uses = 0
	anchors_cleansed.clear()
	_emit_status()

func reset_for_loop() -> void:
	battery_charges.clear()
	loop_counter += 1
	keys_collected.clear()
	letter_ids.clear()
	flags.clear()
	flags["intro_complete"] = true
	flags["flashlight"] = true
	flags["loop_wake"] = true
	if loop_counter >= 2:
		flags["vantree_memory_fragment_A"] = true
	# The piano and vanity each need one pick on every repetition.
	# Retain remaining picks with a two-pick floor; all other ordinary items reset.
	inventory = {"battery": 0, "bottle": 0, "clock": 0, "lockpick": maxi(2, int(inventory.get("lockpick", 0)))}
	hiding_usage.clear()
	detections = 0
	ending_type = ""
	part2_seed.clear()
	current_part = 1
	entity_stage = 0
	flashlight_seconds = MAX_FLASHLIGHT_SECONDS
	max_hp = BASE_MAX_HP
	hp = max_hp
	mechanic_uses = 0
	anchors_cleansed.clear()
	_emit_status()

func restore_sense(sense: String) -> bool:
	if entity_stage >= SENSES.size() or sense != SENSES[entity_stage]:
		return false
	keys_collected.append(sense)
	entity_stage = keys_collected.size()
	EventBus.sense_restored.emit(sense)
	return true

func collect_letter(id: String) -> bool:
	if id in letter_ids:
		return false
	letter_ids.append(id)
	if id == "vantree_04":
		flags["lore_jailer_hint"] = true
	EventBus.letter_collected.emit(id)
	return true

func collect_item(id: String, amount: int = 1) -> void:
	if amount <= 0:
		return
	if id == "battery":
		_sync_batteries()
		for i in amount:
			battery_charges.append(100.0)
	inventory[id] = int(inventory.get(id, 0)) + amount
	EventBus.inventory_changed.emit(id, int(inventory[id]))

func consume_item(id: String, amount: int = 1) -> bool:
	if amount <= 0 or int(inventory.get(id, 0)) < amount:
		return false
	if id == "battery":
		_sync_batteries()
		for i in amount:
			battery_charges.pop_front()
	inventory[id] = int(inventory[id]) - amount
	EventBus.inventory_changed.emit(id, int(inventory[id]))
	return true

func record_detection() -> void:
	detections += 1
	EventBus.detection_recorded.emit(detections)

func _sync_batteries() -> void:
	# Migrate legacy count-only saves and scripted supply grants to full cells.
	var count := clampi(int(inventory.get("battery", 0)), 0, 999)
	inventory["battery"] = count
	while battery_charges.size() < count:
		battery_charges.append(100.0)
	if battery_charges.size() > count:
		battery_charges.resize(count)

func battery_percentages() -> Array[float]:
	_sync_batteries()
	return battery_charges.duplicate()

func recharge_from_batteries(seconds: float) -> float:
	if not is_finite(seconds) or seconds <= 0.0:
		return 0.0
	_sync_batteries()
	var wanted := minf(seconds, MAX_FLASHLIGHT_SECONDS - flashlight_seconds)
	var transferred := 0.0
	while wanted > 0.00001 and not battery_charges.is_empty():
		var used := minf(wanted, battery_charges[0] * CELL_SECONDS / 100.0)
		battery_charges[0] = maxf(0.0, battery_charges[0] - used / CELL_SECONDS * 100.0)
		transferred += used
		wanted -= used
		if battery_charges[0] < 0.0001:
			battery_charges.pop_front()
	inventory["battery"] = battery_charges.size()
	if transferred > 0.0:
		set_flashlight_seconds(flashlight_seconds + transferred)
		EventBus.inventory_changed.emit("battery", battery_charges.size())
	return transferred

func record_hiding_use(id: String) -> void:
	hiding_usage[id] = int(hiding_usage.get(id, 0)) + 1

func set_flashlight_seconds(value: float) -> void:
	flashlight_seconds = clampf(value, 0.0, MAX_FLASHLIGHT_SECONDS)
	EventBus.battery_changed.emit(flashlight_seconds, MAX_FLASHLIGHT_SECONDS)

func damage(amount: float) -> bool:
	if not is_finite(amount) or amount <= 0.0:
		return hp <= 0.0
	hp = maxf(0.0, hp - amount)
	EventBus.health_changed.emit(hp, max_hp)
	EventBus.player_hurt.emit(amount)
	return hp <= 0.0

func heal(amount: float) -> void:
	hp = minf(max_hp, hp + maxf(0.0, amount))
	EventBus.health_changed.emit(hp, max_hp)

func freedom_summary() -> String:
	if current_part == 1:
		var awareness := "blind" if keys_collected.is_empty() else ", ".join(keys_collected)
		return "Degrees of freedom: %d / 3 bonds released  |  Hound: %s" % [entity_stage, awareness]
	var choice := "Clockwork & glass" if part2_seed.get("full_gadgets", false) else ("Partial sigil" if part2_seed.get("hybrid_magic", false) else "Blood rites")
	return "Degrees of freedom: " + choice + "  |  [H] Field guide"

func eligible(candidate: String) -> bool:
	match candidate:
		"untouched": return current_part == 1 and entity_stage == 0 and detections == 0
		"vantree": return current_part == 1 and entity_stage == 1 and estate_letters_found >= 4
		"partial_mercy": return current_part == 1 and entity_stage == 2
		"loop": return current_part == 1 and entity_stage == 3
		"severance", "custodian_rest", "vessel":
			return current_part == 2 and anchors_cleansed.size() >= 1
	return false

func begin_part_two(part_one_ending: String) -> void:
	ending_type = part_one_ending
	part2_seed = _build_part2_seed(part_one_ending)
	current_part = 2
	anchors_cleansed.clear()
	mechanic_uses = 0
	flags["part1_complete"] = true
	flags["part2_started"] = true
	if part_one_ending == "untouched":
		for gadget in ["battery", "bottle", "clock"]:
			inventory[gadget] = maxi(3, int(inventory.get(gadget, 0)))
	max_hp = BASE_MAX_HP * (0.8 if part_one_ending == "vantree" else 1.0)
	hp = max_hp
	_emit_status()

func _build_part2_seed(part_one_ending: String) -> Dictionary:
	var inherited_senses: Array[String] = []
	if part_one_ending == "partial_mercy":
		inherited_senses.assign(keys_collected)
	var dormant: Array[String] = []
	for sense in SENSES:
		if sense not in inherited_senses:
			dormant.append(sense)
	return {
		"part1_ending": part_one_ending,
		"senses": inherited_senses,
		"dormant_senses": dormant,
		"monster_stage": inherited_senses.size(),
		"touch_mutation": part_one_ending == "vantree",
		"blood_magic": part_one_ending == "vantree",
		"hybrid_magic": part_one_ending == "partial_mercy",
		"full_gadgets": part_one_ending == "untouched",
		"hp_softcap": 0.8 if part_one_ending == "vantree" else 1.0,
		"loop_counter": loop_counter
	}

func cleanse_anchor(id: String) -> bool:
	if id in anchors_cleansed:
		return false
	anchors_cleansed.append(id)
	EventBus.anchor_cleansed.emit(id, anchors_cleansed.size())
	return true

func has_requirement(requirement: String) -> bool:
	if requirement.is_empty():
		return true
	if requirement in SENSES:
		return requirement in keys_collected
	if requirement.begins_with("letters:"):
		return letters_found >= int(requirement.get_slice(":", 1))
	if requirement.begins_with("items:"):
		var bits := requirement.split(":")
		return int(inventory.get(bits[1], 0)) >= int(bits[2])
	if requirement == "part2_mechanic_3":
		return mechanic_uses >= 3
	if requirement == "branch_vantree":
		return bool(part2_seed.get("blood_magic", false))
	if requirement == "branch_magic":
		return bool(part2_seed.get("blood_magic", false)) or bool(part2_seed.get("hybrid_magic", false))
	return bool(flags.get(requirement, false))

func snapshot() -> Dictionary:
	_sync_batteries()
	return {
		"battery_charges": battery_charges.duplicate(),
		"keys": keys_collected.duplicate(), "letters": letter_ids.duplicate(),
		"entity_stage": entity_stage, "ending_type": ending_type,
		"loop_counter": loop_counter, "part2_seed": part2_seed.duplicate(true),
		"flags": flags.duplicate(true), "inventory": inventory.duplicate(true),
		"hiding_usage": hiding_usage.duplicate(true), "detections": detections,
		"current_part": current_part, "flashlight_seconds": flashlight_seconds,
		"max_hp": max_hp, "hp": hp, "mechanic_uses": mechanic_uses,
		"anchors": anchors_cleansed.duplicate()
	}

func snapshot_is_valid(data: Variant) -> bool:
	if not data is Dictionary:
		return false
	if data.has("battery_charges"):
		if not data.battery_charges is Array or data.battery_charges.size() > 999:
			return false
		for charge in data.battery_charges:
			if not _finite_number(charge) or float(charge) <= 0.0 or float(charge) > 100.0:
				return false
	for key in ["keys", "letters", "anchors"]:
		if data.has(key):
			if not data[key] is Array:
				return false
			for value in data[key]:
				if not value is String:
					return false
	var keys: Array = data.get("keys", [])
	if keys.size() > SENSES.size():
		return false
	for i in keys.size():
		if keys[i] != SENSES[i]:
			return false
	for key in ["flags", "inventory", "hiding_usage", "part2_seed"]:
		if data.has(key) and not data[key] is Dictionary:
			return false
	for value in data.get("flags", {}).values():
		if not (value is bool or value is String or _finite_number(value)):
			return false
	for key in data.get("flags", {}):
		if str(key).ends_with("_steps") and not _finite_number(data.flags[key]):
			return false
	for key in ["entity_stage", "loop_counter", "detections", "current_part", "flashlight_seconds", "max_hp", "hp", "mechanic_uses"]:
		if data.has(key) and not _finite_number(data[key]):
			return false
	for key in ["loop_counter", "detections", "mechanic_uses"]:
		if absf(float(data.get(key, 0))) > 2147483647.0:
			return false
	for key in ["inventory", "hiding_usage"]:
		for value in data.get(key, {}).values():
			if not _finite_number(value) or absf(float(value)) > 2147483647.0:
				return false
	var part := float(data.get("current_part", 1))
	if part != 1.0 and part != 2.0:
		return false
	if int(data.get("current_part", 1)) == 2:
		var seed_data: Dictionary = data.get("part2_seed", {})
		if seed_data.get("part1_ending", "") not in ["untouched", "vantree", "partial_mercy"]:
			return false
	return true

func _finite_number(value: Variant) -> bool:
	return (value is int or value is float) and is_finite(float(value))

func restore_snapshot(data: Dictionary) -> void:
	if not snapshot_is_valid(data):
		push_warning("Invalid ledger snapshot; current state retained.")
		return
	keys_collected.assign(data.get("keys", []))
	letter_ids.assign(data.get("letters", []))
	entity_stage = keys_collected.size()
	ending_type = str(data.get("ending_type", ""))
	loop_counter = maxi(0, int(data.get("loop_counter", 0)))
	part2_seed = data.get("part2_seed", {}).duplicate(true)
	flags = data.get("flags", {}).duplicate(true)
	inventory = data.get("inventory", {"battery": 0, "bottle": 0, "clock": 0, "lockpick": 0}).duplicate(true)
	for id in inventory:
		inventory[id] = maxi(0, int(inventory[id]))
	battery_charges.assign(data.get("battery_charges", []))
	_sync_batteries()
	hiding_usage = data.get("hiding_usage", {}).duplicate(true)
	for id in hiding_usage:
		hiding_usage[id] = maxi(0, int(hiding_usage[id]))
	detections = maxi(0, int(data.get("detections", 0)))
	current_part = int(data.get("current_part", 1))
	if current_part == 2:
		# Branch effects are derived from the ending, not unchecked serialized flags.
		part2_seed = _build_part2_seed(str(part2_seed.part1_ending))
	flashlight_seconds = clampf(float(data.get("flashlight_seconds", MAX_FLASHLIGHT_SECONDS)), 0.0, MAX_FLASHLIGHT_SECONDS)
	max_hp = BASE_MAX_HP * (0.8 if current_part == 2 and part2_seed.get("blood_magic", false) else 1.0)
	hp = clampf(float(data.get("hp", max_hp)), 0.0, max_hp)
	mechanic_uses = maxi(0, int(data.get("mechanic_uses", 0)))
	anchors_cleansed.assign(data.get("anchors", []))
	_emit_status()

func _emit_status() -> void:
	EventBus.battery_changed.emit(flashlight_seconds, MAX_FLASHLIGHT_SECONDS)
	EventBus.health_changed.emit(hp, max_hp)
