
import h3d.col.Point;

class Main extends hxd.App {

	override function init() {
        
		var sky_size = 128;

        var skyTexture = new h3d.mat.Texture(Std.int(sky_size*4), Std.int(sky_size*4), [Cube]);
		var faceColors = [hxd.Res.ft, hxd.Res.bk, hxd.Res.rt, hxd.Res.lf, hxd.Res.up, hxd.Res.dn];
		for( i in 0...6 ) {
			skyTexture.uploadPixels(faceColors[i].getPixels(h3d.mat.Texture.nativeFormat), 0, i);
		}

		var sky = new h3d.prim.Sphere(20, sky_size, sky_size);
		sky.addNormals();
		var skyMesh = new h3d.scene.Mesh(sky, s3d);
		skyMesh.material.mainPass.culling = Front;
		skyMesh.material.mainPass.addShader(new h3d.shader.CubeMap(skyTexture));

		// s3d.lightSystem.ambientLight.set(0.1, 0.1, 0.1);


		var tex = hxd.Res.noho_maansi.toTexture();
		// creates a new unit cube
		var prim = new h3d.prim.Cube(.01, 1, 1);

		// translate it so its center will be at the center of the cube
		prim.translate( -0.005, -0.5, -0.5);

		// unindex the faces to create hard edges normals
		prim.unindex();

		// add face normals
		prim.addNormals();

		// add texture coordinates
		prim.addUVs();
		var mat = new h3d.mat.MeshMaterial(tex);
		var mesh = new h3d.scene.Mesh(prim, mat, s3d);
		mesh.x = -19;
		mesh.y = 0;
		mesh.z = -2;
		// mesh.rotate(0, 0, 3.14);


		var b = new h2d.Bitmap(hxd.Res.bineta.toTile(), s2d);
		b.tile.scaleToSize(s2d.width, s2d.height);

		// var bitmap = new h2d.Bitmap(hxd.Res.noho_maansi.toTile(), s3d);
		
        s3d.addEventListener(function(e) {
            if (e.kind != hxd.Event.EventKind.EKeyDown) return;
            switch (e.keyCode) {
                case hxd.Key.LEFT: mesh.x--;
                case hxd.Key.RIGHT: mesh.x++;
                case hxd.Key.UP: mesh.y--;
                case hxd.Key.DOWN: mesh.y++;
                case hxd.Key.A: mesh.z++;
                case hxd.Key.Z: mesh.z--;
                default:
            }

            trace('x: ${mesh.x} / y: ${mesh.y} / z: ${mesh.z}');
        });

		new h3d.scene.CameraController(0, s3d).loadFromCamera();
	}

    override function update(dt:Float) {
	}

    static public function main() {
	    hxd.Res.initEmbed();
        new Main();
    }
}
