extends RefCounted
## Curated clips exclude the unwanted turns in the supplied action sheets.
static var cached_frames: SpriteFrames
const DIRECTIONS := ["s", "sw", "w", "nw", "n", "ne", "e", "se"]
const FLASHLIGHT := preload("res://assets/sprites/player/flashlight.png")
const CROUCH := preload("res://scenes/player/crouch_frames.tres")

static func frames(source: SpriteFrames) -> SpriteFrames:
	if cached_frames != null:
		return cached_frames
	cached_frames = source.duplicate()
	var crouch: SpriteFrames = CROUCH
	for direction in DIRECTIONS:
		for action in ["crouch_idle", "crouch_walk"]:
			var clip: String = action + "_" + direction
			cached_frames.add_animation(clip)
			cached_frames.set_animation_loop(clip, true)
			cached_frames.set_animation_speed(clip, 7.0)
			for index in crouch.get_frame_count(clip):
				cached_frames.add_frame(clip, crouch.get_frame_texture(clip, index))
		_copy_clip(source, "unlock", "unlock", direction, [3, 4, 5, 6, 5, 6, 7, 8, 9], false)
		_copy_clip(source, "door_open", "interact", direction, [0, 3, 4, 5, 8, 10], false)
		_copy_clip(source, "piano", "interact", direction, [3, 4, 5, 6, 5, 4, 6, 8], false)
		_copy_clip(source, "channel", "interact", direction, [3, 5, 6, 5, 6], true)
		_copy_clip(source, "recharge", "interact", direction, [0, 3, 4, 8, 4, 10], true)
		_copy_clip(source, "read", "interact", direction, [0, 3, 4, 4, 8, 10], false)
		var collect := "collect_" + str(direction)
		cached_frames.add_animation(collect)
		cached_frames.set_animation_loop(collect, false)
		cached_frames.set_animation_speed(collect, 8.0)
		cached_frames.add_frame(collect, source.get_frame_texture("idle_" + direction, 0))
		for index in [0, 1, 2, 1]:
			cached_frames.add_frame(collect, crouch.get_frame_texture("crouch_walk_" + direction, index))
		cached_frames.add_frame(collect, source.get_frame_texture("idle_" + direction, 0))
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
