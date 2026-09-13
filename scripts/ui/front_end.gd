extends "res://scripts/ui/menu_navigation.gd"

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	setup_navigation($PageContent)
	var menu = add_page("menu", preload("res://scenes/ui/main_menu.tscn"))
	menu.selected.connect(select)
	for id in ["settings", "rules", "controls", "credits"]:
		var page = add_page(id, load("res://scenes/ui/" + id + "_page.tscn"))
		page.back_requested.connect(back)
	pages.rules.controls_requested.connect(func(): navigate("controls"))
	show_initial()

func select(destination: String) -> void:
	match destination:
		"start": leave_to(GameManager.new_game)
		"continue": leave_to(GameManager.continue_game)
		"quit":
			if not OS.has_feature("web"):
				leave_to(get_tree().quit)
		_: navigate(destination)
