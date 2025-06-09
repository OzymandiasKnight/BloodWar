shader_type canvas_item;

uniform sampler2D noise : repeat_enable;
uniform sampler2D ramp_color;
uniform sampler2D ramp_alpha;

void fragment() {
	float alpha = COLOR.a;
	float time = TIME*0.5;
	//Flow = BLack to White gradient
	float flow = COLOR.r;
	float offset = texture(noise,vec2(UV.x,flow-time)).r;
	COLOR = texture(ramp_color,vec2(offset,UV.y))*0.8;
	//Alpha Color
	alpha = alpha*texture(noise,vec2(UV.x,flow-time)).r*((1.0-flow)*12.5);
	COLOR.a = round(alpha);
}
