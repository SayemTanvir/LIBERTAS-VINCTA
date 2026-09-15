shader_type canvas_item;

uniform sampler2D frame_masks : filter_nearest, repeat_disable;
uniform float clip_id = 1.0;

void fragment() {
	float frame_id = round(texture(frame_masks, UV).r * 255.0);
	COLOR.a *= abs(frame_id - clip_id) < 0.5 ? 1.0 : 0.0;
}
