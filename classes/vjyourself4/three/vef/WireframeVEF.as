package vjyourself4.three.vef
{
	import flash.geom.Vector3D;
	import away3d.primitives.WireframePrimitiveBase;

	/**
	 * A WirefameCube primitive mesh.
	 */
	public class WireframeVEF extends WireframePrimitiveBase
	{
		private var _width : Number;
		private var _height : Number;
		private var _depth : Number;

		/**
		 * Creates a new WireframeCube object.
		 * @param width The size of the cube along its X-axis.
		 * @param height The size of the cube along its Y-axis.
		 * @param depth The size of the cube along its Z-axis.
		 * @param color The colour of the wireframe lines
		 * @param thickness The thickness of the wireframe lines
		 */
		public var prg:Object;
		public function WireframeVEF(objprg:Object, color:uint = 0xFFFFFF, thickness:Number = 1) {
			super(color, thickness);

			//_width = width;
			//_height = height;
			//_depth = depth;
			prg=objprg;
		}

		/**
		 * The size of the cube along its X-axis.
		 */
		public function get width() : Number
		{
			return _width;
		}

		public function set width(value : Number) : void
		{
			_width = value;
			invalidateGeometry();
		}

		/**
		 * The size of the cube along its Y-axis.
		 */
		public function get height() : Number
		{
			return _height;
		}

		public function set height(value : Number) : void
		{
			if (value <= 0) throw new Error("Value needs to be greater than 0");
			_height = value;
			invalidateGeometry();
		}

		/**
		 * The size of the cube along its Z-axis.
		 */
		public function get depth() : Number
		{
			return _depth;
		}

		public function set depth(value : Number) : void
		{
			_depth = value;
			invalidateGeometry();
		}

		/**
		 * @inheritDoc
		 */
		override protected function buildGeometry() : void
		{
			
			var edges=prg.edges;
			var verts=prg.verts;
			
			var v0:Vector3D = new Vector3D();
			var v1:Vector3D = new Vector3D();
			for(var i=0;i<edges.length/2;i++){
				v0.x=verts[edges[i*2]].x;
				v0.y=verts[edges[i*2]].y;
				v0.z=verts[edges[i*2]].z;
				v1.x=verts[edges[i*2+1]].x;
				v1.y=verts[edges[i*2+1]].y;
				v1.z=verts[edges[i*2+1]].z;
				updateOrAddSegment(i, v0, v1);
			}
		}
	}
}
