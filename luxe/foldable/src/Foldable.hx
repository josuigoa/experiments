package;

import luxe.Color;
import luxe.Entity;
import luxe.Vector;
import phoenix.Batcher.PrimitiveType;
import phoenix.geometry.Geometry;
import phoenix.geometry.Vertex;
import phoenix.Shader;
import phoenix.Texture;
import luxe.options.EntityOptions;

/**
 * ...
 * @author josu
 */

enum FoldDirection {
	UP;
	RIGHT;
	DOWN;
	LEFT;
} //FoldDirection
 
typedef FoldableOptions = {

    > EntityOptions,
	var texture : Texture;
	@:optional var direction:FoldDirection;
	@:optional var is_folded:Bool;
	@:optional var folded_percentage:Float;
	@:optional var unfolded_percentage:Float;
	@:optional var folding_time:Float;
	@:optional var flipx:Bool;
	@:optional var flipy:Bool;

} //FoldableOptions

class Foldable extends Entity {
	
	public var direction:FoldDirection = FoldDirection.UP;
	public var texture		(default, set):Texture;
	public var is_folded	(default, null):Bool = false;
	public var is_unfolded	(default, null):Bool = true;
	public var is_folding	(default, null):Bool = false;
    public var flipx        (default, set) : Bool = false;
    public var flipy        (default, set) : Bool = false;
	@range(0, 1) public var folded_percentage:Float = 0.;
	@range(0, 1) public var unfolded_percentage:Float = 1.;
	public var folding_time:Float = .5;
	
	var mesh:Geometry;
	var folding_line_shader:Shader;
	@range(0, 1) var folding_value:Float; // 0:closed, 1:opened

	public function new(?_options:FoldableOptions) {
		
		super(_options);
		
		if (_options.direction != null) {
			direction = _options.direction;
		}
		
		if (_options.folded_percentage != null) {
			folded_percentage = _options.folded_percentage;
		}
		
		if (_options.unfolded_percentage != null) {
			unfolded_percentage = _options.unfolded_percentage;
		}
		
		if (_options.folding_time != null) {
			folding_time = _options.folding_time;
		}
		
		if (_options.is_folded != null) {
			is_folded = _options.is_folded;
		}
        
        if(options.flipx != null) {
            flipx = options.flipx;
        }
		
        if(options.flipy != null) {
            flipy = options.flipy;
        }
		
		is_unfolded = !is_folded;
		folding_value = (is_folded) ? folded_percentage : unfolded_percentage;
		
		folding_line_shader = Luxe.loadShader("assets/shaders/fold_shadow.frag");

		if (folding_line_shader != null) {
			folding_line_shader.set_float("line_center", .5);
		}
		
		if (_options.texture != null) {
			texture = _options.texture;
		}
		
	} //new
	
	public function fold(animate:Bool = true, oncomplete:Foldable->Void = null) {
		if (is_folded || is_folding) {
			
			if (is_folded) {
				complete_un_folding(true, oncomplete);
			}
			
			return;
		}
		
		if (animate) {
			is_unfolded = is_folded = false;
			is_folding = true;
			luxe.tween.Actuate.tween(this, folding_time, { folding_value: folded_percentage } ).onUpdate(updateFolding).onComplete(complete_un_folding, [true, oncomplete]);
		} else {
			folding_value = folded_percentage;
			updateFolding();
			complete_un_folding(true, oncomplete);
		}
	} //fold
	
	public function unfold(animate:Bool = true, oncomplete:Foldable->Void = null) {
		if (is_unfolded || is_folding) {
			
			if (is_unfolded) {
				complete_un_folding(false, oncomplete);
			}
			
			return;
		}
		
		if (animate) {
			is_unfolded = is_folded = false;
			is_folding = true;
			luxe.tween.Actuate.tween(this, folding_time, { folding_value: unfolded_percentage } ).onUpdate(updateFolding).onComplete(complete_un_folding, [false, oncomplete]);
		} else {
			folding_value = unfolded_percentage;
			updateFolding();
			complete_un_folding(false, oncomplete);
		}
	} //unfold
	
	override public function update(dt:Float) {
		
		super.update(dt);
		
	} //update
	
	function complete_un_folding(isfolded:Bool, oncomplete:Foldable->Void) {
		
		is_folding = false;
		is_folded = isfolded;
		is_unfolded = !is_folded;
		
		if (oncomplete != null) {
			oncomplete(this);
		}
		
	} //complete_un_folding
	
	function updateMesh(_) {
		
		if (texture == null) {
			return;
		}
		
		if (mesh != null) {
			mesh.drop();
		}
		
		mesh = new Geometry( {
								texture: texture,
								shader: folding_line_shader,
								batcher: Luxe.renderer.batcher,
								primitive_type: PrimitiveType.triangle_strip
							});
		
		#if web
		var w:Float = texture.width_actual;
		var h:Float = texture.height_actual;
		#else
		var w:Float = texture.width;
		var h:Float = texture.height;
		#end
		
		/*
		0 * 1 * 3
		*       *
		2 * * * 5 
		*       *
		4 * 6 * 7
		*/
		var vert0_uv = new Vector(0, 0);
		var vert0_pos = new Vector(0, 0);
		
		var vert1_uv = new Vector(.5, 0);
		var vert1_pos = new Vector(w * .5, 0);
		
		var vert2_uv = new Vector(0, .5);
		var vert2_pos = new Vector(0, h * .5);
		
		var vert3_uv = new Vector(1, 0);
		var vert3_pos = new Vector(w, 0);
		
		var vert4_uv = new Vector(0, 1);
		var vert4_pos = new Vector(0, h);
		
		var vert5_uv = new Vector(1, .5);
		var vert5_pos = new Vector(w, h * .5);
		
		var vert6_uv = new Vector(.5, 1);
		var vert6_pos = new Vector(w * .5, h);
		
		var vert7_pos = new Vector(w, h);
		var vert7_uv = new Vector(1, 1);
		
		//flipped y swaps [vert0_uv, vert1_uv, vert3_uv] with [vert4_uv, vert6_uv, vert7_uv], only on y
		if (flipy) {
			
			//swap vert0_uv and vert4_uv
			var tmp_y = vert4_uv.y;
			vert4_uv.y = vert0_uv.y;
			vert0_uv.y = tmp_y;
			//swap vert1_uv and vert6_uv
			tmp_y = vert6_uv.y;
			vert6_uv.y = vert1_uv.y;
			vert1_uv.y = tmp_y;
			//swap vert3_uv and vert7_uv
			tmp_y = vert7_uv.y;
			vert7_uv.y = vert3_uv.y;
			vert3_uv.y = tmp_y;
			
		} //flipy
		
		//flipped x swaps [vert0_uv, vert2_uv, vert4_uv] with [vert3_uv, vert5_uv, vert7_uv], only on x
		if (flipx) {
			
			//swap vert0_uv and vert3_uv
			var tmp_x = vert3_uv.x;
			vert3_uv.x = vert0_uv.x;
			vert0_uv.x = tmp_x;
			//swap vert2_uv and vert5_uv
			tmp_x = vert5_uv.x;
			vert5_uv.x = vert2_uv.x;
			vert2_uv.x = tmp_x;
			//swap vert4_uv and vert7_uv
			tmp_x = vert7_uv.x;
			vert7_uv.x = vert4_uv.x;
			vert4_uv.x = tmp_x;
			
		} //flipx
		
		addVertex(vert0_pos, vert0_uv);
		addVertex(vert1_pos, vert1_uv);
		addVertex(vert2_pos, vert2_uv);
		addVertex(vert3_pos, vert3_uv);
		addVertex(vert4_pos, vert4_uv);
		addVertex(vert5_pos, vert5_uv);
		addVertex(vert6_pos, vert6_uv);
		addVertex(vert7_pos, vert7_uv);
		
		mesh.transform.pos = pos;
		mesh.transform.scale = scale;
		mesh.transform.origin = origin;
		updateFolding();
		
	} //updateMesh
	
	function addVertex(pos:Vector, uv:Vector) {
		
		#if web
		var w:Float = texture.width_actual;
		var h:Float = texture.height_actual;
		#else
		var w:Float = texture.width;
		var h:Float = texture.height;
		#end
		
		var vert = new Vertex(new Vector(pos.x, pos.y));
		vert.uv.uv0.set_uv(uv.x, uv.y);
		mesh.add(vert);
		
	} //addVertex
	
	function updateFolding() {
		var w = texture.width;
		var h = texture.height;
		
		switch (direction) {
			case UP | DOWN:
				mesh.vertices[2].pos.x = (w * .25) * (1.- folding_value);
				mesh.vertices[5].pos.x = w - ((w * .25) * (1.-folding_value));
				if (direction == UP) {
					mesh.vertices[2].pos.y = mesh.vertices[5].pos.y = h * .5 * folding_value;
					mesh.vertices[4].pos.y = mesh.vertices[6].pos.y = mesh.vertices[7].pos.y = h * folding_value;
				} else {
					mesh.vertices[2].pos.y = mesh.vertices[5].pos.y = h - (h * .5 * folding_value);
					mesh.vertices[0].pos.y = mesh.vertices[1].pos.y = mesh.vertices[3].pos.y = h * (1 - folding_value);
				}
			case RIGHT | LEFT:
				mesh.vertices[1].pos.y = h * .25 * (1.- folding_value);
				mesh.vertices[6].pos.y = h - (h * .25 * (1.- folding_value));
				
				if (direction == RIGHT) {
					mesh.vertices[1].pos.x = mesh.vertices[6].pos.x = w - (w * .5 * folding_value);
					mesh.vertices[0].pos.x = mesh.vertices[2].pos.x = mesh.vertices[4].pos.x = w * (1 - folding_value);
				} else {
					mesh.vertices[1].pos.x = mesh.vertices[6].pos.x = w * .5 * folding_value;
					mesh.vertices[3].pos.x = mesh.vertices[5].pos.x = mesh.vertices[7].pos.x = w * folding_value;
				}
			default:
				
		}
		
		if (folding_line_shader != null) {
			folding_line_shader.set_float("line_alpha", 1.-folding_value);
			folding_line_shader.set_int("is_horizontal", (direction == UP || direction == DOWN) ? 1 : 0);
		}
		
		//mesh.transform.pos.add(pos);
		
	} //updateFolding
	
//listeners

	override function set_pos_from_transform(_pos:Vector) {
		
		super.set_pos_from_transform(_pos);
		
		if (mesh != null) {
			mesh.transform.pos = _pos;
		}
	} //set_pos_from_transform

    override function set_scale_from_transform( _scale:Vector ) {

		super.set_scale_from_transform(_scale);
		
		if (mesh != null) {
			mesh.transform.scale = _scale;
		}

    } //set_scale_from_transform

    override function set_origin_from_transform( _origin:Vector ) {

		super.set_origin_from_transform(_origin);
		
		if (mesh != null) {
			mesh.transform.origin = _origin;
		}
		
    } //set_origin_from_transform
	
	/* GETTERS & SETTERS */
	public function set_texture(t:Texture):Texture {
		
		var prevW = (texture != null) ? texture.width : -1;
		var prevH = (texture != null) ? texture.height : -1;
		
		texture = t;
		
		if (texture != null && (texture.width != prevW || texture.height != prevH)) {
			if (t.loaded) {
				updateMesh(t);
			} else {
				t.onload = updateMesh;
			}
		}
		
		return texture;
	} //set_texture
	
	public function set_flipx(b:Bool):Bool {
		flipx = b;
		
		if (texture == null) {
			return b;
		}
		
		if (texture.loaded) {
			updateMesh(texture);
		} else {
			texture.onload = updateMesh;
		}
		
		return b;
	} //set_flipx
	
	public function set_flipy(b:Bool):Bool {
		flipy = b;
		
		if (texture == null) {
			return b;
		}
		
		if (texture.loaded) {
			updateMesh(texture);
		} else {
			texture.onload = updateMesh;
		}
		
		return b;
	} //set_flipy
	
} //Foldable