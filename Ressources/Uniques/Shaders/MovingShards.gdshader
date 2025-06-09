shader_type canvas_item;

uniform sampler2D noise : repeat_enable;
uniform vec4 p_color : source_color;
uniform vec4 s_color : source_color;
uniform bool colors_alpha;
uniform float height;

void fragment() {
	float multiply = 0.875;
	float alpha = COLOR.a;

	float time = TIME*0.2;
	vec2 uv = UV*vec2(1,0.5);
	uv = uv + vec2(0,time);
	vec4 col = texture(noise,uv);
	col = round(col*(UV.y)+(height-0.5));

	if (col.r >= 0.99) {
		col = p_color;
	} else {
		col = s_color;
	}
	COLOR = col*multiply;
	if (colors_alpha) {
		COLOR.a = alpha * col.a;
	}
	else {
		COLOR.a = alpha;
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
