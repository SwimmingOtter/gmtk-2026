shader_type canvas_item;

uniform float progression : hint_range(0.0, 1.0, 0.01) = 0.0;
uniform vec4 modulate : source_color = vec4(1.0);

float flash() {
	return min(1.3*sin(progression*PI), 1.0);
}


void fragment() {
	vec4 color = texture(TEXTURE, UV);
	COLOR = mix(color, modulate, modulate * color.a * flash());
}
