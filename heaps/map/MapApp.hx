
class MapApp extends hxd.App {

    var f:Foldable;
    var clone:h2d.Bitmap;

	override function init() {
        
        var t = hxd.Res.hxlogo.toTile();
        var font = hxd.Res.littera.toFont();

        var container = new h2d.Sprite(s2d);

        new h2d.Bitmap(t, container);//.color.r = .5;
        new h2d.Bitmap(hxd.Res.ic_media_play_b.toTile(), container);

        var c = font.getChar("M".code);
        var b = new h2d.Bitmap(c.t, container);
        b.color.setColor(0xFFFF0000);
        b.x = 20;
        b.y = 10;

        var text = new h2d.Text(font, container);
        text.text = 'TEST';
        text.textColor = 0x000000;
        text.x = t.width*.5-text.textWidth*.5;
        text.y = t.height*.5-text.textHeight*.5;



        haxe.Timer.delay(function() {
            var tex = new h3d.mat.Texture(t.width, t.height, [h3d.mat.Data.TextureFlags.Target]);
            container.drawTo(tex);
            var ttex = h2d.Tile.fromTexture(tex);

            clone = new h2d.Bitmap(ttex, s2d);
            clone.x = t.width+ttex.width*.5+5;
            clone.y = container.y+ttex.height*.5;
            clone.tile.dx = -Std.int(ttex.width*.5);
            clone.tile.dy = -Std.int(ttex.height*.5);

            f = new Foldable(ttex, s2d);
            f.x = clone.x+clone.tile.width+5;
            f.y = 10;
        }, 0);
	}

    override function update(dt:Float) {
        if (f != null) f.update(dt);

        if (hxd.Key.isReleased("F".code)) f.fold(function(_){trace('fold completed!');});
        if (hxd.Key.isReleased("U".code)) f.unfold(function(_){trace('unfold completed!');});
        if (hxd.Key.isDown('R'.code)) clone.rotation += dt*.01;
    }

    // override function loadAssets(done) {
    //     new hxd.fmt.pak.Loader(s2d, done);
    // }

    static public function main() {
	    hxd.Res.initEmbed();
        // hxd.Res.initPak();
        new MapApp();
    }
}
