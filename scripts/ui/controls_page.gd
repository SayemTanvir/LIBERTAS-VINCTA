extends "res://scripts/ui/menu_sheet.gd"

func _ready() -> void:
	build_sheet("Controls", "Keep these close. The field guide is always available during play.", [
		{"id": "back", "label": "‹  Back", "rect": Rect2(84, 620, 160, 46)}])
	section("Movement & survival", 84, 256)
	section("Tools & reading", 684, 256)
	var rows := [["W A S D / Arrows", "Move"], ["Shift", "Sprint"], ["Ctrl", "Crouch"], ["E", "Interact / leave hiding"], ["F", "Toggle flashlight"], ["B", "Hold breath"], ["Q", "Use gadget / battery"], ["R", "Cast sigil, when unlocked"], ["T", "Stun rite, when unlocked"], ["Tab", "Inventory"], ["H", "Field guide"], ["Esc", "Pause / back"]]
	for i in rows.size():
		var x := 84.0 if i < 6 else 684.0
		var y := 296.0 + (i % 6) * 46.0
		Style.keycap(design, rows[i][0], Rect2(x, y, 154, 32))
		Style.label(design, rows[i][1], Rect2(x + 174, y, 338, 32), 16)
	footer_label.text = "Letters: ↑ ↓ / Wheel to scroll    ·    E / Enter / Esc to close"
	selected.connect(func(_id: String): back_requested.emit())
