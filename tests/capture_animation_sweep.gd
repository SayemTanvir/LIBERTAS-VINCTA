extends Node

const PLAYER := preload("res://scenes/player/player.tscn")
const ENEMY := preload("res://scenes/enemy/deprived_one.tscn")
const OUTPUT := "res://build/animation-sweep"

var room: Node2D
var player: CharacterBody2D

func _ready() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUTPUT))
	AudioServer.set_bus_mute(0, true)
	_capture_all.call_deferred()

func _setup(zone: String) -> void:
	FreedomLedger.reset()
	GameManager.zone = zone
	GameManager.state = GameManager.State.PLAYING
	room = load("res://scenes/levels/" + zone + "_floor.tscn").instantiate()
	add_child(room)
	player = PLAYER.instantiate()
	room.add_child(player)
	var camera: Camera2D = player.get_node("Camera2D")
	camera.limit_left = 0
	camera.limit_right = int(room.room_width)
	camera.limit_top = 0
	camera.limit_bottom = 720
	camera.position_smoothing_enabled = false
	camera.make_current()
	await get_tree().process_frame

func _clear() -> void:
	room.queue_free()
	await get_tree().process_frame
	await get_tree().process_frame

func _frame(name: String) -> void:
	var camera: Camera2D = player.get_node("Camera2D")
	camera.snap_to_player()
	camera.force_update_scroll()
	await get_tree().process_frame
	await RenderingServer.frame_post_draw
	var image := get_viewport().get_texture().get_image()
	if image.save_png(OUTPUT + "/" + name + ".png") != OK:
		push_error("Could not save animation frame " + name)

func _write_contact_sheet() -> void:
	var names := PackedStringArray([
		"01_tool_pouch_interact", "02_piano_interact", "03_held_flashlight",
		"04_open_doorway", "05_capture", "06_respawn",
		"07_vanity_unlock", "08_ritual_seal", "09_monster_stun"
	])
	var cell := Vector2i(640, 360)
	var contact := Image.create(cell.x * 3, cell.y * 3, false, Image.FORMAT_RGBA8)
	contact.fill(Color("#111716"))
	for index in names.size():
		var source := Image.new()
		var path := OUTPUT + "/" + names[index] + ".png"
		if source.load(ProjectSettings.globalize_path(path)) != OK:
			push_error("Could not load contact-sheet frame " + path)
			continue
		source.resize(cell.x, cell.y, Image.INTERPOLATE_LANCZOS)
		var destination := Vector2i(index % 3, floori(float(index) / 3.0)) * cell
		contact.blit_rect(source, Rect2i(Vector2i.ZERO, cell), destination)
	if contact.save_png(OUTPUT + "/contact.png") != OK:
		push_error("Could not save animation contact sheet")

func _pose(prop_name: String) -> BaseInteractable:
	var prop: BaseInteractable = room.props.get_node(prop_name)
	prop._prepare_action_pose(player)
	player.play_action(prop._action_animation(), prop.action_seconds)
	return prop

func _capture_all() -> void:
	await _setup("intro")
	var tool: BaseInteractable = room.props.get_node("LockpickTool")
	player.global_position = tool.global_position + Vector2(-38, 24)
	player.facing = Vector2.RIGHT
	player.play_action(tool._action_animation())
	await get_tree().create_timer(0.52).timeout
	await _frame("01_tool_pouch_interact")
	await _clear()

	await _setup("ground")
	FreedomLedger.collect_item("lockpick")
	_pose("PianoSeal")
	await get_tree().create_timer(0.52).timeout
	await _frame("02_piano_interact")
	FreedomLedger.flags["flashlight"] = true
	player.animation_hold = 0.0
	player.set_flashlight(true)
	await get_tree().create_timer(1.05).timeout
	await _frame("03_held_flashlight")
	var door: BaseInteractable = room.props.get_node("FrontDoor")
	player.global_position = door.global_position + Vector2(0, 56)
	player.facing = Vector2.UP
	door.get_node("Visual/DoorPresentation").set_open_immediate(true)
	player.play_animation("walk")
	await _frame("04_open_doorway")
	player._caught()
	await get_tree().create_timer(0.42).timeout
	await _frame("05_capture")
	door.get_node("Visual/DoorPresentation").set_open_immediate(false)
	player.play_respawn()
	await get_tree().create_timer(0.30).timeout
	await _frame("06_respawn")
	await _clear()

	await _setup("upper")
	FreedomLedger.restore_sense("hearing")
	_pose("VanitySeal")
	await get_tree().create_timer(0.52).timeout
	await _frame("07_vanity_unlock")
	await _clear()

	await _setup("basement")
	FreedomLedger.restore_sense("hearing")
	FreedomLedger.restore_sense("sight")
	_pose("RitualSeal")
	await get_tree().create_timer(0.52).timeout
	await _frame("08_ritual_seal")
	await _clear()

	await _setup("echoes")
	FreedomLedger.restore_sense("hearing")
	FreedomLedger.begin_part_two("vantree")
	var enemy: CharacterBody2D = ENEMY.instantiate()
	enemy.global_position = Vector2(850, 500)
	room.add_child(enemy)
	player.global_position = Vector2(700, 500)
	enemy.stun(6.0)
	await get_tree().physics_frame
	await get_tree().create_timer(0.18).timeout
	await _frame("09_monster_stun")
	await _clear()

	_write_contact_sheet()
	print("ANIMATION SWEEP CAPTURED: tool, piano, flashlight, door, capture, respawn, vanity, ritual, stun")
	get_tree().quit()
