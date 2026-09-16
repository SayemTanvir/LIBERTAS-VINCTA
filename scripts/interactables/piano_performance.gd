extends Node2D
## A small seated rig made from the installed Els action texture; no new artwork.
const SOURCE := preload("res://assets/sprites/player/actions/frames.json")
const NOTES := [220.0, 261.6256, 207.6523]
var seated := 0.0
var clock := 0.0
var seat := Vector2.ZERO
var strips: Array[Polygon2D] = []
var sound: AudioStreamPlayer2D
var stage := "approach"
var actor: CharacterBody2D

func perform(player: CharacterBody2D, piano: Node2D, step: int, duration: float) -> bool:
	actor = player
	var instrument: Sprite2D = piano.get_node("Visual/Sprite2D")
	# Authored stool centre in the existing 270 x 287 piano crop.
	var stool := instrument.to_global(Vector2(-76, -68))
	var staging := Vector2(stool.x, piano.global_position.y + 24.0)
	var initial_hp := FreedomLedger.hp
	player.control_enabled = false
	player.animation_hold = 0.0
	player.set_flashlight(false, false)
	var remaining := 2.0
	while player.global_position.distance_to(staging) > 1.0:
		await get_tree().physics_frame
		if get_tree().paused:
			continue
		var delta := get_physics_process_delta_time()
		remaining -= delta
		if not _safe(initial_hp) or remaining <= 0.0:
			return _finish(false)
		var offset := staging - player.global_position
		player.facing = offset.normalized()
		player.play_animation("walk")
		if player.move_and_collide(offset.limit_length(player.walk_speed * delta)) != null:
			return _finish(false)
	global_position = player.global_position
	seat = to_local(stool)
	player.velocity = Vector2.ZERO
	player.facing = Vector2.UP
	player.visual.hide()
	z_index = 3
	_build_rig()
	stage = "sit"
	if not await _pose_to(1.0, 0.45, initial_hp):
		return _finish(false)
	stage = "play"
	sound = AudioStreamPlayer2D.new()
	sound.bus = "SFX"
	sound.volume_db = -8.0
	sound.max_distance = 700.0
	sound.stream = _piano_phrase(NOTES[step % NOTES.size()], duration)
	add_child(sound)
	sound.play()
	var elapsed := 0.0
	while elapsed < duration:
		await get_tree().physics_frame
		if get_tree().paused:
			continue
		if not _safe(initial_hp):
			return _finish(false)
		elapsed += get_physics_process_delta_time()
	stage = "stand"
	if not await _pose_to(0.0, 0.4, initial_hp):
		return _finish(false)
	return _finish(true)

func _safe(hp: float) -> bool:
	return is_instance_valid(actor) and GameManager.state == GameManager.State.PLAYING and FreedomLedger.hp >= hp

func _finish(success: bool) -> bool:
	if is_instance_valid(sound):
		sound.stop()
	if is_instance_valid(actor):
		actor.visual.show()
		actor.animation_hold = 0.0
		actor.control_enabled = GameManager.state == GameManager.State.PLAYING
		if actor.control_enabled:
			actor.play_animation("idle")
	queue_free()
	return success

func _pose_to(target: float, seconds: float, hp: float) -> bool:
	var start := seated
	var elapsed := 0.0
	while elapsed < seconds:
		await get_tree().physics_frame
		if get_tree().paused:
			continue
		if not _safe(hp):
			return false
		elapsed += get_physics_process_delta_time()
		seated = lerpf(start, target, smoothstep(0.0, seconds, elapsed))
	return true

func _build_rig() -> void:
	for i in 3:
		var strip := Polygon2D.new()
		strip.texture = load(SOURCE.data.piano.texture)
		strip.material = actor.sprite.material.duplicate()
		(strip.material as ShaderMaterial).set_shader_parameter("action_art", true)
		(strip.material as ShaderMaterial).set_shader_parameter("holding_light", false)
		(strip.material as ShaderMaterial).set_shader_parameter("crouch_art", false)
		add_child(strip)
		strips.append(strip)
	_update_rig()

func _process(delta: float) -> void:
	clock += delta
	if not strips.is_empty():
		_update_rig()

func _update_rig() -> void:
	var row: Dictionary = SOURCE.data.piano.rows[2]
	var index: int = [2, 3, 4, 3][int(clock * 8.0) % 4] if stage == "play" else 1
	var frame: Dictionary = row.frames[index]
	var rect := Rect2(frame.rect[0], frame.rect[1], frame.rect[2], frame.rect[3])
	var width := rect.size.x * float(row.scale)
	var height := rect.size.y * float(row.scale)
	var cuts := [0.0, 0.70, 0.84, 1.0]
	# Head/torso stay rigid; thighs project forward and boots stay below the knees.
	var seated_y := [seat.y - height * 0.70, seat.y, seat.y + 6.0, seat.y + 28.0]
	var seated_x := [0.0, 0.0, 7.0, 7.0]
	for i in 3:
		var top := lerpf((cuts[i] - 1.0) * height, seated_y[i], seated)
		var bottom := lerpf((cuts[i + 1] - 1.0) * height, seated_y[i + 1], seated)
		var x1: float = seated_x[i] * seated
		var x2: float = seated_x[i + 1] * seated
		strips[i].polygon = PackedVector2Array([Vector2(-width/2+x1, top), Vector2(width/2+x1, top), Vector2(width/2+x2, bottom), Vector2(-width/2+x2, bottom)])
		strips[i].uv = PackedVector2Array([rect.position + Vector2(0, cuts[i]*rect.size.y), rect.position + Vector2(rect.size.x, cuts[i]*rect.size.y), rect.position + Vector2(rect.size.x, cuts[i+1]*rect.size.y), rect.position + Vector2(0, cuts[i+1]*rect.size.y)])

static func _piano_phrase(frequency: float, duration: float) -> AudioStreamWAV:
	# Damped, slightly inharmonic strings with separate hammer attacks.
	var rate := 22050
	var data := PackedByteArray()
	data.resize(int((duration + 0.5) * rate) * 2)
	for i in data.size() / 2:
		var time := float(i) / rate
		var value := 0.0
		for note in 3:
			var t := time - float(note) * duration / 3.0
			if t < 0.0:
				continue
			var hz: float = frequency * [1.0, 1.5, 1.189207][note]
			for harmonic in range(1, 7):
				value += sin(TAU * hz * harmonic * (1.0 + 0.0002 * harmonic * harmonic) * t) * exp(-t * (2.5 + harmonic * 0.65)) * minf(1.0, t * 300.0) / (harmonic * harmonic)
		var sample := int(clampf(value * 0.36, -1.0, 1.0) * 32767.0)
		data.encode_s16(i * 2, sample)
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = rate
	stream.data = data
	return stream
