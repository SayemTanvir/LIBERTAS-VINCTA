extends RefCounted
## Preserve the generated source and cache alpha-masked crops for the whole session.
static var cache: Dictionary = {}

static func texture(source: Texture2D, region: Rect2i, seeds: Array) -> AtlasTexture:
	var key := source.resource_path + str(region)
	if cache.has(key):
		return cache[key]
	var picture := source.get_image().get_region(region)
	picture.convert(Image.FORMAT_RGBA8)
	var w := picture.get_width()
	var h := picture.get_height()
	var queue: Array[Vector2i] = []
	for x in w:
		queue.append(Vector2i(x, 0))
		queue.append(Vector2i(x, h - 1))
	for y in h:
		queue.append(Vector2i(0, y))
		queue.append(Vector2i(w - 1, y))
	for point in seeds:
		queue.append(Vector2i(point[0], point[1]))
	var seen := PackedByteArray()
	seen.resize(w * h)
	while not queue.is_empty():
		var p: Vector2i = queue.pop_back()
		if p.x < 0 or p.y < 0 or p.x >= w or p.y >= h:
			continue
		var i := p.y * w + p.x
		if seen[i]:
			continue
		seen[i] = 1
		var c := picture.get_pixelv(p)
		var lo := minf(c.r, minf(c.g, c.b))
		var hi := maxf(c.r, maxf(c.g, c.b))
		if c.a > 0.01 and (lo < 0.67 or hi - lo > 0.075):
			continue
		picture.set_pixelv(p, Color.TRANSPARENT)
		for step: Vector2i in [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]:
			queue.append(p + step)
	var atlas := AtlasTexture.new()
	atlas.atlas = ImageTexture.create_from_image(picture)
	atlas.region = picture.get_used_rect()
	atlas.filter_clip = true
	cache[key] = atlas
	return atlas
