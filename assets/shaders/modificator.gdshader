shader_type canvas_item;

uniform bool flip_h = false;
uniform bool flip_v = false;
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

// These varyings safely track the rect bounds in 0.0-1.0 screen coordinate space
varying vec2 min_screen_uv;
varying vec2 max_screen_uv;

void vertex() {
    // Transform local corner coordinates (0,0 and VERTEX) into absolute screen space
    vec2 tl_uv = (SCREEN_MATRIX * CANVAS_MATRIX * MODEL_MATRIX * vec4(0.0, 0.0, 0.0, 1.0)).xy;
    vec2 br_uv = (SCREEN_MATRIX * CANVAS_MATRIX * MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
    
    // Ensure accurate bounding boxes regardless of rotation or stretching
    min_screen_uv = min(tl_uv, br_uv);
    max_screen_uv = max(tl_uv, br_uv);
}

void fragment() {
    vec2 uv = SCREEN_UV;
    
    // Invert the uv sampling position cleanly within our bounds
    if (flip_h) {
        uv.x = min_screen_uv.x + (max_screen_uv.x - uv.x);
    }
    if (flip_v) {
        uv.y = min_screen_uv.y + (max_screen_uv.y - uv.y);
    }
    
    COLOR = texture(screen_texture, uv);
}
