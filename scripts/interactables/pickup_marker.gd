extends Node2D
## Presentation only: the parent pickup still owns availability and collection.
var is_key := false
var elapsed := 0.0
var radius := 14.0
var emphasis := 0.0

func _process(delta: float) -> void:
	elapsed += delta
	var prop := get_parent().get_parent()
	var player = get_tree().get_first_node_in_group("player")
	var selected: bool = player != null and player.target_interactable == prop
	emphasis = move_toward(emphasis, 1.0 if selected else 0.0, delta * 6.0)
	queue_redraw()

func _draw() -> void:
	# A restrained contact ellipse and glint replace the large opaque diamond badge.
	var ring := PackedVector2Array()
	for i in 33:
		var angle := TAU * float(i) / 32.0
		ring.append(Vector2(cos(angle) * radius, sin(angle) * radius * 0.32 - 2))
	draw_colored_polygon(ring, Color(0.015, 0.02, 0.018, 0.3))
	var accent := Color("#f8d476") if is_key else Color("#d3dcd1")
	accent.a = 0.12 + emphasis * 0.42
	draw_polyline(ring, accent, 1.0, true)
	accent.a = (0.4 + sin(elapsed * 2.0) * 0.2) if is_key else emphasis * 0.65
	var glint := Vector2(radius * 0.55, -radius * 1.05)
	draw_line(glint - Vector2(3, 0), glint + Vector2(3, 0), accent, 1.0, true)
	draw_line(glint - Vector2(0, 3), glint + Vector2(0, 3), accent, 1.0, true)
