shader_type canvas_item;

uniform sampler2D noise : repeat_enable;
uniform float show;

void fragment() {
	float time = TIME;
	float hor = pow(distance(0.5,UV.x)*2.0,10.0);
	float ver = pow(distance(0,UV.y/2.0)*2.0,5.0);
	vec2 move = UV+vec2(0.0,time);
	float top = distance(0.0,UV.y);
	COLOR.a = texture(noise,move).r*(ver+(hor*top))*show;
	COLOR.a = round(COLOR.a+0.2);
}