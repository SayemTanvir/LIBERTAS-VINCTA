extends "res://scripts/ui/menu_sheet.gd"
@export var chapter: bool = false
var outcome_label: Label

func _ready() -> void:
	var primary := "continue" if chapter else "retry"
	build_sheet("Chapter complete" if chapter else "The estate claims you", "Every freedom has a price." if chapter else "Your last checkpoint is waiting.", [
		{"id": primary, "label": "Continue  ›" if chapter else "Retry checkpoint  ›", "rect": Rect2(84, 451, 370, 56)},
		{"id": "home", "label": "Main menu", "rect": Rect2(84, 523, 370, 52)}], "LIBERTAS VINCTA  /  " + ("A FATE WRITTEN" if chapter else "A LIFE INTERRUPTED"))
	outcome_label = Style.label(design, "", Rect2(84, 290, 850, 52), 30, Style.BRASS, true)
	Style.label(design, "", Rect2(84, 355, 1000, 52), 17, Style.MUTED).name = "OutcomeDetail"
	footer_label.text = "↑ ↓  Navigate     Enter  Select"

func focus_default() -> void:
	var final_ending := GameManager.ending in ["severance", "custodian_rest", "vessel"]
	if chapter:
		heading_label.text = "A fate written" if final_ending else "Chapter complete"
		outcome_label.text = {"untouched": "Untouched", "partial_mercy": "Partial Mercy", "vantree": "Vantree", "severance": "Severance", "custodian_rest": "Custodian's Rest", "vessel": "Vessel"}.get(GameManager.ending, "Libertas Vincta")
		buttons[0].text = "Begin again  ›" if final_ending else "Continue to Part II  ›"
		design.get_node("OutcomeDetail").text = "The story is complete. Another choice waits at the beginning." if final_ending else "Beyond Hollowmere, the consequences of your choices remain."
	else:
		outcome_label.text = "Caught in Hollowmere"
		design.get_node("OutcomeDetail").text = "Retry restores your health, belongings and progress from the last checkpoint."
	super.focus_default()
