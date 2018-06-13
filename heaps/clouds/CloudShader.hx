package;

class CloudShader extends hxsl.Shader {

	static var SRC = {

		@global var time : Float;
		@param var vel : Float;
		@param var max_alpha : Float;

		var calculatedUV : Vec2;
        var pixelColor : Vec4;
        var texture : Sampler2D;

        var output : {
			var position : Vec4;
			var color : Vec4;
        };

		// function fragment() {
		// 	calculatedUV.x += sin(calculatedUV.y * frequency + time * speed) * amplitude;
		// }


        function noise(uv:Vec2):Float{
	        return texture.get(uv).r;
        }

        function perlin_noise(uv:Vec2, t:Float):Float{
            var res = noise(uv     +t*vec2(.5,  .5))*64.0 
                    + noise(uv*2.0 +t*vec2(-.7, .2))*32.0
                    + noise(uv*4.0 +t*vec2(.3,   1))*16.0
                    + noise(uv*8.0 +t*vec2(1,    0))*8.0
                    + noise(uv*16.0+t*vec2(-.5,-.5))*4.0
                    + noise(uv*32.0+t*vec2(.1,  .1))*2.0
                    + noise(uv*64.0+t*vec2(.9,  .9))*1.0;
            
            return res / (1.0+2.0+4.0+8.0+16.0+32.0+64.0);
        }

		function fragment() {
            var col = vec4(perlin_noise(calculatedUV.xy * .05, time/vel));
            col.a = max_alpha - pixelColor.a;
            output.color = col;
            // output.color = vec4(1., 1., 1., max_alpha-pixelColor.a);
            // output.color = texture.get(calculatedUV)*input.color;
            // output.color.rgb = pixelColor.brg;
            // output.color.a = max_alpha;
		}

	};

    public function new(vel:Float = 100, max_alpha:Float = 1.) {
        super();
        this.vel = vel;
        this.max_alpha = max_alpha;
    }

}