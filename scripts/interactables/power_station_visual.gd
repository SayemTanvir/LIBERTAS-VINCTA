extends Sprite2D
## The supplied JPEG contains a painted checkerboard, not real transparency.
## Mask only background connected to the crop edges and the cable gaps.
const SHEET := preload("res://assets/environment/props/estate_essentials/powerstation.jpg")
const REGIONS := [Rect2i(0, 55, 378, 340), Rect2i(380, 548, 378, 340), Rect2i(758, 548, 363, 340)]
static var frames: Array[Texture2D] = []
var station: BaseInteractable
var state := -1

func _ready() -> void:
	if frames.is_empty():
		var sheet := SHEET.get_image()
		for region in REGIONS:
			frames.append(_cutout(sheet.get_region(region)))
	texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	set_meta("estate_asset", "power_station")
	_process(0.0)

static func _cutout(picture: Image) -> Texture2D:
	picture.convert(Image.FORMAT_RGBA8)
	var width := picture.get_width()
	var height := picture.get_height()
	var pending: Array[Vector2i] = []
	for x in width:
		pending.append(Vector2i(x, 0))
		pending.append(Vector2i(x, height - 1))
	for y in height:
		pending.append(Vector2i(0, y))
		pending.append(Vector2i(width - 1, y))
	# Enclosed empty spaces between leads beneath the case.
	pending.append_array([Vector2i(177, 274), Vector2i(251, 267), Vector2i(330, 253)])
	var visited := PackedByteArray()
	visited.resize(width * height)
	while not pending.is_empty():
		var point: Vector2i = pending.pop_back()
		if point.x < 0 or point.x >= width or point.y < 0 or point.y >= height:
			continue
		var index := point.y * width + point.x
		if visited[index]:
			continue
		visited[index] = 1
		var pixel := picture.get_pixelv(point)
		var low := minf(pixel.r, minf(pixel.g, pixel.b))
		var high := maxf(pixel.r, maxf(pixel.g, pixel.b))
		if low < 0.58 or high - low > 0.14:
			continue
		picture.set_pixelv(point, Color.TRANSPARENT)
		for step: Vector2i in [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]:
			pending.append(point + step)
	return ImageTexture.create_from_image(picture)

func _process(_delta: float) -> void:
	if not is_instance_valid(station):
		return
	var full := FreedomLedger.flashlight_charge >= FreedomLedger.MAX_CHARGE and (FreedomLedger.current_part == 1 or FreedomLedger.hp >= FreedomLedger.max_hp)
	var next := 2 if full else (1 if station.busy else 0)
	if next == state:
		return
	state = next
	texture = frames[state]
	scale = Vector2.ONE * 32.0 / texture.get_width()
	offset = Vector2(0, -texture.get_height() * 0.5)
