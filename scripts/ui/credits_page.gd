extends "res://scripts/ui/menu_sheet.gd"
var team_labels: Array[Label] = []

func _ready() -> void:
	build_sheet("Credits", "Team 4's Compliment", [
		{"id": "back", "label": "‹  Back", "rect": Rect2(84, 620, 160, 46)}])
	section("The people behind Hollowmere", 84, 257)
	var team := [["Sajib", "Redesign / Direction"], ["Ifat", "Assets / Implementation"], ["Ramim", "Godot Implementation / Story Designer"], ["Tanvir", "Visuals / Sound Effects"]]
	for i in team.size():
		team_labels.append(Style.label(design, team[i][0], Rect2(84, 299 + i * 69, 130, 30), 24, Style.PAPER, true))
		team_labels.append(Style.label(design, team[i][1], Rect2(230, 299 + i * 69, 396, 40), 15, Style.MUTED))
	section("Made with Godot", 684, 257)
	paragraph("An estate built from many hands", "Godot 4.7. Player artwork and selected scenery use AI-generated assets. Additional artwork and recordings were supplied by the project owner.", 684, 300)
	var credit := Style.label(design, "Food & Drink 2D Mega Props Pack — nacl1234\nAntons_Footsteps wood recordings\n\nAsset provenance and license details are recorded in the project's asset credits.", Rect2(684, 455, 512, 112), 15, Style.MUTED)
	credit.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	selected.connect(func(_id: String): back_requested.emit())
