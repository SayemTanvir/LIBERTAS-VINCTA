extends Node
## Quiet, existing mechanical switch recordings; one cue per selection/accept.
@export var ui_hover: AudioStream = preload("res://assets/audio/others/switch/switchon1.wav")
@export var ui_confirm: AudioStream = preload("res://assets/audio/others/switch/switchon2.wav")
@export var ui_back: AudioStream = preload("res://assets/audio/others/switch/switchon1.wav")
var voice: AudioStreamPlayer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	voice = AudioStreamPlayer.new()
	voice.bus = "SFX"
	voice.volume_db = -22.0
	add_child(voice)
	EventBus.audio_requested.connect(play_cue)

func play_cue(cue: String) -> void:
	if not get_parent().is_visible_in_tree():
		return
	var streams := {"ui_hover": ui_hover, "ui_confirm": ui_confirm, "ui_back": ui_back}
	var stream: AudioStream = streams.get(cue)
	if stream != null:
		voice.stream = stream
		voice.play()
