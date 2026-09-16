shader_type canvas_item;
render_mode unshaded;
void fragment() {
	float sides = smoothstep(0.0, 0.12, UV.x) * (1.0 - smoothstep(0.88, 1.0, UV.x));
	float depth = smoothstep(0.0, 0.08, UV.y) * (1.0 - smoothstep(0.60, 1.0, UV.y));
	COLOR = vec4(0.48, 0.58, 0.68, sides * depth * 0.095);
}
