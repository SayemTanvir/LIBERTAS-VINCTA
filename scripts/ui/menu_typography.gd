extends RefCounted
## Local menu/intro theme. Never modify the shared gameplay theme resource.
const TITLE := preload("res://assets/fonts/horroroid/horroroid.ttf")
const BODY_SIZE_SCALE := 1.2
static var BODY: FontFile = preload("res://assets/fonts/horror_comics_demo/HorrorComicsDemoMenuLetters.ttf").duplicate()
static var cached: Theme

static func body_size(size: int) -> int:
	return maxi(14, roundi(size * BODY_SIZE_SCALE))

static func enlarge_body(root: Node) -> void:
	# Called after each menu finishes building, including its page-specific text.
	# Font identity excludes Horroroid headings and any gameplay-font controls.
	if root is Label or root is Button or root is RichTextLabel:
		var rich := root is RichTextLabel
		var font: Font = root.get_theme_font("normal_font" if rich else "font")
		while font is FontVariation:
			font = font.base_font
		if font == BODY and not root.has_meta("menu_body_enlarged"):
			var key := "normal_font_size" if rich else "font_size"
			root.add_theme_font_size_override(key, body_size(root.get_theme_font_size(key)))
			root.set_meta("menu_body_enlarged", true)
	for child in root.get_children():
		enlarge_body(child)

static func menu_theme() -> Theme:
	if cached == null:
		# Demo numerals/punctuation are placeholder art. Use the existing serif for
		# those characters so settings percentages and controls remain meaningful.
		BODY.fallbacks = [preload("res://scripts/ui/ui_style.gd").serif()]
		cached = preload("res://themes/libertas_ui_theme.tres").duplicate()
		cached.default_font = BODY
		for type in ["Label", "Button", "CheckButton", "MenuText", "StoryBody"]:
			cached.set_font("font", type, BODY)
		for type in ["GameTitle", "PageTitle"]:
			cached.set_font("font", type, TITLE)
		for key in ["normal_font", "bold_font", "italics_font", "bold_italics_font", "mono_font"]:
			cached.set_font(key, "RichTextLabel", BODY)
	return cached
