extends Control
## Keeps the foyer alive without distracting from menu navigation.

@onready var background: TextureRect = $BackgroundTexture
var elapsed: float = 0.0
var drift: Vector2 = Vector2.ZERO

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_process(true)

func _process(delta: float) -> void:
	elapsed += delta
	var viewport_size := get_viewport_rect().size
	if viewport_size.x <= 0.0 or viewport_size.y <= 0.0:
		return
	var mouse_ratio := (get_viewport().get_mouse_position() / viewport_size) - Vector2(0.5, 0.5)
	var target := Vector2(-mouse_ratio.x * 5.0, -mouse_ratio.y * 3.0)
	target += Vector2(sin(elapsed * 0.11) * 1.5, cos(elapsed * 0.08) * 0.8)
	drift = drift.lerp(target, minf(delta * 2.2, 1.0))
	background.offset_left = -12.0 + drift.x
	background.offset_top = -8.0 + drift.y
	background.offset_right = 12.0 + drift.x
	background.offset_bottom = 8.0 + drift.y
