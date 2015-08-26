package vjyourself4.three.vef
{
	import away3d.arcane;
	import away3d.core.base.CompactSubGeometry;
	import away3d.primitives.PrimitiveBase;
	import flash.geom.Vector3D;

	use namespace arcane;

	/**
	 * A Cube primitive mesh.
	 */
	public class GeometryVEF extends PrimitiveBase
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
		public var prg:Object;
		public function GeometryVEF(objprg:Object)
		{
			super();
			prg=objprg;
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
		var uvData : Vector.<Number>;
		protected override function buildGeometry(target : CompactSubGeometry):void
		{
			var vertices : Vector.<Number>;
			var vertexNormals : Vector.<Number>;
			var vertexTangents : Vector.<Number>;
			var indices : Vector.<uint>;


			
			var verts=prg.verts;
			var faces=prg.faces;
			
			var uvs=[0.5,1-Math.sin(Math.PI/3),
					 1,1,
					 0,1];
					 
					 
			
			var numVerts : uint = faces.length*3;

			var numUvs=numVerts;
			uvData = new Vector.<Number>(numUvs*2, true);
			/*
			if (numVerts == target.numVertices) {
				vertices = target.vertexData;
				vertexNormals = target.vertexNormalData;
				vertexTangents = target.vertexTangentData;
				indices = target.indexData;
			}
			else {*/
				vertices = new Vector.<Number>(numVerts * 3, true);
				vertexNormals = new Vector.<Number>(numVerts * 3, true);
				vertexTangents = new Vector.<Number>(numVerts * 3, true);
				indices = new Vector.<uint>(numVerts, true);
			//}
					 
			//use mutual vertexes
			/*
			var vidx=0;
			for(var i=0;i<geom.length;i++){
				vertexNormals[vidx] = 0;
				vertexTangents[vidx] = 1;
				vertices[vidx++] = geom[i].x;

				vertexNormals[vidx] = 0;
				vertexTangents[vidx] = 0;
				vertices[vidx++] = geom[i].y;
				
				vertexNormals[vidx] = -1;
				vertexTangents[vidx] = 0;
				vertices[vidx++] = geom[i].z;
			}
			for(var i=0;i<tris.length;i++) indices[i]=tris[i];
			*/
			
			//Each face own vertexes
			var ind=0;
			for(var i=0;i<faces.length/3;i++){
				//calculate face normal
				var nx:Number=0;
				var ny:Number=0;
				var nz:Number=0;
				/*
				for(var ii=0;ii<3;ii++){var v=verts[faces[i*3+ii]];nx+=v.x;ny+=v.y;nz+=v.z;}
				var l=Math.sqrt(nx*nx+ny*ny+nz*nz);
				nx/=l;ny/=l;nz/=l;
				*/
				var p0:Vector3D=new Vector3D(verts[faces[i*3]].x,verts[faces[i*3]].y,verts[faces[i*3]].z);
				var p1:Vector3D=new Vector3D(verts[faces[i*3+1]].x,verts[faces[i*3+1]].y,verts[faces[i*3+1]].z);
				var p2:Vector3D=new Vector3D(verts[faces[i*3+2]].x,verts[faces[i*3+2]].y,verts[faces[i*3+2]].z);
				var p1p0=p1.subtract(p0);
				var p2p0=p2.subtract(p0);
				var norm:Vector3D=p1p0.crossProduct(p2p0);
				
				for(var ii=0;ii<3;ii++){
					var v=verts[faces[i*3+ii]];
					vertices[ind*3] = v.x;vertexNormals[ind*3] = norm.x;vertexTangents[ind*3] = 0;
					vertices[ind*3+1] = v.y;vertexNormals[ind*3+1] = norm.y;vertexTangents[ind*3+1] = 0;
					vertices[ind*3+2] = v.z;vertexNormals[ind*3+2] = norm.z;vertexTangents[ind*3+2] = 0;
					indices[ind]=ind;
					uvData[ind*2]=uvs[ii*2];
					uvData[ind*2+1]=uvs[ii*2+1];
					ind++;
				}
			}
			
			var data=new Vector.<Number>(numVerts * 13, true);
			for(var i=0;i<numVerts;i++){
				data[i*13+0]=vertices[i*3+0];
				data[i*13+1]=vertices[i*3+1];
				data[i*13+2]=vertices[i*3+2];
				
				data[i*13+3]=vertexNormals[i*3+0];
				data[i*13+4]=vertexNormals[i*3+1];
				data[i*13+5]=vertexNormals[i*3+2];
				
				data[i*13+6]=vertexTangents[i*3+0];
				data[i*13+7]=vertexTangents[i*3+1];
				data[i*13+8]=vertexTangents[i*3+2];
				
				data[i*13+9]=uvData[i*2+0];
				data[i*13+10]=uvData[i*2+1];
			}
			target.updateData(data);
			target.updateIndexData(indices);
			
			/*
			//target.autoDeriveVertexNormals=true;
			target.autoDeriveVertexTangents=true;
			target.updateVertexData(vertices);
			target.updateVertexNormalData(vertexNormals);
			//target.updateVertexTangentData(vertexTangents);
			target.updateIndexData(indices);*/
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