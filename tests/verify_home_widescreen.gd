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
	menu.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	for resolution in [Vector2i(1280, 720), Vector2i(1600, 900), Vector2i(1920, 1080), Vector2i(1024, 768), Vector2i(2560, 1080)]:
		viewport.size = resolution
		await get_tree().process_frame
		await get_tree().process_frame
		var screen := Rect2(Vector2.ZERO, Vector2(resolution))
		check(is_equal_approx(menu.design.scale.x, menu.design.scale.y), "Artwork proportions preserved at " + str(resolution))
		var art_bounds: Rect2 = menu.design.get_global_transform() * Rect2(Vector2.ZERO, menu.reference_size)
		check(art_bounds.grow(0.01).encloses(screen), "Artwork covers every screen edge at " + str(resolution))
		for i in 6:
			var button: Button = menu.buttons[i]
			var bounds := button.get_global_transform() * Rect2(Vector2.ZERO, button.size)
			check(screen.encloses(bounds), "Button remains fully on-screen: " + str(i) + " at " + str(resolution))
			menu.set_selection(i, false)
			await get_tree().process_frame
			if DisplayServer.get_name() != "headless":
				await RenderingServer.frame_post_draw
				var rendered := viewport.get_texture().get_image()
				for y in [0, resolution.y - 1]:
					var has_scenery := false
					for x in range(0, resolution.x, 32):
						var pixel := rendered.get_pixel(x, y)
						has_scenery = has_scenery or maxf(pixel.r, maxf(pixel.g, pixel.b)) > 0.03
					check(has_scenery, "No black bar on edge " + str(y) + " in state " + str(i))
				if resolution.x == 1920 or i == 0:
					rendered.save_png("res://build/home_widescreen_%d_state_%d.png" % [resolution.x, i])
	print("HOME WIDESCREEN: %d checks, %d failures" % [checks, failures.size()])
	get_tree().quit(0 if failures.is_empty() else 1)
