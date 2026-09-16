extends Node
func _ready() -> void:
	var checks := 0
	var failures := 0
	for zone in ["ground", "upper"]:
		var room = load("res://scenes/levels/" + zone + "_floor.tscn").instantiate()
		add_child(room)
		for name in ["BrokenGlass", "CarpetBypass", "LinenShadowLane"]:
			var node = room.get_node_or_null("Backdrop/" + name)
			if node != null:
				checks += 1
				if node.visible:
					failures += 1
		room.queue_free()
	print("GAP 4: %d checks, %d failures; Path B removes misleading strips" % [checks, failures])
	get_tree().quit(0 if failures == 0 else 1)
