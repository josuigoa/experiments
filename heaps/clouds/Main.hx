
typedef K = hxd.Key;

class Main extends hxd.App {

    var shader:CloudsFx;
    // var shader:CloudShader;
    var b:h2d.Bitmap;

	override function init() {

        var t = hxd.Res.perlin_tex.toTile();
        // var t = h2d.Tile.fromColor(0xffff0000, 100, 200);
        // var font = hxd.Res.littera.toFont();

        b = new h2d.Bitmap(t, s2d);
        // b.scaleX = .5*s2d.width/t.width;
        // b.scaleY = .5*s2d.height/t.height;
        var tex = t.getTexture();
        tex.filter = Linear;
        shader = new CloudsFx(tex, 2, 100, .03, .8);

        // driver.getNativeShaderCode(hxsl.RuntimerShader)
        // shader = new CloudShader();
        // b.blendMode = h2d.BlendMode.Screen;
        // b.blendMode = SrcAlpha;
        trace('brasdkfals');
        b.addShader(shader);
	}

    override function update(dt:Float) {
        if (shader == null) return;
        // shader.max_alpha += dt/hxd.Timer.wantedFPS;
    }

    static public function main() {
	    hxd.Res.initEmbed();
        new Main();
    }
}
