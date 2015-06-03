#ifdef GL_ES
precision highp float;
#endif

uniform sampler2D tex0;
varying vec2 tcoord;
varying vec4 color;

uniform float sin_value;
uniform float wave_count;
uniform float wave_width; //default: .02; 

void main()
{
	float s = sin(sin_value + (tcoord.y*wave_count)) * wave_width;
	vec2 ncoord = vec2(tcoord.x + s, tcoord.y);
	gl_FragColor = texture2D(tex0, ncoord);
}