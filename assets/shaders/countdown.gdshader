shader_type canvas_item;

uniform float progression : hint_range(0.0, 1.0, 0.01);
uniform float trail_size : hint_range(0.0, 10, 0.1) = 3.0;
uniform vec4 modulate : source_color = vec4(1.0);
uniform bool clean_loop = true;

void fragment() {
	if (UV.y < progression){
		float trail_coef = (1.0 - log(1.0 + (progression - UV.y) * trail_size));
		COLOR.rgba = max(COLOR.rgba, modulate * trail_coef);
	} else if (clean_loop) {
		float trail_coef = (1.0 - log(1.0 + (progression - UV.y + 1.0) * trail_size));
		COLOR.rgba = max(COLOR.rgba, modulate * trail_coef);
	}
}