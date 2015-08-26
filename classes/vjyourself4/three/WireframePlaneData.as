package vjyourself4.three
{
	import flash.geom.Vector3D;
	import away3d.primitives.WireframePrimitiveBase;

	/**
	 * A WireframePlane primitive mesh.
	 */
	public class WireframePlaneData extends WireframePrimitiveBase
	{
		public static const ORIENTATION_YZ:String = "yz";
		public static const ORIENTATION_XY:String = "xy";
		public static const ORIENTATION_XZ:String = "xz";

		private var _width : Number;
		private var _height : Number;
		private var _segmentsW : int;
		private var _segmentsH : int;
		private var _orientation : String;
		var _numW:int;
		var _numH:int;
		var _depth:Number;
		var _data:Array;

		/**
		 * Creates a new WireframePlane object.
		 * @param width The size of the cube along its X-axis.
		 * @param height The size of the cube along its Y-axis.
		 * @param segmentsW The number of segments that make up the cube along the X-axis.
		 * @param segmentsH The number of segments that make up the cube along the Y-axis.
		 * @param color The colour of the wireframe lines
		 * @param thickness The thickness of the wireframe lines
		 * @param orientation The orientaion in which the plane lies.
		 */
		public function WireframePlaneData(data:Array,numW:Number,numH:Number,width: Number, height : Number, depth:Number, color:uint = 0xFFFFFF, thickness:Number = 1, orientation : String = "yz") {
			super(color, thickness);

			_data=data;
			_numW=numW;
			_numH=numH;
			_width = width;
			_height = height;
			_depth = depth;
			//_segmentsW = segmentsW;
			//_segmentsH = segmentsH;
			_orientation = orientation;
		}

		/**
		 * The orientaion in which the plane lies.
		 */
		public function get orientation() : String
		{
			return _orientation;
		}

		public function set orientation(value : String) : void
		{
			_orientation = value;
			invalidateGeometry();
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
		 * The number of segments that make up the plane along the X-axis.
		 */
		public function get segmentsW() : int
		{
			return _segmentsW;
		}

		public function set segmentsW(value : int) : void
		{
			_segmentsW = value;
			removeAllSegments();
			invalidateGeometry();
		}

		/**
		 * The number of segments that make up the plane along the Y-axis.
		 */
		public function get segmentsH() : int
		{
			return _segmentsH;
		}

		public function set segmentsH(value : int) : void
		{
			_segmentsH = value;
			removeAllSegments();
			invalidateGeometry();
		}

public function updateGeometry(){
			invalidateGeometry();
		}
		/**
		 * @inheritDoc
		 */
		override protected function buildGeometry() : void
		{
			var v0 : Vector3D = new Vector3D();
			var v1 : Vector3D = new Vector3D();
			var hw : Number = _width*.5;
			var hh : Number = _height*.5;
			var index : int;
			var iW : int, iH : int;
			
			var dW=_width/(_numW-1);
			var dH=_height/(_numH-1);
			var sW=-(_numW-1)/2;
			var sH=-(_numH-1)/2;
			
				for (iW = 0; iW < _numW; iW++) {
					v0.x = v1.x = (iW+sW)*dW;
					var dataLine:Array=_data[iW];
					for (iH = 0; iH < _numH-1; iH++) {
						v0.z = (iH+sH)*dH
						v0.y = dataLine[iH]*_depth;
						v1.z = (iH+1+sH)*dH;
						v1.y = dataLine[iH+1]*_depth;
						updateOrAddSegment(index++, v0, v1);
					}
					
				}
				
				for (iH = 0; iH < _numH; iH++) {
					v0.z = v1.z = (iH+sH)*dH;
					for (iW = 0; iW < _numW-1; iW++) {
						v0.x = (iW+sW)*dW;
						v0.y = _data[iW][iH]*_depth;
						v1.x = (iW+1+sW)*dW;
						v1.y = _data[iW+1][iH]*_depth;
						updateOrAddSegment(index++, v0, v1);
					}
					
				}


		}
		

	}
}
