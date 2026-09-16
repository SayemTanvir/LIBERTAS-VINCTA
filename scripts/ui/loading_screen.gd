extends Control
## Timed presentation, followed by normal scene loading behind an opaque curtain.
@export_file("*.tscn") var target_scene: String = "res://scenes/main/main.tscn"
@export_range(0.5, 15.0) var display_seconds: float = 5.0
@export var ambience: AudioStream
var failed: bool = false
var presentation: Control
var loading_clock: float = 0.0
var indicator: Control
@onready var curtain: ColorRect = $Curtain
@onready var message: Control = $MessageBubble

func _ready() -> void:
	theme = preload("res://scripts/ui/menu_typography.gd").menu_theme()
	preload("res://scripts/ui/menu_typography.gd").enlarge_body.call_deferred(self)
	process_mode = Node.PROCESS_MODE_ALWAYS
	_build_presentation()
	message.show_text("", "Entering Hollowmere...")
	# Only this loading-screen instance; shared gameplay bubbles keep their fonts.
	message.text_label.add_theme_font_override("normal_font", preload("res://scripts/ui/menu_typography.gd").BODY)
	if DisplayServer.get_name() == "headless":
		_enter_game.call_deferred()
		return
	if ambience != null:
		$Ambience.stream = ambience
		$Ambience.play()
	# Begin the five-second presentation after the screen has had a frame to draw.
	await RenderingServer.frame_post_draw
	await get_tree().create_timer(maxf(display_seconds - 0.32, 0.0), true, false, true).timeout
	var tween := create_tween().set_parallel(true)
	tween.tween_property(curtain, "color:a", 1.0, 0.32)
	tween.tween_property($Ambience, "volume_db", -60.0, 0.32)
	await tween.finished
	# Submit opaque black before synchronous resource preparation/instantiation.
	await RenderingServer.frame_post_draw
	_enter_game.call_deferred()

func _build_presentation() -> void:
	var style := preload("res://scripts/ui/ui_style.gd")
	presentation = Control.new()
	presentation.size = Vector2(1280, 720)
	presentation.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(presentation)
	move_child(presentation, get_child_count() - 2)
	var brand := style.label(presentation, "LIBERTAS VINCTA", Rect2(140, 240, 1000, 66), 42, style.PAPER, true)
	brand.add_theme_font_override("font", preload("res://scripts/ui/menu_typography.gd").TITLE)
	brand.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var chapter := style.label(presentation, "PART II  /  DEGREES OF FREEDOM" if FreedomLedger.current_part == 2 else "PART I  /  HOLLOWMERE ESTATE", Rect2(140, 328, 1000, 32), 12, style.BRASS)
	chapter.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	style.rule(presentation, Rect2(440, 385, 400, 1))
	indicator = Control.new()
	indicator.position = Vector2(640, 428)
	indicator.mouse_filter = Control.MOUSE_FILTER_IGNORE
	presentation.add_child(indicator)
	indicator.draw.connect(func():
		var glow := 0.55 + sin(loading_clock * 2.0) * 0.25
		indicator.draw_polyline(PackedVector2Array([Vector2(0, -10), Vector2(6, 0), Vector2(0, 10), Vector2(-6, 0), Vector2(0, -10)]), Color(style.BRASS, glow), 1.5, true)
		indicator.draw_circle(Vector2.ZERO, 2.0, style.PAPER, true, -1, true))
	resized.connect(_layout_presentation)
	_layout_presentation()

func _layout_presentation() -> void:
	var factor := minf(size.x / 1280.0, size.y / 720.0)
	presentation.scale = Vector2.ONE * factor
	presentation.position = (size - presentation.size * factor) * 0.5

func _process(delta: float) -> void:
	loading_clock += delta
	if indicator != null:
		indicator.queue_redraw()

func _enter_game() -> void:
	# Avoid the threaded dependency wait that left this screen stuck.
	var scene := ResourceLoader.load(target_scene, "PackedScene") as PackedScene
	if scene == null or not scene.can_instantiate():
		_fail("Could not load an instantiable scene: " + target_scene)
		return
	var error := get_tree().change_scene_to_packed(scene)
	if error != OK:
		_fail("Could not enter %s (error %s)." % [target_scene, error])

func _fail(reason: String) -> void:
	push_error("LoadingScreen: " + reason)
	failed = true
	curtain.color.a = 0.0
	message.show_text("", "Hollowmere could not be opened.\nPress Enter or Escape to return home.")

func _unhandled_input(event: InputEvent) -> void:
	get_viewport().set_input_as_handled()
	if failed and (event.is_action_pressed("ui_cancel") or event.is_action_pressed("ui_accept") or event.is_action_pressed("pause")):
		GameManager.go_home()
