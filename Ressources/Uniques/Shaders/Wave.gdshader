shader_type canvas_item;

uniform float height = 0.0;
uniform float offset = 0.0;
uniform float speed = 1.0;
uniform float time_offset = 0.0;
uniform float waves = 1.0;
uniform float foam_size = 0.0;
uniform vec4 foam : source_color;

void fragment() {
	float alpha = COLOR.a;
	float time = TIME*speed+SCREEN_UV.y;
	float wave = ((UV.y)*2.0)+sin(UV.x*waves+time)*height+((offset-0.5)*2.0)-height;
	wave = wave*0.5;
	if (wave < foam_size) {
		COLOR = foam;
	} 
	COLOR.a = round(wave)*alpha;
}