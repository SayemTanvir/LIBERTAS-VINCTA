extends "res://scripts/ui/menu_navigation.gd"

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	setup_navigation($PageContent)
	var menu = add_page("menu", preload("res://scenes/ui/pause_page.tscn"))
	menu.selected.connect(select)
	menu.back_requested.connect(back)
	for id in ["settings", "rules", "controls"]:
		var page = add_page(id, load("res://scenes/ui/" + id + "_page.tscn"))
		page.back_requested.connect(back)
	pages.rules.controls_requested.connect(func(): navigate("controls"))
	hide()
	process_mode = Node.PROCESS_MODE_DISABLED

func open() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	busy = false
	show()
	show_initial()

func back() -> void:
	if busy:
		return
	if current_id == "menu":
		resume_game()
	else:
		super.back()

func resume_game() -> void:
	var focus := get_viewport().gui_get_focus_owner()
	if focus != null:
		focus.release_focus()
	hide()
	process_mode = Node.PROCESS_MODE_DISABLED
	GameManager.block_ui_input()
	GameManager.resume()

func select(destination: String) -> void:
	match destination:
		"resume": resume_game()
		"checkpoint": leave_to(GameManager.restart_checkpoint)
		"home": leave_to(GameManager.go_home)
		_: navigate(destination)
