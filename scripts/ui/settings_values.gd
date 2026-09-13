extends Control
## Live values and controls drawn from the restored full-resolution artwork.
var source: Texture2D
var paper_source: Texture2D
var serif: SystemFont

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	serif = SystemFont.new()
	serif.font_names = PackedStringArray(["Georgia", "Times New Roman"])

func paper(rect: Rect2) -> void:
	# Restore the exact matching clean pixels, never a stretched paper swatch.
	draw_texture_rect_region(paper_source, rect, rect)

func diamond(center: Vector2) -> void:
	var offsets := PackedVector2Array([Vector2(0, -20), Vector2(19, 0), Vector2(0, 21), Vector2(-18, 0)])
	var points := PackedVector2Array()
	var uvs := PackedVector2Array()
	for offset in offsets:
		points.append(center + offset)
		uvs.append((Vector2(940, 329) + offset) / source.get_size())
	draw_colored_polygon(points, Color.WHITE, uvs, source)

func ink(value: String, rect: Rect2, font_size: int = 26) -> void:
	var baseline := rect.position + Vector2(0, (rect.size.y - serif.get_height(font_size)) * 0.5 + serif.get_ascent(font_size))
	draw_string(serif, baseline, value, HORIZONTAL_ALIGNMENT_CENTER, rect.size.x, font_size, Color(0.12, 0.055, 0.025))

func _draw() -> void:
	if source == null or serif == null:
		return
	for i in 3:
		var y := 329.0 + i * 64.0
		var volume: float = SessionSettings.volumes[["Master", "Music", "SFX"][i]]
		paper(Rect2(782, y - 29, 239, 58))
		# Rebuild the track from its empty part and original engraved end caps.
		draw_texture_rect_region(source, Rect2(802, y - 9, 196, 18), Rect2(973, 320, 21, 18))
		draw_texture_rect_region(source, Rect2(790, y - 12, 18, 24), Rect2(790, 317, 18, 24))
		draw_texture_rect_region(source, Rect2(997, y - 12, 18, 24), Rect2(997, 317, 18, 24))
		if volume > 0:
			draw_texture_rect_region(source, Rect2(802, y - 5, 196 * volume, 10), Rect2(811, 324, 90, 10))
		diamond(Vector2(802 + 196 * volume, y))
		paper(Rect2(1027, y - 20, 74, 40))
		ink(str(roundi(volume * 100)) + "%", Rect2(1027, y - 17, 74, 35), 24)
	paper(Rect2(837, 540, 196, 39))
	var resolution: Vector2i = SessionSettings.resolution
	ink("%d x %d" % [resolution.x, resolution.y], Rect2(842, 541, 187, 36), 25)
	for i in 2:
		var y := 626.0 + i * 64
		var enabled: bool = SessionSettings.fullscreen if i == 0 else SessionSettings.screen_shake
		# Preserve the outer gold checkbox; cover only the baked checkmark.
		paper(Rect2(814, y - 17, 33, 35))
		if enabled:
			draw_texture_rect_region(source, Rect2(817, y - 13, 26, 27), Rect2(817, 613, 26, 27))
		paper(Rect2(871, y - 20, 87, 40))
		ink("On" if enabled else "Off", Rect2(873, y - 18, 82, 36))
