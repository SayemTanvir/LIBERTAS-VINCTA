extends Node
## One preference authority, independent of run/checkpoint state.
signal settings_changed
signal save_failed(error: Error)
const SETTINGS_PATH := "user://settings.cfg"
const DEFAULT_VOLUMES := {"Master": 0.8, "Music": 0.7, "Ambience": 0.8, "SFX": 0.8}
var settings_path := SETTINGS_PATH
var last_save_error: Error = OK
var volumes: Dictionary = {"Master": 0.8, "Music": 0.7, "Ambience": 0.8, "SFX": 0.8}
var fullscreen: bool = false
var subtitles_enabled: bool = true
var screen_shake: bool = true
var resolution: Vector2i = Vector2i(1280, 720)
const RESOLUTIONS: Array[Vector2i] = [Vector2i(1280, 720), Vector2i(1366, 768), Vector2i(1600, 900), Vector2i(1920, 1080)]

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	load_settings()
	apply_settings()

func load_settings() -> void:
	var config := ConfigFile.new()
	# A malformed file is never partially trusted; missing keys use per-key defaults.
	if config.load(settings_path) != OK:
		config.clear()
	volumes = DEFAULT_VOLUMES.duplicate()
	for bus in DEFAULT_VOLUMES:
		var value: Variant = config.get_value("audio", bus, DEFAULT_VOLUMES[bus])
		if (value is float or value is int) and is_finite(float(value)):
			volumes[bus] = clampf(float(value), 0.0, 1.0)
	fullscreen = _read_bool(config, "display", "fullscreen", false)
	screen_shake = _read_bool(config, "accessibility", "screen_shake", true)
	subtitles_enabled = _read_bool(config, "accessibility", "subtitles", true)
	var saved_resolution: Variant = config.get_value("display", "resolution", RESOLUTIONS[0])
	resolution = saved_resolution if saved_resolution is Vector2i and saved_resolution in RESOLUTIONS else RESOLUTIONS[0]

func _read_bool(config: ConfigFile, section: String, key: String, fallback: bool) -> bool:
	var value: Variant = config.get_value(section, key, fallback)
	return value if value is bool else fallback

func apply_settings() -> void:
	for bus in volumes:
		_apply_volume(bus)
	_apply_display()
	settings_changed.emit()

func save_settings() -> Error:
	var config := ConfigFile.new()
	for bus in DEFAULT_VOLUMES:
		config.set_value("audio", bus, volumes[bus])
	config.set_value("display", "resolution", resolution)
	config.set_value("display", "fullscreen", fullscreen)
	config.set_value("accessibility", "screen_shake", screen_shake)
	config.set_value("accessibility", "subtitles", subtitles_enabled)
	last_save_error = config.save(settings_path)
	if last_save_error != OK:
		save_failed.emit(last_save_error)
		push_warning("Settings could not be saved (error %d)." % last_save_error)
	settings_changed.emit()
	return last_save_error

func set_volume(bus: String, value: float) -> void:
	if not DEFAULT_VOLUMES.has(bus) or not is_finite(value):
		return
	value = clampf(value, 0.0, 1.0)
	volumes[bus] = value
	_apply_volume(bus)
	save_settings()

func _apply_volume(bus: String) -> void:
	var value: float = volumes[bus]
	var index := AudioServer.get_bus_index(bus)
	if index >= 0:
		AudioServer.set_bus_volume_db(index, linear_to_db(maxf(value, 0.001)))
		AudioServer.set_bus_mute(index, value <= 0.0)

func set_fullscreen(enabled: bool) -> void:
	fullscreen = enabled
	_apply_display()
	save_settings()

func set_resolution(value: Vector2i) -> void:
	if value not in RESOLUTIONS:
		return
	resolution = value
	if not fullscreen:
		_apply_display()
	save_settings()

func _apply_display() -> void:
	if DisplayServer.get_name() == "headless":
		return
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if fullscreen else DisplayServer.WINDOW_MODE_WINDOWED)
	if not fullscreen:
		var screen := DisplayServer.window_get_current_screen()
		var usable := DisplayServer.screen_get_usable_rect(screen)
		# Preserve the selected resolution even if this monitor needs a smaller window.
		var available := Vector2i(maxi(320, usable.size.x - 32), maxi(240, usable.size.y - 64))
		var fit := minf(1.0, minf(float(available.x) / resolution.x, float(available.y) / resolution.y))
		var window_size := Vector2i(Vector2(resolution) * fit)
		DisplayServer.window_set_size(window_size)
		DisplayServer.window_set_position(usable.position + (usable.size - window_size) / 2)

func set_screen_shake(enabled: bool) -> void:
	screen_shake = enabled
	save_settings()

func set_subtitles(enabled: bool) -> void:
	subtitles_enabled = enabled
	save_settings()
