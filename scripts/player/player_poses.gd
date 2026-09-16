extends RefCounted
## Curated clips exclude the unwanted turns in the supplied action sheets.
static var cached_frames: SpriteFrames
const DIRECTIONS := ["s", "sw", "w", "nw", "n", "ne", "e", "se"]
const FLASHLIGHT := preload("res://assets/sprites/player/flashlight.png")
const CROUCH := preload("res://scenes/player/crouch_frames.tres")
const ActionFrames := preload("res://scripts/player/action_frames.gd")

static func frames(source: SpriteFrames) -> SpriteFrames:
	if cached_frames != null:
		return cached_frames
	cached_frames = source.duplicate()
	var crouch: SpriteFrames = CROUCH
	for direction in DIRECTIONS:
		# Use the original animated gait with the held-light pose until a dedicated
		# torch movement sheet is installed. Generated clips can replace these below.
		for gait in ["walk", "run"]:
			var source_clip: String = gait + "_" + direction
			var target_clip: String = "torch_" + source_clip
			cached_frames.add_animation(target_clip)
			cached_frames.set_animation_loop(target_clip, true)
			cached_frames.set_animation_speed(target_clip, source.get_animation_speed(source_clip))
			for frame_index in source.get_frame_count(source_clip):
				cached_frames.add_frame(target_clip, source.get_frame_texture(source_clip, frame_index), source.get_frame_duration(source_clip, frame_index))
		for action in ["crouch_idle", "crouch_walk"]:
			var clip: String = action + "_" + direction
			cached_frames.add_animation(clip)
			cached_frames.set_animation_loop(clip, true)
			cached_frames.set_animation_speed(clip, 7.0)
			for index in crouch.get_frame_count(clip):
				cached_frames.add_frame(clip, crouch.get_frame_texture(clip, index))
		_copy_clip(source, "unlock", "unlock", direction, [3, 4, 5, 6, 5, 6, 7, 8, 9], false)
		_copy_clip(source, "door_open", "interact", direction, [0, 3, 4, 5, 8, 10], false)
		if direction == "n":
			# Keep the same planted body and reaching hand from key insertion to opening.
			# Frames 7/8 are empty-handed; frame 9 turns sideways and is omitted.
			_copy_clip(source, "unlock", "unlock", direction, [3, 4, 5, 6, 5, 6, 7, 8], false)
			_copy_clip(source, "door_open", "unlock", direction, [7, 8, 10, 11], false)
		_copy_clip(source, "piano", "interact", direction, [3, 4, 5, 6, 5, 4, 6, 8], false)
		_copy_clip(source, "channel", "interact", direction, [3, 5, 6, 5, 6], true)
		# A planted standing pose while the machine charges; no repeated hand gestures.
		_copy_clip(source, "recharge", "idle", direction, [0], true)
		_copy_clip(source, "read", "interact", direction, [0, 3, 4, 4, 8, 10], false)
		_copy_clip(source, "hurt", "stagger", direction, [0, 1, 2, 1, 0], false)
		var collect := "collect_" + str(direction)
		cached_frames.add_animation(collect)
		cached_frames.set_animation_loop(collect, false)
		cached_frames.set_animation_speed(collect, 8.0)
		cached_frames.add_frame(collect, source.get_frame_texture("idle_" + direction, 0))
		for index in [0, 1, 2, 1]:
			cached_frames.add_frame(collect, crouch.get_frame_texture("crouch_walk_" + direction, index))
		cached_frames.add_frame(collect, source.get_frame_texture("idle_" + direction, 0))
	ActionFrames.append_to(cached_frames)
	return cached_frames

static func _copy_clip(source: SpriteFrames, name: String, source_action: String, direction: String, indices: Array, loop: bool) -> void:
	var clip := name + "_" + direction
	if cached_frames.has_animation(clip):
		cached_frames.remove_animation(clip)
	cached_frames.add_animation(clip)
	cached_frames.set_animation_loop(clip, loop)
	cached_frames.set_animation_speed(clip, 12.0)
	for index in indices:
		cached_frames.add_frame(clip, source.get_frame_texture(source_action + "_" + direction, index))

static func flashlight_pose(direction: String, enabled: bool) -> AtlasTexture:
	var row := DIRECTIONS.find(direction)
	var column := (5 if direction in ["s", "w", "n", "e"] else 4) if enabled else 2
	var atlas := AtlasTexture.new()
	atlas.atlas = FLASHLIGHT
	atlas.region = Rect2(column * 256, row * 256, 256, 168)
	atlas.margin = Rect2(0, 0, 0, 88)
	atlas.filter_clip = true
	return atlas
