extends RefCounted
## Player-facing explanations shared by the HUD, tutorial and field guide.

static func room_groups() -> Array[Dictionary]:
	var layout: Dictionary = preload("res://data/estate_layout.json").data
	var floors := {"ground": "Ground Floor", "upper": "Upper Floor", "basement": "Basement", "roots": "Cathedral Roots", "echoes": "Chamber of Echoes", "nexus": "Ley-Nexus"}
	var groups: Array[Dictionary] = []
	for floor_id in floors:
		var names: PackedStringArray = []
		var rooms: Array = layout[floor_id].rooms.duplicate()
		if floor_id == "ground":
			rooms = layout.intro.rooms + rooms
		for room in rooms:
			names.append("%s  %s" % [room.id, room.name])
		groups.append({"floor": floors[floor_id], "rooms": "  •  ".join(names)})
	return groups

static func branch_name() -> String:
	if FreedomLedger.part2_seed.get("full_gadgets", false):
		return "Clockwork & glass"
	return "Partial sigil" if FreedomLedger.part2_seed.get("hybrid_magic", false) else "Blood rites"

static func tutorial() -> String:
	if FreedomLedger.part2_seed.get("full_gadgets", false):
		return "Press Q to throw bottles or set clocks. Three uses open Nexus Descent. H opens my field guide."
	if FreedomLedger.part2_seed.get("hybrid_magic", false):
		return "R draws a quiet circle. It blocks Hearing, but the Hound can still see. Three casts open Nexus Descent. H explains the rite."
	return "Find the Sigil Forge and press E to awaken my blood rites. Then R draws a silencing circle. H opens my field guide."

static func objective(room: Node) -> String:
	if GameManager.zone == "nexus":
		if room != null and not room.outcome.is_empty():
			return "The door is open. Press E at the threshold."
		return "Destroy: Knife + Guide + Power | Flee / Remain: hold E 20s. [H] Guide"
	if GameManager.zone == "echoes":
		if FreedomLedger.mechanic_uses >= 3:
			return "Nexus Descent is open â€” follow the passage in CE-05."
		if FreedomLedger.part2_seed.get("blood_magic", false) and not FreedomLedger.flags.get("part2_ability_unlocked", false):
			return "Find the Sigil Forge in CE-02. Press E to awaken blood rites. [H] Guide"
		var action := "Q: bottles / clocks" if FreedomLedger.part2_seed.get("full_gadgets", false) else "R: cast a sigil"
		return "Open Nexus Descent: %d / 3 resonances | %s | [H] Guide" % [mini(FreedomLedger.mechanic_uses, 3), action]
	return "Follow the roots to the Chamber of Echoes. Stations restore health; flashlight charging needs batteries."

static func ability_status(player: Node) -> String:
	if GameManager.zone == "nexus":
		var enemy = player.get_tree().get_first_node_in_group("enemy")
		var held := " | Bound: %ds / 18s" % ceili(enemy.blood_trap_seconds) if enemy != null and enemy.blood_trap_seconds > 0.0 else ""
		var ready := "read Guide" if not FreedomLedger.flags.get("nexus_guide_read", false) else ("%ds" % ceili(player.blood_trap_cooldown) if player.blood_trap_cooldown > 0.0 else ("low HP" if FreedomLedger.hp <= 40.0 else "ready"))
		return "[Y] Blood Trap: %s / 40 HP%s | Knife %d / Power %d" % [ready, held, FreedomLedger.inventory.get("knife", 0), FreedomLedger.inventory.get("power", 0)]
	if FreedomLedger.part2_seed.get("full_gadgets", false):
		return "[Q] Gadget | Bottles %d Â· Clocks %d | [H] Field guide" % [FreedomLedger.inventory.get("bottle", 0), FreedomLedger.inventory.get("clock", 0)]
	if not FreedomLedger.flags.get("part2_ability_unlocked", false):
		return "Blood rites sealed â€” awaken them at the Sigil Forge. [H] Field guide"
	var cost := FreedomLedger.max_hp * (0.04 if FreedomLedger.part2_seed.get("hybrid_magic", false) else 0.08)
	var ready := "%ds" % ceili(player.sigil_cooldown) if player.sigil_cooldown > 0.0 else ("low HP" if FreedomLedger.hp <= cost else "ready")
	var result := "[R] %s: %s Â· %.1f HP" % [branch_name(), ready, cost]
	if FreedomLedger.part2_seed.get("blood_magic", false):
		var stun := "%ds" % ceili(player.stun_cooldown) if player.stun_cooldown > 0.0 else "ready"
		result += " | [T] Stun: %s Â· %.0f HP" % [stun, FreedomLedger.max_hp * 0.20]
	return result

static func guide_text() -> String:
	if FreedomLedger.current_part == 1:
		return "ELS' FIELD GUIDE\n\nWASD moves; Shift sprints; Ctrl crouches. F switches the flashlight. With the light off, Els lowers it and walks normally. E interacts and leaves hiding. B holds breath for up to 6 seconds.\n\nThe keys grant freedom at a price: every key restores a sense to the Hound. Taking all three creates a false escape. Leave at least one ward sealed.\n\nLook for the cyan CHARGE markers. About 30% of tables have a teal power station. Each room has at most one. Ordinary tables cannot charge the light. Carry batteries to charge. Each full cell holds 50% charge; the bag shows each remaining percentage. Press E and stand still to transfer charge; move to stop. Empty cells disappear and unused energy remains. No battery means no charging. H opens this guide; Esc closes it."
	var body := "DEGREES OF FREEDOM\nYour escape from Hollowmere changed what Els can do â€” and what the Hound can sense.\n\n"
	if FreedomLedger.part2_seed.get("full_gadgets", false):
		body += "CLOCKWORK & GLASS\nYou escaped without opening the wards. The Hound's senses remain sealed. Q uses a battery if charge is below 56%; otherwise it throws a bottle, then uses a clock when bottles run out. Bottles/clocks count toward the descent; batteries do not. Use three in Echoes. The supply cache at Nexus Descent replenishes distractions if you run out.\n\n"
	else:
		var partial: bool = FreedomLedger.part2_seed.get("hybrid_magic", false)
		body += "PARTIAL SIGIL\nYou spared one ward. Your cheaper rite blocks Hearing, but Sight still works: crouch, turn off the light and break line of sight. It is available when you enter Echoes.\n\n" if partial else "BLOOD RITES\nThe Vantree escape awakened Touch in the Hound and reduced Els' maximum health to 80. Touch can find you through nearby stone even when you stand still. In Echoes, press E at the Sigil Forge (CE-02) to unlock the rites. The forge takes 8% of maximum HP and counts as your first resonance.\n\n"
		body += "R â€” SILENCING CIRCLE\nDraws a visible circle at your feet for 12 seconds. Its effect applies while the Hound is INSIDE the circle. "
		body += "Blocks Hearing; costs 4% of maximum HP (4 HP). " if partial else "Blocks Hearing, Sight, Memory and Touch; costs 8% of maximum HP (6.4 HP). "
		body += "It does not prevent contact damage. Move away while its senses are suppressed. Wait 20 seconds between casts; the HUD shows when it is ready.\n\n"
		if not partial:
			body += "T â€” STUN RITE\nWhen the Hound is close (inside the circle's reach), stun it for 6 seconds. Costs 20% of maximum HP (16 HP); cooldown 60 seconds. An out-of-range attempt costs nothing. This rite does not count toward the descent.\n\n"
		body += "OPEN THE DESCENT\nEach R cast in Echoes counts as one resonance. Reach 3, then use the door in CE-05. Blood-rite users can also evade Touch by moving over the Sunken Choir rubble near the Hound. Power stations restore HP and flashlight charge; use them before you are too weak to cast.\n\n"
	body += "CONVERGENCE — DESTROY, FLEE OR REMAIN\nThe Hound roams the whole chamber. Touching any rune with E raises a red alarm and gives it your trail for this visit. Screens and rubble routes buy time.\n\n" + preload("res://scripts/systems/nexus_guide.gd").GUIDE + "\n\nY is available on every branch after reading the Guide Letter. Blood Trap costs 40 HP flat, holds for 18 seconds, and has a 60-second cooldown; failed casts spend nothing. Q priority: battery below 56% charge, The Power, bottle, clock. Cyan stations restore HP; flashlight charge still needs batteries."

	return body
