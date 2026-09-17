shader_type canvas_item;

void fragment() {
	vec4 source = texture(TEXTURE, UV);
	// Transparent exports already contain alpha. This guard also suppresses any
	// residual fuchsia caused by an importer or texture-edge sampling change.
	float magenta_strength = min(source.r, source.b) - source.g;
	float chroma_alpha = 1.0 - smoothstep(0.03, 0.16, magenta_strength);
	COLOR = source * COLOR;
	COLOR.a *= chroma_alpha;
}
