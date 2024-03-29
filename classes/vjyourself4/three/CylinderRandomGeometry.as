﻿package vjyourself4.three
{
	import away3d.arcane;
	import away3d.core.base.SubGeometry;
	import away3d.primitives.PrimitiveBase;
	
	//use namespace arcane;

	/**
	 * A UV Cylinder primitive mesh.
	 */
	public class CylinderRandomGeometry extends PrimitiveBase
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
			var dr : Number, latNormElev : Number, latNormBase : Number;

			// reset utility variables
			_numVertices = 0;
			_numTriangles = 0;
			_nextVertexIndex = 0;
			_currentIndex = 0;
			_currentTriangleIndex = 0;

			// evaluate target number of vertices, triangles and indices
			if(_surfaceClosed) {
				_numVertices += (_segmentsH + 1) * (_segmentsW + 1); // segmentsH + 1 because of closure, segmentsW + 1 because of UV unwrapping
				_numTriangles += _segmentsH * _segmentsW * 2; // each level has segmentW quads, each of 2 triangles
			}
			if(_topClosed) {
				_numVertices += 2 * (_segmentsW + 1); // segmentsW + 1 because of unwrapping
				_numTriangles += _segmentsW; // one triangle for each segment
			}
			if(_bottomClosed) {
				_numVertices += 2 * (_segmentsW + 1);
				_numTriangles += _segmentsW;
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
			if (_topClosed && _topRadius > 0) {

				z = -0.5 * _height;

				for (i = 0; i <= _segmentsW; ++i) {
					// central vertex
					if(_yUp)
						addVertex(0, -z, 0,   0, 1, 0,   1, 0, 0);
					else
						addVertex(0, 0, z,   0, 0, -1,   1, 0, 0);

					// revolution vertex
					revolutionAngle = i * revolutionAngleDelta;
					x = _topRadius * Math.cos(revolutionAngle);
					y = _topRadius * Math.sin(revolutionAngle);
					if(_yUp)
						addVertex(x, -z, y,   0, 1, 0,   1, 0, 0);
					else
						addVertex(x, y, z,   0, 0, -1,   1, 0, 0);

					if(i > 0) // add triangle
						addTriangleClockWise(_nextVertexIndex - 1, _nextVertexIndex - 3, _nextVertexIndex - 2);
				}

				_vertexIndexOffset = _nextVertexIndex;
			}

			// bottom
			if (_bottomClosed && _bottomRadius > 0) {

				z = 0.5 * _height;

				for (i = 0; i <= _segmentsW; ++i)
				{
					// central vertex
					if(_yUp)
						addVertex(0, -z, 0,   0, -1, 0,   1, 0, 0);
					else
						addVertex(0, 0, z,   0, 0, 1,   1, 0, 0);

					// revolution vertex
					revolutionAngle = i * revolutionAngleDelta;
					x = _bottomRadius * Math.cos(revolutionAngle);
					y = _bottomRadius * Math.sin(revolutionAngle);
					if(_yUp)
						addVertex(x, -z, y,   0, -1, 0,   1, 0, 0);
					else
						addVertex(x, y, z,   0, 0, 1,   1, 0, 0);

					if(i > 0) // add triangle
						addTriangleClockWise(_nextVertexIndex - 2, _nextVertexIndex - 3, _nextVertexIndex - 1);
				}

				_vertexIndexOffset = _nextVertexIndex;
			}
			
			// The normals on the lateral surface all have the same incline, i.e.
			// the "elevation" component (Y or Z depending on yUp) is constant.
			// Same principle goes for the "base" of these vectors, which will be
			// calculated such that a vector [base,elev] will be a unit vector.
			dr = (_bottomRadius - _topRadius);
			latNormElev = dr / _height;
			latNormBase = (latNormElev==0)? 1 : _height / dr;
			

			// lateral surface
			if(_surfaceClosed)
			{
				var a:uint, b:uint, c:uint, d:uint;
				var na0 : Number, na1 : Number;

				for(j = 0; j <= _segmentsH; ++j)
				{
					radius = _topRadius - ((j / _segmentsH) * (_topRadius - _bottomRadius));
					z = -(_height / 2) + (j / _segmentsH * _height);

					for(i = 0; i <= _segmentsW; ++i)
					{
						// revolution vertex
						revolutionAngle = i * revolutionAngleDelta;
						var rr=radius+Math.random()*20;
						x = rr * Math.cos(revolutionAngle);
						y = rr * Math.sin(revolutionAngle);
						na0 = latNormBase * Math.cos(revolutionAngle);
						na1 = latNormBase * Math.sin(revolutionAngle);
						
						if(_yUp)
							addVertex(x, -z, y,
									  na0, latNormElev, na1,
									  na1, 0, -na0);
						else
							addVertex(x, y, z,
									  na0, na1, latNormElev,
									  na1, -na0, 0);

						// close triangle
						if(i > 0 && j > 0)
						{
							a = _nextVertexIndex - 1; // current
							b = _nextVertexIndex - 2; // previous
							c = b - _segmentsW - 1; // previous of last level
							d = a - _segmentsW - 1; // current of last level
							addTriangleClockWise(a, b, c);
							addTriangleClockWise(a, c, d);
						}
					}
				}
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

			// bottom
			if (_bottomClosed) {
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

			// lateral surface
			if(_surfaceClosed)
			{
				for(j = 0; j <= _segmentsH; ++j)
				{
					for(i = 0; i <= _segmentsW; ++i)
					{
						// revolution vertex
						_rawUvs[currentUvCompIndex++] = i / _segmentsW;
						_rawUvs[currentUvCompIndex++] = j / _segmentsH;
					}
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
		 * @param topRadius The radius of the top end of the cylinder.
		 * @param bottomRadius The radius of the bottom end of the cylinder
		 * @param height The radius of the bottom end of the cylinder
		 * @param segmentsW Defines the number of horizontal segments that make up the cylinder. Defaults to 16.
		 * @param segmentsH Defines the number of vertical segments that make up the cylinder. Defaults to 1.
		 * @param topClosed Defines whether the top end of the cylinder is closed (true) or open.
		 * @param bottomClosed Defines whether the bottom end of the cylinder is closed (true) or open.
		 * @param yUp Defines whether the cone poles should lay on the Y-axis (true) or on the Z-axis (false).
		 */
		public function CylinderRandomGeometry(topRadius : Number = 50, bottomRadius : Number = 50, height : Number = 100, segmentsW : uint = 16, segmentsH : uint = 1, topClosed:Boolean = true, bottomClosed:Boolean = true, surfaceClosed:Boolean = true, yUp : Boolean = true)
		{
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