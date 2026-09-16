extends Node

enum State { INTRO, PLAYING, PAUSED, READING, CAUGHT, ENDING, MENU }
const SAVE_PATH := "user://libertas_vincta_save.json"

var state: State = State.MENU
var zone: String = "intro"
var entry: String = "start"
var checkpoint: Dictionary = {}
var ending: String = ""
var return_state: State = State.PLAYING
var arrival_pending: bool = false
var respawn_pending: bool = false
var save_path: String = SAVE_PATH
var ui_input_until_frame: int = -1
var transition_epoch := 0
var checkpoint_error := ""
const FLOOR_LAYOUT := preload("res://data/estate_layout.json")

func block_ui_input() -> void:
	# GUI consumption does not clear Input.is_action_just_pressed in player physics.
	ui_input_until_frame = Engine.get_physics_frames() + 2

func ui_blocks_input() -> bool:
	return Engine.get_physics_frames() <= ui_input_until_frame

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	EventBus.player_caught.connect(caught)
	EventBus.ending_triggered.connect(finish)

func new_game() -> void:
	checkpoint_error = ""
	transition_epoch += 1
	get_tree().paused = false
	if FileAccess.file_exists(save_path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(save_path))
	FreedomLedger.reset()
	zone = "intro"
	entry = "start"
	checkpoint.clear()
	ending = ""
	arrival_pending = false
	respawn_pending = false
	state = State.INTRO
	return_state = State.PLAYING
	_load_game_scene()

func go_home() -> void:
	transition_epoch += 1
	get_tree().paused = false
	checkpoint.clear()
	zone = "intro"
	entry = "start"
	ending = ""
	arrival_pending = false
	respawn_pending = false
	return_state = State.PLAYING
	state = State.MENU
	get_tree().change_scene_to_file("res://scenes/ui/front_end.tscn")

func save_checkpoint(position: Vector2) -> void:
	checkpoint = {"zone": zone, "position": position, "ledger": FreedomLedger.snapshot()}
	var serializable := checkpoint.duplicate(true)
	serializable.position = [position.x, position.y]
	var file := FileAccess.open(save_path, FileAccess.WRITE)
	if file != null:
		file.store_string(JSON.stringify(serializable, "  "))
	else:
		push_warning("Checkpoint could not be written.")

func has_save() -> bool:
	return FileAccess.file_exists(save_path)

func continue_game() -> void:
	transition_epoch += 1
	if not has_save():
		new_game()
		return
	var data = JSON.parse_string(FileAccess.get_file_as_string(save_path))
	if not checkpoint_is_valid(data):
		checkpoint_error = "Checkpoint could not be read. It has been kept; choose New Game to start again."
		go_home()
		return
	checkpoint_error = ""
	get_tree().paused = false
	var saved_position: Array = data.position
	FreedomLedger.restore_snapshot(data.ledger)
	zone = str(data.get("zone", "ground"))
	var p: Array = saved_position
	checkpoint = {"zone": zone, "position": Vector2(float(p[0]), float(p[1])), "ledger": FreedomLedger.snapshot()}
	entry = "checkpoint"
	arrival_pending = false
	respawn_pending = false
	ending = ""
	state = State.PLAYING
	_load_game_scene()

func checkpoint_is_valid(data: Variant) -> bool:
	if not data is Dictionary or not FreedomLedger.snapshot_is_valid(data.get("ledger")):
		return false
	var saved_zone: Variant = data.get("zone", "ground")
	if not saved_zone is String or not FLOOR_LAYOUT.data.has(saved_zone):
		return false
	var point: Variant = data.get("position")
	if not point is Array or point.size() != 2:
		return false
	for coordinate in point:
		if not (coordinate is int or coordinate is float) or not is_finite(float(coordinate)):
			return false
	if float(point[0]) < 0.0 or float(point[0]) > float(FLOOR_LAYOUT.data[saved_zone].width) or float(point[1]) < 354.0 or float(point[1]) > 634.0:
		return false
	var part := int(data.ledger.get("current_part", 1))
	if (saved_zone in ["roots", "echoes", "nexus"]) != (part == 2):
		return false
	return float(data.ledger.get("hp", 100.0)) > 0.0

func travel(destination: String, entrance: String = "start") -> void:
	# Death wins even when an old vent/door callback is already deferred.
	if state != State.PLAYING or FreedomLedger.hp <= 0.0:
		return
	transition_epoch += 1
	get_tree().paused = false
	zone = destination
	entry = entrance
	arrival_pending = true
	respawn_pending = false
	state = State.PLAYING
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")

func restart_checkpoint() -> void:
	transition_epoch += 1
	get_tree().paused = false
	if checkpoint.is_empty():
		new_game()
		return
	FreedomLedger.restore_snapshot(checkpoint.ledger)
	zone = checkpoint.zone
	entry = "checkpoint"
	arrival_pending = false
	ending = ""
	respawn_pending = true
	state = State.PLAYING
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")

func caught() -> void:
	if state != State.PLAYING:
		return
	state = State.CAUGHT
	transition_epoch += 1
	var epoch := transition_epoch
	EventBus.audio_requested.emit("monster_breathing")
	await get_tree().create_timer(1.2, false).timeout
	if state != State.CAUGHT or epoch != transition_epoch:
		return
	var hud := get_tree().get_first_node_in_group("hud")
	if hud != null:
		get_tree().paused = true
		hud.show_game_over()
	else:
		restart_checkpoint()

func finish(kind: String) -> void:
	if state != State.PLAYING or not FreedomLedger.eligible(kind):
		return
	if kind == "loop":
		_trigger_loop()
		return
	ending = kind
	FreedomLedger.ending_type = kind
	state = State.ENDING

func continue_to_part_two() -> void:
	if ending not in ["untouched", "vantree", "partial_mercy"]:
		return
	get_tree().paused = false
	FreedomLedger.begin_part_two(ending)
	EventBus.part_two_started.emit(FreedomLedger.part2_seed)
	ending = ""
	state = State.PLAYING
	zone = "roots"
	entry = "start"
	arrival_pending = false
	respawn_pending = false
	checkpoint.clear()
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")

func _trigger_loop() -> void:
	transition_epoch += 1
	var epoch := transition_epoch
	state = State.INTRO
	FreedomLedger.reset_for_loop()
	EventBus.loop_started.emit(FreedomLedger.loop_counter)
	zone = "ground"
	entry = "start"
	ending = ""
	checkpoint.clear()
	arrival_pending = false
	respawn_pending = false
	await get_tree().create_timer(0.35, false).timeout
	if epoch != transition_epoch or state != State.INTRO:
		return
	state = State.PLAYING
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")

func pause_game() -> void:
	if state not in [State.PLAYING, State.INTRO]:
		return
	return_state = state
	state = State.PAUSED
	get_tree().paused = true

func resume() -> void:
	get_tree().paused = false
	state = return_state

func read_letter() -> void:
	if state == State.READING:
		return
	return_state = state
	state = State.READING
	get_tree().paused = true

func _load_game_scene() -> void:
	var error := get_tree().change_scene_to_file("res://scenes/ui/loading_screen.tscn")
	if error != OK:
		push_error("Could not open loading screen (error %s)." % error)
		go_home()
