extends RefCounted
## Shared colors, type and surfaces for menus, reading and game feedback.
const INK := Color("0c1218")
const PAPER := Color("e7ddce")
const MUTED := Color("a99e91")
const BRASS := Color("a78a60")
const RULE := Color("51473c")
const RED := Color("994b4f")
const TEAL := Color("91b8b2")

static func serif() -> SystemFont:
	var font := SystemFont.new()
	font.font_names = PackedStringArray(["Georgia", "Times New Roman"])
	return font

static func tracked(base: Font, spacing: int = 2) -> FontVariation:
	var font := FontVariation.new()
	font.base_font = base
	font.spacing_glyph = spacing
	return font

static func label(parent: Node, text: String, rect: Rect2, font_size: int = 18, color: Color = PAPER, heading: bool = false) -> Label:
	var node := Label.new()
	node.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	node.text = text
	node.position = rect.position
	node.size = rect.size
	node.mouse_filter = Control.MOUSE_FILTER_IGNORE
	node.add_theme_font_size_override("font_size", font_size)
	node.add_theme_color_override("font_color", color)
	if heading:
		node.add_theme_font_override("font", serif())
	parent.add_child(node)
	return node

static func rule(parent: Node, rect: Rect2, color: Color = RULE) -> ColorRect:
	var node := ColorRect.new()
	node.position = rect.position
	node.size = rect.size
	node.color = color
	node.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(node)
	return node

static func panel(color: Color = INK, border: Color = RULE, padding: float = 16.0) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = color
	box.border_color = border
	box.set_border_width_all(1)
	box.set_corner_radius_all(2)
	box.content_margin_left = padding
	box.content_margin_right = padding
	box.content_margin_top = padding * 0.5
	box.content_margin_bottom = padding * 0.5
	return box

static func keycap(parent: Node, text: String, rect: Rect2) -> Label:
	var node := label(parent, text, rect, 13, PAPER)
	node.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	node.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	node.add_theme_stylebox_override("normal", panel(Color("151c22"), RULE, 6))
	return node
