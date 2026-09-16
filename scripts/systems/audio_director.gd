extends Node
## Central audio coordinator. Wires all organized assets from assets/audio/ to game events.
## Cues are played via EventBus.audio_requested.emit("cue_name").
## Tension states (CALM / SEARCHING / CHASE) are driven by EventBus.tension_changed.

# ── Ambience ──────────────────────────────────────────────────────────────────
@export var house_ambience: AudioStream = preload("res://assets/audio/ambience/horrorambience1.wav")
@export var ambience_alt: Array[AudioStream] = [
	preload("res://assets/audio/ambience/horrorambience2.wav"),
	preload("res://assets/audio/ambience/horrorambience3.wav"),
	preload("res://assets/audio/ambience/horrorambience4.wav"),
	preload("res://assets/audio/ambience/paranormalambience.wav"),
]

# ── Player ────────────────────────────────────────────────────────────────────
@export var breathing: AudioStream = preload("res://assets/audio/player/breathing/humanbreathing1.wav")
@export var scared_breathing: AudioStream = preload("res://assets/audio/player/breathing/femalebreathing1.wav")
@export var heartbeat: AudioStream = preload("res://assets/audio/player/heartbeat/heartbeat1.wav")

# Player screams — randomized on caught / heavy damage
@export var player_scream_samples: Array[AudioStream] = [
	preload("res://assets/audio/player/scream/femalescream1.wav"),
	preload("res://assets/audio/player/scream/femalescream2.wav"),
	preload("res://assets/audio/player/scream/femalescream3.wav"),
]

# ── Monster ───────────────────────────────────────────────────────────────────
@export var monster_breathing: AudioStream = preload("res://assets/audio/monster/breathing/monsterbreathing1.wav")
@export var monster_search: AudioStream = preload("res://assets/audio/monster/breathing/monsterbreathing2.wav")
@export var monster_growl3: AudioStream = preload("res://assets/audio/monster/growl/monstergrowl3.wav")

# Monster growls — randomized on hunt/chase entry
@export var monster_growl_samples: Array[AudioStream] = [
	preload("res://assets/audio/monster/growl/monstergrowl1.wav"),
	preload("res://assets/audio/monster/growl/monstergrowl2.wav"),
	preload("res://assets/audio/monster/growl/monstergrowl3.wav"),
	preload("res://assets/audio/monster/growl/monstergrowl4.wav"),
]

# Monster footsteps — randomized ticks from enemy script
@export var monster_footstep_samples: Array[AudioStream] = [
	preload("res://assets/audio/monster/footstep/monsterfootstep1.wav"),
	preload("res://assets/audio/monster/footstep/monsterfootstep2.wav"),
	preload("res://assets/audio/monster/footstep/monsterfootstep3.wav"),
]

# Screech used when hearing-sense is restored (sharp, alarming)
@export var monster_screech: AudioStream = preload("res://assets/audio/monster/growl/monstergrowl4.wav")

# ── Doors ─────────────────────────────────────────────────────────────────────
@export var door_open_samples: Array[AudioStream] = [
	preload("res://assets/audio/others/door/opendoor1.wav"),
	preload("res://assets/audio/others/door/opendoor2.wav"),
	preload("res://assets/audio/others/door/opendoor3.wav"),
]
@export var door_close_samples: Array[AudioStream] = [
	preload("res://assets/audio/others/door/closedoor1.wav"),
	preload("res://assets/audio/others/door/closedoor2.wav"),
]
@export var door_knock: AudioStream = preload("res://assets/audio/others/door/doorknocking1.wav")
@export var drop_on_floor: AudioStream = preload("res://assets/audio/others/door/droponfloor1.wav")

# ── Keys / Lockpick ───────────────────────────────────────────────────────────
@export var key_grab_samples: Array[AudioStream] = [
	preload("res://assets/audio/others/key/grabkey1.wav"),
	preload("res://assets/audio/others/key/grabkey2.wav"),
]
@export var key_unlock_samples: Array[AudioStream] = [
	preload("res://assets/audio/others/key/keyunlock1.wav"),
	preload("res://assets/audio/others/key/keyunlock2.wav"),
	preload("res://assets/audio/others/key/keyunlock3.wav"),
]

# ── Glass ─────────────────────────────────────────────────────────────────────
@export var glass_break_samples: Array[AudioStream] = [
	preload("res://assets/audio/others/glass/glassbreak1.wav"),
	preload("res://assets/audio/others/glass/glassbreak2.wav"),
]
@export var glass_pickup: AudioStream = preload("res://assets/audio/others/glass/glasspickup1.wav")

# ── Switches / UI ─────────────────────────────────────────────────────────────
@export var flashlight_samples: Array[AudioStream] = [
	preload("res://assets/audio/others/switch/switchon1.wav"),
	preload("res://assets/audio/others/switch/switchon2.wav"),
]

# ── Jumpscares ────────────────────────────────────────────────────────────────
@export var jumpscare_samples: Array[AudioStream] = [
	preload("res://assets/audio/jumpscare/jumpscare1.wav"),
	preload("res://assets/audio/jumpscare/jumpscare2.wav"),
	preload("res://assets/audio/jumpscare/jumpscare3.wav"),
	preload("res://assets/audio/jumpscare/jumpscare4.wav"),
]

# ── Stingers ──────────────────────────────────────────────────────────────────
@export var stinger_samples: Array[AudioStream] = [
	preload("res://assets/audio/stinger/stinger1.wav"),
	preload("res://assets/audio/stinger/stinger2.wav"),
]
@export var no_escape_stinger: AudioStream = preload("res://assets/audio/stinger/thereisnoescapestinger.wav")

# ── Astonishment ──────────────────────────────────────────────────────────────
@export var astonishment_samples: Array[AudioStream] = [
	preload("res://assets/audio/others/astonishment/astonishment1.wav"),
	preload("res://assets/audio/others/astonishment/astonishment2.wav"),
]

# ── Distant Sounds (random ambient events) ────────────────────────────────────
@export var distant_event_samples: Array[AudioStream] = [
	preload("res://assets/audio/others/distantsounds/distantsounds1.wav"),
	preload("res://assets/audio/others/distantsounds/distantscream1.wav"),
	preload("res://assets/audio/others/distantsounds/insect.wav"),
	preload("res://assets/audio/others/distantsounds/laugh1.wav"),
	preload("res://assets/audio/others/distantsounds/metalfalling1.wav"),
	preload("res://assets/audio/others/distantsounds/thunder1.wav"),
	preload("res://assets/audio/others/distantsounds/thunder2.wav"),
	preload("res://assets/audio/others/distantsounds/waterdrop1.wav"),
	preload("res://assets/audio/others/distantsounds/wind1.wav"),
]

# ── Music ─────────────────────────────────────────────────────────────────────
@export var calm_music: AudioStream = preload("res://assets/audio/themesounds/horrortheme1.wav")
@export var searching_music: AudioStream = preload("res://assets/audio/themesounds/horrortheme2.wav")
@export var chase_music: AudioStream = preload("res://assets/audio/themesounds/horrortheme3.wav")

# ─────────────────────────────────────────────────────────────────────────────

var players: Dictionary = {}
var tension: String = ""
var fade_tween: Tween
var shutting_down: bool = false
var _rng := RandomNumberGenerator.new()
var _ambient_timer: float = 0.0
var _ambient_interval: float = 0.0
var _last_scream_sample: AudioStream = null
var _death_audio_epoch := -1
var _last_growl_sample: AudioStream = null
var _last_monster_step: AudioStream = null
var _last_distant_sample: AudioStream = null

func _ready() -> void:
	_rng.randomize()
	add_to_group("audio_director")
	_setup_players()
	_reset_ambient_timer()

	EventBus.audio_requested.connect(play_cue)
	EventBus.tension_changed.connect(set_tension)
	EventBus.sense_restored.connect(_play_key_sting)
	EventBus.player_caught.connect(_on_player_caught)
	EventBus.player_detected.connect(_on_player_detected)

	play_cue("house_ambience")
	set_tension("CALM")

# ── Setup ─────────────────────────────────────────────────────────────────────

func _setup_players() -> void:
	# Single-stream looping cues
	var simple_cues := {
		"house_ambience": {"stream": house_ambience, "bus": "Ambience", "loop": true},
		"breathing":       {"stream": breathing,      "bus": "Ambience", "volume": -6.0, "loop": true},
		"scared_breathing":{"stream": scared_breathing,"bus": "Ambience", "volume": -4.0},
		"heartbeat":       {"stream": heartbeat,       "bus": "Ambience", "volume": -8.0, "loop": true},
		"monster_breathing":{"stream": monster_breathing,"bus": "SFX",   "volume": -4.0, "pitch": 0.68},
		"monster_growl3":  {"stream": monster_growl3,  "bus": "SFX",     "volume": 0.0},
		"monster_search":  {"stream": monster_search,  "bus": "SFX",     "volume": -7.0, "pitch": 0.82},
		"monster_screech": {"stream": monster_screech, "bus": "SFX",     "volume": 2.0,  "pitch": 1.35},
		"building_creak":  {"stream": preload("res://assets/audio/others/distantsounds/metalfalling1.wav"), "bus": "Ambience", "volume": -10.0},
		"door_knock":      {"stream": door_knock,      "bus": "SFX"},
		"drop_on_floor":   {"stream": drop_on_floor,   "bus": "SFX"},
		"glass_pickup":    {"stream": glass_pickup,    "bus": "SFX",     "volume": -4.0},
		"no_escape_stinger":{"stream": no_escape_stinger,"bus": "SFX",   "volume": -2.0},
	}

	for cue in simple_cues:
		var cfg: Dictionary = simple_cues[cue]
		var audio := AudioStreamPlayer.new()
		audio.name = cue.to_pascal_case()
		audio.bus = cfg.get("bus", "SFX")
		audio.stream = cfg.get("stream")
		audio.volume_db = float(cfg.get("volume", 0.0))
		audio.pitch_scale = float(cfg.get("pitch", 1.0))
		add_child(audio)
		players[cue] = audio
		if cfg.get("loop", false):
			audio.finished.connect(audio.play)

	# Randomized multi-sample cues
	var multi_cues := {
		"player_scream":    {"samples": player_scream_samples,   "bus": "SFX",     "volume": -2.0},
		"monster_growl":    {"samples": monster_growl_samples,   "bus": "SFX",     "volume": -1.0},
		"monster_footstep": {"samples": monster_footstep_samples,"bus": "SFX",     "volume": -8.0},
		"door_open":        {"samples": door_open_samples,        "bus": "SFX"},
		"door_close":       {"samples": door_close_samples,       "bus": "SFX"},
		"key_grab":         {"samples": key_grab_samples,         "bus": "SFX",    "volume": -4.0},
		"key_unlock":       {"samples": key_unlock_samples,       "bus": "SFX",    "volume": -3.0},
		"glass_break":      {"samples": glass_break_samples,      "bus": "SFX"},
		"flashlight":       {"samples": flashlight_samples,       "bus": "SFX",    "volume": -14.0},
		"jumpscare":        {"samples": jumpscare_samples,        "bus": "SFX",    "volume": 3.0},
		"stinger":          {"samples": stinger_samples,          "bus": "SFX",    "volume": -2.0},
		"astonishment":     {"samples": astonishment_samples,     "bus": "SFX",    "volume": -6.0},
		"distant_event":    {"samples": distant_event_samples,    "bus": "Ambience","volume": -10.0},
		"ambience_alt":     {"samples": ambience_alt,             "bus": "Ambience","volume": -8.0},
	}

	for cue in multi_cues:
		var cfg: Dictionary = multi_cues[cue]
		var audio := AudioStreamPlayer.new()
		audio.name = cue.to_pascal_case()
		audio.bus = cfg.get("bus", "SFX")
		audio.volume_db = float(cfg.get("volume", 0.0))
		add_child(audio)
		players[cue] = audio

	# Music layers
	for state in ["CALM", "SEARCHING", "CHASE"]:
		var audio := AudioStreamPlayer.new()
		audio.name = state
		audio.bus = "Music"
		audio.stream = get(state.to_lower() + "_music")
		audio.volume_db = -60.0
		add_child(audio)
		players[state] = audio
		audio.finished.connect(audio.play)

# ── Process (distant ambient events) ─────────────────────────────────────────

func _process(delta: float) -> void:
	if shutting_down or GameManager.state != GameManager.State.PLAYING:
		return
	_ambient_timer -= delta
	if _ambient_timer <= 0.0:
		_reset_ambient_timer()
		_play_random_distant_event()

func _reset_ambient_timer() -> void:
	_ambient_interval = _rng.randf_range(35.0, 80.0)
	_ambient_timer = _ambient_interval

func _play_random_distant_event() -> void:
	if distant_event_samples.is_empty():
		return
	var choices := distant_event_samples.filter(func(s): return s != _last_distant_sample)
	if choices.is_empty():
		choices = distant_event_samples
	var sample: AudioStream = choices[_rng.randi_range(0, choices.size() - 1)]
	_last_distant_sample = sample
	var audio: AudioStreamPlayer = players.get("distant_event")
	if audio != null and not audio.playing:
		audio.stream = sample
		audio.play()

# ── Cleanup ───────────────────────────────────────────────────────────────────

func _exit_tree() -> void:
	shutdown()

func shutdown() -> void:
	if shutting_down:
		return
	shutting_down = true
	if fade_tween != null:
		fade_tween.kill()
		fade_tween = null
	if EventBus.audio_requested.is_connected(play_cue):
		EventBus.audio_requested.disconnect(play_cue)
	if EventBus.tension_changed.is_connected(set_tension):
		EventBus.tension_changed.disconnect(set_tension)
	if EventBus.sense_restored.is_connected(_play_key_sting):
		EventBus.sense_restored.disconnect(_play_key_sting)
	if EventBus.player_caught.is_connected(_on_player_caught):
		EventBus.player_caught.disconnect(_on_player_caught)
	if EventBus.player_detected.is_connected(_on_player_detected):
		EventBus.player_detected.disconnect(_on_player_detected)
	for audio in players.values():
		if is_instance_valid(audio):
			if audio.finished.is_connected(audio.play):
				audio.finished.disconnect(audio.play)
			audio.stop()
			audio.stream = null
	players.clear()
	tension = ""

# ── Event handlers ────────────────────────────────────────────────────────────

func _play_key_sting(sense: String) -> void:
	# Use the "no escape" stinger for memory (most dramatic reveal)
	if sense == "memory":
		play_cue("no_escape_stinger")
	else:
		play_cue("stinger")

func _on_player_caught() -> void:
	if _death_audio_epoch == GameManager.transition_epoch:
		return
	_death_audio_epoch = GameManager.transition_epoch
	play_cue("jumpscare")
	play_cue("player_scream")
	play_cue("monster_growl3")

func _on_player_detected(_source: Node) -> void:
	play_cue("astonishment")

# ── Public API ────────────────────────────────────────────────────────────────

func play_cue(cue: String) -> void:
	if cue == "start_running_breathing":
		var audio = players.get("breathing")
		if audio and not audio.playing:
			audio.play()
		return
	if cue == "stop_running_breathing":
		var audio = players.get("breathing")
		if audio and audio.playing:
			audio.stop()
		return

	var audio: AudioStreamPlayer = players.get(cue)
	if audio == null:
		return

	# Multi-sample cues: pick a non-repeating random sample
	match cue:
		"player_scream":
			_play_random(audio, player_scream_samples, _last_scream_sample)
			_last_scream_sample = audio.stream
		"monster_growl":
			_play_random(audio, monster_growl_samples, _last_growl_sample)
			_last_growl_sample = audio.stream
		"monster_footstep":
			_play_random(audio, monster_footstep_samples, _last_monster_step)
			_last_monster_step = audio.stream
		"door_open":
			_play_random(audio, door_open_samples, null)
		"door_close":
			_play_random(audio, door_close_samples, null)
		"key_grab":
			_play_random(audio, key_grab_samples, null)
		"key_unlock":
			_play_random(audio, key_unlock_samples, null)
		"glass_break":
			_play_random(audio, glass_break_samples, null)
		"flashlight":
			_play_random(audio, flashlight_samples, null)
		"jumpscare":
			_play_random(audio, jumpscare_samples, null)
		"stinger":
			_play_random(audio, stinger_samples, null)
		"astonishment":
			_play_random(audio, astonishment_samples, null)
		_:
			# Simple single-stream cue
			if audio.stream != null:
				audio.play()

func _play_random(audio: AudioStreamPlayer, samples: Array, last: AudioStream) -> void:
	if samples.is_empty():
		return
	var choices := samples.filter(func(s): return s != last)
	if choices.is_empty():
		choices = samples
	audio.stream = choices[_rng.randi_range(0, choices.size() - 1)]
	audio.play()

func set_tension(state: String) -> void:
	if state == tension:
		return
	tension = state

	# Scared breathing: on during CHASE, off otherwise
	var scared: AudioStreamPlayer = players.get("scared_breathing")
	if scared != null:
		if state == "CHASE" and not scared.playing:
			scared.play()
		elif state != "CHASE" and scared.playing:
			scared.stop()

	# Heartbeat: loop during CHASE
	var hb: AudioStreamPlayer = players.get("heartbeat")
	if hb != null:
		if state == "CHASE" and not hb.playing:
			hb.play()
		elif state != "CHASE" and hb.playing:
			hb.stop()

	# Monster growl on entering alert states
	if state in ["SEARCHING", "CHASE"]:
		play_cue("monster_growl")

	# Music crossfade
	if fade_tween != null:
		fade_tween.kill()
	fade_tween = create_tween().set_parallel(true)
	for candidate in ["CALM", "SEARCHING", "CHASE"]:
		var audio: AudioStreamPlayer = players[candidate]
		if candidate == state and audio.stream != null and not audio.playing:
			audio.play()
		var target_db := -60.0
		if candidate == state:
			target_db = -18.0 if state == "SEARCHING" else (-7.0 if state == "CHASE" else -12.0)
		fade_tween.tween_property(audio, "volume_db", target_db, 1.2)
