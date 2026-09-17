extends Node2D

const ENEMY := preload("res://scenes/enemy/deprived_one.tscn")
const PLAYER := preload("res://scenes/player/player.tscn")
const ZOMBIE_FEET := preload("res://scripts/enemy/zombie_foot_offsets.gd")
var checks := 0
var failures := 0

func _ready() -> void:
	AudioServer.set_bus_mute(0, true)
	_run.call_deferred()

func check(value: bool, message: String) -> void:
	checks += 1
	if not value:
		failures += 1
		push_error(message)

func capture(label: String) -> void:
	if DisplayServer.get_name() == "headless":
		return
	await get_tree().process_frame
	await RenderingServer.frame_post_draw
	check(get_viewport().get_texture().get_image().save_png("res://build/" + label + ".png") == OK, "Capture failed: " + label)

func _run() -> void:
	FreedomLedger.reset()
	GameManager.zone = "ground"
	GameManager.state = GameManager.State.PLAYING
	var room: Node2D = preload("res://scenes/levels/ground_floor.tscn").instantiate()
	add_child(room)
	var player: CharacterBody2D = PLAYER.instantiate()
	room.add_child(player)
	player.position = Vector2(1100, 590)
	player.set_physics_process(false)
	var enemy: CharacterBody2D = ENEMY.instantiate()
	room.add_child(enemy)
	enemy.position = Vector2(950, 590)
	enemy.set_physics_process(false)
	var sprite: AnimatedSprite2D = enemy.sprite
	check(sprite.sprite_frames.resource_path.ends_with("new_zombie_frames.tres"), "Main enemy does not use the new zombie artwork")
	check(enemy.get_node("CollisionShape2D").shape.size == Vector2(24, 14), "Foot collision changed")
	check(is_equal_approx(sprite.scale.x, 0.63) and is_equal_approx(sprite.scale.y, 0.63), "Zombie is not reduced by ten percent")
	for action in ["idle", "walk", "sniff", "run", "attack", "stagger"]:
		enemy.facing = Vector2.DOWN
		enemy._play_visual(action)
		var animation: StringName = sprite.animation
		check(str(animation).begins_with(action + "_"), action + " does not select a directional zombie animation")
		var count: int = sprite.sprite_frames.get_frame_count(animation)
		check(count >= 4, action + " is missing its supplied poses")
		for frame in count:
			sprite.set_frame_and_progress(frame, 0.0)
			check(is_equal_approx(sprite.offset.y, ZOMBIE_FEET.offset_y(animation, frame)), action + " frame is not grounded to the floor")
			var atlas: AtlasTexture = sprite.sprite_frames.get_frame_texture(animation, frame)
			check(atlas.get_size() == Vector2(256, 256), action + " changes canvas size")
			check(atlas.atlas.resource_path.begins_with("res://assets/sprites/new_zombie/transparent/"), action + " does not use a transparent zombie sheet")
			if frame == 0:
				check(atlas.atlas.get_image().get_pixel(0, 0).a < 0.01, action + " retains the magenta sheet background")
	enemy.facing = Vector2.LEFT
	enemy._play_visual("walk")
	sprite.set_frame_and_progress(3, 0.5)
	enemy.facing = Vector2.RIGHT
	enemy._update_visual_facing(Vector2.RIGHT, 0.2)
	enemy._play_visual("walk")
	check(sprite.animation == &"walk_090" and sprite.frame == 3 and is_equal_approx(sprite.frame_progress, 0.5), "Turning restarts the gait")
	enemy.facing = Vector2.LEFT
	enemy._update_visual_facing(Vector2.LEFT, 0.2)
	enemy._play_visual("walk")
	check(sprite.animation == &"walk_270", "Left-facing movement does not use the supplied west view")
	enemy.facing = Vector2.UP
	enemy._play_visual("walk")
	check(sprite.animation == &"walk_0", "Upward movement does not use the supplied north view")
	enemy._visual_speed = enemy.patrol_speed
	enemy._play_visual("walk")
	check(is_equal_approx(sprite.speed_scale, 1.0), "Walk rate is not synchronized with movement")
	enemy._attack()
	check(str(sprite.animation).begins_with("attack_") and enemy._attack_seconds > 0.0 and not sprite.sprite_frames.get_animation_loop(sprite.animation), "Attack is not a held one-shot")
	enemy.stun(2.0)
	check(str(sprite.animation).begins_with("stagger_") and enemy._attack_seconds == 0.0, "Stun does not interrupt the attack")
	var second: CharacterBody2D = ENEMY.instantiate()
	room.add_child(second)
	second.set_physics_process(false)
	check(second.sprite.material != sprite.material, "Enemies share mutable sprite materials")
	second.queue_free()
	var camera: Camera2D = player.get_node("Camera2D")
	camera.limit_left = 0
	camera.limit_right = int(room.room_width)
	camera.limit_top = 0
	camera.limit_bottom = 720
	camera.position_smoothing_enabled = false
	camera.snap_to_player()
	camera.force_update_scroll()
	enemy.stun_seconds = 0.0
	enemy.facing = Vector2.RIGHT
	enemy._play_visual("idle")
	await capture("zombie_in_room")
	room.hide()
	var sheet := CanvasLayer.new()
	add_child(sheet)
	var background := ColorRect.new()
	background.color = Color("354b51")
	background.size = Vector2(1280, 720)
	sheet.add_child(background)
	var row := 0
	for action in ["idle", "walk", "sniff", "run", "attack", "stagger"]:
		enemy.facing = Vector2.DOWN
		enemy._play_visual(action)
		var action_animation: StringName = sprite.animation
		for frame in sprite.sprite_frames.get_frame_count(action_animation):
			var pose := AnimatedSprite2D.new()
			pose.sprite_frames = sprite.sprite_frames
			pose.material = sprite.material.duplicate()
			pose.animation = action_animation
			pose.frame = frame
			pose.offset = sprite.offset
			pose.scale = Vector2.ONE * 0.50
			pose.position = Vector2(frame * 158 + 90, row * 120 + 106)
			sheet.add_child(pose)
			var label := Label.new()
			label.text = action + " " + str(frame + 1)
			label.position = Vector2(frame * 158 + 12, row * 120 + 5)
			sheet.add_child(label)
		row += 1
	await capture("zombie_all_frames")
	sheet.queue_free()
	room.queue_free()
	await get_tree().process_frame
	GameManager.zone = "intro"
	var intro: Node2D = preload("res://scenes/levels/intro_floor.tscn").instantiate()
	add_child(intro)
	check(intro.get_node_or_null("Backdrop/Moonlight") == null, "Intro still contains the rectangular moonlight patch")
	var intro_player: CharacterBody2D = PLAYER.instantiate()
	intro.add_child(intro_player)
	intro_player.position = Vector2(260, 500)
	intro_player.set_physics_process(false)
	var intro_camera: Camera2D = intro_player.get_node("Camera2D")
	intro_camera.limit_left = 0
	intro_camera.limit_right = int(intro.room_width)
	intro_camera.limit_top = 0
	intro_camera.limit_bottom = 720
	intro_camera.position_smoothing_enabled = false
	var intro_sprite: AnimatedSprite2D = intro_player.get_node("Visual/AnimatedSprite2D")
	intro_sprite.animation = &"death_w"
	intro_sprite.frame = intro_sprite.sprite_frames.get_frame_count(&"death_w") - 1
	intro_sprite.pause()
	intro_camera.snap_to_player()
	intro_camera.force_update_scroll()
	await capture("intro_floor_fixed")
	intro.queue_free()
	await get_tree().process_frame
	print("ENEMY PRESENTATION: %s checks, %s failures" % [checks, failures])
	get_tree().quit(0 if failures == 0 else 1)
