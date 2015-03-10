uniform sampler2D tex0;
varying vec2 tcoord;
varying vec4 color;

uniform float line_center; // .5
uniform int is_horizontal;
uniform float line_alpha;

void main(){
	
	// get the distance between the current pixel and the 'line_center'
	float dist;
	if (is_horizontal)
		dist = min((abs(tcoord.y-line_center)/line_center), 1.);
	else
		dist = min((abs(tcoord.x-line_center)/line_center), 1.);
	
	// get the original texture
	vec4 tex = texture2D(tex0, tcoord)*color;
	// set to black depending on the distance (the closer to the 'line_center', more black)
	vec4 black_line = vec4(tex.rgb * dist, tex.a);
	
	// mix the original and the blackened according to the 'line_alpha' uniform value (it is the folding percentage of the paper)
	gl_FragColor = mix(tex, black_line, line_alpha);
}