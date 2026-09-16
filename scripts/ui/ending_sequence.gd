extends Node2D
## Three final treatments over the existing actors/anchors; no replacement artwork.
const LINES := {"severance": "No next keeper.", "custodian_rest": "Then the door stays with me.", "vessel": "Small enough to carry. Heavy enough to pass on."}
const CARDS := {"severance": "The captive and the bond are destroyed.", "custodian_rest": "Els Vantree becomes the living ward.", "vessel": "The prison waits in another key."}
var ending := ""
var elapsed := 0.0
var center := Vector2.ZERO
var player: Node2D
var hound: Node2D
var anchor: Node2D
var key: Sprite2D
var picked_up := false
var fragments: Array[Sprite2D] = []

func play(kind: String, hud: CanvasLayer) -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	z_index = 80
	ending = kind
	player = get_tree().get_first_node_in_group("player")
	hound = get_tree().get_first_node_in_group("enemy")
	# Node names may retain hyphens; use the stable gameplay IDs as authority.
	for prop in get_tree().get_nodes_in_group("interactable"):
		if prop.interaction_id == {"severance": "LN-A", "custodian_rest": "LN-B", "vessel": "LN-C"}[kind]:
			anchor = prop
	center = anchor.global_position if kind == "severance" and is_instance_valid(anchor) else player.global_position
	player.control_enabled = false
	player.velocity = Vector2.ZERO
	player.process_mode = Node.PROCESS_MODE_ALWAYS
	player.get_node("Camera2D").cinematic_focus(center, 5.0)
	if kind == "severance" and is_instance_valid(anchor):
		var source: Sprite2D = anchor.get_node("Visual/Sprite2D")
		for i in 4:
			var shard := Sprite2D.new()
			var texture := AtlasTexture.new()
			texture.atlas = source.texture
			texture.region = Rect2(i * source.texture.get_width() / 4.0, 0, source.texture.get_width() / 4.0, source.texture.get_height())
			shard.texture = texture
			shard.position = center + Vector2((i - 1.5) * 23, -50)
			shard.scale = Vector2.ONE * 0.25
			add_child(shard)
			fragments.append(shard)
		anchor.get_node("Visual").hide()
	elif kind == "custodian_rest":
		player.play_action("channel", 3.2)
	elif kind == "vessel":
		key = Sprite2D.new()
		key.texture = preload("res://scripts/levels/estate_art.gd").new().texture_for("key")
		key.scale = Vector2.ONE * (24.0 / key.texture.get_width())
		key.position = center + Vector2(0, -12)
		key.modulate.a = 0.0
		add_child(key)
	hud._present_message("ELS", LINES[kind])
	hud.subtitle_time = 8.0
	EventBus.audio_requested.emit("stinger")
	await get_tree().create_timer(4.4, true).timeout
	player.process_mode = Node.PROCESS_MODE_INHERIT
	player.animation_hold = 0.0
	player.play_animation("idle")
	hud.active_message.dismiss()
	queue_free()

func _process(delta: float) -> void:
	if ending.is_empty():
		return
	elapsed += delta
	var progress := smoothstep(0.3, 2.8, elapsed)
	if ending == "severance":
		for i in fragments.size():
			fragments[i].position = center + Vector2((i - 1.5) * 23 * (1.0 - progress), -50 + progress * 42)
			fragments[i].rotation = (i - 1.5) * progress * 0.7
			fragments[i].modulate.a = 1.0 - progress
		if is_instance_valid(hound):
			hound.modulate.a = 1.0 - progress
	elif ending == "vessel":
		key.modulate.a = progress if not picked_up else 1.0 - smoothstep(2.7, 3.4, elapsed)
		if elapsed >= 2.7 and not picked_up:
			picked_up = true
			player.play_action("key_pickup", 0.72)
		if picked_up:
			key.position.y = center.y - 12 - smoothstep(2.7, 3.4, elapsed) * 40
		if is_instance_valid(hound):
			hound.modulate.a = 1.0 - progress
	queue_redraw()

func _draw() -> void:
	if ending.is_empty():
		return
	var progress := smoothstep(0.3, 2.8, elapsed)
	var tint := Color("b8d4c7") if ending == "custodian_rest" else Color("aa8d72")
	if ending == "severance":
		tint.a = 1.0 - progress
		for i in 9:
			var direction := Vector2.from_angle(i * TAU / 9)
			draw_line(center + direction * 30, center + direction * 200 * (1.0 - progress), tint, 2.0, true)
	elif ending == "custodian_rest":
		tint.a = progress * (1.0 - smoothstep(3.9, 4.4, elapsed))
		_draw_ward_ellipse(center + Vector2(0, -40), Vector2(43, 74), tint)
		for i in 5:
			draw_line(center + Vector2(-95, -i * 25), center + Vector2(95, -i * 25), Color(tint, tint.a * 0.3), 1.0)
	else:
		tint.a = 1.0 - progress
		for i in 12:
			var direction := Vector2.from_angle(i * TAU / 12)
			draw_line(center + direction * 230 * (1.0 - progress), center + Vector2(0, -12), tint, 1.5, true)

func _draw_ward_ellipse(at: Vector2, radius: Vector2, tint: Color) -> void:
	var points := PackedVector2Array()
	for i in 65:
		points.append(at + Vector2(cos(i * TAU / 64), sin(i * TAU / 64)) * radius)
	draw_polyline(points, tint, 2.5, true)
