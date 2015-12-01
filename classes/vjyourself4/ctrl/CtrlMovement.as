package vjyourself4.ctrl{
	import vjyourself4.patt.WaveFollow;
	import flash.events.TransformGestureEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.events.MouseEvent;
	import vjyourself4.VJYBase;
	import vjyourself4.io.IOManager;
	
	public class CtrlMovement extends VJYBase{
	
		//io
		public var io:IOManager;
		public var ns:Object;
		public var speedMax:Number=10;
		public var speedDef:Number=1;
		public var speedMin:Number=0;
		public var cameraRotXMax:Number=180;
		public var cameraRotYMax:Number=180;
		
		//Output
		public var speed:Number=0; //actualized by delta time
		public var cameraRotX:Number=0;
		public var cameraRotY:Number=0;
		public var cameraRotZ:Number=0;
		public var look:Matrix3D = new Matrix3D();
		
		//Inside
		var sA:Number=0;
		var WFRotX:WaveFollow = new WaveFollow({div:20,treshold:0.001});
		var WFRotY:WaveFollow = new WaveFollow({div:20,treshold:0.001});
		//var mode:String="path"; or roaming ... not implemented yet 
		var dragX0:Number=0;
		var dragY0:Number=0;
		var dragOn:Boolean=false;

		// mkb / touch / gamepad
		var activeInterface:String="";
		
		public function CtrlMovement(){
		}

		public function init(){
			activeInterface = io.lastActiveBase;
			sA=speedDef;
			if(io.touch.enabled){
				io.touch.manager.events.addEventListener(TransformGestureEvent.GESTURE_ZOOM,onZoom,0,0,1);
				io.touch.manager.events.addEventListener(TransformGestureEvent.GESTURE_ROTATE,onRotate,0,0,1);
			}
		}

		//reset speed to v
		public function setsA(v){sA=v;}
		
		function onZoom(e:TransformGestureEvent){
			if(activeInterface=="touch"){
				sA*=e.scaleX;
				if(sA>speedMax) sA=speedMax;
				if(sA<0) sA=0;
			}
		}
		
		function onRotate(e:TransformGestureEvent){
			if(activeInterface=="touch"){
				cameraRotZ=(cameraRotZ+e.rotation+360)%360;
			}
		}

		public function onEF(ev:Object){
			var ff=ev.delta*60/1000;
			activeInterface = io.lastActiveBase;

			switch(activeInterface){

				//move by Mouse & Keyboard
				case "mkb":
					if(io.mkb.manager.keys.Up) sA+=0.04;
					if(io.mkb.manager.keys.Down){
						sA-=0.02;
						if(sA<0) sA=0;
					}else{
						if(sA<speedDef) sA+=0.01;
					}
					if(sA>speedDef) sA-=0.02;
					if(sA>speedMax) sA=speedMax;
					if(io.mkb.manager.keys.Right) cameraRotZ+=1;
					if(io.mkb.manager.keys.Left) cameraRotZ-=1;
					if(cameraRotZ>360) cameraRotZ-=360;if(cameraRotZ<0) cameraRotZ+=360;
					if(io.mkb.manager.drag.active){
						WFRotX.setVal(io.mkb.manager.drag.drX);
						WFRotY.setVal(io.mkb.manager.drag.drY);
					}else{
						WFRotX.setVal(0);
						WFRotY.setVal(0);
					}
					
				break;

				//move by Touch
				case "touch":
					if(io.touch.manager.drag.active){
						WFRotX.setVal(io.touch.manager.drag.drX);
						WFRotY.setVal(io.touch.manager.drag.drY);
					}else{
						WFRotX.setVal(0);
						WFRotY.setVal(0);
					}
					if(sA>speedDef) sA=speedDef+(sA-speedDef)*0.98;
					if(sA<speedDef) sA=speedDef+(sA-speedDef)*0.98;
				break;

				//move by Gamepad
				case "gamepad":
					var s0=io.gamepad.manager.getState(0);
					var s1=io.gamepad.manager.getState(1);
					merge(s0.LeftStick,s1.LeftStick,"x");
					merge(s0.LeftStick,s1.LeftStick,"y");
					merge(s0.RightStick,s1.RightStick,"x");
					merge(s0.RightStick,s1.RightStick,"y");
					
					cameraRotZ+=s0.LeftStick.x*ff;
						
					WFRotX.setVal(s0.RightStick.x);
					WFRotY.setVal(-s0.RightStick.y);
						
					var val=s0.LeftStick.y;
					if(val>=0) sA=speedDef+val*(speedMax-speedDef);
					else sA=speedDef+val*(speedDef-speedMin);
				break;
					
				default:
				sA=1;
			}
			
			WFRotX.onEF();WFRotY.onEF();
			cameraRotX=WFRotX.val*cameraRotXMax;
			cameraRotY=WFRotY.val*cameraRotXMax;
			
			//adjust actual frame timing;
			speed=sA*ff;
		}
		
		function merge(o0,o1,n){o0[n]=o0[n]+o1[n];if(o0[n]>1) o0[n]=1;if(o0[n]<-1) o0[n]=-1;}

		public function dispose(){
			if(io.touch.enabled){
				io.touch.manager.events.removeEventListener(TransformGestureEvent.GESTURE_ZOOM,onZoom);
				io.touch.manager.events.removeEventListener(TransformGestureEvent.GESTURE_ROTATE,onRotate);
			}
		}
	}
}