package vjyourself4.three
{
	import away3d.arcane;
	import away3d.core.base.CompactSubGeometry;
	import away3d.primitives.PrimitiveBase;
	import flash.geom.Vector3D;
	import flash.geom.Matrix3D;

	use namespace arcane;

	
	public class GeometryPipeBasic extends PrimitiveBase
	{
		private var _width : Number;
		private var _height : Number;
		private var _depth : Number;
		private var _tile6 : Boolean;
		
		private var _segmentsW : Number;
		private var _segmentsH : Number;
		private var _segmentsD : Number;

	

		public var pathPos:Array;
		public var pathRot:Array;

		public var doubleSided:Boolean=false;
		public var uv:Object={mirrorU:true,countU:2,mirrorV:true,countV:2};

		public var segCount:Number=12;
		public var segLoop:String="auto";
		var slp:Boolean=true;

		public var angleSpread:Number=360;
		public var angleStart:Number=0;
		public var angleShift:Number=0;
		
		public var box0:Object;
		public var box1:Object;
		var box:Object={width:240,height:240,x:0,y:0};
		var boxChange:Boolean = false;
		var boxDelta:Object={};

		public var shape:String="circle";
		public var lines:Object={plane:true,planeClose:true,planeFirst:false,long:true}

		public var circleParams:Object={};
		public var planeParams:Object={};
		public var sinParams:Object={freqX:1,freqY:1};
		public var starParams:Object={innerPerc:0.6}

		public var noise:Object={x:0,y:0,z:0};
	
		public var getPlaneVertex:Function;
		
		public function GeometryPipeBasic(code:Object)
		{
			super();
			pathPos=code.path.pos;
			pathRot=code.path.rot;
		
			for ( var i in code ) if ( hasOwnProperty(i) ) this[i]=code[i];
			for ( var i in code.mesh ) if ( hasOwnProperty(i) ) this[i]=code.mesh[i];
		}


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
		var data:Vector.<Number>;
		var firstBuilt:Boolean = true;
		var tt : CompactSubGeometry
		protected override function buildGeometry(target : CompactSubGeometry):void
		{
			
			tt=target;

			//Init Box
			for(var iii in box0) box[iii]=box0[iii];
			if(box1!=null){
				boxChange=true;
				for(var iii in box) boxDelta[iii]=box1[iii]-box0[iii];
			}
		
			//Init Plane Function
			getPlaneVertex=this[shape+"GetVertex"];			
			switch(shape){
				case "circle":case "star":slp=true;break;
				case "sin":sinParams.shift=sinParams.shift0;break;
				default:slp=false;break;
			}
			if(segLoop!="auto") slp=segLoop=="yes";
			var segCountR = segCount; if(!slp) segCountR++;
			var segCountR=segCount+1;

			//Init Buffers
			var length=pathPos.length;
			var numVerts : uint = length*(segCountR);
			var numTriangles : uint = (length-1)*segCount*2*(doubleSided?2:1);
			var vertices : Vector.<Number> = new Vector.<Number>(numVerts * 3, true);	
			var vertexNormals : Vector.<Number> = new Vector.<Number>(numVerts * 3, true);
			//var vertexTangents : Vector.<Number>
			var indices : Vector.<uint> = new Vector.<uint>(numTriangles * 3, true);
			uvData = new Vector.<Number>(numVerts*2, true);

			//Init variables for Build
			
			var vind=0;
			var uind=0;
			var v:Vector3D = new Vector3D();
			var vc:Vector3D = new Vector3D();
			var nc:Vector3D = new Vector3D();
			var uv2Inc=1/(pathPos.length-1)*uv.countU;
			var uv2=0;
			var segShift=angleStart;
			
			var pp:Object={x:0,y:0};
			var percRot:Number=0;

			//Building the Geometry
			for(var i=0;i<pathPos.length;i++){
				//calculate actual box params
				if(boxChange) for(var iii in boxDelta) box[iii]=box0[iii]+boxDelta[iii]*i/(pathPos.length-1);
				//function specific per Plane updates
				switch(shape){
					case "sin":sinParams.percY=i/(pathPos.length-1);break;
				}
				
				v = pathPos[i];


				for(ii=0;ii<segCountR;ii++){
					percRot=Math.round(angleSpread/segCount*ii+segShift);
					getPlaneVertex(pp,percRot,ii);
						
						vc.x=pp.x+box.x+((noise.x==0)?0:(Math.random()-0.5)*noise.x);
						vc.y=pp.y+box.y+((noise.y==0)?0:(Math.random()-0.5)*noise.y);
						vc.z=(noise.z==0)?0:(Math.random()-0.5)*noise.z;
						
						vc=pathRot[i].transformVector(vc);
						vc.incrementBy(v);
						nc=v.subtract(vc);
						vertices[vind]=vc.x;vertexNormals[vind]=nc.x; vind++;
						vertices[vind]=vc.y;vertexNormals[vind]=nc.y; vind++;
						vertices[vind]=vc.z;vertexNormals[vind]=nc.z; vind++;
						uvData[uind]=uv2;uind++;
						if(uv.mirrorV) uvData[uind]=( (ii<=segCount/2)?ii/segCount*2:2-ii/segCount*2 )*uv.countV/2;
						else uvData[uind]=ii/(segCountR-1)*uv.countV;
						uind++;
					
				}

				segShift+=angleSpread/segCount*angleShift;


				//UV.u
				uv2+=uv2Inc;
				if(uv.mirrorU){
					if((uv2==1)||(uv2==0)) uv2Inc*=-1;
				}

			}
			
			
			
			//index
			var iind=0;
			//var divCirc=holesCirc+facesCirc;
			for(var i=0;i<pathPos.length-1;i++){
				for(var ii=0;ii<segCount;ii++){
						
						indices[iind]=i*(segCountR)+ii+1;iind++;
						indices[iind]=(i+1)*(segCountR)+ii;iind++;
						indices[iind]=i*(segCountR)+ii;iind++;
					
						indices[iind]=(i+1)*(segCountR)+ii+1;iind++;
						indices[iind]=(i+1)*(segCountR)+ii;iind++;
						indices[iind]=i*(segCountR)+ii+1;iind++;
						
						if(doubleSided){
						indices[iind]=i*(segCountR)+ii;iind++;
						indices[iind]=(i+1)*(segCountR)+ii;iind++;
						indices[iind]=i*(segCountR)+ii+1;iind++;
						
					
						indices[iind]=i*(segCountR)+ii+1;iind++;
						indices[iind]=(i+1)*(segCountR)+ii;iind++;
						indices[iind]=(i+1)*(segCountR)+ii+1;iind++;
						}
					
					}
			}
			
			
			
			//target.autoDeriveVertexTangents=true;
			data=new Vector.<Number>(numVerts * 13, true);
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
			target.updateIndexData(indices);

			//target.autoDeriveVertexNormals=true;
			//target.updateVertexData(vertices);
			//target.updateVertexNormalData(vertexNormals);
			//target.updateVertexTangentData(vertexTangents);
		}
		
		/* Plane Generating Functions */

		public function circleGetVertex(pp:Object,percRot:Number,ind:Number){
			pp.x=Math.sin(Math.PI*2*percRot/360)*box.width/2;
			pp.y=Math.cos(Math.PI*2*percRot/360)*box.height/2;
		}
		function easePerc(perc):Number{
			return Math.cos(perc*Math.PI)*-0.5+0.5;
		}
		public function heartGetVertex(pp:Object,percRot:Number,ind:Number){
			var pc=easePerc((percRot%90)/90);
			switch(Math.floor(percRot/90)){
				case 0:
				pp.x=pc*2;
				pp.y=Math.sqrt(1-(pp.x-1)*(pp.x-1));
				break;
				case 1:
				pp.x=2-pc*2;
				pp.y=-3*Math.sqrt(1-Math.sqrt(pp.x)/Math.sqrt(2));
				break;
				case 2:
				pp.x=-pc*2;
				pp.y=-3*Math.sqrt(1-Math.sqrt(-pp.x)/Math.sqrt(2));
				break;

				case 3:
				pp.x=-2+pc*2;
				pp.y=Math.sqrt(1-(-pp.x-1)*(-pp.x-1));
				break;
				case 4:
				pp.x=0;
				pp.y=0;
				break;
			}
			pp.x*=box.width/4;
			pp.y=(pp.y+1)*box.height/4;
		}
		public function starGetVertex(pp:Object,percRot:Number,ind:Number){
			pp.x=Math.sin(Math.PI*2*percRot/360)*box.width/2*((ind%2)?1:starParams.innerPerc);
			pp.y=Math.cos(Math.PI*2*percRot/360)*box.height/2*((ind%2)?1:starParams.innerPerc);
		}
		public function planeGetVertex(pp:Object,percRot:Number,ind:Number){
			pp.x=(percRot/180-1)*box.width/2;
			pp.y=0;
		}
		public function sinGetVertex(pp:Object,percRot:Number,ind:Number){
			pp.x=(percRot/180-1)*box.width/2;
			pp.y=Math.sin(Math.PI*2*(percRot*sinParams.freqX+sinParams.freqY*sinParams.percY*360)/360)*box.height/2;
		}
		public function randomGetVertex(pp:Object,percRot:Number,ind:Number){
			pp.x=(Math.random()-0.5)*box.width;
			pp.y=(Math.random()-0.5)*box.height;
		} 

		override protected function buildUVs(target : CompactSubGeometry) : void
		{
			
		}

		public var spritesDiv:Number=4;
		public var spritesX:Number=0;
		public var spritesY:Number=0;
		public var spritesCC:Number=0;
		var uvs0:Vector.<Number>;
		var uvs1:Vector.<Number>;
		public var aniPerc:Number=0;
		public var aniPerc2:Number=0;

		public function onEF(e=null){		
			if((shiftAniVal!=0)||(zoomVal!=1)||(zoomYVal!=1)||(distroVal!=0)){
					
			}
			onEFShiftZoomDistro();
		}

		var verts:int=0;
		function saveOriginalValues(){
			if(uvs0==null){
				verts=data.length/13;
				uvs0=new Vector.<Number>(verts*2,true);
				for(var i=0;i<verts;i++){
					uvs0[i*2+0]=data[i*13+9];
					uvs0[i*2+1]=data[i*13+10];
				}
			}
		}

		public var distroVal:Number=0;
		public var zoomVal:Number=1;
		public var zoomYVal:Number=1;
		public var shiftVal:Number=0;
		public var shiftAniVal:Number=100;
		public function onEFShiftZoomDistro(e=null){	
			saveOriginalValues();

			//aniPerc2+=aniPerc/100;if(aniPerc2>10000)aniPerc2-=10000;
			if(!distroInit){
				uvs1=new Vector.<Number>(verts*2,true);
				for(var i=0;i<verts;i++){
					uvs1[i*2+0]=Math.random();
					uvs1[i*2+1]=Math.random();
				}
				distroInit=true;
			}else{
				for(var i=0;i<verts;i++){
					uvs1[i*2+0]+=(Math.random()*2-1)*0.05;
					uvs1[i*2+1]+=(Math.random()*2-1)*0.05;
				}
			}
			shiftVal+=shiftAniVal/150; if(shiftVal>1) shiftVal-=1;
			for(var i=0;i<verts;i++) {
				data[i*13+9]=uvs0[i*2+0]*zoomVal+shiftVal*zoomVal+distroVal*distroVal*uvs1[i*2]*zoomVal;
				data[i*13+10]=(uvs0[i*2+1]+shiftVal+distroVal*distroVal*uvs1[i*2+1])*zoomVal*zoomYVal;
			}
			tt.updateData(data);
		}

		var distroInit:Boolean=false;
		public function onEFDistroNoise(e=null){
			saveOriginalValues();
			if(!distroInit){
				uvs1=new Vector.<Number>(verts*2,true);
				for(var i=0;i<verts;i++){
					uvs1[i*2+0]=Math.random();
					uvs1[i*2+1]=Math.random();
				}
				distroInit=true;
			}else{
				for(var i=0;i<verts;i++){
					uvs1[i*2+0]+=(Math.random()*2-1)*0.05;
					uvs1[i*2+1]+=(Math.random()*2-1)*0.05;
				}
			}

			for(var i=0;i<verts;i++) {
				//rnd vibes
				//data[i*13+9]=(uvs0[i*2+0]+0.3*aniPerc*Math.random());
				//data[i*13+10]=(uvs0[i*2+1]+0.3*aniPerc*Math.random());
				data[i*13+9]=(uvs0[i*2+0]+distroVal*distroVal*uvs1[i*2]);
				data[i*13+10]=(uvs0[i*2+1]+distroVal*distroVal*uvs1[i*2+1]);
			}
			tt.updateData(data);
		}

			//SPRITE ANIM
			/*
			spritesCC++
			if(spritesCC>3){
				spritesCC=0;
			
			var verts=data.length/13;
			if(uvs0==null){
				uvs0=new Vector.<Number>(verts*2,true);
				for(var i=0;i<verts;i++){
					uvs0[i*2+0]=data[i*13+9]/spritesDiv;
					uvs0[i*2+1]=data[i*13+10]/spritesDiv;
				}
			}
			
			spritesX++;if(spritesX>=spritesDiv){ spritesX=0;spritesY++}
			if(spritesY>=spritesDiv){spritesX=0;spritesY=0}
			for(var i=0;i<verts;i++) {
				data[i*13+9]=(uvs0[i*2+0]+spritesX/spritesDiv);
				//if(data[i*13+9]>1)data[i*13+9]-=1;
				data[i*13+10]=(uvs0[i*2+1]+spritesY/spritesDiv);
				//if(data[i*13+10]>1)data[i*13+10]-=1;
			}
			
			tt.updateData(data);
		}*/
		
	}
}