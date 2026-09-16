extends Node2D

var radius: float = 192.0
var lifetime: float = 12.0
var tint: Color = Color(0.46, 0.11, 0.13, 0.68)
var age: float = 0.0
var silences_senses := false
var partial := false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	z_index = -2
	if silences_senses:
		add_to_group("silencing_sigil")
	queue_redraw()

func blocks(sense: String, point: Vector2) -> bool:
	return age < lifetime and global_position.distance_to(point) <= radius and (not partial or sense == "hearing")

func _process(delta: float) -> void:
	age += delta
	if age >= lifetime:
		queue_free()
	else:
		queue_redraw()

func _draw() -> void:
	var reveal := smoothstep(0.0, minf(0.35, lifetime * 0.25), age)
	var alpha := reveal * clampf((lifetime - age) / minf(1.5, lifetime * 0.4), 0.0, 1.0)
	var color := tint
	color.a *= alpha
	var visible_radius := radius * lerpf(0.88, 1.0, reveal)
	draw_circle(Vector2.ZERO, visible_radius, Color(color, color.a * 0.10))
	draw_arc(Vector2.ZERO, visible_radius, 0.0, TAU, 96, color, 2.0, true)
	var echo := Color(color, color.a * (0.25 + sin(age * 2.8) * 0.08))
	draw_arc(Vector2.ZERO, visible_radius * 0.91, age * 0.1, TAU + age * 0.1, 96, echo, 1.0, true)
	for i in 4:
		var angle := float(i) * PI * 0.5 + PI * 0.25
		draw_line(Vector2.from_angle(angle) * visible_radius * 0.18, Vector2.from_angle(angle) * visible_radius * 0.74, color, 1.5, true)
