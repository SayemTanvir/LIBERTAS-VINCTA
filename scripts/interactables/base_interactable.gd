class_name BaseInteractable
extends Node2D
## Shared interaction contract. Scene presets provide shape; data provides behavior.

@export_enum("door", "locked_door", "key", "letter", "flashlight", "tool", "hiding", "puzzle", "exit", "item", "recharge", "vent", "forge", "anchor", "lore") var kind: String = "door"
@export var interaction_id: String = ""
@export var title: String = ""
@export var display_name: String = ""
@export_multiline var text: String = ""
@export var speaker: String = "ELS"
@export var sense: String = ""
@export var item_id: String = ""
@export var item_amount: int = 1
@export var noise_radius: float = 0.0
@export var required_flag: String = ""
@export var destination: String = ""
@export var entrance: String = "start"
@export var ending_type: String = "untouched"
@export var puzzle_steps: int = 3
@export var action_seconds: float = 0.9
@export var consumes_lockpick: bool = true
@export var action_animation_override: String = ""
@export var action_position_offset: Vector2 = Vector2.ZERO
@export var action_facing: Vector2 = Vector2.ZERO
@export_enum("low", "medium", "high") var hiding_priority: String = "low"
@export var channel_seconds: float = 20.0

var busy: bool = false
var progress: int = 0
var interrupt_serial: int = 0

func _ready() -> void:
	add_to_group("interactable")
	if kind == "item" and item_id == "battery":
		display_name = "Battery · 100%"
	$Visual/PlaceholderVisual.visible = $Visual/Sprite2D.texture == null
	EventBus.player_detected.connect(_interrupt_for_detection)
	EventBus.player_hurt.connect(_interrupt_for_damage)
	if kind == "puzzle":
		progress = clampi(int(FreedomLedger.flags.get(interaction_id + "_steps", 0)), 0, puzzle_steps)
	if interaction_id == "scratched_nameplate":
		$Visual.hide()
		var fragments := preload("res://scripts/interactables/nameplate_fragments.gd").new()
		fragments.name = "NameplateFragments"
		add_child(fragments)
	refresh()

func _interrupt_for_detection(_source: Node) -> void:
	interrupt_serial += 1

func _interrupt_for_damage(_amount: float) -> void:
	interrupt_serial += 1

func available() -> bool:
	if busy:
		return false
	if interaction_id == "scratched_nameplate":
		# Older checkpoints only recorded the static inspection, not assembly.
		return not FreedomLedger.flags.get("nameplate_assembled", false)
	if interaction_id in ["nexus_bell", "echo_supply_cache"]:
		return true
	if kind == "puzzle":
		return not FreedomLedger.flags.get(interaction_id, false)
	if kind in ["forge", "lore"] and not required_flag.is_empty() and not FreedomLedger.has_requirement(required_flag):
		return false
	if kind == "lore" and interaction_id == "vantree_altar":
		return not FreedomLedger.flags.get("story_name_carving", false) and not FreedomLedger.flags.get(interaction_id, false)
	if kind == "lore" and interaction_id == "mechanic_intro":
		return not FreedomLedger.flags.get("mechanic_intro_seen", false) and not FreedomLedger.flags.get(interaction_id, false)
	if kind == "lore" and interaction_id == "first_voice":
		return not FreedomLedger.flags.get("entity_spoke", false) and not FreedomLedger.flags.get(interaction_id, false)
	if kind == "key":
		return sense not in FreedomLedger.keys_collected
	if kind == "letter":
		return interaction_id not in FreedomLedger.letter_ids
	if kind in ["flashlight", "tool", "item", "forge", "lore"]:
		return not FreedomLedger.flags.get(interaction_id, false)
	if kind == "anchor":
		return interaction_id not in FreedomLedger.anchors_cleansed
	return true

func refresh() -> void:
	visible = available() or kind in ["puzzle", "door", "locked_door", "hiding", "exit", "recharge", "vent", "anchor", "lore"]
	if has_node("NameplateFragments"):
		$NameplateFragments.set_collected(bool(FreedomLedger.flags.get("nameplate_assembled", false)))
	if kind in ["flashlight", "tool", "item", "key", "letter"] and not visible:
		# Remove the entire pickup presentation, including glints, dropped beams and shadows.
		for child in get_children():
			if child is CanvasItem:
				child.hide()
		set_process(false)

func say(line: String, seconds: float = 2.0, speaker: String = "ELS") -> void:
	EventBus.subtitle_requested.emit(speaker, line, seconds)

func interact(player: Node2D) -> void:
	if not available() or GameManager.state != GameManager.State.PLAYING:
		return
	busy = true
	# Reach the door before playing the key/handle gesture, not after it succeeds.
	var door_presentation := get_node_or_null("Visual/DoorPresentation")
	if door_presentation != null and kind in ["locked_door", "door", "exit"]:
		if not await door_presentation.align_for_interaction(player):
			busy = false
			return
	EventBus.interaction_started.emit(self)
	if _can_play_action():
		_prepare_action_pose(player)
		var duration := action_seconds if kind == "puzzle" else (0.55 if kind in ["item", "tool", "flashlight", "letter"] else 0.8)
		if kind == "tool":
			duration = 0.85
		elif kind == "key":
			duration = 0.72
		elif kind == "locked_door":
			duration = 1.2
		player.play_action(_action_animation(), duration, kind in ["item", "tool", "flashlight", "letter", "key"])
		if door_presentation != null and kind in ["locked_door", "door"]:
			# Key insertion and handle use reach toward the visible left-hand lock.
			player.sprite.flip_h = door_presentation.LOCK_SIDE < 0.0
	match kind:
		"flashlight": _take_flashlight(player)
		"tool": _take_tools()
		"item": _take_item()
		"letter": _read_letter()
		"hiding": _hide(player)
		"key": _take_key(player)
		"puzzle": await _work_puzzle(player)
		"recharge": await _recharge(player)
		"forge": _activate_forge()
		"lore":
			if interaction_id == "scratched_nameplate":
				await _assemble_nameplate(player)
			else:
				_reveal_lore()
		"anchor": await _channel_anchor(player)
		"locked_door": await _unlock_intro(player)
		"door", "vent": await _travel(player)
		"exit": await _exit(player)
	busy = false
	EventBus.interaction_finished.emit(self)
	refresh()

func _can_play_action() -> bool:
	if interaction_id == "piano_seal":
		return false # Its own approach, seated performance and stand-up sequence.
	if kind in ["hiding", "lore", "exit", "vent"]:
		return false
	if kind == "locked_door":
		return FreedomLedger.flags.get("intro_door_tried", false) and FreedomLedger.flags.get("lockpick_tool", false) and FreedomLedger.flags.get("flashlight", false)
	if kind == "forge" and FreedomLedger.hp <= FreedomLedger.max_hp * 0.08:
		return false
	if kind == "recharge" and (not FreedomLedger.flags.get("flashlight", false) or (FreedomLedger.flashlight_seconds >= FreedomLedger.MAX_FLASHLIGHT_SECONDS and (FreedomLedger.current_part == 1 or FreedomLedger.hp >= FreedomLedger.max_hp))):
		return false
	if kind == "recharge" and FreedomLedger.battery_percentages().is_empty() and (FreedomLedger.current_part == 1 or FreedomLedger.hp >= FreedomLedger.max_hp):
		return false
	if kind == "puzzle" and progress == 0 and consumes_lockpick and int(FreedomLedger.inventory.get("lockpick", 0)) == 0:
		return false
	if kind in ["key", "puzzle", "door", "vent", "anchor"] and not required_flag.is_empty():
		return FreedomLedger.has_requirement(required_flag)
	return true

func _action_animation() -> String:
	if not action_animation_override.is_empty():
		return action_animation_override
	if kind == "key":
		return "key_pickup"
	if kind == "tool":
		return "bag_pickup"
	if kind in ["item", "flashlight"]:
		return "collect"
	if kind == "letter":
		return "read"
	if kind in ["anchor", "forge"]:
		return "channel"
	if kind == "recharge":
		return "recharge"
	if interaction_id == "piano_seal":
		return "piano"
	if interaction_id == "ritual_seal":
		return "channel"
	if kind in ["locked_door", "puzzle"]:
		return "unlock"
	if kind == "vent":
		return "vent_enter"
	if kind == "door":
		return "door_open"
	return "interact"

func _prepare_action_pose(player: Node2D) -> void:
	# Keep the player's feet where they approached. Authored offsets are reach points,
	# never teleport destinations (the piano offset even exceeded the E radius).
	if player is CharacterBody2D:
		player.velocity = Vector2.ZERO
	var target_direction := action_facing if action_facing != Vector2.ZERO else global_position - player.global_position
	if target_direction.length_squared() > 0.001:
		player.facing = target_direction.normalized()

func interaction_points() -> PackedVector2Array:
	var points := PackedVector2Array([global_position])
	if action_position_offset != Vector2.ZERO:
		points.append(global_position + action_position_offset)
	return points

func _take_flashlight(player: Node2D) -> void:
	FreedomLedger.flags[interaction_id] = true
	visible = false
	FreedomLedger.set_flashlight_seconds(FreedomLedger.MAX_FLASHLIGHT_SECONDS)
	player.set_flashlight(true, false)
	say("Mine...", 1.8)
	say("How did it get over there?", 2.6)

func _take_tools() -> void:
	FreedomLedger.flags[interaction_id] = true
	visible = false
	FreedomLedger.collect_item("lockpick", 3)
	say("At least I came prepared.")

func _take_item() -> void:
	FreedomLedger.flags[interaction_id] = true
	visible = false
	FreedomLedger.collect_item(item_id, item_amount)

func _read_letter() -> void:
	if FreedomLedger.collect_letter(interaction_id):
		visible = false
		EventBus.audio_requested.emit("astonishment")
		var hud = get_tree().get_first_node_in_group("hud")
		if hud != null:
			hud.show_letter(title, text)

func _assemble_nameplate(player: Node2D) -> void:
	var hud = get_tree().get_first_node_in_group("hud")
	if hud == null:
		return
	_prepare_action_pose(player)
	if not await $NameplateFragments.assemble(player):
		return
	FreedomLedger.flags[interaction_id] = true
	FreedomLedger.flags["nameplate_assembled"] = true
	$NameplateFragments.set_collected(true)
	hud.show_letter(title, text)
	# Save the completed interaction, including its consumed floor fragments.
	GameManager.save_checkpoint(player.global_position)
	say("My name, in this house. That doesn't tell me whose portrait it was.", 4.0)

func _hide(player: Node2D) -> void:
	if player.hidden_spot != null or player.hiding_transition_active:
		return
	FreedomLedger.record_hiding_use(interaction_id)
	player.enter_hiding(self)

func _take_key(player: Node2D) -> void:
	if not FreedomLedger.has_requirement(required_flag):
		say("The seal is still holding.")
	elif FreedomLedger.restore_sense(sense):
		visible = false
		EventBus.audio_requested.emit("key_grab")
		if sense == "hearing":
			EventBus.audio_requested.emit("monster_screech")
			EventBus.tension_changed.emit("SEARCHING")
			FreedomLedger.flags["piano_screech"] = true
		elif sense == "memory":
			FreedomLedger.flags["true_form_revealed"] = true
		say({"hearing": "That cry... it came when I lifted the key.", "sight": "The second ward is open. I should lower my light.", "memory": "The last ward is gone. I shouldn't stay here."}[sense], 2.8)
		GameManager.save_checkpoint(player.global_position)
	else:
		say("Another seal holds this one.")

func _work_puzzle(player: Node2D) -> void:
	if not FreedomLedger.has_requirement(required_flag):
		say("Not yet.")
		return
	if progress == 0 and consumes_lockpick and int(FreedomLedger.inventory.get("lockpick", 0)) == 0:
		say("I need a lockpick.")
		return
	if interaction_id == "piano_seal":
		var performance := preload("res://scripts/interactables/piano_performance.gd").new()
		get_parent().add_child(performance)
		if not await performance.perform(player, self, progress, action_seconds):
			return
	else:
		player.control_enabled = false
		player.velocity = Vector2.ZERO
		EventBus.audio_requested.emit("key_unlock")
		await get_tree().create_timer(action_seconds, false).timeout
	if GameManager.state != GameManager.State.PLAYING:
		return
	if progress == 0 and consumes_lockpick:
		FreedomLedger.consume_item("lockpick")
	player.control_enabled = true
	player.animation_hold = 0.0
	progress += 1
	FreedomLedger.flags[interaction_id + "_steps"] = progress
	EventBus.noise_created.emit(global_position, 300.0, "GENERIC")
	if progress >= puzzle_steps:
		FreedomLedger.flags[interaction_id] = true
		say({"piano_seal": "A lock hidden in a piano. There's a key inside.", "vanity_seal": "The vanity's compartment is open.", "ritual_seal": "The stone has split along the seal."}.get(interaction_id, "The seal gives."))

func _recharge(player: Node2D) -> void:
	if not FreedomLedger.flags.get("flashlight", false):
		say("I should pick up my flashlight first.")
		return
	if FreedomLedger.flashlight_seconds >= FreedomLedger.MAX_FLASHLIGHT_SECONDS and (FreedomLedger.current_part == 1 or FreedomLedger.hp >= FreedomLedger.max_hp):
		say("Ready to move on. No charge or recovery needed.")
		return
	var started_serial := interrupt_serial
	var elapsed := 0.0
	var can_recover := FreedomLedger.current_part == 2 and FreedomLedger.hp < FreedomLedger.max_hp
	if FreedomLedger.battery_percentages().is_empty() and not can_recover:
		say("I need a battery. This station cannot charge an empty bag.")
		return
	player.control_enabled = false
	player.velocity = Vector2.ZERO
	player.set_flashlight(false, false)
	player.is_crouching = false
	player.is_sprinting = false
	player.visual.scale = Vector2.ONE
	say("Recovering. Charging uses my batteries. Move to stop." if FreedomLedger.current_part == 2 else "Charging from my batteries. Move to stop.", 3.0)
	player.play_action("recharge", 12.0)
	while elapsed < 12.0:
		await get_tree().physics_frame
		if get_tree().paused:
			continue
		if GameManager.state != GameManager.State.PLAYING or interrupt_serial != started_serial or Input.get_vector("move_left", "move_right", "move_up", "move_down").length_squared() > 0.01:
			break
		var step := minf(get_physics_process_delta_time(), 12.0 - elapsed)
		elapsed += step
		FreedomLedger.recharge_from_batteries(FreedomLedger.MAX_FLASHLIGHT_SECONDS * step / 12.0)
		if FreedomLedger.current_part == 2:
			FreedomLedger.heal(FreedomLedger.max_hp * step / 12.0)
		EventBus.anchor_progress.emit("Charging — move to stop", elapsed, 12.0)
		var charge_done := FreedomLedger.flashlight_seconds >= FreedomLedger.MAX_FLASHLIGHT_SECONDS or FreedomLedger.battery_percentages().is_empty()
		if charge_done and (FreedomLedger.current_part == 1 or FreedomLedger.hp >= FreedomLedger.max_hp):
			break
	player.animation_hold = 0.0
	player.control_enabled = GameManager.state == GameManager.State.PLAYING
	if player.control_enabled:
		player.play_animation("idle")
	EventBus.anchor_progress.emit("", 0.0, 12.0)
	if elapsed >= 12.0:
		say("Restored. Time to move.")

func _activate_forge() -> void:
	if FreedomLedger.hp <= FreedomLedger.max_hp * 0.08:
		say("Too weak to awaken the forge. Recover at a cyan power station.")
		return
	FreedomLedger.flags[interaction_id] = true
	FreedomLedger.flags["part2_ability_unlocked"] = true
	FreedomLedger.damage(FreedomLedger.max_hp * 0.08)
	FreedomLedger.mechanic_uses += 1
	EventBus.ability_used.emit("forge")
	say("Blood rites awakened. R: silencing circle. T: close-range stun. H: field guide.", 4.0)

func _reveal_lore() -> void:
	if interaction_id == "the_note":
		var hud = get_tree().get_first_node_in_group("hud")
		if hud != null:
			FreedomLedger.flags[interaction_id] = true
			hud.show_letter(title, text)
		return
	if interaction_id == "nexus_bell":
		var room = get_tree().get_first_node_in_group("room")
		if room != null and not room.ring_ward_bell():
			say("The ward is still holding. Choose an anchor now.")
		return
	if interaction_id == "echo_supply_cache":
		if int(FreedomLedger.inventory.get("bottle", 0)) + int(FreedomLedger.inventory.get("clock", 0)) < 3:
			FreedomLedger.collect_item("clock", 3)
			say("Three clocks. Q sets a distraction; each use in Echoes counts toward the descent.", 4.0)
		else:
			say("I have enough distractions. Q uses them; H explains the route.")
		return
	FreedomLedger.flags[interaction_id] = true
	if noise_radius > 0.0:
		EventBus.noise_created.emit(global_position, noise_radius, "GENERIC")
	var line := text
	if interaction_id == "mechanic_intro":
		line = preload("res://scripts/systems/field_guide.gd").tutorial()
	say(line, 4.0, speaker)

func _channel_anchor(player: Node2D) -> void:
	if not FreedomLedger.has_requirement(required_flag):
		say(text if not text.is_empty() else "The anchor refuses the pattern.")
		return
	if _player_is_detected():
		say("The entity's attention breaks the pattern.")
		return
	player.control_enabled = false
	player.velocity = Vector2.ZERO
	player.play_action("channel", channel_seconds)
	var started_serial := interrupt_serial
	var elapsed := 0.0
	while elapsed < channel_seconds:
		await get_tree().physics_frame
		if get_tree().paused:
			continue
		if interrupt_serial != started_serial or _player_is_detected() or GameManager.state != GameManager.State.PLAYING:
			player.control_enabled = GameManager.state == GameManager.State.PLAYING
			player.animation_hold = 0.0
			EventBus.anchor_progress.emit(interaction_id, 0.0, channel_seconds)
			say("The pattern broke.")
			return
		if Input.get_vector("move_left", "move_right", "move_up", "move_down").length_squared() > 0.01 or (not Input.is_action_pressed("interact") and elapsed > 0.2 and not FreedomLedger.flags.get("automation_channel", false)):
			player.control_enabled = true
			player.animation_hold = 0.0
			EventBus.anchor_progress.emit(interaction_id, 0.0, channel_seconds)
			return
		elapsed += get_physics_process_delta_time()
		EventBus.anchor_progress.emit(interaction_id, elapsed, channel_seconds)
	FreedomLedger.cleanse_anchor(interaction_id)
	player.control_enabled = true
	player.animation_hold = 0.0
	say("Anchor cleansed.")
	if ending_type in ["severance", "custodian_rest", "vessel"]:
		EventBus.ending_triggered.emit(ending_type)

func _player_is_detected() -> bool:
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if bool(enemy.get("detection_active")):
			return true
	return false

func _unlock_intro(player: CharacterBody2D) -> void:
	var epoch := GameManager.transition_epoch
	if not FreedomLedger.flags.get("intro_door_tried", false):
		FreedomLedger.flags["intro_door_tried"] = true
		EventBus.audio_requested.emit("door_knock")
		say("Locked.", 1.4)
		say("Of course.", 1.4)
	elif not FreedomLedger.flags.get("lockpick_tool", false):
		say("I need my tools.")
	elif not FreedomLedger.flags.get("flashlight", false):
		say("I should take my flashlight.")
	else:
		player.control_enabled = false
		EventBus.audio_requested.emit("key_unlock")
		await get_tree().create_timer(1.2, false).timeout
		if GameManager.state != GameManager.State.PLAYING or epoch != GameManager.transition_epoch:
			return
		EventBus.audio_requested.emit("door_open")
		EventBus.audio_requested.emit("building_creak")
		var presentation := get_node_or_null("Visual/DoorPresentation")
		if presentation != null:
			# Open at the planted key stance, without a sideways camera pull or restaging.
			await presentation.animate_open(true)
		if GameManager.state != GameManager.State.PLAYING or epoch != GameManager.transition_epoch:
			return
		say("Hello?", 1.8)
		await get_tree().create_timer(2.0, false).timeout
		if GameManager.state != GameManager.State.PLAYING or epoch != GameManager.transition_epoch:
			return
		FreedomLedger.flags["intro_complete"] = true
		await _depart(player)
		if GameManager.state == GameManager.State.PLAYING and epoch == GameManager.transition_epoch:
			GameManager.travel.call_deferred("ground")

func _travel(player: CharacterBody2D) -> void:
	var epoch := GameManager.transition_epoch
	if not FreedomLedger.has_requirement(required_flag):
		say(text if not text.is_empty() else "The passage is sealed.")
		return
	if not await _depart(player):
		return
	if GameManager.state == GameManager.State.PLAYING and epoch == GameManager.transition_epoch and FreedomLedger.hp > 0.0:
		GameManager.travel.call_deferred(destination, entrance)

func _exit(player: CharacterBody2D) -> void:
	var candidate := ending_type
	if ending_type == "front_door":
		if FreedomLedger.current_stage == 0 and not FreedomLedger.flags.get("door_tested", false):
			FreedomLedger.flags["door_tested"] = true
			EventBus.audio_requested.emit("door_knock")
			return
		candidate = "untouched" if FreedomLedger.current_stage == 0 else ("loop" if FreedomLedger.current_stage == 3 else "")
	if not candidate.is_empty() and FreedomLedger.eligible(candidate):
		await _depart(player)
		if GameManager.state == GameManager.State.PLAYING:
			EventBus.ending_triggered.emit(candidate)
	else:
		say(text if not text.is_empty() else "This way is still sealed.")

func _depart(player: CharacterBody2D) -> bool:
	if kind == "vent":
		EventBus.audio_requested.emit("building_creak")
		return await player.traverse_vent(global_position, true)
	var presentation: Node = get_node_or_null("Visual/DoorPresentation")
	if presentation != null and presentation.has_method("depart"):
		await presentation.depart(player)
	else:
		EventBus.audio_requested.emit("door_open")
		await get_tree().create_timer(0.45, false).timeout
		if GameManager.state == GameManager.State.PLAYING:
			EventBus.audio_requested.emit("door_close")
	return GameManager.state == GameManager.State.PLAYING and not player.death_started
