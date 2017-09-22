
class Main extends hxd.App {

    // var b:h2d.Bitmap;
    // var b1:h2d.Bitmap;

    var touchMap:Map<Int, h2d.Bitmap>;

	override function init() {
        
        // var b = new h2d.Bitmap(h2d.Tile.fromColor(0xffff0000, 200, 200), s2d);
        // var b1 = new h2d.Bitmap(h2d.Tile.fromColor(0xff00ff00, 200, 200), s2d);

        @:privateAccess s2d.stage.addEventTarget(onEvent);
        touchMap = new Map();
	}

    function onEvent(e:hxd.Event) {
        if (touchMap == null) return;
        switch e.kind {
            case EPush:
                var b = new h2d.Bitmap(h2d.Tile.fromColor(Std.int(hxd.Math.random(0xffffff)), 200, 200), s2d);
                b.tile = b.tile.center();
                b.x = e.relX;
                b.y = e.relY;
                touchMap.set(e.touchId, b);
            case ERelease:
                var b = touchMap.get(e.touchId);
                b.remove();
                touchMap.remove(e.touchId);
            case EMove: 
                var b = touchMap.get(e.touchId);
                if (b == null) return;
                b.x = e.relX;
                b.y = e.relY;
            case _: trace('event: $e');
        }
    }

    override function update(dt:Float) {
	}

    static public function main() {
        new Main();
    }
}
