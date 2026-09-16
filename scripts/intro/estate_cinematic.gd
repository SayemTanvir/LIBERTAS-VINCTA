extends Control
## Authored, pause-safe prologue. Source sheets remain untouched; no atlas labels render.
signal finished

const DURATION := 22.4
const INTRO_FONT := preload("res://assets/fonts/horroroid/horroroid.ttf")
const HOUSE := preload("res://assets/BG/11_intro/05_house_hd.png")
const BATS := preload("res://assets/BG/11_intro/02_bat_flight.png")
const LIGHTNING := preload("res://assets/BG/11_intro/03_lightning.png")
const STORM := preload("res://assets/BG/11_intro/04_storm_rain_mist.png")
const THUNDER := preload("res://assets/audio/others/distantsounds/thunder1.wav")
const WIND := preload("res://assets/audio/others/distantsounds/wind1.wav")
const STING := preload("res://assets/audio/stinger/stinger2.wav")
# Nonuniform wing silhouettes: polygons isolate neighboring wings without recutting art.
const BAT_OUTLINES := [
	[Vector2(6, 105), Vector2(290, 105), Vector2(293, 360), Vector2(245, 535), Vector2(64, 535), Vector2(6, 355)],
	[Vector2(293, 207), Vector2(635, 207), Vector2(580, 365), Vector2(559, 542), Vector2(390, 542), Vector2(335, 362)],
	[Vector2(633, 343), Vector2(979, 340), Vector2(912, 450), Vector2(877, 545), Vector2(690, 545), Vector2(584, 418), Vector2(580, 377)],
	[Vector2(906, 449), Vector2(989, 376), Vector2(1165, 376), Vector2(1253, 453), Vector2(1253, 564), Vector2(906, 564)],
	[Vector2(22, 921), Vector2(103, 881), Vector2(225, 881), Vector2(307, 960), Vector2(299, 1180), Vector2(22, 1180)],
	[Vector2(294, 805), Vector2(570, 798), Vector2(644, 897), Vector2(644, 993), Vector2(567, 1032), Vector2(359, 1032), Vector2(294, 985)],
	[Vector2(626, 657), Vector2(900, 657), Vector2(939, 919), Vector2(859, 1040), Vector2(704, 1040), Vector2(650, 915)],
	[Vector2(942, 656), Vector2(1238, 656), Vector2(1253, 913), Vector2(1170, 1040), Vector2(1028, 1040), Vector2(942, 912)],
]
const BAT_ANCHORS := [Vector2(164, 456), Vector2(474, 456), Vector2(774, 456), Vector2(1093, 456), Vector2(165, 952), Vector2(474, 952), Vector2(782, 952), Vector2(1100, 952)]

var elapsed := 0.0
var skip_elapsed := -1.0
var completed := false
var stage: Control
var landscape: ColorRect
var effect: ShaderMaterial
var skip_button: Button
var veil: ColorRect
var captions: Array[Dictionary] = []
var audio: Array[AudioStreamPlayer] = []
var thunder_count := 0
var title_sounded := false
var serif: Font
var bat_vertices: Array[PackedVector2Array] = []
var bat_uvs: Array[PackedVector2Array] = []

func _ready() -> void:
	theme = preload("res://scripts/ui/menu_typography.gd").menu_theme()
	preload("res://scripts/ui/menu_typography.gd").enlarge_body.call_deferred(self)
	name = "EstateCinematic"
	process_mode = Node.PROCESS_MODE_PAUSABLE
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_to_group("estate_cinematic")
	texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	var background := ColorRect.new()
	background.color = Color.BLACK
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)
	stage = Control.new()
	stage.size = Vector2(1280, 720)
	stage.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stage.clip_contents = true
	add_child(stage)
	landscape = ColorRect.new()
	landscape.size = stage.size
	landscape.mouse_filter = Control.MOUSE_FILTER_IGNORE
	effect = ShaderMaterial.new()
	effect.shader = preload("res://shaders/intro_estate.gdshader")
	effect.set_shader_parameter("house_background", HOUSE)
	effect.set_shader_parameter("storm_sheet", STORM)
	effect.set_shader_parameter("lightning_sheet", LIGHTNING)
	landscape.material = effect
	stage.add_child(landscape)
	var flock := Control.new()
	flock.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stage.add_child(flock)
	flock.draw.connect(_draw_flock.bind(flock))
	for i in BAT_OUTLINES.size():
		var vertices := PackedVector2Array()
		var uvs := PackedVector2Array()
		for point: Vector2 in BAT_OUTLINES[i]:
			vertices.append(point - BAT_ANCHORS[i])
			uvs.append(point / BATS.get_size())
		bat_vertices.append(vertices)
		bat_uvs.append(uvs)
	for bounds: Rect2 in [Rect2(0, 0, 1280, 46), Rect2(0, 646, 1280, 74)]:
		var bar := ColorRect.new()
		bar.position = bounds.position
		bar.size = bounds.size
		bar.color = Color("05080b")
		bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
		stage.add_child(bar)
	serif = preload("res://scripts/ui/menu_typography.gd").BODY
	_caption("H O L L O W M E R E   E S T A T E", Vector2(78, 203), 17, 1.3, 8.4, true)
	_caption("An offer too generous.\nA signature too easy.", Vector2(74, 248), 35, 2.5, 8.4)
	_caption("Six hours are missing.", Vector2(78, 374), 20, 5.6, 9.1)
	_caption("D E G R E E S   O F   F R E E D O M", Vector2(78, 203), 16, 10.0, 20.5, true)
	_caption("LIBERTAS\nVINCTA", Vector2(72, 237), 67, 10.4, 20.5)
	_caption("Every freedom has a price.", Vector2(78, 435), 22, 12.2, 20.5)
	_caption("HOLLOWMERE  /  AFTER DARK", Vector2(78, 15), 12, 1.5, 20.5, true)
	_caption("A house that remembers.", Vector2(78, 671), 14, 3.0, 20.5)
	skip_button = Button.new()
	skip_button.text = "Skip  [Enter]"
	skip_button.position = Vector2(1076, 666)
	skip_button.size = Vector2(132, 32)
	skip_button.add_theme_font_size_override("font_size", 15)
	skip_button.add_theme_color_override("font_color", Color("b8b4a9"))
	skip_button.pressed.connect(request_skip)
	stage.add_child(skip_button)
	veil = ColorRect.new()
	veil.size = stage.size
	veil.color = Color.BLACK
	veil.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stage.add_child(veil)
	_make_audio(WIND, "Ambience", -16.0, true)
	_make_audio(THUNDER, "SFX", -12.0)
	_make_audio(STING, "Music", -19.0)
	audio[0].play()
	resized.connect(_layout)
	_layout()
	_update_presentation()

func _caption(text: String, at: Vector2, font_size: int, start: float, end: float, brass := false) -> void:
	var label := Label.new()
	label.text = text
	label.position = at
	label.size = Vector2(565, 195 if font_size > 50 else 108)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_font_override("font", INTRO_FONT if font_size > 50 else serif)
	if font_size > 50:
		label.name = "HorroroidTitle"
		while font_size > 40 and INTRO_FONT.get_string_size("LIBERTAS", HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x > 565:
			font_size -= 1
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", Color("ba9e68") if brass else Color("e2ded2"))
	label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.65))
	label.add_theme_constant_override("shadow_offset_y", 2)
	stage.add_child(label)
	captions.append({"node": label, "start": start, "end": end, "y": at.y})

func _make_audio(stream: AudioStream, bus: String, volume: float, loop := false) -> void:
	var player := AudioStreamPlayer.new()
	player.stream = stream
	player.bus = bus
	player.volume_db = volume
	player.set_meta("base_volume", volume)
	add_child(player)
	if loop:
		player.finished.connect(player.play)
	audio.append(player)

func _layout() -> void:
	if stage == null:
		return
	var fit := minf(size.x / 1280.0, size.y / 720.0)
	stage.scale = Vector2.ONE * fit
	stage.position = (size - stage.size * fit) * 0.5

func _process(delta: float) -> void:
	if completed:
		return
	elapsed += delta
	if skip_elapsed >= 0.0:
		skip_elapsed += delta
	_update_presentation()
	if skip_elapsed < 0.0:
		if (thunder_count == 0 and elapsed >= 5.65) or (thunder_count == 1 and elapsed >= 15.55):
			audio[1].pitch_scale = 0.92 if thunder_count == 0 else 0.8
			audio[1].play()
			thunder_count += 1
		if not title_sounded and elapsed >= 10.4:
			audio[2].play()
			title_sounded = true
	if elapsed >= DURATION or skip_elapsed >= 0.65:
		completed = true
		for player in audio:
			player.stop()
		GameManager.block_ui_input()
		finished.emit()

func _update_presentation() -> void:
	effect.set_shader_parameter("elapsed", elapsed)
	effect.set_shader_parameter("approach", smoothstep(0.0, DURATION, elapsed))
	var lightning := _strike(5.3) + _strike(15.2)
	effect.set_shader_parameter("strike", lightning)
	for caption in captions:
		var alpha := _envelope(caption.start, caption.end)
		caption.node.modulate.a = alpha
		caption.node.position.y = caption.y + (1.0 - smoothstep(caption.start, caption.start + 1.4, elapsed)) * 8.0
	var blackout := maxf(1.0 - smoothstep(0.0, 1.7, elapsed), smoothstep(20.7, DURATION, elapsed))
	if skip_elapsed >= 0.0:
		blackout = maxf(blackout, smoothstep(0.0, 0.65, skip_elapsed))
	veil.color.a = blackout
	skip_button.modulate.a = smoothstep(0.6, 1.7, elapsed)
	skip_button.disabled = elapsed < 0.6 or skip_elapsed >= 0.0
	for player in audio:
		player.volume_db = float(player.get_meta("base_volume")) + linear_to_db(maxf(0.001, 1.0 - blackout))
	stage.get_child(1).queue_redraw()

func _strike(at: float) -> float:
	var t := elapsed - at
	return sin(clampf(t / 0.65, 0.0, 1.0) * PI) * 0.65 if t >= 0.0 and t < 0.65 else 0.0

func _envelope(start: float, end: float) -> float:
	return smoothstep(start, start + 1.3, elapsed) * (1.0 - smoothstep(end - 0.8, end, elapsed))

func _draw_flock(canvas: Control) -> void:
	# Two crossings at different depths, with independent wing phases and body anchors.
	for i in 7:
		var start := 3.4 + i * 0.34 if i < 4 else 13.0 + (i - 4) * 0.38
		var travel := (elapsed - start) / (5.4 if i < 4 else 4.0)
		if travel < 0.0 or travel > 1.0:
			continue
		var point := Vector2(lerpf(1350.0, 400.0, travel), 145.0 + i * 19.0 + sin(travel * TAU + i) * 24.0)
		var scale_factor := (0.075 + i * 0.012) * (0.65 + travel * 0.4)
		var frame := floori(elapsed * 10.0 + i * 1.7) % 8
		canvas.draw_set_transform(point, -0.12, Vector2.ONE * scale_factor)
		var alpha := smoothstep(0.0, 0.1, travel) * (1.0 - smoothstep(0.72, 1.0, travel))
		canvas.draw_polygon(bat_vertices[frame], PackedColorArray([Color(0.56, 0.61, 0.67, alpha)]), bat_uvs[frame], BATS)
	canvas.draw_set_transform(Vector2.ZERO)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and not event.is_echo():
		request_skip()
		get_viewport().set_input_as_handled()

func request_skip() -> void:
	if completed or get_tree().paused or elapsed < 0.6 or skip_elapsed >= 0.0:
		return
	skip_elapsed = 0.0
	GameManager.block_ui_input()
