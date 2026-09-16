extends Node
## The supplied door has a left-hand lock and a right-hand hinge.
const LOCK_SIDE := -1.0
const LEAF_REGION := Rect2(682, 532, 168, 379)
var door_sprite: Sprite2D
var destination_label: Label
var closed_position: Vector2
var closed_scale: Vector2
var closed_rotation: float
var open_position: Vector2
var open_scale: Vector2
var arrival_completed: bool = false
var is_open := false

func configure(sprite: Sprite2D, label: Label) -> void:
	_split_frame(sprite)
	door_sprite = sprite
	destination_label = label
	closed_position = sprite.position
	closed_scale = sprite.scale
	closed_rotation = sprite.rotation
	var width := sprite.texture.get_width() * closed_scale.x
	open_scale = Vector2(closed_scale.x * 0.28, closed_scale.y)
	open_position = closed_position + Vector2(-LOCK_SIDE * width * 0.36, 0)

func _split_frame(sprite: Sprite2D) -> void:
	# Crop existing artwork into a moving leaf and four stationary jamb/threshold pieces.
	# No source image is changed, and the brass lock remains part of the moving leaf.
	var atlas := sprite.texture as AtlasTexture
	if atlas == null:
		return
	var source := atlas.region
	var origin := sprite.position + sprite.get_rect().position * sprite.scale
	var pieces := [
		Rect2(source.position, Vector2(source.size.x, LEAF_REGION.position.y - source.position.y)),
		Rect2(source.position.x, LEAF_REGION.position.y, LEAF_REGION.position.x - source.position.x, LEAF_REGION.size.y),
		Rect2(LEAF_REGION.end.x, LEAF_REGION.position.y, source.end.x - LEAF_REGION.end.x, LEAF_REGION.size.y),
		Rect2(source.position.x, LEAF_REGION.end.y, source.size.x, source.end.y - LEAF_REGION.end.y)]
	var frame := Node2D.new()
	frame.name = "StationaryDoorFrame"
	sprite.get_parent().add_child(frame)
	for region: Rect2 in pieces:
		var part := Sprite2D.new()
		var crop := AtlasTexture.new()
		crop.atlas = atlas.atlas
		crop.region = region
		crop.filter_clip = true
		part.texture = crop
		part.scale = sprite.scale
		part.position = origin + (region.get_center() - source.position) * sprite.scale
		part.self_modulate = sprite.self_modulate
		part.texture_filter = sprite.texture_filter
		frame.add_child(part)
	var leaf := AtlasTexture.new()
	leaf.atlas = atlas.atlas
	leaf.region = LEAF_REGION
	leaf.filter_clip = true
	sprite.position = origin + (LEAF_REGION.get_center() - source.position) * sprite.scale
	sprite.offset = Vector2.ZERO
	sprite.texture = leaf

func set_open_immediate(opened: bool) -> void:
	is_open = opened
	if not is_instance_valid(door_sprite):
		return
	door_sprite.position = open_position if opened else closed_position
	door_sprite.scale = open_scale if opened else closed_scale
	door_sprite.rotation = closed_rotation
	if is_instance_valid(destination_label):
		destination_label.modulate.a = 0.0 if opened else 1.0

func animate_open(opened: bool, duration: float = 0.42) -> void:
	is_open = opened
	if not is_instance_valid(door_sprite):
		return
	var tween := create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(door_sprite, "position", open_position if opened else closed_position, duration)
	tween.tween_property(door_sprite, "scale", open_scale if opened else closed_scale, duration)
	tween.tween_property(door_sprite, "rotation", closed_rotation, duration)
	if is_instance_valid(destination_label):
		tween.tween_property(destination_label, "modulate:a", 0.0 if opened else 1.0, duration * 0.7)
	await tween.finished

func align_for_interaction(player: CharacterBody2D) -> bool:
	var doorway: Vector2 = get_parent().get_parent().global_position
	# E may be pressed beside the doorway, but cannot operate it from across a room.
	if player.global_position.distance_to(doorway) > player.interaction_radius:
		return false
	var locking: bool = get_parent().get_parent().kind == "locked_door"
	# Align sideways/forward only. A player already at the handle never backs away.
	var staging := Vector2(doorway.x, minf(player.global_position.y, doorway.y + (10.0 if locking else 34.0)))
	var start_hp: float = FreedomLedger.hp
	var remaining := 1.5
	player.control_enabled = false
	player.velocity = Vector2.ZERO
	player.animation_hold = 0.0
	while player.global_position.distance_to(staging) > 1.0:
		await get_tree().physics_frame
		if get_tree().paused:
			continue
		if GameManager.state != GameManager.State.PLAYING or FreedomLedger.hp < start_hp or remaining <= 0.0:
			player.control_enabled = GameManager.state == GameManager.State.PLAYING
			player.play_animation("idle")
			return false
		var delta := get_physics_process_delta_time()
		remaining -= delta
		var offset := staging - player.global_position
		player.facing = offset.normalized()
		player.play_animation("walk")
		# Respect walls and furniture during the short approach; never tween through them.
		var collision := player.move_and_collide(offset.limit_length(player.walk_speed * delta))
		if collision != null:
			player.control_enabled = true
			player.play_animation("idle")
			return false
	player.facing = Vector2.UP
	player.play_animation("idle")
	player.control_enabled = true
	return true

func depart(player: CharacterBody2D) -> void:
	var doorway: Vector2 = get_parent().get_parent().global_position
	player.control_enabled = false
	player.velocity = Vector2.ZERO
	player.facing = Vector2.UP
	# BaseInteractable already aligned Els before its key/handle action.
	if not is_open:
		EventBus.audio_requested.emit("door_open")
		await animate_open(true)
	if GameManager.state != GameManager.State.PLAYING or player.death_started:
		return
	player.animation_hold = 0.0
	player.play_animation("walk")
	# Enter from the exact key/handle stance, always moving forward into the opening.
	var threshold := Vector2(doorway.x, minf(doorway.y - 12.0, player.global_position.y - 22.0))
	var enter := create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	enter.tween_property(player, "global_position", threshold, 0.48)
	enter.tween_property(player.get_node("Visual"), "modulate:a", 0.0, 0.38).set_delay(0.10)
	while enter.is_running():
		await get_tree().process_frame
		if get_tree().paused:
			continue
		if GameManager.state != GameManager.State.PLAYING or player.death_started:
			enter.kill()
			player.get_node("Visual").modulate.a = 1.0
			return

func arrive(player: CharacterBody2D) -> void:
	var doorway: Vector2 = get_parent().get_parent().global_position
	set_open_immediate(true)
	player.control_enabled = false
	player.velocity = Vector2.ZERO
	player.global_position = doorway + Vector2(0, 8)
	player.facing = Vector2.DOWN
	player.get_node("Visual").modulate.a = 0.0
	player.animation_hold = 0.0
	player.play_animation("walk")
	var emerge := create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	emerge.tween_property(player, "global_position", doorway + Vector2(0, 56), 0.52)
	emerge.tween_property(player.get_node("Visual"), "modulate:a", 1.0, 0.34)
	await emerge.finished
	player.play_animation("idle")
	EventBus.audio_requested.emit("door_open")
	await animate_open(false)
	EventBus.audio_requested.emit("door_close")
	player.control_enabled = true
	arrival_completed = true
