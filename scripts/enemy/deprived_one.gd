extends CharacterBody2D

const ZOMBIE_DIRECTIONS := ["0", "045", "090", "135", "180", "225", "270", "315"]
const ZombieFootOffsets := preload("res://scripts/enemy/zombie_foot_offsets.gd")

enum State {
	NEXUS_ROAM,
	WANDER_BLIND,
	PATROL_AUDIO,
	INVESTIGATE,
	HUNT_AUDIO,
	PATROL_SIGHT,
	CHASE,
	INVESTIGATE_LAST_SEEN,
	PREDICT_HUNT,
	AMBUSH
}

const SPEED_MULTIPLIER := 0.99

@export var blind_speed: float = 113.85
@export var patrol_speed: float = 140.58
@export var audio_hunt_speed: float = 213.84
@export var sight_chase_speed: float = 279.18
@export var true_form_speed: float = 235.62
@export var hearing_scale: float = 740.0
@export var vision_range: float = 520.0
@export var shadow_vision_range: float = 260.0
@export var field_of_view: float = 140.0
@export var flashlight_range_multiplier: float = 1.5
@export var catch_distance: float = 44.0
@export var audio_hunt_seconds: float = 10.0
@export var path_refresh_seconds: float = 0.28
@export_range(0.0, 1.0) var ambush_chance: float = 0.55
@export var ambush_interval: float = 2.5
@export var ambush_seconds: float = 10.0
@export var contact_damage: float = 30.0
@export var remembered_hide_damage: float = 45.0
@export var debug_detection: bool = false

var nexus_hunting := false
var blood_trap_seconds := 0.0
var nexus_defeated := false
var state: State = State.WANDER_BLIND
var player: Node2D
var room: Node2D
var target: Vector2
var last_seen: Vector2
var facing := Vector2.LEFT
var path := PackedVector2Array()
var path_clock: float = 0.0
var state_clock: float = 0.0
var state_limit: float = 10.0
var lost_sight: float = 0.0
var chase_break: float = 6.5
var sight_confirm: float = 0.0
var patrol_index: int = 0
var recent_hides: Array[String] = []
var memory_points: Array[Vector2] = []
var noise_pings: Array[float] = []
var hearing_time := 0.0
var witnessed_hide: String = ""
var route_clock: float = 0.0
var stalled_time: float = 0.0
var ambush_clock: float = 0.0
var hit_cooldown: float = 0.0
var stun_seconds: float = 0.0
var detection_active: bool = false
var _attack_seconds: float = 0.0
var _visual_speed: float = 0.0
var _turn_clock := 0.0
var _locomotion_grace := 0.0
var _attack_elapsed := 0.0
var _strike_pending := false
var _strike_damage := 0.0
var _strike_reach := 0.0
var _strike_hide := ""
var _voice_cooldown := 0.0
var is_distracted: bool = false
var distraction_target: Vector2 = Vector2.ZERO
var distraction_arrived: bool = false
var distraction_stay_timer: float = 0.0

@onready var sprite: AnimatedSprite2D = $Visual/AnimatedSprite2D

func _ready() -> void:
	add_to_group("enemy")
	player = get_tree().get_first_node_in_group("player")
	room = get_tree().get_first_node_in_group("room")
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	target = global_position
	EventBus.noise_created.connect(_hear)
	EventBus.player_hidden.connect(_hidden)
	EventBus.player_left_hiding.connect(_left_hiding)
	EventBus.sense_restored.connect(_restored)
	EventBus.player_caught.connect(_attack)
	ambush_clock = ambush_interval
	sprite.frame_changed.connect(_on_visual_frame_changed)
	_play_visual("idle")
	change_state(_patrol_state())
	_observe_debug()

func change_state(next: State) -> void:
	if is_distracted and next != State.INVESTIGATE:
		next = State.INVESTIGATE
	if next != State.INVESTIGATE and is_distracted:
		is_distracted = false
		distraction_arrived = false
		distraction_stay_timer = 0.0
	state = next
	if state == State.NEXUS_ROAM:
		detection_active = false
		_choose_patrol_target()
	state_clock = 0.0
	path_clock = 0.0
	match state:
		State.WANDER_BLIND:
			state_limit = randf_range(8.0, 15.0)
		State.INVESTIGATE:
			state_limit = 20.0 if is_distracted else 4.0
		State.HUNT_AUDIO:
			state_limit = audio_hunt_seconds
		State.CHASE:
			chase_break = randf_range(5.0, 8.0)
		State.INVESTIGATE_LAST_SEEN:
			state_limit = 4.0
		State.PREDICT_HUNT:
			state_limit = 8.0
		State.AMBUSH:
			state_limit = ambush_seconds
	var searching := state in [State.INVESTIGATE, State.HUNT_AUDIO, State.INVESTIGATE_LAST_SEEN, State.PREDICT_HUNT, State.AMBUSH]
	EventBus.tension_changed.emit("CHASE" if state == State.CHASE else ("SEARCHING" if searching else "CALM"))
	if _voice_cooldown > 0.0:
		return
	if state in [State.HUNT_AUDIO, State.CHASE]:
		EventBus.audio_requested.emit("monster_growl")
		_voice_cooldown = 1.8
	elif searching:
		EventBus.audio_requested.emit("monster_search")
		_voice_cooldown = 2.8

func _patrol_state() -> State:
	if is_instance_valid(room) and room.zone_id == "nexus":
		return State.NEXUS_ROAM
	if _stage() == 0:
		return State.WANDER_BLIND
	if _stage() == 1:
		return State.PATROL_AUDIO
	return State.PATROL_SIGHT

func _stage() -> int:
	return int(FreedomLedger.part2_seed.get("monster_stage", FreedomLedger.current_stage)) if FreedomLedger.current_part == 2 else FreedomLedger.current_stage

func _has_sense(sense: String) -> bool:
	if nexus_hunting and is_instance_valid(room) and room.zone_id == "nexus":
		return true
	var active: bool = sense in FreedomLedger.part2_seed.get("senses", []) if FreedomLedger.current_part == 2 else sense in FreedomLedger.keys_collected
	return active and not _sense_blocked(sense)

func _sense_blocked(sense: String) -> bool:
	for field in get_tree().get_nodes_in_group("silencing_sigil"):
		if field.blocks(sense, global_position):
			return true
	return false

func _restored(sense: String) -> void:
	if sense == "memory":
		recent_hides.clear()
		for id in FreedomLedger.hiding_usage:
			if int(FreedomLedger.hiding_usage[id]) > 0:
				recent_hides.append(str(id))
		while recent_hides.size() > 5:
			recent_hides.pop_front()
		_apply_base_appearance()
		_predict()
	else:
		change_state(_patrol_state())

func _physics_process(delta: float) -> void:
	if nexus_defeated:
		return
	if not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("player")
	if not is_instance_valid(room):
		room = get_tree().get_first_node_in_group("room")
	if not is_instance_valid(player) or not is_instance_valid(room) or GameManager.state != GameManager.State.PLAYING:
		velocity = Vector2.ZERO
		return
	blood_trap_seconds = maxf(0.0, blood_trap_seconds - delta)
	hearing_time += delta
	if room.has_method("threat_active_at") and not room.threat_active_at(player.global_position):
		_strike_pending = false
		_attack_seconds = 0.0
		detection_active = false
		if state != _patrol_state():
			change_state(_patrol_state())
		target = Vector2(room.patrol_anchor(), 500.0)
		_move(delta)
		return
	hit_cooldown = maxf(0.0, hit_cooldown - delta)
	_voice_cooldown = maxf(0.0, _voice_cooldown - delta)
	if stun_seconds > 0.0:
		stun_seconds -= delta
		velocity = Vector2.ZERO
		_play_visual("stagger")
		return
	if _attack_seconds > 0.0:
		_update_attack(delta)
		return
	state_clock += delta
	route_clock -= delta
	ambush_clock -= delta
	_update_vision(delta)
	_detect_touch()
	_update_state(delta)
	# The alarm maintains a trail, but only the existing senses confirm detection.
	# Hiding and distractions buy time; a lost trail returns to arena patrol.
	if nexus_hunting and not is_distracted and player.hidden_spot == null:
		if state == State.NEXUS_ROAM:
			target = player.global_position
			last_seen = target
			change_state(State.HUNT_AUDIO)
		elif state == State.HUNT_AUDIO and not detection_active and global_position.distance_to(target) < 36.0:
			# Search the last alarm trail for the existing four-second window.
			# Real Hearing/Sight/Touch cues can interrupt this search immediately.
			change_state(State.INVESTIGATE_LAST_SEEN)
	if GameManager.state != GameManager.State.PLAYING or _attack_seconds > 0.0:
		return
	_move(delta)
	_resolve_contact()
	_observe_debug()

func _update_vision(delta: float) -> void:
	if is_distracted:
		target = distraction_target if distraction_target != Vector2.ZERO else target
		sight_confirm = 0.0
		return
	var sees := can_see_player()
	if sees:
		sight_confirm += delta
		last_seen = player.global_position
		lost_sight = 0.0
		if _stage() >= 3 and route_clock <= 0.0:
			route_clock = 1.0
			memory_points.append(last_seen)
			if memory_points.size() > 5:
				memory_points.pop_front()
		var confirm_time := 0.12 if global_position.distance_to(player.global_position) < 110.0 else 0.3
		if sight_confirm >= confirm_time and state != State.CHASE:
			_begin_detection()
			change_state(State.CHASE)
	else:
		sight_confirm = 0.0

func _detect_touch() -> void:
	var touch_active: bool = nexus_hunting and is_instance_valid(room) and room.zone_id == "nexus"
	if (FreedomLedger.current_part != 2 or not FreedomLedger.part2_seed.get("touch_mutation", false)) and not touch_active:
		return
	if _sense_blocked("touch"):
		return
	var transmission: float = room.vibration_transmission_at(player.global_position)
	if global_position.distance_to(player.global_position) <= transmission:
		target = player.global_position
		last_seen = target
		lost_sight = 0.0
		if state == State.HUNT_AUDIO:
			state_clock = 0.0
		elif state != State.CHASE:
			_begin_detection()
			change_state(State.HUNT_AUDIO)

func _update_state(delta: float) -> void:
	match state:
		State.WANDER_BLIND:
			if global_position.distance_to(target) < 30.0 or state_clock >= state_limit:
				_choose_patrol_target()
				state_limit = randf_range(8.0, 15.0)
				state_clock = 0.0
		State.NEXUS_ROAM, State.PATROL_AUDIO, State.PATROL_SIGHT:
			if global_position.distance_to(target) < 30.0 or state_clock > 9.0:
				_choose_patrol_target()
				state_clock = 0.0
			if state != State.NEXUS_ROAM and _stage() >= 3 and ambush_clock <= 0.0:
				ambush_clock = ambush_interval
				if randf() <= ambush_chance:
					_predict_exit()
		State.INVESTIGATE:
			if is_distracted:
				if not distraction_arrived:
					if global_position.distance_to(distraction_target) < 40.0:
						distraction_arrived = true
						distraction_stay_timer = 5.0
						velocity = Vector2.ZERO
					elif state_clock > 5.0:
						# Distraction is no longer valid after the short 5s window.
						is_distracted = false
						distraction_arrived = false
						distraction_stay_timer = 0.0
						change_state(_patrol_state())
				else:
					velocity = Vector2.ZERO
					distraction_stay_timer = maxf(0.0, distraction_stay_timer - delta)
					if distraction_stay_timer <= 0.0:
						is_distracted = false
						distraction_arrived = false
						distraction_stay_timer = 0.0
						distraction_target = Vector2.ZERO
						change_state(_patrol_state())
			else:
				if global_position.distance_to(target) < 36.0:
					velocity = Vector2.ZERO
					var distraction_near := get_tree().get_nodes_in_group("distraction_object").any(func(d): return is_instance_valid(d) and d.global_position.distance_to(global_position) < 80.0)
					if not distraction_near and state_clock > 1.2:
						change_state(_patrol_state())
					elif state_clock >= state_limit:
						change_state(_patrol_state())
				elif state_clock > 10.0:
					change_state(_patrol_state())
		State.HUNT_AUDIO:
			if state_clock >= state_limit:
				detection_active = false
				change_state(_patrol_state())
		State.CHASE:
			if can_see_player():
				target = player.global_position
			else:
				lost_sight += delta
				target = last_seen
				if lost_sight >= chase_break:
					detection_active = false
					change_state(State.INVESTIGATE_LAST_SEEN)
		State.INVESTIGATE_LAST_SEEN:
			if global_position.distance_to(target) < 36.0 and state_clock >= state_limit:
				if _stage() >= 3:
					_predict()
				else:
					change_state(_patrol_state())
			elif state_clock > 10.0:
				change_state(_patrol_state())
		State.PREDICT_HUNT:
			if global_position.distance_to(target) < 36.0:
				_check_remembered_hide()
				change_state(State.INVESTIGATE_LAST_SEEN)
			elif state_clock >= state_limit:
				change_state(_patrol_state())
		State.AMBUSH:
			if state_clock >= state_limit:
				change_state(_patrol_state())

func _choose_patrol_target() -> void:
	patrol_index += 1
	if room.has_method("patrol_target"):
		target = room.patrol_target(_stage(), patrol_index)
		return
	var anchor: float = room.patrol_anchor()
	var spread := 440.0 if patrol_index % 2 == 0 else -440.0
	target = room.clamp_point(Vector2(anchor + spread, 440.0 if patrol_index % 2 == 0 else 570.0))

func _move(delta: float) -> void:
	if is_distracted and distraction_arrived:
		velocity = Vector2.ZERO
		move_and_slide()
		_play_visual("sniff")
		return
	path_clock -= delta
	var direction := Vector2.ZERO
	# Follow an unobstructed target directly, rather than snapping back to our grid cell.
	if global_position.distance_to(target) > 4.0 and _clear_motion_to(target):
		direction = global_position.direction_to(target)
		path.clear()
	else:
		if path_clock <= 0.0:
			path_clock = minf(path_refresh_seconds, 0.14) if state in [State.CHASE, State.HUNT_AUDIO] else path_refresh_seconds
			path = room.find_path(global_position, target)
		while not path.is_empty() and global_position.distance_to(path[0]) < 10.0:
			path.remove_at(0)
		# Skip grid centers only when the complete body can reach the next waypoint.
		while path.size() > 1 and _clear_motion_to(path[1]):
			path.remove_at(0)
		if not path.is_empty():
			direction = global_position.direction_to(path[0])
	var speed := _move_speed()
	# Slow depth travel without bending the swept, collision-safe direction.
	var desired_speed := speed * lerpf(1.0, 0.7, absf(direction.y))
	var response := 1900.0 if state in [State.CHASE, State.HUNT_AUDIO] else 1000.0
	# Accelerate along the swept route; never blend a corner into a wall.
	velocity = direction * move_toward(velocity.length(), desired_speed, response * delta)
	if velocity.length() * delta > global_position.distance_to(target) and _clear_motion_to(target):
		velocity = (target - global_position) / maxf(delta, 0.001)
	var before := global_position
	move_and_slide()
	var movement := global_position - before
	if direction.length_squared() > 0.01:
		if movement.length() > 0.15:
			facing = movement.normalized()
		stalled_time = stalled_time + delta if global_position.distance_to(before) < 0.15 else 0.0
	else:
		stalled_time = 0.0
	if stalled_time > 0.75:
		path_clock = 0.0
		stalled_time = 0.0
		if state not in [State.CHASE, State.HUNT_AUDIO, State.PREDICT_HUNT]:
			target = room.reachable_fallback(global_position)
	var animation := "idle"
	_visual_speed = lerpf(_visual_speed, movement.length() / maxf(delta, 0.001), 1.0 - exp(-10.0 * delta))
	_locomotion_grace = 0.12 if movement.length() > 0.05 else maxf(0.0, _locomotion_grace - delta)
	_update_visual_facing(movement, delta)
	if _locomotion_grace > 0.0:
		animation = "run" if state == State.CHASE or speed >= audio_hunt_speed else "walk"
	_play_visual(animation)

func _update_visual_facing(_movement: Vector2, _delta: float) -> void:
	_turn_clock = 0.0

func _clear_motion_to(point: Vector2) -> bool:
	var collision: CollisionShape2D = $CollisionShape2D
	var query := PhysicsShapeQueryParameters2D.new()
	query.shape = collision.shape
	query.transform = collision.global_transform
	query.motion = point - global_position
	query.collision_mask = 1
	query.exclude = [get_rid()]
	query.margin = 0.1
	if not get_world_2d().direct_space_state.intersect_shape(query, 1).is_empty():
		return false
	var result := get_world_2d().direct_space_state.cast_motion(query)
	return result.size() == 2 and result[0] >= 0.999

func _move_speed() -> float:
	if nexus_hunting and state in [State.HUNT_AUDIO, State.CHASE]:
		return true_form_speed if FreedomLedger.part2_seed.get("touch_mutation", false) else audio_hunt_speed
	if state == State.NEXUS_ROAM:
		return patrol_speed
	if FreedomLedger.current_part == 2 and FreedomLedger.part2_seed.get("touch_mutation", false) and state == State.HUNT_AUDIO:
		return true_form_speed
	if is_distracted and not distraction_arrived:
		return audio_hunt_speed
	if _stage() == 0:
		return blind_speed
	if state == State.CHASE:
		return true_form_speed if _stage() >= 3 else sight_chase_speed
	if state == State.HUNT_AUDIO:
		return audio_hunt_speed
	if _stage() >= 3 and state in [State.PREDICT_HUNT, State.AMBUSH, State.INVESTIGATE_LAST_SEEN]:
		return true_form_speed
	return patrol_speed

func _resolve_contact() -> void:
	if GameManager.state != GameManager.State.PLAYING or player.death_started:
		return
	if global_position.distance_to(player.global_position) >= catch_distance or hit_cooldown > 0.0:
		return
	if player.hidden_spot != null and player.hidden_spot.interaction_id != witnessed_hide:
		return
	if not clear_sight(player.global_position):
		return
	if _stage() == 0 and not FreedomLedger.part2_seed.get("touch_mutation", false) and not nexus_hunting:
		# Final Untouched rule (Path A): all senses stay dormant throughout Part II.
		# Blind contact is intentionally a nonlethal stagger, including the Nexus.
		# Only the separately seeded Vantree Touch branch bypasses this rule.
		hit_cooldown = 2.0
		player.play_action("stagger", 0.7)
		EventBus.noise_created.emit(player.global_position, 320.0, "GENERIC")
		velocity = -facing * blind_speed
		return
	_queue_strike(contact_damage, catch_distance + 30.0, witnessed_hide)

func _queue_strike(amount: float, reach: float, hide_id: String = "") -> void:
	if _attack_seconds > 0.0 or hit_cooldown > 0.0 or stun_seconds > 0.0:
		return
	hit_cooldown = 1.1
	_strike_damage = amount
	_strike_reach = reach
	_strike_hide = hide_id
	_strike_pending = true
	_attack_elapsed = 0.0
	_attack()

func _update_attack(delta: float) -> void:
	velocity = Vector2.ZERO
	_attack_seconds = maxf(0.0, _attack_seconds - delta)
	_attack_elapsed += delta
	var frame_count := sprite.sprite_frames.get_frame_count(sprite.animation)
	var impact_frame := maxi(1, roundi(frame_count * 0.25))
	var contact_time := float(impact_frame) / maxf(1.0, sprite.sprite_frames.get_animation_speed(sprite.animation))
	if _strike_pending and _attack_elapsed >= contact_time:
		_strike_pending = false
		_commit_strike()

func _commit_strike() -> void:
	if not is_instance_valid(player) or player.death_started or GameManager.state != GameManager.State.PLAYING or stun_seconds > 0.0:
		return
	if global_position.distance_to(player.global_position) > _strike_reach or not clear_sight(player.global_position):
		return
	if player.hidden_spot != null and player.hidden_spot.interaction_id != _strike_hide:
		return
	if FreedomLedger.current_part == 2:
		player.take_hit(_strike_damage)
	else:
		EventBus.player_caught.emit()

func _is_distraction_noise(point: Vector2, surface: String) -> bool:
	if surface == "CLOCK":
		return true
	for obj in get_tree().get_nodes_in_group("distraction_object"):
		if is_instance_valid(obj) and obj.global_position.distance_to(point) < 60.0:
			return true
	return false

func _hear(point: Vector2, intensity: float, surface: String) -> void:
	if not is_instance_valid(player) or not is_instance_valid(room):
		return
	if stun_seconds > 0.0 or _attack_seconds > 0.0 or GameManager.state != GameManager.State.PLAYING:
		return
	var is_distraction := _is_distraction_noise(point, surface)
	if is_distracted:
		if is_distraction:
			# Fresh distraction wins immediately; reject stale bottle/clock memory.
			is_distracted = true
			distraction_target = point
			distraction_arrived = false
			distraction_stay_timer = 0.0
			sight_confirm = 0.0
			lost_sight = 999.0
			detection_active = false
			change_state(State.INVESTIGATE)
			state_limit = 20.0
			return
		# While a distraction is active, ignore ordinary movement and noise.
		target = distraction_target if distraction_target != Vector2.ZERO else target
		return
	if not _has_sense("hearing") and not (is_distraction and state == State.CHASE):
		return
	if state == State.CHASE and not is_distraction:
		return
	var radius := intensity if intensity > 10.0 else intensity * hearing_scale
	if global_position.distance_to(point) > radius:
		return
	noise_pings = noise_pings.filter(func(stamp: float): return hearing_time - stamp <= 6.0)
	noise_pings.append(hearing_time)
	target = point
	path_clock = 0.0
	if global_position.distance_squared_to(point) > 1.0:
		facing = global_position.direction_to(point)
	if is_distraction:
		is_distracted = true
		distraction_target = point
		distraction_arrived = false
		distraction_stay_timer = 0.0
		sight_confirm = 0.0
		lost_sight = 999.0
		detection_active = false
		change_state(State.INVESTIGATE)
		state_limit = 20.0
		return
	if state == State.HUNT_AUDIO:
		state_clock = 0.0
		return
	if surface == "GLASS" or noise_pings.size() >= 2:
		_begin_detection()
		change_state(State.HUNT_AUDIO)
	else:
		change_state(State.INVESTIGATE)

func _begin_detection() -> void:
	if detection_active:
		return
	detection_active = true
	FreedomLedger.record_detection()
	EventBus.player_detected.emit(self)

func clear_sight(point: Vector2) -> bool:
	var query := PhysicsRayQueryParameters2D.create(global_position + Vector2(0, -7), point + Vector2(0, -7), 1, [get_rid()])
	return get_world_2d().direct_space_state.intersect_ray(query).is_empty()

func can_see_player() -> bool:
	if not is_instance_valid(player) or not is_instance_valid(room):
		return false
	if not _has_sense("sight") or player.hidden_spot != null:
		return false
	var offset: Vector2 = player.global_position - global_position
	var reach := vision_range if room.is_exposed(player.global_position) else shadow_vision_range
	if player.is_crouching and not player.flashlight_enabled:
		reach *= 0.72
	if player.flashlight_enabled:
		reach *= flashlight_range_multiplier
	if offset.length() > reach:
		return false
	# Close uncovered movement is visible in darkness, even just outside the cone.
	var tracking := state == State.CHASE and lost_sight < 1.2
	if offset.length() > 110.0 and not tracking and facing.dot(offset.normalized()) < cos(deg_to_rad(field_of_view * 0.5)):
		return false
	return clear_sight(player.global_position)

func _hidden(id: String) -> void:
	if not is_instance_valid(player) or not is_instance_valid(room):
		return
	var observed := _has_sense("sight") and sight_confirm > 0.0 and clear_sight(player.global_position)
	if observed:
		witnessed_hide = id
		target = player.global_position
		last_seen = target
		change_state(State.INVESTIGATE_LAST_SEEN)
		if _stage() >= 3:
			recent_hides.erase(id)
			recent_hides.append(id)
			if recent_hides.size() > 5:
				recent_hides.pop_front()

func _left_hiding(id: String) -> void:
	if witnessed_hide == id:
		witnessed_hide = ""

func _predict() -> void:
	var candidates: Array = get_tree().get_nodes_in_group("interactable").filter(func(spot): return spot.kind == "hiding")
	candidates.sort_custom(func(a, b): return _hide_score(a) > _hide_score(b))
	if not candidates.is_empty():
		target = candidates[0].global_position
		change_state(State.PREDICT_HUNT)
		return
	if memory_points.size() >= 2:
		var direction: Vector2 = (memory_points[-1] - memory_points[-2]).normalized()
		target = room.clamp_point(memory_points[-1] + direction * 240.0)
		change_state(State.PREDICT_HUNT)
	else:
		change_state(_patrol_state())

func _hide_score(spot: BaseInteractable) -> int:
	var priority: int = int({"low": 1, "medium": 2, "high": 3}.get(spot.hiding_priority, 1))
	priority = mini(3, priority + int(FreedomLedger.hiding_usage.get(spot.interaction_id, 0)))
	return priority * 10

func _predict_exit() -> bool:
	if not is_instance_valid(player) or not is_instance_valid(room):
		return false
	var exits: Array[Vector2] = room.known_exit_positions()
	if exits.is_empty():
		return false
	var heading: Vector2 = player.facing
	var best: Vector2 = exits[0]
	var best_dot: float = -2.0
	for point in exits:
		var dot: float = heading.dot(player.global_position.direction_to(point))
		if dot > best_dot:
			best_dot = dot
			best = point
	if best_dot < 0.45:
		return false
	target = best
	change_state(State.AMBUSH)
	return true

func _check_remembered_hide() -> void:
	if player.hidden_spot != null and global_position.distance_to(player.hidden_spot.global_position) < 45.0 and clear_sight(player.hidden_spot.global_position):
		_queue_strike(remembered_hide_damage, 68.0, player.hidden_spot.interaction_id)

func begin_nexus_hunt() -> void:
	nexus_hunting = true
	is_distracted = false
	distraction_arrived = false
	distraction_stay_timer = 0.0
	if is_instance_valid(player):
		target = player.global_position
		last_seen = target
	change_state(State.HUNT_AUDIO)

func bind_blood_trap() -> void:
	stun(18.0)
	blood_trap_seconds = 18.0

func defeat_in_nexus() -> void:
	stun(3600.0)
	nexus_defeated = true
	blood_trap_seconds = 0.0
	collision_layer = 0
	collision_mask = 0
	var fade := create_tween()
	fade.tween_property(self, "modulate:a", 0.0, 1.0)

func stun(seconds: float) -> void:
	stun_seconds = maxf(stun_seconds, seconds)
	detection_active = false
	sight_confirm = 0.0
	witnessed_hide = ""
	is_distracted = false
	distraction_arrived = false
	distraction_stay_timer = 0.0
	change_state(_patrol_state())
	_attack_seconds = 0.0
	_strike_pending = false
	_attack_elapsed = 0.0
	velocity = Vector2.ZERO
	_play_visual("stagger")

func _play_visual(animation: String) -> void:
	_apply_base_appearance()
	sprite.rotation = 0.0
	var base := "sniff" if animation == "idle" and state in [State.INVESTIGATE, State.INVESTIGATE_LAST_SEEN, State.AMBUSH] else animation
	var requested := _zombie_animation(base)
	var has_art := sprite.sprite_frames.has_animation(requested)
	if has_art:
		if sprite.animation != requested:
			var previous_frame := sprite.frame
			var previous_progress := sprite.frame_progress
			sprite.play(requested)
			if base in ["walk", "run"]:
				sprite.set_frame_and_progress(mini(previous_frame, sprite.sprite_frames.get_frame_count(requested) - 1), previous_progress)
		sprite.speed_scale = clampf(_visual_speed / (sight_chase_speed if base == "run" else patrol_speed), 0.4, 1.6) if base in ["walk", "run"] else 1.0
		_sync_zombie_footing()
	sprite.visible = has_art
	$Visual/PlaceholderVisual.visible = not has_art

func _zombie_animation(base: String) -> String:
	var asset_degrees := fposmod(rad_to_deg(facing.angle()) + 90.0, 360.0)
	var direction_index: int = roundi(asset_degrees / 45.0) % ZOMBIE_DIRECTIONS.size()
	return base + "_" + ZOMBIE_DIRECTIONS[direction_index]

func _on_visual_frame_changed() -> void:
	_sync_zombie_footing()
	var is_walk := str(sprite.animation).begins_with("walk_")
	var is_run := str(sprite.animation).begins_with("run_")
	if (is_walk and sprite.frame in [0, 10]) or (is_run and sprite.frame in [0, 8]):
		if _visual_speed > 1.0 and GameManager.state == GameManager.State.PLAYING:
			EventBus.audio_requested.emit("monster_footstep")

func _apply_base_appearance() -> void:
	var true_form: bool = _stage() >= 3 or (FreedomLedger.current_part == 2 and bool(FreedomLedger.part2_seed.get("touch_mutation", false)))
	sprite.scale = Vector2.ONE * (0.79 if true_form else 0.70)
	$Visual/Shadow.scale = Vector2.ONE * (1.13 if true_form else 1.0)
	sprite.modulate = Color(0.88, 0.76, 0.76) if true_form else Color.WHITE

func _sync_zombie_footing() -> void:
	sprite.offset = Vector2(0.0, ZombieFootOffsets.offset_y(sprite.animation, sprite.frame))

func _attack() -> void:
	velocity = Vector2.ZERO
	if _attack_seconds > 0.0:
		return
	if is_instance_valid(player):
		facing = global_position.direction_to(player.global_position)
	_play_visual("attack")
	sprite.set_frame_and_progress(0, 0.0)
	_attack_seconds = float(sprite.sprite_frames.get_frame_count(sprite.animation)) / sprite.sprite_frames.get_animation_speed(sprite.animation)

func _observe_debug() -> void:
	$DebugState.visible = debug_detection
	if debug_detection:
		$DebugState.text = State.keys()[state] + " / " + str(_stage())
		queue_redraw()

func _draw() -> void:
	if not debug_detection:
		return
	draw_arc(Vector2.ZERO, vision_range, facing.angle() - deg_to_rad(field_of_view / 2), facing.angle() + deg_to_rad(field_of_view / 2), 30, Color(0.8, 0.55, 0.2, 0.45), 2.0)
	draw_line(Vector2.ZERO, to_local(target), Color(0.8, 0.2, 0.2, 0.7), 2.0)
