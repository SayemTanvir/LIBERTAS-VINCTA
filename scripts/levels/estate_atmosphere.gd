extends Node2D
## Presentation lighting. Never changes noise, exposure, AI, or story flags.
const AMBIENT := {
	"intro": Color(0.48, 0.54, 0.65), "ground": Color(0.46, 0.51, 0.61),
	"upper": Color(0.44, 0.48, 0.62), "basement": Color(0.38, 0.47, 0.52),
	"roots": Color(0.37, 0.47, 0.50), "echoes": Color(0.40, 0.45, 0.53),
	"nexus": Color(0.43, 0.46, 0.57)
}
var ambient: CanvasModulate
var sources: Array[Dictionary] = []
var elapsed: float = 0.0
var disturbance: float = 0.0
var threat: float = 0.0
var light_texture: GradientTexture2D

static func soft_light_texture() -> GradientTexture2D:
	var gradient := Gradient.new()
	gradient.offsets = PackedFloat32Array([0.0, 0.16, 0.42, 0.72, 1.0])
	gradient.colors = PackedColorArray([Color.WHITE, Color(0.88, 0.88, 0.88, 1), Color(0.42, 0.42, 0.42, 1), Color(0.09, 0.09, 0.09, 1), Color.BLACK])
	var texture := GradientTexture2D.new()
	texture.gradient = gradient
	texture.width = 256
	texture.height = 256
	texture.fill = GradientTexture2D.FILL_RADIAL
	texture.fill_from = Vector2(0.5, 0.5)
	texture.fill_to = Vector2(1, 0.5)
	return texture

func configure(room: Node2D) -> void:
	name = "EstateAtmosphere"
	add_to_group("estate_atmosphere")
	ambient = CanvasModulate.new()
	ambient.name = "NightAmbient"
	ambient.color = AMBIENT.get(room.zone_id, AMBIENT.ground)
	add_child(ambient)
	light_texture = soft_light_texture()
	for node in room.find_children("*", "Sprite2D", true, false):
		var asset: String = node.get_meta("estate_asset", "")
		if asset in ["candle", "window", "string_lights", "sigil_forge", "nexus_anchor", "blood_altar"]:
			_add_source(node, asset)
	for group in [room.props, room.geometry]:
		for body in group.get_children():
			if body is StaticBody2D and (group == room.props or "Footprint" in body.name or str(body.name).begins_with("WallFurniture")):
				_add_occluder(body)
	EventBus.sense_restored.connect(_sense_restored)
	EventBus.tension_changed.connect(_tension_changed)
	_update_lights(0.0)

func _add_source(sprite: Sprite2D, kind: String) -> void:
	var specs := {
		"candle": [210.0, 0.80, Color("e9b478"), 0.82],
		"window": [270.0, 0.42, Color("799bbd"), 0.45],
		"string_lights": [235.0, 0.65, Color("dfb77e"), 0.4],
		"sigil_forge": [220.0, 0.70, Color("b87c78"), 0.55],
		"nexus_anchor": [250.0, 0.65, Color("71babd"), 0.62],
		"blood_altar": [180.0, 0.46, Color("b87573"), 0.55]
	}
	var spec: Array = specs[kind]
	var light := PointLight2D.new()
	light.name = kind.to_pascal_case() + "Light"
	light.texture = light_texture
	light.texture_scale = float(spec[0]) / 128.0
	light.color = spec[2]
	light.range_layer_min = 0
	light.range_layer_max = 0
	light.scale.y = 0.85
	add_child(light)
	var glow: Sprite2D
	if kind != "window":
		glow = Sprite2D.new()
		glow.name = "LightHalo"
		glow.texture = light_texture
		glow.scale = Vector2.ONE * (0.27 if kind == "candle" else 0.45)
		glow.z_index = 3
		var glow_material := CanvasItemMaterial.new()
		glow_material.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
		glow_material.light_mode = CanvasItemMaterial.LIGHT_MODE_UNSHADED
		glow.material = glow_material
		add_child(glow)
	var point := Vector2(0, -sprite.texture.get_height() * float(spec[3]))
	var phase := fposmod(sprite.global_position.x * 0.017 + sprite.global_position.y * 0.029, TAU)
	sources.append({"sprite": sprite, "light": light, "glow": glow, "kind": kind,
		"point": point, "phase": phase, "base": float(spec[1]), "radius": float(spec[0]),
		"level": 1.0, "tint": sprite.self_modulate})

func _add_occluder(body: StaticBody2D) -> void:
	var collision: CollisionShape2D = body.get_node_or_null("CollisionShape2D")
	if collision == null or not collision.shape is RectangleShape2D:
		return
	var half: Vector2 = collision.shape.size * 0.5
	var polygon := OccluderPolygon2D.new()
	polygon.polygon = PackedVector2Array([Vector2(-half.x, -half.y), Vector2(half.x, -half.y), half, Vector2(-half.x, half.y)])
	var occluder := LightOccluder2D.new()
	occluder.name = "FlashlightOccluder"
	occluder.occluder = polygon
	occluder.position = collision.position
	occluder.occluder_light_mask = 2
	body.add_child(occluder)

func _sense_restored(_sense: String) -> void:
	disturbance = 1.0

func _tension_changed(state: String) -> void:
	threat = 1.0 if state == "CHASE" else (0.4 if state == "SEARCHING" else 0.0)

func _process(delta: float) -> void:
	elapsed += delta
	disturbance = move_toward(disturbance, 0.0, delta * 0.45)
	_update_lights(delta)

func _update_lights(delta: float) -> void:
	var camera := get_viewport().get_camera_2d()
	var center_x := camera.get_screen_center_position().x if camera != null else 0.0
	var view_half := get_viewport_rect().size.x / (2.0 * camera.zoom.x) if camera != null else 1280.0
	for source in sources:
		var sprite: Sprite2D = source.sprite
		var light: PointLight2D = source.light
		light.global_position = sprite.to_global(source.point)
		var nearby := absf(light.global_position.x - center_x) < view_half + float(source.radius)
		light.enabled = nearby and sprite.is_visible_in_tree()
		var glow: Sprite2D = source.glow
		if glow != null:
			glow.visible = light.enabled
			glow.global_position = light.global_position
		if not light.enabled:
			continue
		var phase: float = source.phase
		var flutter := sin(elapsed * 2.7 + phase) * 0.07 + sin(elapsed * 6.1 + phase * 1.9) * 0.045
		var level := 0.91 + flutter
		if source.kind == "window":
			level = 0.94 + sin(elapsed * 0.23 + phase) * 0.06
		elif source.kind == "string_lights":
			# A local, eased brownout every few seconds; lamps do not blink in unison.
			var cycle := fposmod(elapsed + phase * 2.0, 5.8)
			var dip := smoothstep(0.0, 0.22, cycle) * (1.0 - smoothstep(0.68, 1.12, cycle))
			level *= 1.0 - dip * 0.88
		elif source.kind in ["nexus_anchor", "sigil_forge", "blood_altar"]:
			level = 0.85 + sin(elapsed * 1.3 + phase) * 0.13
		if source.kind != "window":
			level *= 1.0 - disturbance * 0.42 - threat * 0.10
		source.level = lerpf(float(source.level), clampf(level, 0.08, 1.08), 1.0 - exp(-8.0 * delta))
		light.energy = float(source.base) * float(source.level)
		if glow != null:
			glow.modulate = Color(light.color, float(source.level) * 0.16)
		if source.kind != "window":
			var tone := 0.55 + float(source.level) * 0.45
			sprite.self_modulate = source.tint * Color(tone, tone, tone, 1.0)
