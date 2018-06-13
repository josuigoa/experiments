uniform sampler2D tex0;
varying vec2 tcoord;
varying vec4 color;

uniform float time;

uniform float vel;
uniform float max_alpha;

float noise( vec2 uv ){
	return texture2D(tex0, uv).r;
}

float perlin_noise(vec2 uv, float t){
	float res = noise(uv     +t*vec2(.5,  .5))*64.0 
		      + noise(uv*2.0 +t*vec2(-.7, .2))*32.0
			  + noise(uv*4.0 +t*vec2(.3,   1))*16.0
		  	  + noise(uv*8.0 +t*vec2(1,    0))*8.0
			  + noise(uv*16.0+t*vec2(-.5,-.5))*4.0
		   	  + noise(uv*32.0+t*vec2(.1,  .1))*2.0
			  + noise(uv*64.0+t*vec2(.9,  .9))*1.0;
	
	return res / (1.0+2.0+4.0+8.0+16.0+32.0+64.0);
}

void main( ){
	//vec2 uv = vec2(tcoord.x / in_windowWidth, tcoord.y / in_windowHeight);
	vec2 uv = tcoord;
    vec4 col = vec4(perlin_noise(uv.xy * .05, time/vel));
	gl_FragColor = vec4(1., 1., 1., max_alpha-col.a);
	//gl_FragColor = texture2D(tex0, uv).rgba;
}