package;

private class MPoint {
	public var x:Float;
	public var y:Float;
	public var u:Float;
	public var v:Float;
	public var r:Float;
	public var g:Float;
	public var b:Float;
	public var a:Float;
	public function new(_x:Float, _y:Float, _u:Float, _v:Float) {
		x = _x;
		y = _y;
		u = _u;
		v = _v;
		r = g = b = a = 1;
	}
}

private class FoldableContent extends h3d.prim.Primitive {

	var buf : hxd.FloatBuffer;
	var index : hxd.IndexBuffer;

	var points:Array<MPoint>;
	public var x:Float;
	public var y:Float;

	public function new(w:Float, h:Float) {

		points = [];

		inline function add(x:Float, y:Float, u:Float, v:Float) points.push(new MPoint(x, y, u, v));
		
		add(0, 0, 0, 0); // 0
		add(w, 0, 1, 0); // 1
		add(0, h*.33, 0, .33); // 2
		add(w, h*.33, 1, .33); // 3
		add(0, h*.66, 0, .66); // 4
		add(w, h*.66, 1, .66); // 5
		add(0, h, 0, 1); // 6
		add(w, h, 1, 1); // 7

		inline function addIndex(i) index.push(i);

		index = new hxd.IndexBuffer();

		/*
		0 * * * 1
		*       *
		2 * * * 3
		*       *
		4 * * * 5
		*       *
		6 * * * 7
		*/
		addIndex(0);
		addIndex(1);
		addIndex(2);

		addIndex(2);
		addIndex(1);
		addIndex(3);

		addIndex(2);
		addIndex(3);
		addIndex(4);

		addIndex(4);
		addIndex(3);
		addIndex(5);

		addIndex(4);
		addIndex(5);
		addIndex(6);

		addIndex(6);
		addIndex(5);
		addIndex(7);
	}

	public inline function createBuffer() {
		if (buffer != null) buffer.dispose();

		buf = new hxd.FloatBuffer();
		for (p in points) {
			buf.push(p.x);
			buf.push(p.y);
			buf.push(p.u);
			buf.push(p.v);
			buf.push(p.r);
			buf.push(p.g);
			buf.push(p.b);
			buf.push(p.a);
		}
	}

	override function alloc( engine : h3d.Engine ) {
		// trace('alloc');
		if (index.length <= 0) return ;
		if (buf == null) createBuffer();
		buffer = h3d.Buffer.ofFloats(buf, 8, [RawFormat]);
		indexes = h3d.Indexes.alloc(index);
	}

	override function render( engine : h3d.Engine ) {
		// trace('render ${index.length}');
		if (index.length <= 0) return ;
		flush();
		engine.renderIndexed(buffer, indexes);
		super.render(engine);
	}

	public inline function flush() {
		if( buffer == null || buffer.isDisposed() ) alloc(h3d.Engine.getCurrent());
	}

	public function set_vertice_x(v_ind:Int, val:Float) points[v_ind].x = val;
	public function set_vertice_y(v_ind:Int, val:Float) points[v_ind].y = val;
	public function set_vertice_rgb(v_ind:Int, val:Float) points[v_ind].r = points[v_ind].g = points[v_ind].b = val;

	public function clear() {
		// trace('clear');
		dispose();
	}

}

class Foldable extends h2d.Drawable {

	var content : FoldableContent;
	var wevent:hxd.WaitEvent;

	public var tile : h2d.Tile;
	public var bevel = 0.25; //0 = not beveled, 1 = always beveled

	public var is_folded	(default, null):Bool;
	public var is_unfolded	(default, null):Bool;
	public var is_folding	(default, null):Bool;
	public var folded_percentage:Float;
	public var unfolded_percentage:Float;
	public var folding_time:Float;
	var folding_value:Float; // 0:closed, 1:opened

	public function new(t:h2d.Tile, ?parent) {
		super(parent);
		tile = t;
		content = new FoldableContent(tile.width, tile.height);
		folded_percentage = 0.;
		unfolded_percentage = 1.;
		folding_time = 2;
		is_folded = false;
        
		is_unfolded = !is_folded;
		folding_value = (is_folded) ? folded_percentage : unfolded_percentage;

		wevent = new hxd.WaitEvent();
		clear();
	}

	public function fold(animate:Bool = true, oncomplete:Foldable->Void = null, force:Bool = false) {
		if ((is_folded || is_folding) && !force) {
			if (is_folded) 
				complete_un_folding(true, oncomplete);
			return;
		}

		if (animate) {
			is_unfolded = is_folded = false;
			is_folding = true;

			var t = 0.;
			wevent.waitUntil(function (dt) {
				t += dt/hxd.Timer.wantedFPS;
				if (t >= folding_time) {
					complete_un_folding(true, oncomplete);
					return true;
				}
				folding_value = folded_percentage + (unfolded_percentage-t/folding_time);
				updateFolding();
				return false;
			});
		} else {
			folding_value = folded_percentage;
			updateFolding();
			complete_un_folding(true, oncomplete);
		}
	} //fold

	public function unfold(animate:Bool = true, oncomplete:Foldable->Void = null, force:Bool = false) {
		if ((is_unfolded || is_folding) && !force) {
			if (is_unfolded)
				complete_un_folding(false, oncomplete);
			return;
		}

		visible = true;
		if (animate) {
			is_unfolded = is_folded = false;
			is_folding = true;
			var t = folding_time;
			wevent.waitUntil(function (dt) {
				t -= dt/hxd.Timer.wantedFPS;
				if (t <= 0) {
					complete_un_folding(false, oncomplete);
					return true;
				}
				folding_value = unfolded_percentage + (folded_percentage-t/folding_time);
				updateFolding();
				return false;
			});
		} else {
			folding_value = unfolded_percentage;
			updateFolding();
			complete_un_folding(false, oncomplete);
		}
	} //unfold

	function complete_un_folding(isfolded:Bool, oncomplete:Foldable->Void) {

		is_folding = false;
		is_folded = isfolded;
		is_unfolded = !is_folded;
		folding_value = (isfolded) ? folded_percentage : unfolded_percentage;
		updateFolding();

		if (oncomplete != null)
			oncomplete(this);

		if (is_folded) visible = false;

	} //complete_un_folding

	function updateFolding() {

		var w = tile.width;
		var h = tile.height;

		var val = (w * .25) * (1.- folding_value);
		content.set_vertice_x(2, val);
		content.set_vertice_x(4, -val);
		content.set_vertice_x(3, w-val);
		content.set_vertice_x(5, w+val);

		content.set_vertice_rgb(2, folding_value);
		content.set_vertice_rgb(3, folding_value);

		val = h * .33 * folding_value;
		content.set_vertice_y(2, val);
		content.set_vertice_y(3, val);
		val = h * .66 * folding_value;
		content.set_vertice_y(4, val);
		content.set_vertice_y(5, val);
		val = h * folding_value;
		content.set_vertice_y(6, val);
		content.set_vertice_y(7, val);

		content.createBuffer();

	} //updateFolding

	public function update(dt:Float) {
		if (!visible) return;
		wevent.update(dt);
	}

	override function onRemove() {
		super.onRemove();
		clear();
	}

	public function clear() {
		content.clear();
	}

	override function draw(ctx:h2d.RenderContext) {
		if( !ctx.beginDrawObject(this, tile.getTexture()) ) return;
		content.render(ctx.engine);
	}

	override function sync(ctx:h2d.RenderContext) {
		super.sync(ctx);
		content.flush();
	}

	override function calcAbsPos() {
		super.calcAbsPos();
		// content.x = x;
		// content.y = y;
	}
}