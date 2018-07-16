// https://thebookofshaders.com/11/
class BSNoise extends hxsl.Shader {

	static var SRC = {
        @:import h3d.shader.Base2d;

        @param var texture:Sampler2D;
        @param var dirX:Float;
        @param var dirY:Float;
		@param var cloud_vel:Float;
		@param var num_clouds:Float;
        @param var min_alpha:Float;
		@param var max_alpha:Float;

        // 2D Random
        function random (st:Vec2):Float {
            return fract(sin(dot(st.xy,
                                vec2(12.9898,78.233)))
                        * 43758.5453123);
        }

        // 2D Noise based on Morgan McGuire @morgan3d
        // https://www.shadertoy.com/view/4dS3Wd
        function noise (st:Vec2):Float {
            var i:Vec2 = floor(st);
            var f:Vec2 = fract(st);

            // Four corners in 2D of a tile
            var a:Float = random(i);
            var b:Float = random(i + vec2(1.0, 0.0));
            var c:Float = random(i + vec2(0.0, 1.0));
            var d:Float = random(i + vec2(1.0, 1.0));

            // Smooth Interpolation

            // Cubic Hermine Curve.  Same as SmoothStep()
            var u:Vec2 = f*f*(3.0-2.0*f);
            // u = smoothstep(0.,1.,f);

            // Mix 4 corners percentages
            return mix(a, b, u.x) +
                    (c - a)* u.y * (1.0 - u.x) +
                    (d - b) * u.x * u.y;
        }

        function fragment() {
            var offset = time/cloud_vel;
            var st:Vec2 = vec2(random(vec2(21.6861, 86.5151)) + calculatedUV.x + offset * dirX, random(vec2(86.5151, 21.6861)) + calculatedUV.y + offset * dirY);

            // Scale the coordinate system to see
            // some noise in action
            var pos:Vec2 = vec2(st * num_clouds);

            // Use the noise function
            var n:Float = noise(pos);

            output.color = vec4(vec3(min_alpha + n), min_alpha + n * max_alpha);
        }
    }

    public function new(dirX:Float = 0, dirY:Float = 0., cloud_vel:Float = 50, num_clouds:Float = 5., min_alpha:Float = 0., max_alpha:Float = 1.) {
        super();

        this.dirX = -1 + hxd.Math.random(2); //hxd.Math.clamp(dirX, -1, 1);
        this.dirY = -1 + hxd.Math.random(2); //hxd.Math.clamp(dirY, -1, 1);
        this.cloud_vel = hxd.Math.clamp(cloud_vel, 10, 90);
        this.num_clouds = hxd.Math.clamp(num_clouds, 1, 7);
        this.min_alpha = min_alpha;
        this.max_alpha = max_alpha;
    }
}