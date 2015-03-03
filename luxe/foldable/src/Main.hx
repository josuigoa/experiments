package;

import luxe.Color;
import luxe.Game;
import luxe.Input.Key;
import luxe.Input.KeyEvent;
import luxe.Vector;
import phoenix.geometry.TextGeometry;
import phoenix.Texture;

/**
 * ...
 * @author josu
 */
class Main extends Game
{
	var txt_foldinDir:TextGeometry;
	var foldable:Foldable;
	
	var texture1:Texture;
	var texture2:Texture;

	override public function ready() 
	{
		super.ready();

		var json_asset = Luxe.loadJSON('assets/parcel.json');
		
		//then create a parcel to load it for us
		var preload = new luxe.Parcel();
		preload.from_json(json_asset.json);
		
		//but, we also want a progress bar for the parcel,
		//this is a default one, you can do your own
		new luxe.ParcelProgress({
			parcel      : preload,
			background  : new Color(1, 1, 1, 0.85),
			oncomplete  : assets_loaded
		});
		
		//go!
		preload.load();
    	
    } //ready

    function assets_loaded(_) {
		
		Luxe.renderer.clear_color = new Color(.8, .8, .8);
		
		Luxe.draw.text({pos: new Vector(50, 10),
						text: 'Cursors: set fold direction\nT: change texture\nF: fold/unfold',
						align: left,
						point_size: 32,
						batcher: Luxe.renderer.batcher
						});
		txt_foldinDir = new TextGeometry({
								pos: new Vector(50, 150),
								align: left,
								point_size: 32,
								batcher: Luxe.renderer.batcher
							});
		texture1 = Luxe.loadTexture("assets/luxe.png");
		texture2 = Luxe.loadTexture("assets/bluxe.png");
		foldable = new Foldable( { texture: texture1, direction: Foldable.FoldDirection.DOWN, pos:new Vector(200, 50), origin:new Vector(100, 100) } );
		foldable.fold(false);
		txt_foldinDir.text = Std.string(foldable.direction);
	} //assets_loaded
	
	override public function onkeyup(event:KeyEvent) 
	{
		super.onkeyup(event);
		
		switch (event.keycode) 
		{
			case Key.key_f:
				(foldable.is_unfolded) ? foldable.fold(): foldable.unfold();
			case Key.key_s:
				foldable.scale.x = .5;
			case Key.key_t:
				if(foldable.texture == texture1){
					foldable.texture = texture2;
				} else {
					foldable.texture = texture1;
				}
				
			case Key.key_m:
				foldable.pos.set_xy(foldable.pos.x + 50, 100);
			case Key.up:
				foldable.direction = Foldable.FoldDirection.UP;
			case Key.right:
				foldable.direction = Foldable.FoldDirection.RIGHT;
			case Key.down:
				foldable.direction = Foldable.FoldDirection.DOWN;
			case Key.left:
				foldable.direction = Foldable.FoldDirection.LEFT;
			default:
				
		}
		txt_foldinDir.text = Std.string(foldable.direction);
	}
	
	override public function update(dt:Float) 
	{
		super.update(dt);
	}
}