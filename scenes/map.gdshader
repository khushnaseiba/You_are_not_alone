shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear;

uniform float blur_strength : hint_range(0.0, 10.0) = 0.0;

void fragment() {
	vec2 pixel_size = 1.0 / vec2(textureSize(screen_texture, 0));

	vec4 color = vec4(0.0);

	for (int x = -3; x <= 3; x++) {
		for (int y = -3; y <= 3; y++) {
			vec2 offset = vec2(float(x), float(y)) * pixel_size * blur_strength;
			color += texture(screen_texture, SCREEN_UV + offset);
		}
	}

	COLOR = color / 49.0;
}