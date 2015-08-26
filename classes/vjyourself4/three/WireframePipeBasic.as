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
		

		public var segNum:Number=12;
		public var segWidth:Number=360;
		public var segShift0:Number=0;
		public var segShiftInc:Number=0;

		public var rotZ0:Number=0;
		public var x0:Number=0;
		public var y0:Number=0;
		public var wave:String="";
		
		public var shape:String="circle";
		public var lines:Object={plane:true,planeClose:true,planeLoop:true,long:true}

		public var circleParams:Object={radius:120,radiusRandom:0};
		public var planeParams:Object={width:120,heightRandom:0};
		public var randomParams:Object={width:120,height:120};
		public var sinParams:Object={width:120,height:120,freqX:1,freqY:1};
		public var starParams:Object={radiusOut:120,radiusIn:60}

		public var getPlaneVertex:Function;
		
		//color / thickness - from parent class
		
		public function WireframePipeBasic(myPathPos:Array, myPathRot:Array, p:Object=null, pp:Object=null) {
			super();
			
			if(p==null)p={};if(pp==null)pp={};
			
			for(var i in p)if(hasOwnProperty(i))this[i]=p[i];
			
			for(var i in pp)if(hasOwnProperty(i))this[i]=pp[i];
			
			//trace("PP:"+p["linesCirc"]);

			pathPos=myPathPos;
			pathRot=myPathRot;
			
		}
		
		public function updateGeometry(){
			invalidateGeometry();
		}

		/**
		 * @inheritDoc
		 */
		override protected function buildGeometry() : void
		{
			buildGeometryStatic();
		}
		
		
		
		function buildGeometryStatic(){
			//who makes a difference
			//radius
			//segNum
			//segNumShift
			//linesH
			//linesCirc

			//PLUS
			// radius0 radius1  // radius - random
			var v0:Vector3D = new Vector3D(0,0,0);
			var v1:Vector3D = new Vector3D(0,0,0);
			var vc0:Vector3D = new Vector3D(0,0,0);
			var vc1:Vector3D = new Vector3D(0,0,0);
			var vc00:Vector3D;
			
			var pp:Object={x:0,y:0};
			var i:Number;
			var ii:Number;

			var segInd=0;
			var prevCircle:Array=[];
			var segShift=segShift0;
			var percRot=0;
			

			var rotZ=rotZ0;
			var rotZMatrix = new Matrix3D();
			rotZMatrix.appendRotation(rotZ,new Vector3D(0,0,1));

			getPlaneVertex=this[shape+"GetVertex"];
			switch(shape){
				case "circle":
				circleParams.rr=circleParams.radius;
				break;
				case "sin":
				sinParams.shift=sinParams.shift0;
				break;
			}
		
			for(i=0;i<pathPos.length;i++){
				v1 = pathPos[i];
				//updateOrAddSegment(segInd, v0, v1);
				//segInd++;
				v0=v1;
				//draw Circle
				vc00= new Vector3D();
				var segNumR:Number=segNum;if(!lines.planeLoop)segNumR++;
				for(ii=0;ii<segNumR;ii++){
					percRot=Math.round(segWidth/segNum*ii+segShift)%360;

					getPlaneVertex(pp,percRot,ii);
				
					vc1.x=pp.x+x0;
					vc1.y=pp.y+y0;
					vc1.z=0;
					vc1=rotZMatrix.transformVector(vc1);
					vc1=pathRot[i].transformVector(vc1);
					vc1.incrementBy(pathPos[i]);
					//circle
					if(ii>0){
						if(lines.plane){
							updateOrAddSegment(segInd,vc0,vc1);
							segInd++;
						}
					}else vc00.copyFrom(vc1);
					vc0.copyFrom(vc1);
					//lines
					if((i>0)&&lines.long){
						updateOrAddSegment(segInd,prevCircle[ii],vc1);
						segInd++;
					}
					prevCircle[ii]=vc1.clone();
				}
				
				segShift+=segShiftInc;
				switch(shape){
					case "circle":
					break;
					case "sin":
					sinParams.shift+=sinParams.shiftInc;
					break;
				}
				
				if(lines.planeClose){
					updateOrAddSegment(segInd,vc00,vc1);
					segInd++;
				}

			}

			
		}

		public function circleGetVertex(pp:Object,percRot:Number,ind:Number){
			if(circleParams.radiusRandom>0) circleParams.rr=circleParams.radius+Math.random()*circleParams.radiusRandom;
			pp.x=Math.sin(Math.PI*2*percRot/360)*circleParams.rr;
			pp.y=Math.cos(Math.PI*2*percRot/360)*circleParams.rr;
		}
		public function starGetVertex(pp:Object,percRot:Number,ind:Number){
			var rr=(ind%2)?starParams.radiusOut:starParams.radiusIn;
			pp.x=Math.sin(Math.PI*2*percRot/360)*rr;
			pp.y=Math.cos(Math.PI*2*percRot/360)*rr;
		}
		public function planeGetVertex(pp:Object,percRot:Number,ind:Number){
			switch(wave){
				case "":
				pp.x=(percRot/180-1)*planeParams.width/2;
				pp.y=0;if(planeParams.heightRandom>0)pp.y=Math.random()*planeParams.heightRandom;
				break;
				case "music":
				pp.x=(percRot/180-1)*planeParams.width/2;
				pp.y=100*waveData[Math.floor((waveData.length-1)*percRot/360)];
				//pp.y=0;if(planeParams.heightRandom>0)pp.y=Math.random()*planeParams.heightRandom;
				
				break;
			}
		}
		public function sinGetVertex(pp:Object,percRot:Number,ind:Number){
			pp.x=(percRot/180-1)*sinParams.width/2;
			pp.y=Math.sin(Math.PI*2*(percRot*sinParams.freqX+sinParams.shift)/360)*sinParams.height/2;
		}
		public function randomGetVertex(pp:Object,percRot:Number,ind:Number){
			pp.x=(Math.random()*2-1)*randomParams.width/2;
			pp.y=(Math.random()*2-1)*randomParams.height/2;
		}

		public var waveData:Array=[0];
		public function onEF(){
			removeAllSegments();
			invalidateGeometry();
			buildGeometryStatic();
		}
	}
}
