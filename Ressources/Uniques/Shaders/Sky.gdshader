shader_type canvas_item;

uniform sampler2D ramp;
uniform sampler2D cloud : repeat_enable;
uniform sampler2D ramp_height;
uniform sampler2D ramp_horizon;
uniform float speed;

void fragment() {
	float horizon_circle = distance(vec2(0.5,1.25),SCREEN_UV);
	vec4 horizon_color = texture(ramp_horizon,vec2(horizon_circle),0.0);
	vec4 height_color = texture(ramp_height,vec2(SCREEN_UV.y,0.0));
	vec4 cloud_color = texture(cloud,SCREEN_UV+vec2(TIME*speed,0.0));
	vec4 color = texture(ramp,vec2(cloud_color.r*height_color.r,0.0));
	COLOR = color*horizon_color;
	COLOR = COLOR*0.8;
	COLOR.a = 1.0;
}
