extends Node
const Settings := preload("res://scripts/systems/session_settings.gd")
var failures := 0
var checks := 0

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error(message)

func _ready() -> void:
	var settings := Settings.new()
	settings.settings_path = "res://build/settings_restart.cfg"
	add_child(settings) # Runs the real startup load/apply path in each fresh process.
	var args := OS.get_cmdline_user_args()
	if "write" in args:
		settings.set_volume("Master", 0.35)
		settings.set_volume("Music", 0.25)
		settings.set_volume("SFX", 0.55)
		settings.set_volume("Ambience", 0.45)
		settings.set_resolution(Vector2i(1366, 768))
		settings.set_fullscreen(true)
		settings.set_screen_shake(false)
		settings.set_subtitles(false)
		check(settings.last_save_error == OK, "Every preference saved")
	elif "invalid" in args:
		var config := ConfigFile.new()
		config.set_value("audio", "Master", "loud")
		config.set_value("audio", "Music", NAN)
		config.set_value("audio", "SFX", 8.0)
		config.set_value("display", "fullscreen", "true")
		config.set_value("display", "resolution", Vector2i(-1, 900))
		config.set_value("accessibility", "screen_shake", [])
		settings.settings_path = "res://build/settings_invalid.cfg"
		config.save(settings.settings_path)
		settings.load_settings()
		check(settings.volumes.Master == 0.8 and settings.volumes.Music == 0.7, "Invalid volume types and NaN default")
		check(settings.volumes.SFX == 1.0, "Out-of-range numeric volume clamps")
		check(not settings.fullscreen and settings.screen_shake and settings.subtitles_enabled, "Invalid and missing booleans default")
		check(settings.resolution == Vector2i(1280, 720), "Invalid resolution defaults")
		var file := FileAccess.open(settings.settings_path, FileAccess.WRITE)
		file.store_string("[broken")
		file.close()
		settings.load_settings()
		check(settings.volumes == Settings.DEFAULT_VOLUMES, "Corrupt config safely defaults")
		settings.settings_path = "res://build/missing_settings_%d.cfg" % Time.get_ticks_usec()
		settings.load_settings()
		check(not settings.fullscreen and settings.resolution == Settings.RESOLUTIONS[0], "Missing config uses defaults")
	else:
		check(settings.volumes == {"Master": 0.35, "Music": 0.25, "SFX": 0.55, "Ambience": 0.45}, "All audio values survive full process restart")
		check(settings.fullscreen and settings.resolution == Vector2i(1366, 768), "Display preferences survive full restart")
		check(not settings.screen_shake and not settings.subtitles_enabled, "Accessibility preferences survive full restart")
		for bus in settings.volumes:
			check(is_equal_approx(db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index(bus))), settings.volumes[bus]), "Startup applies " + bus)
		if DisplayServer.get_name() != "headless":
			await get_tree().process_frame
			check(DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN, "Saved fullscreen applied on fresh process")
			settings.set_resolution(Vector2i(1600, 900))
			check(DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN, "Resolution selection does not leave fullscreen")
			settings.set_fullscreen(false)
			await get_tree().process_frame
			check(DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED, "Fullscreen exits correctly")
			check(settings.resolution == Vector2i(1600, 900), "Selected windowed resolution retained")
			var actual := DisplayServer.window_get_size()
			check(absf(float(actual.x) / actual.y - 1600.0 / 900.0) < 0.01, "Window preserves selected aspect ratio")
	print("SETTINGS RESTART %s: %d checks, %d failures" % [str(args), checks, failures])
	get_tree().quit(0 if failures == 0 else 1)
