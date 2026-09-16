shader_type canvas_item;
render_mode unshaded;
uniform float clock = 0.0;
uniform float pulse = 0.0;
uniform float replenishing = 0.0;

void fragment() {
	vec4 base = COLOR;
	float grain = fract(sin(dot(floor(UV * vec2(860.0, 28.0)), vec2(12.9898, 78.233))) * 43758.5453);
	float bevel = 0.78 + 0.23 * sin(UV.y * 3.14159);
	float glint = 0.09 * (1.0 - smoothstep(0.0, 0.25, UV.y));
	float breathing = 1.0 - pulse * (0.5 + 0.5 * sin(clock * 3.2));
	float sweep = pow(max(0.0, 1.0 - abs(UV.x - fract(clock * 0.32)) * 9.0), 3.0);
	COLOR = vec4(base.rgb * (bevel + grain * 0.13 + glint) * breathing + base.rgb * sweep * replenishing * 0.38, base.a);
}
