#ifdef GL_ES
precision highp float;
#endif

uniform sampler2D tex0;
varying vec2 tcoord;
varying vec4 color;

uniform float line_center; //default: .5
uniform bool is_horizontal;
uniform float line_alpha;

void main(){

	float dist;
	if (is_horizontal)
		dist = min((abs(tcoord.y-line_center)/line_center), 1.);
	else
		dist = min((abs(tcoord.x-line_center)/line_center), 1.);

	vec4 tex = texture2D(tex0, tcoord)*color;
	vec4 black_line = vec4(tex.rgb * dist, tex.a);
	vec4 final = mix(tex, black_line, line_alpha);

	gl_FragColor = vec4(final.rgb, 1);
}
