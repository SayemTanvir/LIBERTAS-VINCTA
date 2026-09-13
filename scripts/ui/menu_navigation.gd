extends Control
## Shared context stack; pages and textures stay cached until leaving this host.
var pages: Dictionary = {}
var current: Control
var current_id: String = ""
var history: Array[String] = []
var busy: bool = false
var page_root: Control

func setup_navigation(host: Control) -> void:
	page_root = host
	add_child(preload("res://scripts/ui/ui_audio.gd").new())

func add_page(id: String, packed: PackedScene, pause_context: bool = false) -> Control:
	var page: Control = packed.instantiate()
	if id == "menu":
		page.pause_context = pause_context
	page.hide()
	page.process_mode = Node.PROCESS_MODE_DISABLED
	page_root.add_child(page)
	pages[id] = page
	return page

func show_initial() -> void:
	history.clear()
	_switch("menu")
	current.set_selection(0, false)

func navigate(id: String) -> void:
	if busy or id == current_id or not pages.has(id):
		return
	history.append(current_id)
	_switch(id)

func back() -> void:
	if busy or history.is_empty():
		return
	_switch(history.pop_back())

func _switch(id: String) -> void:
	if current != null:
		var focus := get_viewport().gui_get_focus_owner()
		if focus != null:
			focus.release_focus()
		current.hide()
		current.process_mode = Node.PROCESS_MODE_DISABLED
	current = pages[id]
	current_id = id
	current.process_mode = Node.PROCESS_MODE_INHERIT
	current.show()
	current.focus_default()

func leave_to(callback: Callable) -> void:
	if busy:
		return
	busy = true
	current.process_mode = Node.PROCESS_MODE_DISABLED
	callback.call_deferred()

func _input(_event: InputEvent) -> void:
	if busy:
		get_viewport().set_input_as_handled()
