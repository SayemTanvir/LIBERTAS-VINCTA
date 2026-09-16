extends Node
func _ready() -> void:
	GameManager.save_path = "res://build/gap7_save.json"
	var failures := 0
	var checks := 0
	for zone in ["roots", "echoes", "nexus"]:
		FreedomLedger.reset()
		FreedomLedger.begin_part_two("untouched")
		GameManager.zone = zone
		GameManager.entry = "start"
		GameManager.state = GameManager.State.PLAYING
		var main = preload("res://scenes/main/main.tscn").instantiate()
		add_child(main)
		var enemy = get_tree().get_first_node_in_group("enemy")
		var player = main.get_node("Entities/Player")
		enemy.set_physics_process(false)
		player.position = Vector2(500 if zone == "nexus" else 2500, 580)
		enemy.position = player.position + Vector2(1, 0)
		for repeat in 4:
			enemy.hit_cooldown = 0.0
			enemy._resolve_contact()
			checks += 1
			if FreedomLedger.hp != FreedomLedger.max_hp or GameManager.state != GameManager.State.PLAYING or player.animation_state != "stagger":
				failures += 1
		checks += 1
		if not FreedomLedger.part2_seed.senses.is_empty() or FreedomLedger.part2_seed.touch_mutation:
			failures += 1
		main.free()
	print("GAP 7: %d checks, %d failures; Untouched remains nonlethal" % [checks, failures])
	get_tree().quit(0 if failures == 0 else 1)
