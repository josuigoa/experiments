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


	override public function config(_config:luxe.AppConfig):luxe.AppConfig
	{
		super.config(_config);

		_config.preload.shaders.push( { id:'fold_shadow', frag_id: "assets/fold_shadow.frag", vert_id:'default' } );
		_config.preload.textures.push( { id:"assets/luxe.png" } );
		_config.preload.textures.push( { id:"assets/bluxe.png" } );

		return _config;
	}

	override public function ready()
	{
		super.ready();

		Luxe.renderer.clear_color = new Color(.8, .8, .8);

		Luxe.draw.text({pos: new Vector(50, 10),
						text: 'Cursors: set fold direction\nT: change texture\nF: fold/unfold',
						align: left,
						point_size: 32,
						});
		txt_foldinDir = new TextGeometry({
								pos: new Vector(50, 150),
								align: left,
								point_size: 32,
							});
		texture1 = Luxe.resources.texture("assets/luxe.png");
		texture2 = Luxe.resources.texture("assets/bluxe.png");
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
}
