package vjyourself4.three
{
	import away3d.arcane;
	import away3d.core.base.SubGeometry;
	import away3d.primitives.PrimitiveBase;

	use namespace arcane;

	/**
	 * A Plane primitive mesh.
	 */
	public class PlaneGeometryData extends PrimitiveBase
	{
		private var _segmentsW : uint;
		private var _segmentsH : uint;
		private var _yUp : Boolean;
		private var _width : Number;
		private var _height : Number;
		private var _depth : Number
		private var _doubleSided : Boolean;
		private var _data:Array;
		var _numW:int;
		var _numH:int;

		/**
		 * Creates a new Plane object.
		 * @param width The width of the plane.
		 * @param height The height of the plane.
		 * @param segmentsW The number of segments that make up the plane along the X-axis.
		 * @param segmentsH The number of segments that make up the plane along the Y or Z-axis.
		 * @param yUp Defines whether the normal vector of the plane should point along the Y-axis (true) or Z-axis (false).
		 * @param doubleSided Defines whether the plane will be visible from both sides, with correct vertex normals.
		 */
		public function PlaneGeometryData(data, numW, numH, width : Number = 100, height : Number = 100, depth:Number=100,yUp : Boolean = true, doubleSided : Boolean = false)
		{
			super();
			
			_data=data;
			_numH=numH;
			_numW=numW;
			_segmentsW = numW-1;
			_segmentsH = numH-1;
			_yUp = yUp;
			_width = width;
			_height = height;
			_depth=depth;
			_doubleSided = doubleSided;
		}

		/**
		 * The number of segments that make up the plane along the X-axis. Defaults to 1.
		 */
		public function get segmentsW() : uint
		{
			return _segmentsW;
		}

		public function set segmentsW(value : uint) : void
		{
			_segmentsW = value;
			invalidateGeometry();
			invalidateUVs();
		}

		/**
		 * The number of segments that make up the plane along the Y or Z-axis, depending on whether yUp is true or
		 * false, respectively. Defaults to 1.
		 */
		public function get segmentsH() : uint
		{
			return _segmentsH;
		}

		public function set segmentsH(value : uint) : void
		{
			_segmentsH = value;
			invalidateGeometry();
			invalidateUVs();
		}

		/**
		 *  Defines whether the normal vector of the plane should point along the Y-axis (true) or Z-axis (false). Defaults to true.
		 */
		public function get yUp() : Boolean
		{
			return _yUp;
		}

		public function set yUp(value : Boolean) : void
		{
			_yUp = value;
			invalidateGeometry();
		}

		/**
		 * Defines whether the plane will be visible from both sides, with correct vertex normals (as opposed to bothSides on Material). Defaults to false.
		 */
		public function get doubleSided() : Boolean
		{
			return _doubleSided;
		}

		public function set doubleSided(value : Boolean) : void
		{
			_doubleSided = value;
			invalidateGeometry();
		}

		/**
		 * The width of the plane.
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
		
		public function updateGeometry(){
			invalidateGeometry();
		}

		/**
		 * The height of the plane.
		 */
		public function get height() : Number
		{
			return _height;
		}

		public function set height(value : Number) : void
		{
			_height = value;
			invalidateGeometry();
		}

		/**
		 * @inheritDoc
		 */
		protected override function buildGeometry(target : SubGeometry) : void
		{
			trace("Build Geometry");
			var vertices : Vector.<Number>;
			var normals : Vector.<Number>;
			var tangents : Vector.<Number>;
			var indices : Vector.<uint>;
			var x : Number, y : Number;
			var numIndices : uint = 0;
			var base : uint;
			var tw : uint = _segmentsW+1;
			var numVertices : uint = (_segmentsH + 1) * tw;
			

			if (numVertices == target.numVertices) {
				vertices = target.vertexData;
				normals = target.vertexNormalData;
				tangents = target.vertexTangentData;
				indices = target.indexData;
			}
			else {
				vertices = new Vector.<Number>(numVertices * 3, true);
				normals = new Vector.<Number>(numVertices * 3, true);
				tangents = new Vector.<Number>(numVertices * 3, true);
				numIndices = _segmentsH * _segmentsW * 6;
				indices = new Vector.<uint>(numIndices, true);
			}

			numIndices = 0;
			numVertices = 0;
			var dW=_width/(_numW-1);
			var dH=_height/(_numH-1);
			var sW=-(_numW-1)/2;
			var sH=-(_numH-1)/2;
			for (var yi : uint = 0; yi < _numW; yi++) {
				for (var xi : uint = 0; xi < _numH; xi++) {
					//trace(yi+","+xi);
					x = (xi+sH)*dW;
					y = (yi+sW)*dH;

					vertices[numVertices] = x;
					normals[numVertices] = 0;
					tangents[numVertices++] = 1;

					//if (_yUp) {
						vertices[numVertices] = _data[xi][yi]*_depth;
						normals[numVertices] = 1;
						tangents[numVertices++] = 0;

						vertices[numVertices] = y;
						normals[numVertices] = 0;
						tangents[numVertices++] = 0;
						/*
					}
					else {
						vertices[numVertices] = y;
						normals[numVertices] = 0;
						tangents[numVertices++] = 0;

						vertices[numVertices] = 0;
						normals[numVertices] = -1;
						tangents[numVertices++] = 0;
					}*/
				}
			}
					
			for (var yi : uint = 0; yi < _segmentsH; yi++) {
				for (var xi : uint = 0; xi < _segmentsW; xi++) {
						
						base = yi*(_segmentsW+1)+xi;

						indices[numIndices++] = base;
						indices[numIndices++] = (base + (_segmentsW+1));
						indices[numIndices++] = (base + (_segmentsW+1) + 1);
						indices[numIndices++] = base;
						indices[numIndices++] = (base + (_segmentsW+1) + 1);
						indices[numIndices++] = (base + 1);
					
				}
			}

			target.updateVertexData(vertices);
			target.updateVertexNormalData(normals);
			target.updateVertexTangentData(tangents);
			target.updateIndexData(indices);
		}

		/**
		 * @inheritDoc
		 */
		override protected function buildUVs(target : SubGeometry) : void
		{
			var uvs : Vector.<Number> = new Vector.<Number>();
			var numUvs : uint = (_segmentsH + 1) * (_segmentsW + 1) * 2;

			if (target.UVData && numUvs == target.UVData.length)
				uvs = target.UVData;
			else
				uvs = new Vector.<Number>(numUvs, true);

			numUvs = 0;
			for (var yi : uint = 0; yi <= _segmentsH; ++yi) {
				for (var xi : uint = 0; xi <= _segmentsW; ++xi) {
					uvs[numUvs++] = xi/_segmentsW;
					uvs[numUvs++] = 1 - yi/_segmentsH;
				}
			}

			target.updateUVData(uvs);
		}
	}
}