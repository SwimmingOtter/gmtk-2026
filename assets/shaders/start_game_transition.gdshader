shader_type canvas_item;

uniform float progression : hint_range(0.0, 1.0, 0.01) = 0.0;
uniform vec2 position_offset = vec2(0.5, 0.5);

uniform float ellipsis_a: hint_range(0.0, 1.0, 0.01) = 0.3;
uniform float ellipsis_b: hint_range(0.0, 1.0, 0.01) = 0.15;

uniform float opening_speed: hint_range(0.0, 100.0, 0.1) = 10.0;

float ellipse(vec2 uv, float scale_a, float scale_b) {
	uv -= position_offset;
	return pow(uv.x,2)/pow(ellipsis_a+progression*scale_a,2) + pow(uv.y,2)/pow(ellipsis_b+progression*scale_b,2);
}

bool is_in_ellipsis(vec2 uv, float scale_a, float scale_b) {
	return ellipse(uv, scale_a, scale_b) < 1.0;
}

void fragment() {
	//if (is_in_ellipsis(UV, opening_speed, opening_speed)) {
		//COLOR.a = 0.0;
	//} else {
		//COLOR.a = ellipse(UV, opening_speed, opening_speed);
	//}
	COLOR.a = ellipse(UV, opening_speed, opening_speed);
}
