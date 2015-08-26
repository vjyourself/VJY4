package vjyourself4.three.vef
{
	import flash.geom.Vector3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.materials.MaterialBase;
	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	

	public class VertexballsVEF extends ObjectContainer3D
	{

		
		public var prg:Object;
		public var meshGeom;
		public var meshMat;
		public function VertexballsVEF(objprg:Object,geom:Geometry,mat:MaterialBase) {
			super();

			//_width = width;
			//_height = height;
			//_depth = depth;
			meshGeom=geom;
			meshMat=mat;
			prg=objprg;
			buildObjects();
		}

		function buildObjects(){
			var verts=prg.verts;
			for(var i=0;i<verts.length;i++){
				var m = new Mesh(meshGeom,meshMat);
				m.x=verts[i].x;
				m.y=verts[i].y;
				m.z=verts[i].z;
				addChild(m);
			}
		}
	}
}
