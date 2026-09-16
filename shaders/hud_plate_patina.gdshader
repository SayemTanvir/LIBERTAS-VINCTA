shader_type canvas_item;
render_mode unshaded;
varying vec4 canvas_tint;

void vertex() {
	canvas_tint = COLOR;
}

// Match the estate's charcoal, aged brass and cold teal without changing source art.
void fragment() {
	vec4 plate = texture(TEXTURE, UV);
	float luminance = dot(plate.rgb, vec3(0.2126, 0.7152, 0.0722));
	vec3 aged = mix(vec3(luminance), plate.rgb, 0.22);
	vec3 charcoal = mix(vec3(0.025, 0.040, 0.046), aged * vec3(0.38, 0.39, 0.40), 0.76);
	vec2 edge = min(UV, vec2(1.0) - UV);
	float feather = smoothstep(0.0, 0.028, edge.x) * smoothstep(0.0, 0.045, edge.y);
	COLOR = vec4(charcoal, plate.a * feather * 0.97) * canvas_tint;
}
