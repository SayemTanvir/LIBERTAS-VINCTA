extends Control
## Native slider tracks, numerical values and explicit on/off switches.
const Style := preload("res://scripts/ui/ui_style.gd")
var menu: Control

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func ink(text: String, rect: Rect2, color: Color = Style.PAPER, font_size: int = 16) -> void:
	var font := get_theme_default_font()
	var at := rect.position + Vector2(0, (rect.size.y - font.get_height(font_size)) * 0.5 + font.get_ascent(font_size))
	draw_string(font, at, text, HORIZONTAL_ALIGNMENT_CENTER, rect.size.x, font_size, color)

func _draw() -> void:
	if menu == null:
		return
	for index in menu.AUDIO:
		var pos: Vector2 = menu.buttons[index].position
		var value: float = SessionSettings.volumes[menu.AUDIO[index]]
		var start := pos + Vector2(228, 26)
		draw_line(start, start + Vector2(192, 0), Style.RULE, 3, true)
		draw_line(start, start + Vector2(192 * value, 0), Style.BRASS, 3, true)
		draw_circle(start + Vector2(192 * value, 0), 5, Style.PAPER, true, -1, true)
		ink("%d%%" % roundi(value * 100), Rect2(pos + Vector2(430, 0), Vector2(66, 52)))
	var res_pos: Vector2 = menu.buttons[3].position
	ink("‹", Rect2(res_pos + Vector2(247, 0), Vector2(32, 52)), Style.BRASS, 24)
	ink("%d × %d" % [SessionSettings.resolution.x, SessionSettings.resolution.y], Rect2(res_pos + Vector2(274, 0), Vector2(191, 52)))
	ink("›", Rect2(res_pos + Vector2(468, 0), Vector2(28, 52)), Style.BRASS, 24)
	var toggles := {4: SessionSettings.fullscreen, 5: SessionSettings.screen_shake, 7: SessionSettings.subtitles_enabled}
	for index in toggles:
		var pos: Vector2 = menu.buttons[index].position
		var enabled: bool = toggles[index]
		ink("On" if enabled else "Off", Rect2(pos + Vector2(357, 0), Vector2(56, 52)), Style.PAPER if enabled else Style.MUTED)
		var box := Style.panel(Color("2b3938") if enabled else Color("1c2228"), Style.BRASS if enabled else Style.RULE, 0)
		draw_style_box(box, Rect2(pos + Vector2(433, 15), Vector2(52, 23)))
		draw_rect(Rect2(pos + Vector2(464 if enabled else 437, 19), Vector2(16, 15)), Style.PAPER if enabled else Style.MUTED)
