extends RefCounted
## Dedicated generated actions, registered in the same foot space as the original art.
const MANIFEST := preload("res://assets/sprites/player/actions/frames.json")
const DIRECTIONS := ["s", "sw", "w", "nw", "n", "ne", "e", "se"]
const ROWS := [0, 1, 1, 2, 2, 2, 3, 3]

static func append_to(frames: SpriteFrames, manifest: JSON = MANIFEST) -> void:
	var definitions := {
		"torch_raise": ["torch_use", [0, 1, 2, 3, 4, 5], false],
		"torch_lower": ["torch_use", [5, 4, 3, 2, 1, 0], false],
		"torch_idle": ["torch_use", [5], true],
		"torch_walk": ["torch_move", [0, 1, 2, 3], true],
		"torch_run": ["torch_move", [4, 5, 6, 7], true],
		"vent_enter": ["vent_enter", [0, 1, 2, 3, 4, 5], false],
		"vent_exit": ["vent_enter", [5, 4, 3, 2, 1, 0], false],
		"unlock": ["door_unlock", [0, 1, 2, 3, 4, 3, 4, 5], false],
		"piano": ["piano", [0, 1, 2, 3, 4, 3, 4, 5], false],
		"hide_wall": ["hide_wall", [0, 1, 3, 4], false],
		"hide_wall_hold": ["hide_wall", [4], true],
		"hide_wall_exit": ["hide_wall", [4, 3, 1, 0], false],
		"hide_table": ["hide_table", [0, 1, 2, 3, 4, 5], false],
		"hide_table_hold": ["hide_table", [5], true],
		"hide_table_exit": ["hide_table", [5, 4, 3, 2, 1, 0], false],
		"bag_pickup": ["bag_pickup", [0, 1, 2, 3, 4, 5], false],
		"key_pickup": ["key_pickup", [0, 1, 2, 3, 4, 5], false],
		"pickup": ["key_pickup", [0, 1, 2, 3, 4, 5], false]}
	var textures := {}
	for action: String in definitions:
		var definition: Array = definitions[action]
		var source_name: String = definition[0]
		# Generated sheets are optional; keep the existing clip when one is absent.
		if not manifest.data.has(source_name):
			continue
		var source: Dictionary = manifest.data[source_name]
		if not ResourceLoader.exists(source.texture):
			continue
		if not textures.has(source_name):
			textures[source_name] = load(source.texture)
		for direction_index in DIRECTIONS.size():
			var row: Dictionary = source.rows[ROWS[direction_index]]
			var name := action + "_" + str(DIRECTIONS[direction_index])
			if frames.has_animation(name):
				frames.remove_animation(name)
			frames.add_animation(name)
			frames.set_animation_loop(name, definition[2])
			frames.set_animation_speed(name, 7.4 if action == "torch_run" else (4.8 if action == "torch_walk" else 10.0))
			for column: int in definition[1]:
				var data: Dictionary = row.frames[column]
				var atlas := AtlasTexture.new()
				atlas.atlas = textures[source_name]
				atlas.region = Rect2(data.rect[0], data.rect[1], data.rect[2], data.rect[3])
				atlas.filter_clip = true
				atlas.set_meta("action_scale", float(row.scale))
				atlas.set_meta("action_offset", Vector2(data.offset[0], data.offset[1]))
				frames.add_frame(name, atlas)
