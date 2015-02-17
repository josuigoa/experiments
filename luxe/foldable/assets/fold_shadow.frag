uniform sampler2D tex0;
varying vec2 tcoord;
varying vec4 color;

uniform float line_center; // .5
uniform int is_horizontal;
uniform float line_alpha;

void main(){
	
	float dist;
	if (is_horizontal)
		dist = min((abs(tcoord.y-line_center)/line_center), 1.);
	else
		dist = min((abs(tcoord.x-line_center)/line_center), 1.);
	
	vec4 tex = texture2D(tex0, tcoord)*color;
	vec4 black_line = vec4(tex.rgb * dist, tex.a);
	
	gl_FragColor = mix(tex, black_line, line_alpha);
}