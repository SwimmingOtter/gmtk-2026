shader_type canvas_item;

uniform float central_blob_width : hint_range(0.0, 2.0, 0.1) = 1.0;
uniform float central_blob_height : hint_range(0.0, 2.0, 0.1) = 1.0;
uniform sampler2D noise_texture : source_color, filter_nearest, repeat_enable;

void fragment() {
	if(length(vec2(pow(cos((UV.x)*PI),2)*central_blob_width, pow(sin((UV.y+0.5)*PI), 2)*central_blob_height)) > 0.4) {
		COLOR.a = clamp(texture(noise_texture, UV + vec2(0.05,0.1) * TIME).r, 0.4, 0.6)+0.1;
	}
}
