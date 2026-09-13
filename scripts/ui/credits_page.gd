extends "res://scripts/ui/image_state_menu.gd"

func _ready() -> void:
	preload("res://scripts/ui/menu_art.gd").single(self, "10_Credits", "credits_final_corrected_back_active", Rect2(670, 802, 333, 93))
	# Only Ifat's contribution region changes; the original page stays intact.
	var contribution := Rect2(714, 350, 250, 30)
	texture_layer(region(preload("res://assets/BG/10_Credits/credits_contributions.png"), contribution), contribution)
	selected.connect(func(_id: String): back_requested.emit())
