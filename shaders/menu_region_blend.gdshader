shader_type canvas_item;

// Blend the narrow margin around an atlas button into the shared background.
uniform vec2 region_size = vec2(410.0, 71.0);
varying vec2 local_position;

void vertex() {
	local_position = VERTEX;
}

void fragment() {
	vec2 edge = min(local_position, region_size - local_position);
	vec2 fade = smoothstep(vec2(0.0), vec2(16.0, 4.0), edge);
	COLOR = texture(TEXTURE, UV);
	COLOR.a *= fade.x * fade.y;
}
