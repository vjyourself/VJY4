package vjyourself4.three
{
	import flash.geom.Vector3D;
	import flash.geom.Matrix3D;
	import away3d.primitives.WireframePrimitiveBase;

	/**
	 * A WirefameCube primitive mesh.
	 */
	public class WireframePipeBasic extends WireframePrimitiveBase
	{
		private var _width : Number;
		private var _height : Number;
		private var _depth : Number;

	
		public var pathPos:Array;
		public var pathRot:Array;
		

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
		public var scaleDown:Number=1;

		public var circleParams:Object={};
		public var planeParams:Object={};
		public var sinParams:Object={freqX:1,freqY:1};
		public var starParams:Object={innerPerc:0.6};
		public var heartParams:Object={}

		public var noise:Object={x:0,y:0,z:0};
	
		public var getPlaneVertex:Function;
		
		//color / thickness - from parent class
		
		public function WireframePipeBasic(code) {
			super();
			
			pathPos=code.path.pos;
			pathRot=code.path.rot;
		
			for ( var i in code ) if ( hasOwnProperty(i) ) this[i]=code[i];
			for ( var i in code.wf ) if ( hasOwnProperty(i) ) this[i]=code.wf[i];
		
		}
		
		public function updateGeometry(){
			invalidateGeometry();
		}

	
		override protected function buildGeometry() : void
		{
			buildGeometryStatic();
		}
		
		
		
		function buildGeometryStatic(){
			
			//Init Box
			for(var iii in box0) box[iii]=box0[iii];
			if(box1!=null){
				boxChange=true;
				for(var iii in box) boxDelta[iii]=box1[iii]-box0[iii];
			}

			//Init Plane function
			getPlaneVertex=this[shape+"GetVertex"];
			switch(shape){
				case "circle":case "star":slp=true;break;
				case "sin":sinParams.shift=sinParams.shift0;break;
				default:slp=false;break;
			}
			if(segLoop!="auto") slp=segLoop=="yes";
			var segCountR:Number = segCount;if(!slp) segCountR++;
			
			//Init variables for Building
			var drawPlane:Boolean;
			var pp:Object={x:0,y:0};
			var i:Number;
			var ii:Number;
			var segInd=0;
			var prevCircle:Array=[];
			var segShift=angleStart;
			var percRot=0;
			var v0:Vector3D = new Vector3D(0,0,0);
			var v1:Vector3D = new Vector3D(0,0,0);
			var vc0:Vector3D = new Vector3D(0,0,0);
			var vc1:Vector3D = new Vector3D(0,0,0);
			var vc00:Vector3D;

			//Start Building WireFrame
			for(i=0;i<pathPos.length;i++){
				//calculate actual box params
				if(boxChange) for(var iii in boxDelta) box[iii]=box0[iii]+boxDelta[iii]*i/(pathPos.length-1);
				//function specific per Plane updates
				switch(shape){
					case "sin":sinParams.percY=i/(pathPos.length-1);break;
				}

				v1 = pathPos[i];
				v0 = v1;
				vc00 = new Vector3D();
				
				drawPlane=lines.plane && (!(i==0 && ! lines.planeFirst ));

				for(ii=0;ii<segCountR;ii++){
					percRot=Math.round(angleSpread/segCount*ii+segShift);
					getPlaneVertex(pp,percRot,ii);
				
					vc1.x=pp.x+box.x+((noise.x==0)?0:(Math.random()-0.5)*noise.x);
					vc1.y=pp.y+box.y+((noise.y==0)?0:(Math.random()-0.5)*noise.y);
					vc1.z=(noise.z==0)?0:(Math.random()-0.5)*noise.z;
					if(scaleDown!=1) vc1.scaleBy(scaleDown);
					//vc1=rotZMatrix.transformVector(vc1);
					vc1=pathRot[i].transformVector(vc1);
					vc1.incrementBy(pathPos[i]);
					
					//AddLine.Plane
					if(ii>0){
						if(drawPlane){
							updateOrAddSegment(segInd,vc0,vc1);
							segInd++;
						}
					}else vc00.copyFrom(vc1);
					vc0.copyFrom(vc1);
				
					//AddLine.Long
					if((i>0)&&lines.long){
						updateOrAddSegment(segInd,prevCircle[ii],vc1);
						segInd++;
					}
					prevCircle[ii]=vc1.clone();
				}
				
				segShift+=angleSpread/segCount*angleShift;
				
				//last closing segment on Plane
				if(lines.planeClose && drawPlane){
					updateOrAddSegment(segInd,vc00,vc1);
					segInd++;
				}

			}

		}

		/* Plane Generating Functions */

		public function circleGetVertex(pp:Object,percRot:Number,ind:Number){
			pp.x=Math.sin(Math.PI*2*percRot/360)*box.width/2;
			pp.y=Math.cos(Math.PI*2*percRot/360)*box.height/2;
		}
		function logPerc(perc,mid=0.2):Number{
			return perc<0.5?perc*2*mid:mid+(perc-0.5)*2*(1-mid);
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

		/*
		public function onEF(){
			removeAllSegments();
			invalidateGeometry();
			buildGeometryStatic();
		}*/
		
	}
}
