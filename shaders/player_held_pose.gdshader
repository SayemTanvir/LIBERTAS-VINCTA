shader_type canvas_item;
uniform bool holding_light = false;
uniform bool crouch_art = false;
uniform bool action_art = false;
void fragment() {
	if (action_art) {
		vec3 source = texture(TEXTURE, UV).rgb;
		// Non-destructive chroma key; the generated source remains untouched.
		float magenta = min(source.r - source.g, source.b - source.g);
		COLOR.a *= 1.0 - smoothstep(0.24, 0.48, magenta);
	}
	if (crouch_art) {
		vec3 sample_color = texture(TEXTURE, UV).rgb;
		float low = min(sample_color.r, min(sample_color.g, sample_color.b));
		float high = max(sample_color.r, max(sample_color.g, sample_color.b));
		// The generated source has a neutral checker backing; preserve the colored figure.
		COLOR.a *= 1.0 - smoothstep(0.36, 0.44, low) * (1.0 - smoothstep(0.055, 0.10, high - low));
	}
	// Animated legs below the original, steady upper-body holding pose.
	if (holding_light && fract(UV.y * 8.0) < 168.0 / 256.0) {
		COLOR.a = 0.0;
	}
}
