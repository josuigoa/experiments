class CloudsFx extends hxsl.Shader {

	static var SRC = {
        @:import h3d.shader.Base2d;

        @param var texture:Sampler2D;
        @param var direction:Int;
		@param var cloud_vel:Float;
		@param var num_clouds:Float;
		@param var max_alpha:Float;

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
            var uv = calculatedUV;
            var col = vec4(1.);
            // if (direction == 0) {
                col = vec4(perlin_noise((1.-uv.xy) * num_clouds, time/cloud_vel));
            // } else if (direction == 1) {
            //     col = vec4(perlin_noise((1.-uv.yx) * num_clouds, time/cloud_vel));
            // } else if (direction == 2) {
            //     col = vec4(perlin_noise(uv.xy * num_clouds, time/cloud_vel));
            // } else {
            //     col = vec4(perlin_noise(uv.yx * num_clouds, time/cloud_vel));
            // }
            // var col = vec4(perlin_noise(vec2(_w, _h) * num_clouds, time/vel));
            // var col = texture.get(calculatedUV.xy);
            // col.a = max_alpha - col.a;
            output.color = vec4(1., 1., 1., max_alpha-col.a);
            // output.color = texture.get(calculatedUV.xy);
        }
    }

    public function new(tex, direction:UInt = 0, cloud_vel:Float = 100, num_clouds:Float = .05, max_alpha:Float = 1.) {
        super();
        this.texture = tex;
        this.direction = direction;
        this.cloud_vel = cloud_vel;
        this.num_clouds = num_clouds;
        this.max_alpha = max_alpha;
    }
}