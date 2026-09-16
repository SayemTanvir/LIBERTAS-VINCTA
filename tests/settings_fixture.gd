extends RefCounted

static func isolate() -> void:
	# Existing input suites may freely change preferences without touching user data.
	SessionSettings.settings_path = "res://build/settings_test_%d.cfg" % Time.get_ticks_usec()
	SessionSettings.load_settings()
