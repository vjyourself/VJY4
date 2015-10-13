package vjyourself4.three
{
	import flash.geom.Vector3D;
	import away3d.primitives.WireframePrimitiveBase;

	/*
	radius
	height
	circSeg
	circSegShift

	flat
	
	linesCirc
	linesH
	*/

	public class WireframePipeLegacy extends WireframePrimitiveBase
	{
		private var _width : Number;
		private var _height : Number;
		private var _depth : Number;

	
		public var pathPos:Array;
		public var pathRot:Array;
		
		public var radius:Number=80;
		public var circSeg:Number=36;
		public var circSegShift:Number=0;
		
		public var linesCirc:Boolean=true;
		public var linesH:Boolean=true;
		
		public var flat:Boolean=false;
		public var height:Number=80;

		//color / thickness - from parent class

		public var useData:Boolean=false;
		public var data:Array;
		public var dataMirr:Number=1;
		
		
		public function WireframePipeLegacy(myPathPos:Array, myPathRot:Array, p:Object=null, pp:Object=null) {
			super(0xffffff,1);
			
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
			if ((useData)&&(data!=null)) buildGeometryData();
			else buildGeometryStatic();
		}
		
		function buildGeometryData(){
			var v0:Vector3D = new Vector3D(0,0,0);
			var v1:Vector3D = new Vector3D(0,0,0);
			var vc0:Vector3D = new Vector3D(0,0,0);
			var vc1:Vector3D = new Vector3D(0,0,0);
			
			
			var segInd=0;
			var prevCircle:Array=[];
			var shift=0;
			var dl:Number=data.length-1;
			var dataInd=(0.5-dataMirr/2)*dl;
			var dataStep=dataMirr*dl/pathPos.length;
			for(var i=0;i<pathPos.length;i++){
					vc1.y=radius;vc1.x=data[Math.floor(dataInd)]*height;vc1.z=0;
					vc1=pathRot[i].transformVector(vc1);
					vc1.incrementBy(pathPos[i]);
					if(i>0){
						updateOrAddSegment(segInd,prevCircle[0],vc1);
						segInd++;
					}
					prevCircle[0]=vc1.clone();
					vc1.y=-radius;vc1.x=-data[Math.floor(dataInd)]*height;vc1.z=0;
					vc1=pathRot[i].transformVector(vc1);
					vc1.incrementBy(pathPos[i]);
					if(i>0){
						updateOrAddSegment(segInd,prevCircle[1],vc1);
						segInd++;
					}
					prevCircle[1]=vc1.clone();
					dataInd+=dataStep;
			}
				
		}

		public function onEF(){}
		public var waveData:Array;

		function buildGeometryStatic(){
			//who makes a difference
			//radius
			//circSeg
			//circSegShift
			//linesH
			//linesCirc

			//flat
			//height

			//PLUS
			// radius0 radius1  // radius - random
			var v0:Vector3D = new Vector3D(0,0,0);
			var v1:Vector3D = new Vector3D(0,0,0);
			var vc0:Vector3D = new Vector3D(0,0,0);
			var vc1:Vector3D = new Vector3D(0,0,0);
			
			
			var segInd=0;
			var prevCircle:Array=[];
			var shift=0;
			for(var i=0;i<pathPos.length;i++){
				v1 = pathPos[i];
				//updateOrAddSegment(segInd, v0, v1);
				//segInd++;
				v0=v1;
				//draw Circle
				var vc00= new Vector3D();
				shift+=circSegShift;
				for(var ii=0;ii<circSeg;ii++){
					var xx=Math.sin(Math.PI*2/circSeg*(ii+shift))*radius;
					var yy=Math.cos(Math.PI*2/circSeg*(ii+shift))*radius;
					if(flat){
						yy=-height;
						xx=radius*(ii/circSeg*2-1);
					}
					vc1.x=xx;vc1.y=yy;vc1.z=0;
					vc1=pathRot[i].transformVector(vc1);
					vc1.incrementBy(pathPos[i]);
					//circle
					if((ii>0)&&linesCirc){
						updateOrAddSegment(segInd,vc0,vc1);
						segInd++;
					}else vc00.copyFrom(vc1);
					vc0.copyFrom(vc1);
					//lines
					if((i>0)&&linesH){
						updateOrAddSegment(segInd,prevCircle[ii],vc1);
						segInd++;
					}
					prevCircle[ii]=vc1.clone();
				}
				if(linesCirc){
					updateOrAddSegment(segInd,vc00,vc1);
					segInd++;
				}
			}
		}
	}
}
