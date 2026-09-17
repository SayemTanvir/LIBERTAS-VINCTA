extends Node2D
## Bottle shattered at the player's feet upon pressing Q as a distraction.
## Breaks immediately in-place, spawns shattered glass remains, and emits a GLASS noise event (576 radius).
## The Hound AI tracks the distraction to this exact location and investigates for 5 seconds.

var throw_direction: Vector2 = Vector2.RIGHT
var _lifetime: float = 5.0
var _elapsed: float = 0.0

func _ready() -> void:
	add_to_group("distraction_object")
	_build_shatter_visuals()
	EventBus.noise_created.emit(global_position, 576.0, "GLASS")
	EventBus.audio_requested.emit("glass_break")

func _build_shatter_visuals() -> void:
	# Floor contact shadow
	var shadow := Polygon2D.new()
	shadow.color = Color(0.02, 0.025, 0.02, 0.35)
	var shadow_points := PackedVector2Array()
	for i in 16:
		var angle := TAU * float(i) / 16.0
		shadow_points.append(Vector2(cos(angle) * 16.0, sin(angle) * 6.0))
	shadow.polygon = shadow_points
	add_child(shadow)

	# Broken bottle base / neck shard
	var base_shard := Polygon2D.new()
	base_shard.polygon = PackedVector2Array([
		Vector2(-6, 2), Vector2(-1, -4), Vector2(4, -2), Vector2(2, 4), Vector2(-4, 5)
	])
	base_shard.color = Color("3f6e4a")
	add_child(base_shard)

	var neck_shard := Polygon2D.new()
	neck_shard.polygon = PackedVector2Array([
		Vector2(2, -8), Vector2(7, -6), Vector2(5, -2), Vector2(1, -4)
	])
	neck_shard.color = Color("5c946e")
	add_child(neck_shard)

	# Scattered glass fragments
	var shard_coords := [
		[Vector2(-12, -3), Vector2(-9, -6), Vector2(-8, -2)],
		[Vector2(-7, 7), Vector2(-3, 9), Vector2(-5, 5)],
		[Vector2(8, 3), Vector2(13, 1), Vector2(10, 6)],
		[Vector2(5, -7), Vector2(9, -10), Vector2(8, -5)],
		[Vector2(-4, -8), Vector2(-1, -11), Vector2(1, -7)],
		[Vector2(11, -3), Vector2(15, -4), Vector2(13, 0)],
		[Vector2(-11, 4), Vector2(-14, 2), Vector2(-9, 1)]
	]
	for coords in shard_coords:
		var shard := Polygon2D.new()
		shard.polygon = PackedVector2Array(coords)
		shard.color = Color(0.40, 0.68, 0.48, 0.85)
		add_child(shard)

	# Glint highlights
	var glint := Line2D.new()
	glint.width = 1.0
	glint.default_color = Color(0.85, 0.95, 0.88, 0.75)
	glint.add_point(Vector2(-3, -2))
	glint.add_point(Vector2(1, 1))
	add_child(glint)

func _process(delta: float) -> void:
	_elapsed += delta
	if _elapsed > _lifetime - 2.0:
		modulate.a = maxf(0.0, (_lifetime - _elapsed) / 2.0)
	if _elapsed >= _lifetime:
		queue_free()
