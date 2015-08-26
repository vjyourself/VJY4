package vjyourself4.three
{
	import flash.geom.Vector3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.materials.MaterialBase;
	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	

	public class VertexObjsPath extends ObjectContainer3D
	{

		
		public var pathPos:Array;
		public var pathRot:Array;
		
		public var meshGeom;
		public var meshMat;
		public function VertexObjsPath(myPathPos:Array,myPathRot:Array,geom:Geometry,mat:MaterialBase) {
			super();

			//_width = width;
			//_height = height;
			//_depth = depth;
			meshGeom=geom;
			meshMat=mat;
			pathPos=myPathPos;
			pathRot=myPathRot;
			buildObjects();
		}

		function buildObjects(){
			for(var i=0;i<pathPos.length;i++){
				var m = new Mesh(meshGeom,meshMat);
				m.transform=pathRot[i];
				m.x=pathPos[i].x;
				m.y=pathPos[i].y;
				m.z=pathPos[i].z;
				
				addChild(m);
			}
		}
	}
}
