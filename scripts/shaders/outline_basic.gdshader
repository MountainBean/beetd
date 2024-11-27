shader_type canvas_item;
render_mode unshaded;

uniform float width : hint_range(0.0, 10.0, 0.1);
uniform vec4 outline_colour : source_color;

void fragment() {
	// Called for every pixel the material is visible on.
	float size = width * 1.0 / float(textureSize(TEXTURE, 0).x);
	vec4 sprite_colour = COLOR;
	float alpha = -8.0 * sprite_colour.a;
	alpha += texture(TEXTURE, UV + vec2(size, size)).a;
	alpha += texture(TEXTURE, UV + vec2(size, 0.0)).a;
	alpha += texture(TEXTURE, UV + vec2(size, -size)).a;
	alpha += texture(TEXTURE, UV + vec2(0.0, -size)).a;
	alpha += texture(TEXTURE, UV + vec2(-size, -size)).a;
	alpha += texture(TEXTURE, UV + vec2(-size, 0.0)).a;
	alpha += texture(TEXTURE, UV + vec2(-size, size)).a;
	alpha += texture(TEXTURE, UV + vec2(0.0, size)).a;

	vec4 out_colour = mix(sprite_colour, outline_colour, clamp(alpha, 0.0,1.0));
	COLOR = vec4(out_colour.rgb, clamp(abs(alpha) + sprite_colour.a, 0.0, 1.0));
}
