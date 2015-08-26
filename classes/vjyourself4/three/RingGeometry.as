package vjyourself4.three
{
	import away3d.arcane;
	import away3d.core.base.SubGeometry;
	import away3d.materials.MaterialBase;
	import away3d.primitives.PrimitiveBase;

	use namespace arcane;

	/**
	 * A UV Cylinder primitive mesh.
	 */
	public class RingGeometry extends PrimitiveBase
	{
		protected var _topRadius : Number;
		protected var _bottomRadius : Number;
		protected var _height : Number;
		protected var _segmentsW : uint;
		protected var _segmentsH : uint;
		protected var _topClosed : Boolean;
		protected var _bottomClosed : Boolean;
		protected var _surfaceClosed: Boolean;
		protected var _yUp : Boolean;
		private var _rawVertexPositions:Vector.<Number>;
		private var _rawVertexNormals:Vector.<Number>;
		private var _rawVertexTangents:Vector.<Number>;
		private var _rawUvs:Vector.<Number>;
		private var _rawIndices:Vector.<uint>;
		private var _nextVertexIndex:uint;
		private var _currentIndex:uint;
		private var _currentTriangleIndex:uint;
		private var _vertexIndexOffset:uint;
		private var _numVertices:uint;
		private var _numTriangles:uint;

		public var wave:Array;
		public var ringInR=100;
		public var ringInAmp=20;
		public var ringOutR=200;
		public var ringOutAmp=20;
		
		private function addVertex(px:Number, py:Number, pz:Number,
								   nx:Number, ny:Number, nz:Number,
								   tx:Number, ty:Number, tz:Number):void
		{
			var compVertInd:uint = _nextVertexIndex * 3; // current component vertex index
			_rawVertexPositions[compVertInd]     = px;
			_rawVertexPositions[compVertInd + 1] = py;
			_rawVertexPositions[compVertInd + 2] = pz;
			_rawVertexNormals[compVertInd]       = nx;
			_rawVertexNormals[compVertInd + 1]   = ny;
			_rawVertexNormals[compVertInd + 2]   = nz;
			_rawVertexTangents[compVertInd]      = tx;
			_rawVertexTangents[compVertInd + 1]  = ty;
			_rawVertexTangents[compVertInd + 2]  = tz;
			_nextVertexIndex++;
		}

		private function addTriangleClockWise(cwVertexIndex0:uint, cwVertexIndex1:uint, cwVertexIndex2:uint):void
		{
			_rawIndices[_currentIndex++] = cwVertexIndex0;
			_rawIndices[_currentIndex++] = cwVertexIndex1;
			_rawIndices[_currentIndex++] = cwVertexIndex2;
			_currentTriangleIndex++;
		}

		/**
		 * @inheritDoc
		 */
		protected override function buildGeometry(target : SubGeometry) : void
		{
			var i:uint, j:uint;
			var x:Number, y:Number, z:Number, radius:Number, revolutionAngle:Number;

			// reset utility variables
			_numVertices = 0;
			_numTriangles = 0;
			_nextVertexIndex = 0;
			_currentIndex = 0;
			_currentTriangleIndex = 0;

			
			if(_topClosed) {
				_numVertices += 2 * (_segmentsW + 1); // segmentsW + 1 because of unwrapping
				_numTriangles += _segmentsW*2; // one triangle for each segment
			}
			

			// need to initialize raw arrays or can be reused?
			if (_numVertices == target.numVertices) {
				_rawVertexPositions = target.vertexData;
				_rawVertexNormals = target.vertexNormalData;
				_rawVertexTangents = target.vertexTangentData;
				_rawIndices = target.indexData;
			}
			else {
				var numVertComponents:uint = _numVertices * 3;
				_rawVertexPositions = new Vector.<Number>(numVertComponents, true);
				_rawVertexNormals = new Vector.<Number>(numVertComponents, true);
				_rawVertexTangents = new Vector.<Number>(numVertComponents, true);
				_rawIndices = new Vector.<uint>(_numTriangles * 3, true);
			}

			// evaluate revolution steps
			var revolutionAngleDelta:Number = 2 * Math.PI / _segmentsW;

			// top
			if (_topClosed) {

				z = 0;

				for (i = 0; i <= _segmentsW; ++i) {
					var rIn=(ringInR+ wave[i]*ringInAmp);
					var rOut=(ringOutR+ wave[i]*ringOutAmp);
					
					revolutionAngle = i * revolutionAngleDelta;
					
					
					/*
					// central vertex
					if(_yUp)
						addVertex(0, -z, 0,   0, 1, 0,   1, 0, 0);
					else
						addVertex(0, 0, z,   0, 0, -1,   1, 0, 0);
					*/
					
					//ring In
					x = rIn * Math.cos(revolutionAngle);
					y = rIn * Math.sin(revolutionAngle);
					if(_yUp)
						addVertex(x, -z, y,   0, 1, 0,   1, 0, 0);
					else
						addVertex(x, y, z,   0, 0, -1,   1, 0, 0);
						
					// ringOut vertex
					x = rOut * Math.cos(revolutionAngle);
					y = rOut * Math.sin(revolutionAngle);
					if(_yUp)
						addVertex(x, -z, y,   0, 1, 0,   1, 0, 0);
					else
						addVertex(x, y, z,   0, 0, -1,   1, 0, 0);

					if(i > 0) addTriangleClockWise(_nextVertexIndex - 1, _nextVertexIndex - 3, _nextVertexIndex - 2);
					if(i > 1) addTriangleClockWise(_nextVertexIndex - 2, _nextVertexIndex - 3, _nextVertexIndex - 4);
				}

				_vertexIndexOffset = _nextVertexIndex;
			}

			// build real data from raw data
			target.updateVertexData(_rawVertexPositions);
			target.updateVertexNormalData(_rawVertexNormals);
			target.updateVertexTangentData(_rawVertexTangents);
			target.updateIndexData(_rawIndices);
		}

		/**
		 * @inheritDoc
		 */
		protected override function buildUVs(target : SubGeometry) : void
		{
			var i:int, j:int;
			var x:Number, y:Number, revolutionAngle:Number;

			// evaluate num uvs
			var numUvs:uint = _numVertices * 2;

			// need to initialize raw array or can be reused?
			if (target.UVData && numUvs == target.UVData.length)
				_rawUvs = target.UVData;
			else
				_rawUvs = new Vector.<Number>(numUvs, true);

			// evaluate revolution steps
			var revolutionAngleDelta:Number = 2 * Math.PI / _segmentsW;

			// current uv component index
			var currentUvCompIndex:uint = 0;

			// top
			if (_topClosed) {
				for (i = 0; i <= _segmentsW; ++i) {

					revolutionAngle = i * revolutionAngleDelta;
					x = 0.5 + 0.5 * Math.cos(revolutionAngle);
					y = 0.5 + 0.5 * Math.sin(revolutionAngle);

					_rawUvs[currentUvCompIndex++] = 0.5; // central vertex
					_rawUvs[currentUvCompIndex++] = 0.5;
					_rawUvs[currentUvCompIndex++] = x; // revolution vertex
					_rawUvs[currentUvCompIndex++] = y;
				}
			}

			

			// build real data from raw data
			target.updateUVData(_rawUvs);
		}
		
		/**
		 * The radius of the top end of the cylinder.
		 */
		public function get topRadius() : Number
		{
			return _topRadius;
		}
		
		public function set topRadius(value : Number) : void
		{
			_topRadius = value;
			invalidateGeometry();
		}
		
		/**
		 * The radius of the bottom end of the cylinder.
		 */
		public function get bottomRadius() : Number
		{
			return _bottomRadius;
		}
		
		public function set bottomRadius(value : Number) : void
		{
			_bottomRadius = value;
			invalidateGeometry();
		}

		/**
		 * The radius of the top end of the cylinder.
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
		 * Defines the number of horizontal segments that make up the cylinder. Defaults to 16.
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
		
		public function updateGeometry(){
			invalidateGeometry();
		}
		/**
		 * Defines the number of vertical segments that make up the cylinder. Defaults to 1.
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
		 * Defines whether the top end of the cylinder is closed (true) or open.
		 */
		public function get topClosed() : Boolean
		{
			return _topClosed;
		}
		
		public function set topClosed(value : Boolean) : void
		{
			_topClosed = value;
			invalidateGeometry();
		}
		
		/**
		 * Defines whether the bottom end of the cylinder is closed (true) or open.
		 */
		public function get bottomClosed() : Boolean
		{
			return _bottomClosed;
		}
		
		public function set bottomClosed(value : Boolean) : void
		{
			_bottomClosed = value;
			invalidateGeometry();
		}

		/**
		 * Defines whether the cylinder poles should lay on the Y-axis (true) or on the Z-axis (false).
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
		 * Creates a new Cylinder object.
		 * @param material The material with which to render the cylinder.
		 * @param topRadius The radius of the top end of the cylinder.
		 * @param bottomRadius The radius of the bottom end of the cylinder
		 * @param height The radius of the bottom end of the cylinder
		 * @param segmentsW Defines the number of horizontal segments that make up the cylinder. Defaults to 16.
		 * @param segmentsH Defines the number of vertical segments that make up the cylinder. Defaults to 1.
		 * @param topClosed Defines whether the top end of the cylinder is closed (true) or open.
		 * @param bottomClosed Defines whether the bottom end of the cylinder is closed (true) or open.
		 * @param yUp Defines whether the cone poles should lay on the Y-axis (true) or on the Z-axis (false).
		 */
		public function RingGeometry(topRadius : Number = 50, segmentsW : uint = 16, segmentsH : uint = 1, topClosed:Boolean = true, bottomClosed:Boolean = true, surfaceClosed:Boolean = true, yUp : Boolean = true)
		{
			var bottomRadius=0;
			var height=0;
			
			super();
			
			_topRadius = topRadius;
			_bottomRadius = bottomRadius;
			_height = height;
			_segmentsW = segmentsW;
			_segmentsH = segmentsH;
			_topClosed = topClosed;
			_bottomClosed = bottomClosed;
			_surfaceClosed = surfaceClosed;
			_yUp = yUp;
		}
	}
}