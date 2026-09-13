extends Node
var volumes: Dictionary = {"Master": 0.8, "Music": 0.7, "Ambience": 0.8, "SFX": 0.8}
var fullscreen: bool = false
var subtitles_enabled: bool = true
var screen_shake: bool = true
var resolution: Vector2i = Vector2i(1280, 720)
const RESOLUTIONS: Array[Vector2i] = [Vector2i(1280, 720), Vector2i(1600, 900), Vector2i(1920, 1080)]

func _ready() -> void:
	for bus in volumes:
		set_volume(bus, volumes[bus])

func set_volume(bus: String, value: float) -> void:
	value = clampf(value, 0.0, 1.0)
	volumes[bus] = value
	var index := AudioServer.get_bus_index(bus)
	if index >= 0:
		AudioServer.set_bus_volume_db(index, linear_to_db(maxf(value, 0.001)))
		AudioServer.set_bus_mute(index, value <= 0.0)

func set_fullscreen(enabled: bool) -> void:
	fullscreen = enabled
	if DisplayServer.get_name() != "headless":
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if enabled else DisplayServer.WINDOW_MODE_WINDOWED)
		if not enabled:
			set_resolution(resolution)

func set_resolution(value: Vector2i) -> void:
	resolution = value
	if not fullscreen and DisplayServer.get_name() != "headless":
		DisplayServer.window_set_size(value)
		var screen := DisplayServer.window_get_current_screen()
		DisplayServer.window_set_position(DisplayServer.screen_get_position(screen) + (DisplayServer.screen_get_size(screen) - value) / 2)

func set_screen_shake(enabled: bool) -> void:
	screen_shake = enabled

func set_subtitles(enabled: bool) -> void:
	subtitles_enabled = enabled
