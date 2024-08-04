shader_type canvas_item;

uniform float speed = 1.0;
uniform float height = 0.0;
uniform float waves = 1.0;
uniform float foam_size = 0.0;
uniform vec4 foam : source_color;

void fragment() {
	float time = TIME*speed;
	float wave = UV.y*(2.0*height)+sin(UV.x*waves+time);
	wave = wave*0.5;
	if (wave < foam_size) {
		COLOR = foam;
	} 
	COLOR.a = round(wave);
}