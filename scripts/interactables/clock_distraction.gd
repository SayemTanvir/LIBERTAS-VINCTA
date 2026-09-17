extends Node2D
## Clock dropped at the player's feet as a distraction.
## Uses the clock asset texture from survival_pickups.png.
## Hound AI tracks to this location and stays for 5 seconds upon arrival.

var _lifetime: float = 5.0
var _elapsed: float = 0.0
var _hand: Line2D
var _countdown_player: AudioStreamPlayer2D

func _ready() -> void:
	add_to_group("distraction_object")
	_build_visuals()
	_play_countdown_sound()

func _build_visuals() -> void:
	# Contact shadow
	var shadow := Polygon2D.new()
	shadow.color = Color(0.02, 0.025, 0.02, 0.35)
	var shadow_points := PackedVector2Array()
	for i in 16:
		var angle := TAU * float(i) / 16.0
		shadow_points.append(Vector2(cos(angle) * 13.0, sin(angle) * 4.5))
	shadow.polygon = shadow_points
	add_child(shadow)

	# Clock sprite from game assets
	var art := preload("res://scripts/levels/estate_art.gd").new()
	var clock_tex: Texture2D = art.texture_for("clock_pickup")

	var sprite := Sprite2D.new()
	sprite.name = "ClockSprite"
	sprite.texture = clock_tex
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	var display_width := 24.0
	if clock_tex != null and clock_tex.get_width() > 0:
		sprite.scale = Vector2.ONE * (display_width / float(clock_tex.get_width()))
	sprite.position = Vector2(0, -3)
	add_child(sprite)

	# Ticking hand
	_hand = Line2D.new()
	_hand.width = 1.2
	_hand.default_color = Color("f5d77f")
	_hand.add_point(Vector2.ZERO)
	_hand.add_point(Vector2(0, -5))
	_hand.position = Vector2(0, -3)
	add_child(_hand)

func _play_countdown_sound() -> void:
	var countdown_stream := preload("res://assets/audio/others/clock/countdown.wav")
	if countdown_stream == null:
		return
	_countdown_player = AudioStreamPlayer2D.new()
	_countdown_player.stream = countdown_stream
	_countdown_player.position = Vector2.ZERO
	_countdown_player.autoplay = true
	_countdown_player.volume_db = 0.0
	add_child(_countdown_player)
	_countdown_player.play()

func _process(delta: float) -> void:
	_elapsed += delta
	if is_instance_valid(_hand):
		_hand.rotation += delta * 12.0
	if _elapsed > _lifetime - 1.0:
		modulate.a = maxf(0.0, (_lifetime - _elapsed) / 1.0)
	if _elapsed >= _lifetime:
		queue_free()
