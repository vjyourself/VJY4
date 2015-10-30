package vjyourself4.three{
	import flash.geom.Vector3D;
	import flash.geom.Matrix3D;
	public class PathSegment{
		public var locRotX:Number=0;
		public var locRotY:Number=0;
		public var locRotZ:Number=0;
		public var locPos:Vector3D;
		public var globRot0:Matrix3D;
		public var globPos0:Vector3D;
		public var globRot1:Matrix3D;
		public var globPos1:Vector3D;
		
		public var type:String="Line";
		public var length:Number=0;
		public var alpha:Number=0;
		public var alpha0:Number=0;
		public var alpha1:Number=0;
		public var radius:Number=0;
		public var depth:Number=1000;
		var zTwist:Object={alpha:0,alpha0:0,alpha1:0};

		var Line_ZigZag_width:Number=0;
		var Line_ZigZag_height:Number=0;
		function PathSegment(p:Object){
			
			if(p.zTwist!=null){
				zTwist.alpha0=p.zTwist.alpha0;
				zTwist.alpha1=p.zTwist.alpha1;
				zTwist.alpha=p.zTwist.alpha1-p.zTwist.alpha0;
				locRotZ=zTwist.alpha;
			}else{
				zTwist.alpha0=0;
				zTwist.alpha1=0;
				zTwist.alpha=0;
			}
			type=p.type;
			length=p.length;
			switch(type){
				
				case "Line":
				locPos = new Vector3D(0,0,length);
				break;
				case "Line_ZigZag":
				locPos = new Vector3D(0,0,length);
				Line_ZigZag_width=p.width;
				Line_ZigZag_height=p.height;
				break;

/*
				case "LinearTurn":
				alpha0=p.alpha0;
				alpha1=p.alpha1;
				alpha=alpha1-alpha0;
				locPos = new Vector3D(0,0,length);
				break;
*/				
				case "CurveXZ":
				alpha=p.alpha;
				radius=length/alpha*180/Math.PI;
				locPos = new Vector3D( (Math.sin((270+alpha)/180*Math.PI)+1)*radius,0,Math.sin(alpha/180*Math.PI)*radius);
				locRotY=alpha;
				break;

				case "SpiralXZ":
				alpha=p.alpha;
				radius=length/alpha*180/Math.PI;
				depth=p.depth;
				locPos = new Vector3D( (Math.sin((270+alpha)/180*Math.PI)+1)*radius,depth,Math.sin(alpha/180*Math.PI)*radius);
				locRotY=alpha;
				break;
				
				case "CurveYZ":
				alpha=p.alpha;
				radius=length/alpha*180/Math.PI;
				locPos = new Vector3D(0,(Math.sin((270+alpha)/180*Math.PI)+1)*radius,Math.sin(alpha/180*Math.PI)*radius);
				locRotX=-alpha;
				break;

				case "SpiralYZ":
				alpha=p.alpha;
				radius=length/alpha*180/Math.PI;
				depth=p.depth;
				locPos = new Vector3D(depth,(Math.sin((270+alpha)/180*Math.PI)+1)*radius,Math.sin(alpha/180*Math.PI)*radius);
				locRotX=-alpha;
				break;


				case "SpiralXY":
				alpha=p.alpha;
				radius=length/alpha*180/Math.PI;
				depth=p.depth;
				locPos = new Vector3D((Math.sin((270+alpha)/180*Math.PI)+1)*radius,Math.sin(alpha/180*Math.PI)*radius,depth);
				locRotX=-alpha;
				break;
			}
			
		}
		
		public function destroy(){
			locPos=null;
			globRot0=null;
			globPos0=null;
			globRot1=null;
			globPos1=null;
		}
		function setGlobTrans(startPos:Vector3D,startRot:Matrix3D){
			globPos0=startPos.clone();
			globRot0=startRot.clone();
			
			globPos1=globPos0.clone();
			var v2:Vector3D=globRot0.transformVector(locPos);
			globPos1.incrementBy(v2);
			//trace("Segment"+type+" : "+locPos);
			//trace("globPos1:"+globPos1);
			
			globRot1=globRot0.clone();
			
			globRot1.appendRotation(locRotX,globRot0.transformVector(new Vector3D(1,0,0)));
			globRot1.appendRotation(locRotY,globRot0.transformVector(new Vector3D(0,1,0)));
			globRot1.appendRotation(locRotZ,globRot0.transformVector(new Vector3D(0,0,1)));
			
			//trace("globRot1:"+globRot1.rawData);
		}
		
		function getLocPos(perc:Number):Vector3D{
			var retPos:Vector3D;
			switch(type){
				case "Line":
				retPos= new Vector3D(0,0,length*perc);
				break;
				case "Line_ZigZag":
				retPos= new Vector3D(Math.sin(perc*Math.PI*2*3)*Line_ZigZag_width,Math.sin(perc*Math.PI*2*3)*Line_ZigZag_height,length*perc);
				break;
				/*
				case "LinearTurn":
				retPos= new Vector3D(0,0,length*perc);
		
				//retPos= new Vector3D(Math.random()*10,Math.random()*10,length*perc);
				break;
				*/
				case "CurveXZ":
				retPos = new Vector3D( (Math.sin((270+alpha*perc)/180*Math.PI)+1)*radius,0,Math.sin(alpha*perc/180*Math.PI)*radius);
				break;

				case "SpiralXZ":
				retPos = new Vector3D( (Math.sin((270+alpha*perc)/180*Math.PI)+1)*radius,depth*perc,Math.sin(alpha*perc/180*Math.PI)*radius);
				break;

				case "CurveYZ":
				retPos = new Vector3D( 0,(Math.sin((270+alpha*perc)/180*Math.PI)+1)*radius,Math.sin(alpha*perc/180*Math.PI)*radius);
				break;

				case "SpiralYZ":
				retPos = new Vector3D( depth*perc,(Math.sin((270+alpha*perc)/180*Math.PI)+1)*radius,Math.sin(alpha*perc/180*Math.PI)*radius);
				break;

				case "SpiralXY":
				retPos = new Vector3D( (Math.sin((270+alpha*perc)/180*Math.PI)+1)*radius,Math.sin(alpha*perc/180*Math.PI)*radius,depth*perc);
				break;
			}
			return retPos
		}
		function getGlobPos(perc:Number):Vector3D{
			var retGlobPos:Vector3D = getLocPos(perc);
			retGlobPos = globRot0.transformVector(retGlobPos);
			retGlobPos.incrementBy(globPos0);
			return retGlobPos;
		}
		
		function getLocRot(perc:Number):Object{
			var retRot:Object={x:0,y:0,z:0};
			retRot.z=zTwist.alpha0+zTwist.alpha*perc;
			switch(type){
				case "Line":
				break;
				case "Line_ZigZag":
				break;

				/*case "LinearTurn":
				retRot.z=alpha0+alpha*perc;
				break;
				*/
				case "CurveXZ":
				retRot.y=alpha*perc;
				break;

				case "SpiralXZ":
				retRot.y=alpha*perc;
				break;

				case "CurveYZ":
				retRot.x=-alpha*perc;
				break;

				case "SpiralYZ":
				retRot.x=-alpha*perc;
				break;

				case "SpiralXY":
				retRot.z=alpha*perc;
				break;
			}
			return retRot
		}
		
		function getGlobRot(perc:Number):Matrix3D{
			var retGlobRot:Matrix3D = globRot0.clone();
			var locRot=getLocRot(perc);

			retGlobRot.appendRotation(locRot.x,globRot0.transformVector(new Vector3D(1,0,0)));
			retGlobRot.appendRotation(locRot.y,globRot0.transformVector(new Vector3D(0,1,0)));
			retGlobRot.appendRotation(locRot.z,globRot0.transformVector(new Vector3D(0,0,1)));

			return retGlobRot;
		}
		
	}
}