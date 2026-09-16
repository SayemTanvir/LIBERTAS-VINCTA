extends Node
var checks := 0
var failures: Array[String] = []

func check(value: bool, description: String) -> void:
	checks += 1
	if not value:
		failures.append(description)
		push_error(description)

func _ready() -> void:
	AudioServer.set_bus_mute(0, true)
	var viewport := SubViewport.new()
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	add_child(viewport)
	var menu = preload("res://scenes/ui/main_menu.tscn").instantiate()
	viewport.add_child(menu)
	# A bright sentinel detects uncovered edges without requiring dark artwork
	# to contain bright pixels along its border.
	(menu.get_child(0) as ColorRect).color = Color.MAGENTA
	menu.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	for resolution in [Vector2i(1280, 720), Vector2i(1600, 900), Vector2i(1920, 1080), Vector2i(1024, 768), Vector2i(2560, 1080)]:
		viewport.size = resolution
		await get_tree().process_frame
		await get_tree().process_frame
		var screen := Rect2(Vector2.ZERO, Vector2(resolution))
		check(is_equal_approx(menu.design.scale.x, menu.design.scale.y), "Artwork proportions preserved at " + str(resolution))
		var art_bounds: Rect2 = menu.artwork.get_global_rect()
		check(art_bounds.grow(0.01).encloses(screen), "Artwork covers every screen edge at " + str(resolution))
		for label: Label in menu.menu_content.find_children("*", "Label", true, false):
			check(screen.encloses(label.get_global_rect()), "Title/helper text stays on screen at " + str(resolution))
		for i in 6:
			var button: Button = menu.buttons[i]
			var bounds := button.get_global_transform() * Rect2(Vector2.ZERO, button.size)
			check(screen.encloses(bounds), "Button remains fully on-screen: " + str(i) + " at " + str(resolution))
			menu.set_selection(i, false)
			await get_tree().create_timer(0.16).timeout
			if DisplayServer.get_name() != "headless":
				await RenderingServer.frame_post_draw
				var rendered := viewport.get_texture().get_image()
				for y in [0, resolution.y - 1]:
					var has_scenery := true
					for x in range(0, resolution.x, 32):
						var pixel := rendered.get_pixel(x, y)
						has_scenery = has_scenery and not (pixel.r > 0.9 and pixel.g < 0.1 and pixel.b > 0.9)
					check(has_scenery, "Scenery covers edge " + str(y) + " in state " + str(i))
				if resolution.x == 1920 or i == 0:
					rendered.save_png("res://build/home_widescreen_%d_state_%d.png" % [resolution.x, i])
	print("HOME WIDESCREEN: %d checks, %d failures" % [checks, failures.size()])
	get_tree().quit(0 if failures.is_empty() else 1)
