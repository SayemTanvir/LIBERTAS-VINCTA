extends CharacterBody2D

const CharacterAnimation := preload("res://scripts/player/character_animation.gd")
const PlayerPoses := preload("res://scripts/player/player_poses.gd")
const SigilField := preload("res://scripts/player/sigil_field.gd")
const EstateAtmosphere := preload("res://scripts/levels/estate_atmosphere.gd")

@export var walk_speed: float = 141.0
@export var sprint_speed: float = 256.0
@export var crouch_speed: float = 70.0
@export_range(0.1, 1.0) var depth_ratio: float = 0.55
@export var acceleration: float = 1100.0
@export var interaction_radius: float = 76.0
@export var breath_capacity: float = 6.0
@export var breath_cooldown_seconds: float = 15.0

var control_enabled: bool = true
var is_crouching: bool = false
var is_sprinting: bool = false
var holding_breath: bool = false
var breath_seconds: float = 0.0
var breath_cooldown: float = 0.0
var hidden_spot: Node2D
var flashlight_enabled: bool = false
var facing: Vector2 = Vector2.RIGHT
var noise_clock: float = 0.0
var target_interactable: Node2D
var animation_state: String = "idle"
var animation_hold: float = 0.0
var sigil_cooldown: float = 0.0
var stun_cooldown: float = 0.0
var touch_evasion_cooldown: float = 0.0
var was_sprinting: bool = false
var presentation_clock: float = 0.0
var action_allows_movement: bool = false
var hiding_return_position := Vector2.ZERO
var hiding_transition: Tween
var hiding_transition_active := false
var flashlight_pose_key := ""

@onready var visual: Node2D = $Visual
@onready var sprite: AnimatedSprite2D = $Visual/AnimatedSprite2D
@onready var flashlight_pose: Sprite2D = $Visual/FlashlightPose

func _ready() -> void:
	add_to_group("player")
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	EventBus.player_caught.connect(_caught)
	sprite.sprite_frames = PlayerPoses.frames(sprite.sprite_frames)
	sprite.frame_changed.connect(_sync_pose_geometry)
	sprite.animation_changed.connect(_sync_pose_geometry)
	$FlashlightFloor/PointLight2D.texture = EstateAtmosphere.soft_light_texture()
	var awareness := PointLight2D.new()
	awareness.name = "AwarenessLight"
	awareness.texture = $FlashlightFloor/PointLight2D.texture
	awareness.position = Vector2(0, -25)
	awareness.texture_scale = 0.85
	awareness.color = Color("8599b3")
	awareness.energy = 0.28
	add_child(awareness)
	play_animation("idle")

func _process(delta: float) -> void:
	_update_body_presentation(delta)
	_update_flashlight_presentation()
	queue_redraw()

func _physics_process(delta: float) -> void:
	animation_hold = maxf(0.0, animation_hold - delta)
	breath_cooldown = maxf(0.0, breath_cooldown - delta)
	sigil_cooldown = maxf(0.0, sigil_cooldown - delta)
	stun_cooldown = maxf(0.0, stun_cooldown - delta)
	touch_evasion_cooldown = maxf(0.0, touch_evasion_cooldown - delta)
	_update_flashlight_charge(delta)
	_update_breath(delta)
	target_interactable = null
	if not control_enabled or GameManager.state != GameManager.State.PLAYING or GameManager.ui_blocks_input():
		velocity = Vector2.ZERO
		return
	if hiding_transition_active:
		velocity = Vector2.ZERO
		return
	if hidden_spot != null:
		velocity = Vector2.ZERO
		if Input.is_action_just_pressed("interact"):
			leave_hiding()
		return
	if animation_hold > 0.0 and animation_state not in ["idle", "walk", "run", "crouch_idle", "crouch_walk"]:
		if action_allows_movement and Input.get_vector("move_left", "move_right", "move_up", "move_down").length_squared() > 0.01:
			animation_hold = 0.0
		else:
			velocity = Vector2.ZERO
			_find_interactable()
			return
	if Input.is_action_just_pressed("flashlight") and FreedomLedger.flags.get("flashlight", false) and hidden_spot == null:
		set_flashlight(not flashlight_enabled)
	if Input.is_action_just_pressed("gadget"):
		use_gadget()
	if Input.is_action_just_pressed("ability"):
		use_sigil()
	if Input.is_action_just_pressed("stun"):
		use_stun()
	is_crouching = Input.is_action_pressed("crouch")
	is_sprinting = Input.is_action_pressed("sprint") and not is_crouching
	var axis := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var currently_sprinting = is_sprinting and axis.length_squared() > 0.01 and not holding_breath
	if currently_sprinting != was_sprinting:
		if currently_sprinting:
			EventBus.audio_requested.emit("start_running_breathing")
		else:
			EventBus.audio_requested.emit("stop_running_breathing")
		was_sprinting = currently_sprinting
	var speed := crouch_speed if is_crouching else (sprint_speed if is_sprinting else walk_speed)
	var desired := Vector2(axis.x, axis.y * depth_ratio) * speed
	velocity = velocity.move_toward(desired, acceleration * delta)
	move_and_slide()
	_register_touch_evasion()
	if axis.length_squared() > 0.01:
		facing = axis.normalized()
	_update_animation(axis, speed)
	noise_clock -= delta
	if get_real_velocity().length() > 10.0 and noise_clock <= 0.0 and not holding_breath:
		noise_clock = 0.52 if is_crouching else (0.27 if is_sprinting else 0.42)
		var intensity := 0.06 if is_crouching else (1.0 if is_sprinting else 0.24)
		var room = get_tree().get_first_node_in_group("room")
		var surface: String = room.surface_at(global_position) if room != null else "GENERIC"
		var emitted_surface := ("CARPET" if is_crouching else "GLASS") if surface == "CREAK" else surface
		NoiseModel.emit_step(global_position, intensity, emitted_surface)
		var gait := "crouch" if is_crouching else ("sprint" if is_sprinting else "walk")
		$FootstepAudio.play_step("WOOD" if surface == "CREAK" else surface, gait)
	_find_interactable()
	if Input.is_action_just_pressed("interact") and is_instance_valid(target_interactable):
		target_interactable.interact(self)

func _update_flashlight_charge(delta: float) -> void:
	if not flashlight_enabled:
		return
	var drain := 3.0 if is_sprinting else 1.0
	FreedomLedger.set_flashlight_seconds(FreedomLedger.flashlight_seconds - delta * drain)
	if FreedomLedger.flashlight_seconds <= 0.0:
		set_flashlight(false)

func _update_breath(delta: float) -> void:
	var wants_breath := Input.is_action_pressed("hold_breath") and breath_cooldown <= 0.0 and control_enabled and GameManager.state == GameManager.State.PLAYING
	if wants_breath and breath_seconds < breath_capacity:
		holding_breath = true
		breath_seconds += delta
	else:
		if holding_breath:
			breath_cooldown = breath_cooldown_seconds
		holding_breath = false
		breath_seconds = 0.0

func _find_interactable() -> void:
	target_interactable = null
	var nearest := interaction_radius
	for candidate in get_tree().get_nodes_in_group("interactable"):
		if not candidate.available():
			continue
		for point in candidate.interaction_points():
			var distance := global_position.distance_to(point)
			if distance < nearest:
				var ray := PhysicsRayQueryParameters2D.create(global_position, point, 1, [get_rid()])
				if get_world_2d().direct_space_state.intersect_ray(ray).is_empty():
					nearest = distance
					target_interactable = candidate

func set_flashlight(enabled: bool, present_action: bool = true) -> void:
	flashlight_enabled = enabled and FreedomLedger.flashlight_seconds > 0.0
	$FlashlightFloor.visible = flashlight_enabled
	EventBus.flashlight_changed.emit(flashlight_enabled)
	if present_action:
		EventBus.audio_requested.emit("flashlight")
	_update_flashlight_presentation()

func use_gadget() -> bool:
	if FreedomLedger.flashlight_seconds < 50.0 and FreedomLedger.consume_item("battery"):
		FreedomLedger.set_flashlight_seconds(FreedomLedger.flashlight_seconds + 45.0)
		play_action("interact", 0.55, true)
		EventBus.ability_used.emit("battery")
		return true
	var gadget := "bottle" if int(FreedomLedger.inventory.get("bottle", 0)) > 0 else "clock"
	if not FreedomLedger.consume_item(gadget):
		return false
	play_action("interact", 0.55, true)
	var point := global_position + facing * (260.0 if gadget == "bottle" else 180.0)
	EventBus.noise_created.emit(point, 576.0 if gadget == "bottle" else 384.0, "GLASS" if gadget == "bottle" else "GENERIC")
	if gadget == "bottle":
		EventBus.audio_requested.emit("glass_break")
	if GameManager.zone == "echoes" and FreedomLedger.current_part == 2 and FreedomLedger.part2_seed.get("full_gadgets", false):
		FreedomLedger.mechanic_uses += 1
	EventBus.ability_used.emit(gadget)
	return true

func _register_touch_evasion() -> void:
	if GameManager.zone != "echoes" or not FreedomLedger.part2_seed.get("touch_mutation", false) or touch_evasion_cooldown > 0.0:
		return
	var room = get_tree().get_first_node_in_group("room")
	if room == null or room.surface_at(global_position) != "RUBBLE" or get_real_velocity().length() < 20.0:
		return
	var enemy = get_tree().get_first_node_in_group("enemy")
	if enemy != null and global_position.distance_to(enemy.global_position) <= 520.0:
		FreedomLedger.mechanic_uses += 1
		touch_evasion_cooldown = 2.0
		EventBus.ability_used.emit("touch_evasion")

func use_sigil() -> bool:
	if GameManager.zone not in ["echoes", "nexus"] or not FreedomLedger.flags.get("part2_ability_unlocked", false) or sigil_cooldown > 0.0:
		return false
	var cost := FreedomLedger.max_hp * (0.04 if FreedomLedger.part2_seed.get("hybrid_magic", false) else 0.08)
	if FreedomLedger.hp <= cost:
		return false
	FreedomLedger.damage(cost)
	FreedomLedger.mechanic_uses += 1
	FreedomLedger.flags["sigil_until"] = Time.get_ticks_msec() + 12000
	FreedomLedger.flags["sigil_x"] = global_position.x
	FreedomLedger.flags["sigil_y"] = global_position.y
	sigil_cooldown = 20.0
	play_action("interact", 0.65, true)
	_spawn_sigil(192.0, 12.0, Color(0.46, 0.11, 0.13, 0.68))
	EventBus.ability_used.emit("blood_sigil")
	return true

func use_stun() -> bool:
	if not FreedomLedger.part2_seed.get("blood_magic", false) or not FreedomLedger.flags.get("part2_ability_unlocked", false) or stun_cooldown > 0.0:
		return false
	var targets: Array[Node] = []
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if global_position.distance_to(enemy.global_position) <= 192.0 and enemy.has_method("stun"):
			targets.append(enemy)
	if targets.is_empty():
		return false
	var cost := FreedomLedger.max_hp * 0.20
	if FreedomLedger.hp <= cost:
		return false
	FreedomLedger.damage(cost)
	stun_cooldown = 60.0
	for enemy in targets:
		enemy.stun(6.0)
	play_action("interact", 0.65, true)
	_spawn_sigil(192.0, 0.8, Color(0.72, 0.16, 0.18, 0.8))
	EventBus.ability_used.emit("blood_stun")
	return true

func _spawn_sigil(radius: float, lifetime: float, color: Color) -> void:
	var effect := Node2D.new()
	effect.name = "SigilField"
	effect.add_to_group("transient_effect")
	effect.set_script(SigilField)
	effect.radius = radius
	effect.lifetime = lifetime
	effect.tint = color
	effect.global_position = global_position
	get_tree().current_scene.add_child(effect)

func enter_hiding(spot: Node2D) -> void:
	if hidden_spot != null or hiding_transition_active:
		return
	hiding_return_position = global_position
	hidden_spot = spot
	velocity = Vector2.ZERO
	animation_hold = 0.0
	is_crouching = true
	is_sprinting = false
	set_flashlight(false, false)
	visual.modulate.a = 1.0
	visual.scale = Vector2.ONE
	facing = Vector2.RIGHT if global_position.x <= spot.global_position.x else Vector2.LEFT
	play_animation("crouch_idle")
	collision_layer = 0
	collision_mask = 0
	hiding_transition_active = true
	hiding_transition = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	var shelter_offset := Vector2(0, 8) if spot.interaction_id == "dining_table_hide" else Vector2(0, -2)
	hiding_transition.tween_property(self, "global_position", spot.global_position + shelter_offset, 0.22)
	hiding_transition.tween_callback(func(): hiding_transition_active = false)
	EventBus.player_hidden.emit(spot.interaction_id)

func leave_hiding() -> void:
	if hidden_spot == null:
		return
	var id: String = hidden_spot.interaction_id
	hidden_spot = null
	visual.modulate.a = 1.0
	if hiding_transition != null and hiding_transition.is_valid():
		hiding_transition.kill()
	hiding_transition_active = true
	hiding_transition = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	hiding_transition.tween_property(self, "global_position", hiding_return_position, 0.18)
	hiding_transition.tween_callback(func():
		collision_layer = 2
		collision_mask = 1
		hiding_transition_active = false
		is_crouching = Input.is_action_pressed("crouch")
		play_animation("crouch_idle" if is_crouching else "idle"))
	EventBus.player_left_hiding.emit(id)

func take_hit(amount: float = 25.0) -> void:
	if hidden_spot != null:
		leave_hiding()
	if FreedomLedger.damage(amount):
		EventBus.player_caught.emit()
	else:
		EventBus.audio_requested.emit("player_scream")
		play_action("damage", 0.55)

func _caught() -> void:
	if hiding_transition != null and hiding_transition.is_valid():
		hiding_transition.kill()
	if hidden_spot != null or hiding_transition_active:
		global_position = hiding_return_position
	hidden_spot = null
	hiding_transition_active = false
	is_crouching = false
	collision_layer = 2
	collision_mask = 1
	control_enabled = false
	velocity = Vector2.ZERO
	visual.scale.y = 1.0
	visual.modulate.a = 1.0
	play_animation("death")

func play_respawn() -> void:
	control_enabled = false
	velocity = Vector2.ZERO
	visual.scale.y = 1.0
	visual.modulate.a = 0.0
	play_animation("death")
	var reveal: Tween
	if sprite.visible and sprite.sprite_frames != null:
		var recovery_animation := sprite.animation
		var frame_count := sprite.sprite_frames.get_frame_count(recovery_animation)
		sprite.pause()
		sprite.set_frame_and_progress(frame_count - 1, 1.0)
		reveal = create_tween()
		reveal.tween_property(visual, "modulate:a", 1.0, 0.18)
		sprite.play(recovery_animation, -1.35, true)
		var fps := maxf(1.0, sprite.sprite_frames.get_animation_speed(recovery_animation))
		await get_tree().create_timer(minf(0.9, float(frame_count) / fps / 1.35), false).timeout
	else:
		reveal = create_tween()
		reveal.tween_property(visual, "modulate:a", 1.0, 0.3)
		await reveal.finished
	visual.modulate.a = 1.0
	animation_hold = 0.0
	play_animation("idle")
	control_enabled = true

func _update_animation(axis: Vector2, speed: float) -> void:
	$FlashlightFloor.rotation = facing.angle()
	if animation_hold > 0.0:
		return
	var animation := "idle"
	if get_real_velocity().length() > 5.0 and axis.length() > 0.01:
		animation = "run" if speed == sprint_speed else "walk"
	if is_crouching:
		animation = "crouch_idle" if animation == "idle" else "crouch_walk"
	play_animation(animation)
	var floor_velocity := Vector2(get_real_velocity().x, get_real_velocity().y / depth_ratio)
	sprite.speed_scale = clampf(floor_velocity.length() / speed, 0.3, 1.15) if animation in ["walk", "run", "crouch_walk"] else 1.0

func play_action(animation: String, seconds: float = 1.0, allow_movement: bool = false) -> void:
	action_allows_movement = allow_movement
	animation_hold = maxf(seconds, 0.1)
	play_animation(animation)
	if sprite.visible:
		sprite.play()
		sprite.set_frame_and_progress(0, 0.0)
		var duration := float(sprite.sprite_frames.get_frame_count(sprite.animation)) / maxf(1.0, sprite.sprite_frames.get_animation_speed(sprite.animation))
		sprite.speed_scale = 1.0 if animation in ["channel", "recharge"] else duration / animation_hold

func play_animation(animation: String) -> void:
	animation_state = animation
	sprite.speed_scale = 1.0
	var direction := CharacterAnimation.direction_name(facing)
	sprite.flip_h = animation == "unlock" and direction in ["w", "e"]
	var has_art := CharacterAnimation.play(sprite, animation, facing)
	sprite.visible = has_art
	$Visual/PlaceholderVisual.visible = not has_art
	_sync_pose_geometry()
	_update_flashlight_presentation()

func _sync_pose_geometry() -> void:
	var texture := sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame)
	var crouch_art := texture.get_width() > 256.0
	sprite.scale = Vector2.ONE * (0.2 if crouch_art else 0.4)
	sprite.offset = Vector2(0, -192 if crouch_art else -96)
	(sprite.material as ShaderMaterial).set_shader_parameter("crouch_art", crouch_art)

func _update_flashlight_presentation() -> void:
	$FlashlightFloor.rotation = facing.angle()
	var has_flashlight: bool = bool(FreedomLedger.flags.get("flashlight", false))
	var holding := has_flashlight and flashlight_enabled and hidden_spot == null and not is_crouching and animation_state in ["idle", "walk", "run"]
	flashlight_pose.visible = holding
	(sprite.material as ShaderMaterial).set_shader_parameter("holding_light", holding)
	if holding:
		var direction := CharacterAnimation.direction_name(facing)
		var key := direction + str(flashlight_enabled)
		if key != flashlight_pose_key:
			flashlight_pose.texture = PlayerPoses.flashlight_pose(direction, flashlight_enabled)
			flashlight_pose_key = key

func _update_body_presentation(delta: float) -> void:
	if GameManager.state != GameManager.State.PLAYING or not control_enabled:
		return
	presentation_clock += delta
	var response := 1.0 - exp(-14.0 * delta)
	var breathing := sin(presentation_clock * 2.2) * 0.006 if animation_state == "idle" and not is_crouching and not holding_breath else 0.0
	visual.scale.y = lerpf(visual.scale.y, 1.0 + breathing, response)
	visual.scale.x = lerpf(visual.scale.x, 1.0, response)

func speech_anchor() -> Vector2:
	return Vector2(0, -46 if is_crouching or hidden_spot != null else -78)

func _draw() -> void:
	if not FreedomLedger.part2_seed.get("touch_mutation", false):
		return
	var room = get_tree().get_first_node_in_group("room")
	if room == null or room.surface_at(global_position) != "STONE":
		return
	for enemy in get_tree().get_nodes_in_group("enemy"):
		var distance := global_position.distance_to(enemy.global_position)
		if distance <= 480.0:
			var local_target := to_local(enemy.global_position)
			draw_circle(local_target.normalized() * minf(56.0, distance * 0.15), 5.0, Color(0.35, 0.76, 0.76, 0.55), false, 2.0)
