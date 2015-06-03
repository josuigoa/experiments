
import luxe.AppConfig;
import luxe.Color;
import luxe.Game;
import luxe.Input;
import luxe.Vector;
import luxe.Visual;
import phoenix.Shader;
import phoenix.Texture;

class Main extends Game {

	var texture:Texture;
	var perlin_shader:Shader;
	var waves_shader:Shader;
	var mousePos:Vector;
	var time:Float;

	var vel:Float;
	var max_alpha:Float;

	var sin_value:Float;
	var sine_add:Float;
	var wave_count:Float;
	var wave_width:Float;

	override public function config(_config:AppConfig):AppConfig
	{
		super.config(_config);

		_config.preload.shaders.push( { id:'perlin', frag_id: "assets/shaders/perlin.frag", vert_id:'default' } );
		_config.preload.shaders.push( { id:'waves', frag_id: "assets/shaders/waves.frag", vert_id:'default' } );
		_config.preload.textures.push( { id:"assets/img/perlin_tex.png" } );
		_config.preload.textures.push( { id:"assets/img/map_wo_seas.png" } );
		_config.preload.textures.push( { id:"assets/img/sea.png" } );

		_config.window.width = 564;
		_config.window.height = 800;

		if (_config.runtime.perlin_vel != null) {
			vel = _config.runtime.perlin_vel;
        }
		if (_config.runtime.perlin_max_alpha != null) {
			max_alpha = _config.runtime.perlin_max_alpha;
        }
		if (_config.runtime.sine_add != null) {
			sine_add = _config.runtime.sine_add;
        }
		if (_config.runtime.wave_count != null) {
			wave_count = _config.runtime.wave_count;
        }
		if (_config.runtime.wave_width != null) {
			wave_width = _config.runtime.wave_width;
        }

		return _config;
	}

    override function ready()
	{
		Luxe.renderer.clear_color = new Color(1, 0, 0);


		time = 0;
		perlin_shader = Luxe.resources.shader('perlin');
		waves_shader = Luxe.resources.shader('waves');
		texture = Luxe.resources.texture("assets/img/perlin_tex.png");

        var w = Luxe.screen.w;
		var h = Luxe.screen.h;

		new Visual( {
			name:"barents",
			texture: Luxe.resources.texture("assets/img/sea.png"),
			shader: waves_shader,
			pos:new Vector()
		});
		new Visual( {
			name:"map",
			texture: Luxe.resources.texture("assets/img/map_wo_seas.png"),
			pos:new Vector(),
			depth:1
		});

		new Visual( {
			name:"lainoak",
			texture: texture,
			shader: perlin_shader,
			pos:new Vector(),
			size:new Vector(w, h),
			depth:2
		});
    } //ready

    override function onkeyup( e:KeyEvent ) {
        if (e.keycode == Key.escape)
            Luxe.shutdown();

    } //onkeyup

	override public function onmousemove(event:MouseEvent) {
		// vel_min -> 196.8
		// max_alpha -> .54

		// vel = 100 + 100 * (event.x / Luxe.screen.width);
		// max_alpha = event.y / Luxe.screen.height;
	} //onmousemove

	override public function update(dt:Float)
	{
		time += dt;
		sin_value = (sin_value + sine_add * dt) % 6.28;
	} //update

	override public function onrender()
	{
		super.onrender();

		if (perlin_shader != null)
		{
			perlin_shader.set_float("time", time);
			perlin_shader.set_float("vel", vel);
			perlin_shader.set_float("max_alpha", max_alpha);
		}
		if (waves_shader != null)
		{
			waves_shader.set_float("sin_value", sin_value);
			waves_shader.set_float("wave_count", wave_count);
			waves_shader.set_float("wave_width", wave_width);
		}
	}


} //Main
