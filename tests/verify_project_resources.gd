extends Node
var checked := 0
var failures := 0

func _ready() -> void:
	for path in ["res://scripts", "res://scenes", "res://shaders"]:
		inspect(path)
	print("PROJECT RESOURCES: %d resources, %d failures" % [checked, failures])
	get_tree().quit(0 if failures == 0 else 1)

func inspect(path: String) -> void:
	var directory := DirAccess.open(path)
	for name in directory.get_files():
		if name.get_extension() not in ["gd", "tscn", "gdshader"]:
			continue
		checked += 1
		var resource := load(path.path_join(name))
		if resource == null or (resource is GDScript and not resource.can_instantiate()):
			failures += 1
			push_error("Cannot load " + path.path_join(name))
	for folder in directory.get_directories():
		inspect(path.path_join(folder))
