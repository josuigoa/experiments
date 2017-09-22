
class Main extends hxd.App {

    var fondo:h2d.Bitmap;
    var buru:h2d.Bitmap;
    var lepo:h2d.Bitmap;
    var bineta:h2d.Sprite;

    var timer:Float = 0;
    var event:hxd.WaitEvent;
    var shaken:Bool = false;

    var hx:Float = 170;
    var hy:Float = 318;
    var bx:Float = 155;
    var by:Float = 330;
    var angle:Float;

	override function init() {
        
        var container = new h2d.Sprite(s2d);

        fondo = new h2d.Bitmap(hxd.Res.fondo.toTile(), container);
        bineta = new h2d.Sprite(container);
        buru = new h2d.Bitmap(hxd.Res.burua.toTile(), bineta);
        buru.x = hx;
        buru.y = hy;
        angle = hxd.Math.atan2(by-hy, bx-hx);
        trace('angle: $angle');
        lepo = new h2d.Bitmap(hxd.Res.lepoa.toTile(), bineta);
        lepo.x = buru.x;
        lepo.y = 549;
        container.setScale(s2d.width/fondo.tile.width);

        event = new hxd.WaitEvent();

        s2d.addEventListener(function(e) {
            // if (e.kind != hxd.Event.EventKind.EKeyDown) return;
            switch e.kind {
                case hxd.Event.EventKind.EKeyDown:
                    switch (e.keyCode) {
                        case hxd.Key.LEFT: buru.x--;
                        case hxd.Key.RIGHT: buru.x++;
                        case hxd.Key.UP: buru.y--;
                        case hxd.Key.DOWN: buru.y++;
                        default:
                    }
                case hxd.Event.EventKind.EKeyUp:
                    switch (e.keyCode) {
                        case hxd.Key.R: 
                            shaken = false;
                            buru.x = hx;
                            buru.y = hy;
                        case hxd.Key.B:
                            shake(bineta);
                        case hxd.Key.S:
                            shake(s2d);
                        default:
                    }
                default:
            }
        });

	}

    override function update(dt:Float) {
        event.update(dt);

        // var delta = dt/hxd.Timer.wantedFPS;
        
        // if (timer > 2 && !shaken) {
        //     // timer = 0;
        //     shaken = true;
        //     // if (burua.x)
        //     shake(s2d);
        // } else {
        //     timer += delta;
        // }
	}


    function shake(sprite:h2d.Sprite, amount = 1., time = 1.) {
        if (shaken) return;

		var baseX = -sprite.x;
		var baseY = -sprite.y;
		event.waitUntil(function(dt) {
			time -= dt / hxd.Timer.wantedFPS;
			if( time < 0 ) {
                shaken = true;
				sprite.x = baseX;
				sprite.y = baseY;
				return true;
			}
            buru.x = hx + hxd.Math.cos(angle)*(hx-bx)*(1-time);
            buru.y = hy - hxd.Math.sin(angle)*(hy-by)*(1-time);
			sprite.x = hxd.Math.srand() * amount * 2.5 * (time < 0.25 ? time / 0.25 : 1);
			sprite.y = hxd.Math.srand() * amount * 2.5 * (time < 0.25 ? time / 0.25 : 1);
			return false;
		});
	}

    static public function main() {
	    hxd.Res.initEmbed();
        new Main();
    }
}
