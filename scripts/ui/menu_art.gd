extends RefCounted
## Source regions for the menu artwork and selection highlights.
const ImageMenu = preload("res://scripts/ui/image_state_menu.gd")
const ROOT := "res://assets/BG/"

static func texture(path: String) -> Texture2D:
	return load(ROOT + path) as Texture2D

static func main(menu: Control, paused: bool) -> void:
	var items: Array[Dictionary] = []
	if paused:
		var base := texture("07_Pause_Menu/restored/pause_resume_active.png")
		var highlights := texture("07_Pause_Menu/restored/pause_highlight_regions.png")
		var ids := ["resume", "settings", "rules", "home"]
		var rows := [338, 447, 551, 655]
		for i in ids.size():
			var visual := Rect2(592, rows[i], 489, 103)
			items.append({"id": ids[i], "rect": Rect2(603, rows[i] + 8, 464, 94), "visual_rect": visual, "texture": ImageMenu.region(base if i == 0 else highlights, visual)})
		menu.build(base, items, false)
		var neutral: TextureRect = menu.texture_layer(ImageMenu.region(highlights, Rect2(592, 338, 489, 103)), Rect2(592, 338, 489, 103))
		menu.design.move_child(neutral, 1)
		blend_regions(menu, neutral)
	else:
		# Widescreen restoration includes newly painted ceiling and floor.
		# Share one background across states so selection cannot change the scene.
		var base := texture("03_Main_Menu/widescreen/main_menu_start_active.png")
		var highlights := texture("03_Main_Menu/widescreen/main_menu_highlight_regions.png")
		var ids := ["start", "continue", "settings", "rules", "credits", "quit"]
		var row_y := [404, 467, 525, 584, 644, 704]
		var row_height := [63, 58, 59, 60, 60, 64]
		for i in ids.size():
			var visual := Rect2(654, row_y[i], 359, row_height[i])
			var hitbox := Rect2(665, row_y[i] + 5, 337, row_height[i] - 8)
			items.append({"id": ids[i], "rect": hitbox, "visual_rect": visual, "texture": ImageMenu.region(base if i == 0 else highlights, visual)})
		menu.build(base, items, false)
		var start_region := Rect2(654, row_y[0], 359, row_height[0])
		var neutral: TextureRect = menu.texture_layer(ImageMenu.region(highlights, start_region), start_region)
		menu.design.move_child(neutral, 1)
		blend_regions(menu, neutral)

static func blend_regions(menu: Control, neutral: TextureRect) -> void:
	var neutral_blend := ShaderMaterial.new()
	neutral_blend.shader = preload("res://shaders/menu_region_blend.gdshader")
	neutral_blend.set_shader_parameter("region_size", neutral.size)
	neutral.material = neutral_blend
	var active_blend := ShaderMaterial.new()
	active_blend.shader = neutral_blend.shader
	active_blend.set_shader_parameter("region_size", menu.active_art.size)
	menu.active_art.material = active_blend
	menu.selection_changed.connect(func(_index: int):
		active_blend.set_shader_parameter("region_size", menu.active_art.size))

static func single(menu: Control, folder: String, filename: String, back: Rect2) -> void:
	var art := texture(folder + "/" + filename + ".png")
	var items: Array[Dictionary] = [{"id": "back", "rect": back, "texture": art}]
	menu.build(art, items)

static func result(menu: Control, chapter: bool) -> void:
	var folder := "09_Chapter_Complete" if chapter else "08_Game_Over"
	var prefix := "chapter_complete" if chapter else "game_over"
	var ids := ["continue", "home"] if chapter else ["retry", "home"]
	var files := ["continue", "main_menu"] if chapter else ["retry", "main_menu"]
	var items: Array[Dictionary] = []
	for i in 2:
		var rect := Rect2(450, 389 + i * 55, 280, 51) if chapter else Rect2(455, 314 + i * 69, 276, 59)
		items.append({"id": ids[i], "rect": rect, "texture": texture(folder + "/states/" + prefix + "_" + files[i] + "_active.png")})
	menu.build(items[0].texture, items)
