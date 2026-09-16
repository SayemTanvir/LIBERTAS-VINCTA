extends Node
var checks := 0
var failures := 0
var main: Node2D
var player: CharacterBody2D
var enemy: CharacterBody2D

func _ready() -> void:
	AudioServer.set_bus_mute(0, true)
	GameManager.save_path = "res://build/action_animation_save.json"
	_run.call_deferred()

func check(value: bool, label: String) -> void:
	checks += 1
	if not value:
		failures += 1
		push_error(label)

func frames(count: int = 3) -> void:
	for index in count:
		await get_tree().physics_frame
		await get_tree().process_frame

func _run() -> void:
	var action_loader := preload("res://scripts/player/action_frames.gd")
	var manifest: Dictionary = action_loader.MANIFEST.data
	check(manifest.has("torch_use"), "Installed flashlight sheet has frame metadata")
	check(manifest.size() == 9, "All nine dedicated sheets are installed")
	var fallback: SpriteFrames = preload("res://scenes/player/female_frames.tres").duplicate()
	var original_count := fallback.get_frame_count("walk_e")
	var empty_manifest := JSON.new()
	empty_manifest.data = {}
	action_loader.append_to(fallback, empty_manifest)
	check(fallback.get_frame_count("walk_e") == original_count, "Empty optional manifest preserves base animations without crashing")
	FreedomLedger.reset()
	GameManager.zone = "ground"
	GameManager.entry = "start"
	GameManager.arrival_pending = false
	GameManager.respawn_pending = false
	GameManager.state = GameManager.State.PLAYING
	main = preload("res://scenes/main/main.tscn").instantiate()
	add_child(main)
	player = main.get_node("Entities/Player")
	enemy = get_tree().get_first_node_in_group("enemy")
	enemy.set_physics_process(false)
	player.position = Vector2(1500, 500)
	await frames()
	var resource: SpriteFrames = player.sprite.sprite_frames
	var actions := ["torch_raise", "torch_lower", "torch_idle", "torch_walk", "torch_run", "vent_enter", "vent_exit", "unlock", "piano", "hide_wall", "hide_wall_hold", "hide_wall_exit", "hide_table", "hide_table_hold", "hide_table_exit", "bag_pickup", "key_pickup"]
	for action: String in actions:
		for direction: String in ["s", "sw", "w", "nw", "n", "ne", "e", "se"]:
			var clip := action + "_" + direction
			check(resource.has_animation(clip), "Available action/direction: " + clip)
			check(resource.get_frame_count(clip) > 0, "Action contains playable frames: " + clip)
			for index in resource.get_frame_count(clip):
				var texture: AtlasTexture = resource.get_frame_texture(clip, index)
				check(Rect2(Vector2.ZERO, texture.atlas.get_size()).encloses(texture.region), "Frame remains inside sheet: " + clip)
				if texture.has_meta("action_scale"):
					var offset: Vector2 = texture.get_meta("action_offset")
					var scale: float = texture.get_meta("action_scale")
					check(absf((texture.get_height() * 0.5 + offset.y) * scale) < 4.0, "Feet remain grounded: " + clip)
				else:
					check(action in ["torch_walk", "torch_run"], "Only missing torch gait uses original frames")
	var sources := {}
	for action: String in ["torch_raise", "vent_enter", "unlock", "piano", "hide_wall", "hide_table", "bag_pickup", "key_pickup"]:
		var texture: AtlasTexture = resource.get_frame_texture(action + "_e", 0)
		check(not sources.has(texture.atlas.resource_path), "Independent generated source: " + action)
		sources[texture.atlas.resource_path] = true
	FreedomLedger.flags.flashlight = true
	player.set_flashlight(true)
	check(player.animation_state == "torch_raise" and not player.get_node("FlashlightFloor").visible, "Raising torch precedes switch frame")
	await get_tree().create_timer(0.28, false).timeout
	check(player.get_node("FlashlightFloor").visible, "Beam activates at switch pose")
	Input.action_press("move_right")
	await frames(9)
	check(str(player.sprite.animation).begins_with("torch_walk_") and player.velocity.x > 50.0, "Movement interrupts raise into dedicated torch gait")
	await capture_world("torch_walk")
	var dedicated_gait := resource.get_frame_texture(player.sprite.animation, player.sprite.frame).has_meta("action_scale")
	check(dedicated_gait, "Distributed torch gait uses generated whole-body artwork")
	check(player.flashlight_pose.visible != dedicated_gait, "Fallback gait holds the light; dedicated art needs no overlay")
	# Sprint back along the cleared approach, away from the room's east wall.
	Input.action_release("move_right")
	Input.action_press("move_left")
	Input.action_press("sprint")
	await frames(8)
	check(str(player.sprite.animation).begins_with("torch_run_"), "Sprinting selects torch run: %s at %s" % [player.sprite.animation, player.position])
	Input.action_release("sprint")
	Input.action_release("move_left")
	player.set_flashlight(false)
	check(player.animation_state == "torch_lower" and not player.get_node("FlashlightFloor").visible, "Lower animation switches beam off immediately")
	await get_tree().create_timer(0.5, false).timeout
	check(player.animation_state == "idle" and str(player.sprite.animation).begins_with("idle_"), "Torch lower returns to ordinary idle")
	check(not player.flashlight_pose.visible, "Light off removes fallback holding pose")
	var table: BaseInteractable = main.room.props.get_node("DiningTableHide")
	player.position = table.position + Vector2(0, 35)
	var approach: Vector2 = player.position
	await table.interact(player)
	check(player.animation_state == "hide_table" and player.hiding_transition_active, "Table entry has its own crawl sequence")
	await get_tree().create_timer(0.75, false).timeout
	check(player.animation_state == "hide_table_hold" and player.hidden_spot == table, "Table hold stays low")
	check(player.speech_anchor().y > -50.0 and player.speech_anchor().y < -20.0, "Speech follows the low head pose")
	await capture_world("table_cover")
	check(player.sprite.sprite_frames.get_frame_texture(player.sprite.animation, player.sprite.frame).get_height() * player.sprite.scale.y < 45.0, "Low hide silhouette fits below table")
	player.leave_hiding()
	check(player.animation_state == "hide_table_exit", "Table exit reverses crawl")
	await get_tree().create_timer(0.6, false).timeout
	check(player.position.distance_to(approach) < 0.1 and player.collision_mask == 1 and player.collision_layer == 2, "Exit restores approach and collision")
	var wall: BaseInteractable = main.room.props.get_node("PantryWardrobe")
	player.position = wall.position + Vector2(0, 35)
	await wall.interact(player)
	check(player.animation_state == "hide_wall", "Tall cover uses wall stance")
	await get_tree().create_timer(0.55, false).timeout
	check(player.animation_state == "hide_wall_hold", "Wall stance holds independently of low cover")
	check(player.speech_anchor().y < -65.0, "Tall cover keeps speech above the standing head")
	await capture_world("wall_cover")
	player.leave_hiding()
	await get_tree().create_timer(0.45, false).timeout
	var vent: BaseInteractable = main.room.props.get_node("GroundVent")
	player.position = vent.position + Vector2(0, 45)
	check(await player.traverse_vent(vent.global_position, true), "Vent crawl completes")
	check(player.visual.modulate.a < 0.01 and player.animation_state == "vent_enter", "Vent disappears only after low crawl")
	GameManager.state = GameManager.State.INTRO
	check(await player.traverse_vent(vent.global_position, false), "Vent emergence completes")
	check(player.visual.modulate.a == 1.0 and player.control_enabled and player.position.distance_to(vent.position + Vector2(0, 56)) < 0.1, "Vent exit restores visibility and movement")
	GameManager.state = GameManager.State.PLAYING
	await capture_world("vent_exit")
	check(main.room.props.get_node("HearingKey")._action_animation() == "key_pickup", "Key dispatch uses tiny-key animation")
	check(main.room.props.get_node("PianoSeal")._action_animation() == "piano", "Piano dispatch stays distinct")
	await _monster_checks()
	await _gallery()
	main.queue_free()
	await frames()
	print("ACTION ANIMATION: %d checks, %d failures" % [checks, failures])
	get_tree().quit(0 if failures == 0 else 1)

func _reset_attack() -> void:
	enemy._attack_seconds = 0.0
	enemy._strike_pending = false
	enemy.hit_cooldown = 0.0
	enemy.stun_seconds = 0.0
	player.hurt_cooldown = 0.0
	player.position = Vector2(1518, 610)
	enemy.position = Vector2(1500, 610)
	enemy.facing = Vector2.RIGHT
	FreedomLedger.hp = FreedomLedger.max_hp

func _monster_checks() -> void:
	player.set_physics_process(false)
	FreedomLedger.current_part = 2
	FreedomLedger.part2_seed = {"monster_stage": 2, "senses": ["hearing", "sight"]}
	await frames()
	_reset_attack()
	var hp: float = FreedomLedger.hp
	enemy._resolve_contact()
	check(enemy._strike_pending and FreedomLedger.hp == hp and enemy.sprite.animation == &"attack", "Contact starts visible windup before damage")
	enemy._update_attack(0.1)
	check(FreedomLedger.hp == hp, "Windup gives a reaction window")
	enemy._update_attack(0.3)
	check(FreedomLedger.hp == hp - enemy.contact_damage, "Jaws apply one hit at contact frame")
	enemy._update_attack(0.3)
	check(FreedomLedger.hp == hp - enemy.contact_damage, "Recovery never repeats damage")
	_reset_attack()
	enemy._resolve_contact()
	player.position.x += 100.0
	enemy._update_attack(0.4)
	check(FreedomLedger.hp == hp, "Moving out of reach evades committed strike")
	_reset_attack()
	enemy._resolve_contact()
	player.position.x = enemy.position.x - 20.0
	enemy._update_attack(0.4)
	check(FreedomLedger.hp == hp, "Running past committed jaws evades strike")
	_reset_attack()
	enemy._resolve_contact()
	enemy.stun(1.0)
	enemy._update_attack(0.4)
	check(FreedomLedger.hp == hp and not enemy._strike_pending and enemy.sprite.animation == &"stagger", "Stun cancels pending damage")
	_reset_attack()
	enemy._resolve_contact()
	main.room._wall("ActionTestWall", Rect2(Vector2(1506, 590), Vector2(5, 40)))
	await frames()
	enemy._update_attack(0.4)
	check(FreedomLedger.hp == hp, "Strike rechecks obstruction at contact")
	main.room.geometry.get_node("ActionTestWall").queue_free()
	await frames()
	_reset_attack()
	FreedomLedger.current_part = 1
	FreedomLedger.part2_seed = {}
	enemy._resolve_contact()
	check(not enemy._strike_pending and FreedomLedger.hp == hp, "Blind stage remains a harmless collision")
	FreedomLedger.keys_collected = ["hearing", "sight"]
	FreedomLedger.entity_stage = 2
	enemy.change_state(enemy.State.PATROL_SIGHT)
	enemy.noise_pings.clear()
	enemy._hear(enemy.position + Vector2(-100, 0), 300, "WOOD")
	check(enemy.facing.x < -0.9 and enemy.path_clock == 0 and enemy.state == enemy.State.INVESTIGATE, "Sound gives immediate directional response")
	enemy.target = enemy.position + Vector2(150, 0)
	enemy.change_state(enemy.State.CHASE)
	enemy.velocity = Vector2.ZERO
	enemy._move(1.0/60.0)
	check(enemy.velocity.length() > 0 and enemy.velocity.length() < enemy.sight_chase_speed, "Chase accelerates into motion without instant full-speed snap")
	player.animation_hold = 0.0
	player.control_enabled = true
	player.play_animation("idle")

func capture_world(label: String) -> void:
	if DisplayServer.get_name() == "headless":
		return
	player.get_node("Camera2D").snap_to_player()
	await frames()
	await RenderingServer.frame_post_draw
	check(get_viewport().get_texture().get_image().save_png("res://build/action_world_" + label + ".png") == OK, "World preview " + label)

func _gallery() -> void:
	if DisplayServer.get_name() == "headless":
		return
	var gallery := CanvasLayer.new()
	gallery.layer = 100
	add_child(gallery)
	var background := ColorRect.new()
	background.size = Vector2(1280, 720)
	background.color = Color("111920")
	gallery.add_child(background)
	var base_actions := ["torch_raise", "unlock", "piano", "vent_enter", "hide_wall", "hide_table", "bag_pickup", "key_pickup"]
	for page: String in ["e", "n", "gaits"]:
		var actions: Array = base_actions if page != "gaits" else ["torch_walk", "torch_run", "torch_walk", "torch_run", "torch_walk", "torch_run", "torch_walk", "torch_run"]
		var content := Node2D.new()
		gallery.add_child(content)
		for row in actions.size():
			var direction: String = page if page != "gaits" else str(["s", "w", "n", "e"][row / 2])
			var label := Label.new()
			label.text = str(actions[row]).replace("_", " ").to_upper() + " / " + direction.to_upper()
			label.position = Vector2(20, 54 + row * 84)
			label.add_theme_font_size_override("font_size", 14)
			label.modulate = Color("dbc6a0")
			content.add_child(label)
			var clip: String = actions[row] + "_" + direction
			var count: int = player.sprite.sprite_frames.get_frame_count(clip)
			for column in 6:
				var texture: Texture2D = player.sprite.sprite_frames.get_frame_texture(clip, roundi(float(column) * (count-1)/5))
				var pose := Sprite2D.new()
				pose.texture = texture
				pose.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
				pose.scale = Vector2.ONE * float(texture.get_meta("action_scale"))
				pose.offset = texture.get_meta("action_offset")
				pose.position = Vector2(285 + column*165, 84 + row*84)
				pose.material = player.sprite.material.duplicate()
				pose.material.set_shader_parameter("action_art", true)
				pose.material.set_shader_parameter("crouch_art", false)
				content.add_child(pose)
		await frames()
		await RenderingServer.frame_post_draw
		check(get_viewport().get_texture().get_image().save_png("res://build/actions_" + page + ".png") == OK, "Render action contact sheet " + page)
		content.queue_free()
		await frames()
	gallery.queue_free()
