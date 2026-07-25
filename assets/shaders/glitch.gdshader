shader_type canvas_item;

uniform float strength = 8.0;
uniform float burst_chance : hint_range(0.0, 10.0, 0.1) = 1.0;

float hash(float x) {
    return fract(sin(x) * 43758.5453123);
}

void vertex() {
    float band = floor(UV.y * 20.0);
	float trigger = step(0.92 / burst_chance, fract(sin(floor(TIME * 8.0)) * 12345.678 ));
    float offset = (hash(band + floor(TIME * 20.0)) - 0.5) * strength;
    VERTEX.x += offset * trigger;
}