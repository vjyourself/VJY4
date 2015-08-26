package vjyourself4.three
{
	import away3d.arcane;
	import away3d.core.base.CompactSubGeometry;
	import away3d.primitives.PrimitiveBase;
	import flash.geom.Vector3D;
	import flash.geom.Matrix3D;

	use namespace arcane;

	/**
	 * A Cube primitive mesh.
	 */
	public class GeometryPipeBasic extends PrimitiveBase
	{
		private var _width : Number;
		private var _height : Number;
		private var _depth : Number;
		private var _tile6 : Boolean;
		
		private var _segmentsW : Number;
		private var _segmentsH : Number;
		private var _segmentsD : Number;

		/**
		 * Creates a new Cube object.
		 * @param width The size of the cube along its X-axis.
		 * @param height The size of the cube along its Y-axis.
		 * @param depth The size of the cube along its Z-axis.
		 * @param segmentsW The number of segments that make up the cube along the X-axis.
		 * @param segmentsH The number of segments that make up the cube along the Y-axis.
		 * @param segmentsD The number of segments that make up the cube along the Z-axis.
		 * @param tile6 The type of uv mapping to use. When true, a texture will be subdivided in a 2x3 grid, each used for a single face. When false, the entire image is mapped on each face.
		 */
		public var pathPos:Array;
		public var pathRot:Array;
		
		//public var shape:Number=0;
		//public var circRandom:Number=0;
		//public var holesCirc:Number=0;
		//public var holesH:Number=0;
		//public var facesCirc:Number=1;
		//public var facesH:Number=1;

		public var circSegShift:Number=0; // shiftii - not active !!
		
	

		public var doubleSided:Boolean=false;
		public var radius:Number=80;
		
		public var circSeg:Number=36;
	
		public var twist0:Number=0; // initial rotation of pipe (rotating whole segment)

		public var curve0:Number=1;
		public var curve1:Number=1;
		public var fillPerc:Number=1;
		public var height:Number=80;

		public var curve:Number=1; //calculated from curve0-curve1
		
		public function GeometryPipeBasic(myPathPos:Array,myPathRot:Array,p:Object=null)
		{
			super();
			pathPos=myPathPos;
			pathRot=myPathRot;
			if(p==null)p={};
			for(var i in p)if(hasOwnProperty(i))this[i]=p[i];
			
			/*
			_width = width;
			_height = height;
			_depth = depth;
			_segmentsW = segmentsW;
			_segmentsH = segmentsH;
			_segmentsD = segmentsD;
			_tile6 = tile6;
			*/
		}


		

		/**
		 * The type of uv mapping to use. When false, the entire image is mapped on each face. 
		 * When true, a texture will be subdivided in a 3x2 grid, each used for a single face.
		 * Reading the tiles from left to right, top to bottom they represent the faces of the
		 * cube in the following order: bottom, top, back, left, front, right. This creates
		 * several shared edges (between the top, front, left and right faces) which simplifies
		 * texture painting.
		 */
		public function get tile6() : Boolean
		{
			return _tile6;
		}

		public function set tile6(value : Boolean) : void
		{
			_tile6 = value;
			invalidateUVs();
		}

		/**
		 * The number of segments that make up the cube along the X-axis. Defaults to 1.
		 */
		public function get segmentsW() : Number
		{
			return _segmentsW;
		}

		public function set segmentsW(value : Number) : void
		{
			_segmentsW = value;
			invalidateGeometry();
			invalidateUVs();
		}

		/**
		 * The number of segments that make up the cube along the Y-axis. Defaults to 1.
		 */
		public function get segmentsH() : Number
		{
			return _segmentsH;
		}

		public function set segmentsH(value : Number) : void
		{
			_segmentsH = value;
			invalidateGeometry();
			invalidateUVs();
		}

		/**
		 * The number of segments that make up the cube along the Z-axis. Defaults to 1.
		 */
		public function get segmentsD() : Number
		{
			return _segmentsD;
		}

		public function set segmentsD(value : Number) : void
		{
			_segmentsD = value;
			invalidateGeometry();
			invalidateUVs();
		}

		/**
		 * @inheritDoc
		 */
		 public function updateGeometry(){
			invalidateGeometry();
		}
		var uvData : Vector.<Number>;
		var firstBuilt:Boolean = true;
		protected override function buildGeometry(target : CompactSubGeometry):void
		{
			

			var length=pathPos.length;

			var numVerts : uint = length*(circSeg+2);
			var numTriangles : uint = (length-1)*circSeg*2*(doubleSided?2:1);
			
			var vertices : Vector.<Number>
			var vertexNormals : Vector.<Number>
			//var vertexTangents : Vector.<Number>
			var indices : Vector.<uint>
			
			if(firstBuilt){
				vertices = new Vector.<Number>(numVerts * 3, true);
				vertexNormals = new Vector.<Number>(numVerts * 3, true);
				//var vertexTangents : Vector.<Number> = new Vector.<Number>(numVerts * 3, true);
				indices = new Vector.<uint>(numTriangles * 3, true);
				uvData = new Vector.<Number>(numVerts*2, true);
			}else{
				vertices = target.vertexData;
				vertexNormals = target.vertexNormalData;
				//tangents = target.vertexTangentData;
				indices = target.indexData;
			}
			 /*
			var vertices : Vector.<Number> = new Vector.<Number>(numVerts * 3, true);
			var vertexNormals : Vector.<Number> = new Vector.<Number>(numVerts * 3, true);
			var vertexTangents : Vector.<Number> = new Vector.<Number>(numVerts * 3, true);
			var indices : Vector.<uint> = new Vector.<uint>(numTriangles * 3, true);
			uvData = new Vector.<Number>(numVerts*2, true);
			*/
			
			//if(firstBuilt){
			
			if(true){
			//vertex
			var vind=0;
			var uind=0;
			
			var v:Vector3D = new Vector3D();
			var vc:Vector3D = new Vector3D();
			var nc:Vector3D = new Vector3D();
			var uv2=0;var uv2Inc=1/((pathPos.length-1)/2);
			trace("UV2INC::"+uv2Inc);
			
			var shiftii=0;
			var mulRadius=1;
			var twist=twist0;
			var twistMatrix = new Matrix3D();
			twistMatrix.appendRotation(twist,new Vector3D(0,0,1));
			for(var i=0;i<pathPos.length;i++){
				v = pathPos[i];
				//draw Circle
				var ii:uint;
				shiftii+=circSegShift;
				//two sides
				curve=curve0+(curve1-curve0)*i/(pathPos.length-1);
				for(var sideInd=0;sideInd<2;sideInd++){
					for(var segInd=0;segInd<circSeg/2+1;segInd++){
						var perc=segInd/(circSeg/2);perc=(1-fillPerc)/2+perc*fillPerc;
						var pos = getPosition(sideInd,perc);
						vc.x=pos.x;vc.y=pos.y;vc.z=0;
						vc=twistMatrix.transformVector(vc);
						vc=pathRot[i].transformVector(vc);
						vc.incrementBy(v);
						nc=v.subtract(vc);
						vertices[vind]=vc.x;vertexNormals[vind]=nc.x; vind++;//vertexTangents[vind]=0;vind++;
						vertices[vind]=vc.y;vertexNormals[vind]=nc.y; vind++;//vertexTangents[vind]=0;vind++;
						vertices[vind]=vc.z;vertexNormals[vind]=nc.z; vind++;//vertexTangents[vind]=0;vind++;
						uvData[uind]=uv2;uind++;
						if(sideInd==0) uvData[uind]=segInd/circSeg*2;
						else uvData[uind]=1-segInd/circSeg*2;
						uind++;
					}
				}
				uv2+=uv2Inc;
				if((uv2==1)||(uv2==0)) uv2Inc*=-1;
			}
			}
			
			if(firstBuilt){
			//index
			var iind=0;
			//var divCirc=holesCirc+facesCirc;
			for(var i=0;i<pathPos.length-1;i++){
				for(var sideInd=0;sideInd<2;sideInd++){
					for(var segInd=0;segInd<circSeg/2;segInd++){
						var ii=sideInd*(circSeg/2+1)+segInd;
						
						indices[iind]=i*(circSeg+2)+ii+1;iind++;
						indices[iind]=(i+1)*(circSeg+2)+ii;iind++;
						indices[iind]=i*(circSeg+2)+ii;iind++;
					
						indices[iind]=(i+1)*(circSeg+2)+ii+1;iind++;
						indices[iind]=(i+1)*(circSeg+2)+ii;iind++;
						indices[iind]=i*(circSeg+2)+ii+1;iind++;
						if(doubleSided){
						indices[iind]=i*(circSeg+2)+ii;iind++;
						indices[iind]=(i+1)*(circSeg+2)+ii;iind++;
						indices[iind]=i*(circSeg+2)+ii+1;iind++;
						
					
						indices[iind]=i*(circSeg+2)+ii+1;iind++;
						indices[iind]=(i+1)*(circSeg+2)+ii;iind++;
						indices[iind]=(i+1)*(circSeg+2)+ii+1;iind++;
						}
					
					}
					
				}
			}
			target.updateIndexData(indices);
			}
			
			target.autoDeriveVertexTangents=true;
			var data=new Vector.<Number>(numVerts * 13, true);
			for(var i=0;i<numVerts;i++){
				data[i*13+0]=vertices[i*3+0];
				data[i*13+1]=vertices[i*3+1];
				data[i*13+2]=vertices[i*3+2];
				
				data[i*13+3]=vertexNormals[i*3+0];
				data[i*13+4]=vertexNormals[i*3+1];
				data[i*13+5]=vertexNormals[i*3+2];
				
				//data[i*13+6]=vertexTangents[i*3+0];
				//data[i*13+7]=vertexTangents[i*3+1];
				//data[i*13+8]=vertexTangents[i*3+2];
				
				data[i*13+9]=uvData[i*2+0];
				data[i*13+10]=uvData[i*2+1];
			}
			target.updateData(data);
			
			//target.autoDeriveVertexNormals=true;
			//target.autoDeriveVertexTangents=true;
			//target.updateVertexData(vertices);
			//target.updateVertexNormalData(vertexNormals);
			//target.updateVertexTangentData(vertexTangents);
			
			firstBuilt=false;
		}
		
		public function getPosition(sideInd,perc):Object{
			var pos={x:0,y:0};
			var posWall = getPositionWalls(sideInd,perc);
			var posCirc = getPositionCirc(sideInd,perc);
			pos.x=(posWall.x+(posCirc.x-posWall.x)*curve);
			pos.y=(posWall.y+(posCirc.y-posWall.y)*curve);
			return pos;
		}
		public function getPositionWalls(sideInd,perc):Object{
			var pos={x:0,y:0}
					if(sideInd==0){
						pos.x=radius;
						pos.y=height*(1-perc*2);
					}else{
						pos.x=-radius;
						pos.y=height*(perc*2-1);
					}
			return pos;
		}
		public function getPositionCirc(sideInd,perc):Object{
			var pos={x:0,y:0}
			//if(circRandom>0)mulRadius=1-Math.random()*circRandom;
			pos.x=Math.sin((sideInd+perc)*Math.PI)*radius;
			pos.y=Math.cos((sideInd+perc)*Math.PI)*radius;
			return pos;
		}

		/**
		 * @inheritDoc
		 */
		override protected function buildUVs(target : CompactSubGeometry) : void
		{
			/*
			var uvData : Vector.<Number>;
			var numUvs=4*2;
			uvData = new Vector.<Number>(numUvs, true);
			var uvi=0;
			for(var i=0;i<4;i++){
				uvData[uvi++]=0;
				uvData[uvi++]=0;
			}*/
			//target.updateUVData(uvData);
		}
	}
}