shader_type canvas_item;

global uniform vec4 p_color;
global uniform vec4 s_color;
global uniform vec4 t_color;

uniform vec4 replace_p_color : source_color;
uniform vec4 replace_s_color : source_color;
uniform vec4 replace_t_color : source_color;

void fragment() {
	vec4 modulate = COLOR;
	COLOR = texture(TEXTURE,UV);
	vec4 col = COLOR;
	if (distance(col,p_color) < 0.01) {
		col = replace_p_color;
	}
	else if (distance(col,s_color) < 0.01) {
		col = replace_s_color;
	}
	else if (distance(col,t_color) < 0.01) {
		col = replace_t_color;
	}
	COLOR = col;
	COLOR.a = modulate.a;
}

float diff(vec4 from,vec4 to) {
	return (from.r-to.r)+(from.g-to.g)+(from.b-to.b);
}