
typedef K = hxd.Key;
@:enum abstract Mode(Int) {
	var Perlin = 0;
	var Ridged = 1;
}

class Main extends hxd.App {

    var shader:BSNoise;
    // var shader:CloudShader;
    var b:h2d.Bitmap;

	override function init() {

		new h2d.Bitmap(hxd.Res.shore.toTile(), s2d);

        var t = h2d.Tile.fromColor(0xffff0000, 1, 1);

        b = new h2d.Bitmap(t, s2d);
        b.scaleX = .45*s2d.width/t.width;
        b.scaleY = s2d.height/t.height;

		// BSNoise
		var dirx = -1 + hxd.Math.random(2);
		var diry = -1 + hxd.Math.random(2);
		var vel = 10 + hxd.Math.random(80);
		var count = 1 + hxd.Math.random(6);
		trace('params: $dirx / $diry / $vel / $count');
		shader = new BSNoise(dirx, diry, vel, count, 0, .8);
		b.addShader(shader);
	}

    override function update(dt:Float) {
        if (shader == null) return;
        // shader.min_alpha += dt/hxd.Timer.wantedFPS;

		if (hxd.Key.isReleased(hxd.Key.S)) {
			var dirx = -1 + hxd.Math.random(2);
			var diry = -1 + hxd.Math.random(2);
			var vel = 10 + hxd.Math.random(80);
			var count = 1 + hxd.Math.random(6);
			trace('params: $dirx / $diry / $vel / $count');
			shader.dirX = dirx;
			shader.dirY = diry;
			shader.cloud_vel = vel;
			shader.num_clouds = count;
		}
    }

    static public function main() {
	    hxd.Res.initEmbed();
        new Main();
    }
}
