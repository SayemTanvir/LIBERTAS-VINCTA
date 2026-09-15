shader_type canvas_item;
render_mode unshaded;

uniform float danger : hint_range(0.0, 1.0) = 0.0;
uniform float elapsed = 0.0;

void fragment() {
	vec2 p = (UV - vec2(0.5, 0.49)) * vec2(1.22, 1.0);
	float edge = smoothstep(0.24, 0.72, length(p));
	float breath = 0.96 + 0.04 * sin(elapsed * 2.3);
	float alpha = edge * (0.53 + danger * 0.24 * breath);
	vec3 tint = mix(vec3(0.008, 0.014, 0.025), vec3(0.13, 0.013, 0.023), danger * 0.66);
	COLOR = vec4(tint, alpha);
}
