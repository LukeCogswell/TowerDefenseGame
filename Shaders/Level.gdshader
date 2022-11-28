shader_type canvas_item;

uniform float scale = 2.0;

void fragment() {
	vec4 pixelColor = texture(TEXTURE, UV * scale);
	COLOR = pixelColor;
}