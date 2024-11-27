shader_type canvas_item;
render_mode unshaded;

uniform float width : hint_range(0.0, 10.0, 0.1);
uniform vec4 outline_colour : source_color;

float sum_mat3(mat3 mat_in) {
	float sum_out = mat_in[0][0] + mat_in[0][1] + mat_in[0][2] +
					mat_in[1][0] + mat_in[1][1] + mat_in[1][2] +
					mat_in[2][0] + mat_in[2][1] + mat_in[2][2];
	return sum_out;
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 sprite_colour = COLOR;
	vec2 pixel = vec2(width / float(textureSize(TEXTURE, 0).x), width / float(textureSize(TEXTURE, 0).y));
	mat3 window = mat3(vec3(texture(TEXTURE, UV + vec2(-pixel.x, -pixel.y)).a, texture(TEXTURE, UV + vec2(-pixel.x, 0.0)).a, texture(TEXTURE, UV + vec2(-pixel.x, pixel.y)).a),
						vec3(texture(TEXTURE, UV + vec2(0.0, -pixel.y)).a, texture(TEXTURE, UV + vec2(0.0, 0.0)).a, texture(TEXTURE, UV + vec2(0.0, pixel.y)).a),
						vec3(texture(TEXTURE, UV + vec2(pixel.x, -pixel.y)).a, texture(TEXTURE, UV + vec2(pixel.x, 0.0)).a, texture(TEXTURE, UV + vec2(pixel.x, pixel.y)).a));

	vec4 out_colour = mix(outline_colour, sprite_colour, sprite_colour.a);
	COLOR = vec4(out_colour.rgb, clamp(sum_mat3(window), 0.0, 1.0));
}
