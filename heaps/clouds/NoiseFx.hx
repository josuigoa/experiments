class NoiseFx extends hxsl.Shader {

	static var SRC = {
        @:import h3d.shader.Base2d;
        @:import h3d.shader.NoiseLib;

        @param var noise_seed:Int;
        // @param var direction:Int;
		@param var cloud_vel:Float;
		@param var num_clouds:Float;
		// @param var max_alpha:Float;

        function __init__() {
            noiseSeed = noise_seed;
        }

		function fragment() {
            // var v = snoise(calculatedUV.xy);
            // output.color = vec4(v.x, v.x, v.x, 1.);

            // var n = snoise((1.-calculatedUV.xy) * num_clouds);
            var n = snoise(calculatedUV.xy+cloud_vel/time);
            output.color = vec4(n, n, n, n * .5);
        }
    }

    public function new(seed:Int, cloud_vel:Float = 100, num_clouds:Float = .05) {
        super();

        this.noise_seed = seed;
        this.cloud_vel = cloud_vel;
        this.num_clouds = num_clouds;
    }
}