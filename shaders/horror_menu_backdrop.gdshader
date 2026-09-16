shader_type canvas_item;
render_mode unshaded;

// One scenery sample; the slow haze never moves the UI or camera.
uniform float atmosphere_clock = 0.0;
uniform float atmosphere_strength = 1.0;
varying vec4 canvas_tint;

void vertex() {
	canvas_tint = COLOR;
}

void fragment() {
	// Composite the artwork's shadow alpha over black before the page fade.
	// This keeps scenery opaque without suppressing inherited reveal opacity.
	vec4 scene = texture(TEXTURE, UV);
	scene.rgb *= scene.a;
	float t = atmosphere_clock;
	float floor_mask = smoothstep(0.58, 0.94, UV.y) * (1.0 - smoothstep(0.95, 1.0, UV.y));
	float mist = sin(UV.x * 13.0 + UV.y * 5.0 - t * 0.065) * sin(UV.x * 7.0 - UV.y * 11.0 + t * 0.043);
	float grain = fract(sin(dot(floor(UV / TEXTURE_PIXEL_SIZE), vec2(12.9898, 78.233))) * 43758.5453) - 0.5;
	float edge = smoothstep(0.27, 0.74, length((UV - 0.5) * vec2(1.0, 0.85)));
	scene.rgb *= 1.0 - edge * 0.13;
	scene.rgb *= 1.0 + sin(t * 0.29) * 0.009 * atmosphere_strength;
	scene.rgb += vec3(0.027, 0.035, 0.042) * (mist * 0.5 + 0.5) * floor_mask * atmosphere_strength;
	scene.rgb += grain * 0.003;
	COLOR = vec4(scene.rgb, 1.0) * canvas_tint;
}
