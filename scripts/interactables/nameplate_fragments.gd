extends Node2D
## Reuses the integrated metal texture for floor fragments and a brief inspection.
const METAL := preload("res://assets/ui/hud/hollowmere_metal_plate.png")
var fragments: Array[Sprite2D] = []
var overlay: CanvasLayer
var assembling := false

func _ready() -> void:
	z_index = -1
	for i in 3:
		var atlas := AtlasTexture.new()
		atlas.atlas = METAL
		atlas.region = Rect2(400 + i * 360, 190, 360, 320)
		atlas.filter_clip = true
		var piece := Sprite2D.new()
		piece.texture = atlas
		piece.scale = Vector2(24.0 / 360.0, 16.0 / 320.0)
		piece.position = Vector2((i - 1) * 27, [0, 10, -5][i])
		piece.rotation = [-0.25, 0.16, -0.12][i]
		piece.modulate = Color("bdb39c")
		add_child(piece)
		fragments.append(piece)
	# Two small chips remain as a visibly reduced, non-interactive floor remnant.
	for i in 2:
		var chip := Sprite2D.new()
		chip.texture = fragments[i].texture
		chip.position = Vector2(-19 + i * 37, 18)
		chip.scale = Vector2(0.013, 0.011)
		chip.modulate = Color("786f61")
		add_child(chip)
	set_collected(bool(FreedomLedger.flags.get("nameplate_assembled", false)))

func set_collected(collected: bool) -> void:
	for piece in fragments:
		piece.visible = not collected

func assemble(player: Node2D) -> bool:
	if assembling:
		return false
	assembling = true
	var epoch := GameManager.transition_epoch
	var serial: int = get_parent().interrupt_serial
	player.control_enabled = false
	player.velocity = Vector2.ZERO
	player.play_action("collect", 0.48)
	await get_tree().create_timer(0.48, false).timeout
	if GameManager.state != GameManager.State.PLAYING or epoch != GameManager.transition_epoch or serial != get_parent().interrupt_serial:
		player.control_enabled = GameManager.state == GameManager.State.PLAYING
		assembling = false
		return false
	GameManager.read_letter()
	GameManager.block_ui_input()
	overlay = CanvasLayer.new()
	overlay.layer = 40
	overlay.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(overlay)
	var root := Control.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_STOP
	overlay.add_child(root)
	var shade := ColorRect.new()
	shade.color = Color(0.01, 0.015, 0.02, 0.0)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shade.mouse_filter = Control.MOUSE_FILTER_STOP
	root.add_child(shade)
	var panel := Control.new()
	panel.size = Vector2(480, 220)
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(panel)
	var layout := func():
		var fit := minf(1.0, minf(root.size.x / 640.0, root.size.y / 360.0))
		panel.scale = Vector2.ONE * fit
		panel.position = (root.size - panel.size * fit) * 0.5
	root.resized.connect(layout)
	layout.call()
	var caption := Label.new()
	caption.text = "Reassembling the nameplate"
	caption.position = Vector2(0, 182)
	caption.size = Vector2(480, 30)
	caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	caption.add_theme_font_size_override("font_size", 17)
	caption.modulate = Color("c9baa0")
	panel.add_child(caption)
	var tween := overlay.create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(shade, "color:a", 0.78, 0.35)
	for i in fragments.size():
		var piece := TextureRect.new()
		piece.texture = fragments[i].texture
		piece.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		piece.size = Vector2(120, 106)
		piece.clip_contents = true
		piece.mouse_filter = Control.MOUSE_FILTER_IGNORE
		panel.add_child(piece)
		piece.position = panel.get_global_transform().affine_inverse() * fragments[i].get_global_transform_with_canvas().origin
		piece.scale = Vector2(0.2, 0.15)
		piece.rotation = fragments[i].rotation
		var lettering := Label.new()
		# Each shard exposes part of one inscription; joining restores a single word.
		lettering.text = "VANTREE"
		lettering.position = Vector2(-i * 120, 0)
		lettering.size = Vector2(360, 106)
		lettering.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lettering.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		lettering.add_theme_font_size_override("font_size", 48)
		lettering.add_theme_color_override("font_color", Color("191b19"))
		lettering.mouse_filter = Control.MOUSE_FILTER_IGNORE
		piece.add_child(lettering)
		fragments[i].hide()
		tween.tween_property(piece, "position", Vector2(60 + i * 120, 45), 0.9).set_delay(i * 0.12)
		tween.tween_property(piece, "scale", Vector2.ONE, 0.9).set_delay(i * 0.12)
		tween.tween_property(piece, "rotation", 0.0, 0.9).set_delay(i * 0.12)
	await tween.finished
	caption.text = "Vantree. My family name."
	EventBus.audio_requested.emit("astonishment")
	await get_tree().create_timer(1.1, true).timeout
	if epoch != GameManager.transition_epoch:
		overlay.queue_free()
		set_collected(false)
		assembling = false
		return false
	overlay.queue_free()
	player.animation_hold = 0.0
	player.play_animation("idle")
	player.control_enabled = true
	assembling = false
	return true
