extends Node
## Settled visual captures, render cost, and repeated live pause/resume checks.
var checks := 0
var failures := 0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	AudioServer.set_bus_mute(0, true)
	GameManager.save_path = "res://build/horror_menu_test_save.json"
	_run.call_deferred()

func check(value: bool, description: String) -> void:
	checks += 1
	if not value:
		failures += 1
		push_error(description)

func settle(seconds := 0.55) -> void:
	await get_tree().create_timer(seconds).timeout

func capture(label: String) -> void:
	if DisplayServer.get_name() != "headless":
		await RenderingServer.frame_post_draw
		check(get_viewport().get_texture().get_image().save_png("res://build/horror_" + label + ".png") == OK, "Capture " + label)

func render_cost() -> Vector2:
	var cpu: Array[float] = []
	var gpu: Array[float] = []
	for index in 90:
		await RenderingServer.frame_post_draw
		if index >= 30:
			cpu.append(RenderingServer.viewport_get_measured_render_time_cpu(get_viewport().get_viewport_rid()))
			gpu.append(RenderingServer.viewport_get_measured_render_time_gpu(get_viewport().get_viewport_rid()))
	cpu.sort()
	gpu.sort()
	return Vector2(cpu[cpu.size() / 2], gpu[gpu.size() / 2])

func _run() -> void:
	get_window().size = Vector2i(1280, 720)
	var home: Control = preload("res://scenes/ui/main_menu.tscn").instantiate()
	add_child(home)
	home.focus_default()
	await settle()
	await capture("menu_focus")
	for button in home.buttons:
		button.release_focus()
	await settle()
	await capture("menu_neutral")
	if DisplayServer.get_name() != "headless":
		RenderingServer.viewport_set_measure_render_time(get_viewport().get_viewport_rid(), true)
		var atmosphere: ShaderMaterial = home.artwork.material
		# Clock updates can continue in the material while it is temporarily detached.
		home.set_process(false)
		home.artwork.material = null
		var baseline: Vector2 = await render_cost()
		home.artwork.material = atmosphere
		home.set_process(true)
		var animated: Vector2 = await render_cost()
		print("HORROR MENU RENDER at 1280x720 median CPU/GPU ms: static=%s atmosphere=%s" % [baseline, animated])
	home.hide()
	var stopped: float = home.atmosphere_clock
	await settle(0.1)
	check(is_equal_approx(stopped, home.atmosphere_clock), "Hidden menu stops atmosphere updates")
	home.queue_free()
	await settle(0.1)
	FreedomLedger.reset()
	GameManager.state = GameManager.State.PLAYING
	GameManager.zone = "ground"
	GameManager.entry = "start"
	GameManager.arrival_pending = false
	GameManager.respawn_pending = false
	var main: Node2D = preload("res://scenes/main/main.tscn").instantiate()
	add_child(main)
	await settle()
	var player: CharacterBody2D = main.get_node("Entities/Player")
	var hud: CanvasLayer = main.get_node("UI")
	var enemy: Node2D = get_tree().get_first_node_in_group("enemy")
	for cycle in 3:
		GameManager.pause_game()
		hud.show_pause()
		var position: Vector2 = player.position
		var enemy_position: Vector2 = enemy.position
		var battery: float = FreedomLedger.flashlight_seconds
		Input.action_press("move_right")
		await settle()
		check(get_tree().paused and player.position == position and enemy.position == enemy_position, "Pause freezes player and hound, cycle " + str(cycle))
		check(FreedomLedger.flashlight_seconds == battery, "Pause freezes battery consumption")
		check(is_equal_approx(hud.pause_menu.current.modulate.a, 1.0), "Pause reveal finishes while tree is paused")
		if cycle == 0:
			await capture("pause")
			for resolution in [Vector2i(800, 600), Vector2i(2560, 1080)]:
				get_window().size = resolution
				await settle()
				var page: Control = hud.pause_menu.current
				var screen := get_viewport().get_visible_rect()
				for button in page.buttons:
					check(screen.encloses(button.get_global_rect()), "Pause button fits " + str(resolution))
				for label: Label in page.design.find_children("*", "Label", true, false):
					check(screen.encloses(label.get_global_rect()), "Pause text fits " + str(resolution))
				await capture("pause_" + str(resolution.x))
			get_window().size = Vector2i(1280, 720)
		Input.action_release("move_right")
		hud.pause_menu.resume_game()
		await settle(0.1)
		check(not get_tree().paused and GameManager.state == GameManager.State.PLAYING and not hud.pause_menu.visible, "Resume restores gameplay without overlay")
	main.queue_free()
	await settle(0.1)
	print("HORROR MENUS: %d checks, %d failures" % [checks, failures])
	get_tree().quit(0 if failures == 0 else 1)
