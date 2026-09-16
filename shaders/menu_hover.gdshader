shader_type canvas_item;
render_mode unshaded;

// Oxblood selection washes into the scenery; no backing exists when idle.
void fragment() {
	vec4 tint = COLOR;
	float wash = 1.0 - smoothstep(0.38, 1.0, UV.x);
	float rim = (1.0 - smoothstep(0.004, 0.008, UV.x)) * smoothstep(0.0, 0.18, UV.y) * (1.0 - smoothstep(0.82, 1.0, UV.y));
	COLOR = vec4(mix(tint.rgb, vec3(0.73, 0.27, 0.24), rim), tint.a * max(wash * 0.86, rim));
}
