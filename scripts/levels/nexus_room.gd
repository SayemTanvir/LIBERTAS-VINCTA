extends "res://scripts/levels/estate_room.gd"
## Visit-scoped finale; inventory and completed outcomes use the existing ledger.
const GUIDE := preload("res://scripts/systems/nexus_guide.gd").GUIDE
var alarm_active := false
var alarm_seconds := 0.0
var outcome := ""
var trap_prompt: BaseInteractable

func _ready() -> void:
	super._ready()
	for prop in props.get_children():
		if prop is BaseInteractable and prop.interaction_id == "nexus_guide":
			prop.text = GUIDE
			prop.refresh()
		if prop is BaseInteractable and prop.interaction_id == "nexus_trap":
			trap_prompt = prop
			trap_prompt.get_node("Visual").hide()
	outcome = str(FreedomLedger.flags.get("nexus_outcome", ""))
	if not outcome.is_empty():
		_reveal_door()
		_restore_resolution.call_deferred()

func _restore_resolution() -> void:
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if outcome == "destroy":
			enemy.defeat_in_nexus()
		else:
			enemy.stun(3600.0)

func _process(delta: float) -> void:
	super._process(delta)
	if GameManager.state != GameManager.State.PLAYING:
		return
	var enemy = get_tree().get_first_node_in_group("enemy")
	if outcome.is_empty() and enemy != null and enemy.nexus_defeated:
		complete_outcome("destroy", enemy.global_position)
	if not outcome.is_empty():
		alarm_active = false
		alarm_seconds = 0.0
		return
	alarm_seconds = maxf(0.0, alarm_seconds - delta)
	if is_instance_valid(trap_prompt):
		trap_prompt.visible = enemy != null and enemy.blood_trap_seconds > 0.0 and outcome.is_empty()
		if trap_prompt.visible:
			trap_prompt.global_position = enemy.global_position
			trap_prompt.display_name = "Set trap + drop The Power (%ds)" % ceili(enemy.blood_trap_seconds)

func trigger_alarm() -> void:
	if alarm_active or not outcome.is_empty():
		return
	alarm_active = true
	alarm_seconds = 5.0
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.begin_nexus_hunt()
	var player = get_tree().get_first_node_in_group("player")
	if player != null:
		player.get_node("Camera2D").add_trauma(0.8)
	EventBus.audio_requested.emit("stinger")
	EventBus.subtitle_requested.emit("", "The runes are awake. The Hound has your trail.", 3.0)

func read_guide() -> void:
	FreedomLedger.flags["nexus_guide_read"] = true
	for prop in props.get_children():
		if prop is BaseInteractable and prop.interaction_id == "nexus_power":
			prop.set_process(true)
			prop.show()
			prop.get_node("Visual").show()
			for child in prop.get_node("Visual").get_children():
				if child is CanvasItem:
					child.show()
			prop.refresh()

func place_power(player: Node2D) -> bool:
	var enemy = get_tree().get_first_node_in_group("enemy")
	if not outcome.is_empty() or enemy == null or enemy.blood_trap_seconds <= 0.0 or player.global_position.distance_to(enemy.global_position) > player.interaction_radius:
		return false
	if int(FreedomLedger.inventory.get("knife", 0)) < 1 or not FreedomLedger.flags.get("nexus_guide_read", false) or int(FreedomLedger.inventory.get("power", 0)) < 1:
		return false
	var ray := PhysicsRayQueryParameters2D.create(player.global_position, enemy.global_position, 1, [player.get_rid(), enemy.get_rid()])
	if not player.get_world_2d().direct_space_state.intersect_ray(ray).is_empty():
		return false
	FreedomLedger.consume_item("power")
	player.play_action("bag_pickup", 0.6, true)
	enemy.defeat_in_nexus()
	complete_outcome("destroy", enemy.global_position)
	return true

func complete_outcome(choice: String, point: Vector2) -> void:
	if not outcome.is_empty() or choice not in ["destroy", "flee", "remain"]:
		return
	outcome = choice
	alarm_active = false
	alarm_seconds = 0.0
	FreedomLedger.flags["nexus_outcome"] = choice
	FreedomLedger.flags["nexus_door_x"] = point.x
	FreedomLedger.flags["nexus_door_y"] = point.y
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.stun(3600.0)
		enemy.nexus_hunting = false
		enemy.blood_trap_seconds = 0.0
	_reveal_door()
	EventBus.anchor_progress.emit("", 0.0, 20.0)
	EventBus.audio_requested.emit("door_open")
	EventBus.subtitle_requested.emit("", "A door opens. Press E to cross the threshold.", 3.0)

func _reveal_door() -> void:
	for prop in props.get_children():
		if prop is BaseInteractable and prop.interaction_id == "nexus_ending_door":
			var door_x := float(FreedomLedger.flags.get("nexus_door_x", 2100.0)) if outcome == "destroy" else clampf(float(FreedomLedger.flags.get("nexus_door_x", 2100.0)) + 120.0, 120.0, room_width - 120.0)
			var door_y := float(FreedomLedger.flags.get("nexus_door_y", 430.0))
			prop.position = Vector2(door_x, door_y)
			prop.ending_type = outcome
			prop.refresh()
			prop.modulate.a = 0.0
			prop.create_tween().tween_property(prop, "modulate:a", 1.0, 1.2)
