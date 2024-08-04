shader_type canvas_item;

global uniform vec4 p_color;

uniform vec4 primary_color : source_color;
uniform vec4 secondary_color : source_color;

void fragment() {
	vec4 def = COLOR;
	if (def == p_color) {
		def = primary_color;
	}
	else if (def == secondary_color) {
		def = secondary_color;
	}
	COLOR = def;
}