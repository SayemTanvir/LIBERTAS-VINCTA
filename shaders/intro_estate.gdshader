shader_type canvas_item;
render_mode unshaded;

uniform sampler2D house_sheet : filter_linear, repeat_disable;
uniform sampler2D storm_sheet : filter_linear, repeat_disable;
uniform sampler2D lightning_sheet : filter_linear, repeat_disable;
uniform vec4 house_a;
uniform vec4 house_b;
uniform float dissolve = 0.0;
uniform float elapsed = 0.0;
uniform float strike = 0.0;
uniform float approach = 0.0;

vec3 house(vec2 uv, vec4 region) {
	vec4 art = texture(house_sheet, (region.xy + clamp(uv, vec2(0.002), vec2(0.998)) * region.zw) / vec2(1536.0, 1024.0));
	vec3 sky = mix(vec3(0.037, 0.055, 0.069), vec3(0.015, 0.024, 0.032), clamp(uv.y, 0.0, 1.0));
	// The supplied sheet has noisy low-alpha RGB around the skyline. Composite it
	// over our sky instead of exposing those otherwise invisible rectangular blocks.
	return mix(sky, art.rgb, smoothstep(0.12, 0.88, art.a));
}

vec3 weather(vec2 uv, float frame) {
	vec2 cell = vec2(mod(frame, 4.0), floor(frame / 4.0));
	// Interior crops exclude the sheet's ragged borders and neighboring cells.
	return texture(storm_sheet, (cell * vec2(313.5, 627.0) + vec2(38.0, 55.0) + uv * vec2(232.0, 505.0)) / 1254.0).rgb;
}

void fragment() {
	vec2 p = UV * vec2(1280.0, 720.0);
	float zoom = mix(1.0, 1.085, approach);
	vec2 h = ((p - vec2(880.0, 388.0)) / zoom + vec2(380.0, 370.0)) / vec2(760.0, 740.0);
	float edge = smoothstep(0.0, 0.29, h.x) * (1.0 - smoothstep(0.96, 1.08, h.x));
	vec3 base = mix(vec3(0.018, 0.029, 0.036), mix(house(h, house_a), house(h, house_b), dissolve), edge);
	// A traveling layer from the supplied rain/mist sheet, softly tiled at the edges.
	vec2 w = vec2(fract(UV.x * 3.1 + elapsed * 0.008), fract(UV.y * 0.83 + elapsed * 0.019));
	float seam = smoothstep(0.0, 0.15, w.x) * (1.0 - smoothstep(0.85, 1.0, w.x));
	seam *= smoothstep(0.0, 0.14, w.y) * (1.0 - smoothstep(0.86, 1.0, w.y));
	float phase = elapsed * 0.32;
	float f = mod(floor(phase), 3.0);
	vec3 rain = mix(weather(w, f), weather(w, mod(f + 1.0, 3.0)), smoothstep(0.0, 1.0, fract(phase)));
	base += rain * seam * (0.12 + 0.18 * smoothstep(0.42, 0.95, UV.y));
	vec2 bolt_uv = (p - vec2(790.0, 45.0)) / vec2(325.0, 490.0);
	vec4 bolt = texture(lightning_sheet, (vec2(320.0, 8.0) + clamp(bolt_uv, vec2(0.0), vec2(1.0)) * vec2(275.0, 505.0)) / 1254.0);
	float bolt_edge = smoothstep(0.0, 0.12, bolt_uv.x) * (1.0 - smoothstep(0.85, 1.0, bolt_uv.x));
	bolt_edge *= smoothstep(0.0, 0.1, bolt_uv.y) * (1.0 - smoothstep(0.85, 1.0, bolt_uv.y));
	base += bolt.rgb * bolt.a * bolt_edge * strike * 0.7;
	base += vec3(0.10, 0.14, 0.19) * strike * edge;
	// Reserve a quiet, readable area for the titles; retain the warm house windows.
	base *= mix(0.30, 0.92, smoothstep(0.06, 0.67, UV.x));
	float vignette = 1.0 - 0.40 * smoothstep(0.30, 0.76, distance(UV, vec2(0.55, 0.45)));
	COLOR = vec4(base * vignette, 1.0);
}
