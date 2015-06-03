
package;
import luxe.AppConfig;
import luxe.Game;
import luxe.Input.MouseEvent;
import luxe.Vector;
import luxe.Visual;
import phoenix.Shader;
import phoenix.Texture;

/**
 * ...
 * @author josu
 */
class Main extends Game {
	
	var tex_diffuse:Texture;
	var tex_normals:Texture;
	var light_shader:Shader;
	var ambient_color:Vector;
	var light_color:Vector;
	var falloff:Vector;
	var light_pos:Vector;

	override public function config(_config:AppConfig):AppConfig  {
		
		super.config(_config);
		
		_config.preload.shaders.push( { id:'normal_mapping', frag_id: "assets/shaders/normal_mapping.frag", vert_id:"default" } );
		_config.preload.textures.push( { id:"assets/img/brick-diffuse.png" } );
		_config.preload.textures.push( { id:"assets/img/brick-normals.png" } );
		
		_config.window.width = 512;
		_config.window.height = 512;
		
		return _config;
	} //config
	
    override function ready() {
		
		tex_diffuse = Luxe.resources.texture('assets/img/brick-diffuse.png');
		tex_diffuse.clamp_s = tex_diffuse.clamp_t = ClampType.repeat;
		tex_normals = Luxe.resources.texture('assets/img/brick-normals.png');
		tex_normals.clamp_s = tex_normals.clamp_t = ClampType.repeat;
		tex_normals.slot = 1;
		
		light_shader = Luxe.resources.shader('normal_mapping');
		
		//the default light Z position
		var lightZ = 0.075;
		//these parameters are per-light
		light_color = new Vector(1, .8, .6, 1);
		ambient_color = new Vector(.6, 0.6, 1, .2);
		falloff = new Vector(.4, 3, 20);
		light_pos = new Vector(0, 0, lightZ);
		
		light_shader.set_vector4("AmbientColor", ambient_color);
		light_shader.set_texture('tex1', tex_normals);
		
		
		new Visual( {
			name:"bricks",
			texture: tex_diffuse,
			shader: light_shader,
			pos: new Vector()
		});
		
	} //ready
	
	override public function onmousemove(event:MouseEvent) {
		
		super.onmousemove(event);
		if (light_pos != null)
			light_pos.set_xy(event.x/Luxe.screen.size.x, 1-event.y/Luxe.screen.size.y);
		
	} //onmousemove
	
	override public function onrender() {
		super.onrender();
		
		if (light_shader == null) return;
		//pass our parameters to the shader
		light_shader.set_vector2("Resolution", Luxe.screen.size);
		//note that these are arrays, and we need to explicitly say the component count
		light_shader.set_vector3("Falloff", falloff);
		light_shader.set_vector4("LightColor", light_color);
		light_shader.set_vector3("LightPos", light_pos);
		
	} //onrender
}