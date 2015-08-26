package vjyourself4.input{
	import vjyourself4.patt.WaveFollow;
	import flash.events.TransformGestureEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.events.MouseEvent;
	
	public class InputVJYourself{
		// ctrls / ctrlsA
		// speed
		// cameraRotX / cameraRotY / cameraRotZ
		// shoot (event)
		public var input:InputManager;
		public var ns:Object;
		
		public var ctrls:Array;
		public var ctrlsA:Array;
		public var speed:Number=0; //actualized by delta time
		public var sA:Number=0;
		public var speedMax:Number=10;
		public var speedMin:Number=1;
		public var cameraRotX:Number=0;
		public var cameraRotXMax:Number=180;
		public var cameraRotY:Number=0;
		public var cameraRotYMax:Number=180;
		public var cameraRotZ:Number=0;
		public var look:Matrix3D = new Matrix3D();
		
		var WFLB:WaveFollow= new WaveFollow();
		var WFRB:WaveFollow= new WaveFollow();
		var WFLT:WaveFollow= new WaveFollow();
		var WFRT:WaveFollow= new WaveFollow();
		var WFRotX:WaveFollow = new WaveFollow({div:20,treshold:0.001});
		var WFRotY:WaveFollow = new WaveFollow({div:20,treshold:0.001});
		
		public var mode:String="path"; // path / roaming
		
		var dragX0:Number=0;
		var dragY0:Number=0;
		var dragOn:Boolean=false;

		var fps:Number;
		
		public function InputVJYourself(){
		}
		public function init(){
			ctrls=[0,0,0,0];
			ctrlsA=[0,0,0,0];
			sA=speedMin;
			fps=input.screen.fps;
			switch(input.def){
				case "mkb":
				break;
				case "touch":
				//input.win.addEventListener(TransformGestureEvent.GESTURE_PAN,onPan,0,0,1);
				input.win.addEventListener(TransformGestureEvent.GESTURE_ZOOM,onZoom,0,0,1);
				input.win.addEventListener(TransformGestureEvent.GESTURE_ROTATE,onRotate,0,0,1);
				//input.win.addEventListener(TransformGestureEvent.GESTURE_SWIPE,onSwipe,0,0,1);
				input.stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown,0,0,1);
				input.stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp,0,0,1);
				
				break;
			}
		}
		function onMouseDown(e){
			if((input.stage.mouseY<input.wDimY-input.wLimBottom)&&(input.stage.mouseY>input.wLimTop)){
			dragOn=true;
			input.updateMouseR();
			dragX0=input.mouse.rX;
			dragY0=input.mouse.rY;
		}
		}
		function onMouseUp(e){
			dragOn=false;
			WFRotX.setVal(0);
			WFRotY.setVal(0);
		}
		public function setMode(m){
			this.mode=m;
		}
		public function setsA(v){sA=v;}
		
		public function onEF(ev:Object){
			var ff=ev.delta*60/1000;
			//trace("fps:"+fps+" d:"+ev.delta+" ff:"+ff);
			//trace(input.def);
			switch(input.def){
				case "mkb":
					trace("mkb");
				if(input.keys.Up) sA+=0.04;
				if(input.keys.Down){
					sA-=0.02;
					if(sA<0) sA=0;
				}else{
					if(sA<speedMin) sA+=0.01;
				}
				if(sA>speedMin) sA-=0.02;
				
				if(sA>speedMax) sA=speedMax;
				
				
				if(input.keys.Right) cameraRotZ+=1;
				if(input.keys.Left) cameraRotZ-=1;
				if(cameraRotZ>360) cameraRotZ-=360;if(cameraRotZ<0) cameraRotZ+=360;
				
				switch(this.mode){
					case "path":
					WFRotX.setVal(input.mouse.rX);
					WFRotY.setVal(input.mouse.rY);
					break;
					case "roaming":
					cameraRotX+=input.mouse.rX*2;//if(cameraRotX>360) cameraRotX-=360;if(cameraRotX<0) cameraRotX+=360;
					cameraRotY+=input.mouse.rY*2;//if(cameraRotY>360) cameraRotY-=360;if(cameraRotY<0) cameraRotY+=360;
					var cameraX:Vector3D = look.transformVector(new Vector3D(1,0,0));
					var cameraY:Vector3D = look.transformVector(new Vector3D(0,1,0));
					var cameraZ:Vector3D = look.transformVector(new Vector3D(0,0,1));
					look.appendRotation(cameraRotX,cameraY);
					look.appendRotation(cameraRotY,cameraX);
					look.appendRotation(cameraRotZ,cameraZ);
					cameraRotX=0;cameraRotY=0;cameraRotZ=0;
					break;
				}
				break;
				
				case "gamepad":
				var s0=input.gamepadManager.getState(0);
				var s1=input.gamepadManager.getState(1);
				merge(s0.LeftStick,s1.LeftStick,"x");
				merge(s0.LeftStick,s1.LeftStick,"y");
				merge(s0.RightStick,s1.RightStick,"x");
				merge(s0.RightStick,s1.RightStick,"y");

				if(s0!=null){
					//ctrls
					WFLB.setVal(s0.LB?1:0);WFLB.onEF();
					WFRB.setVal(s0.RB?1:0);WFRB.onEF();
					WFLT.setVal(s0.LeftTrigger);WFLT.onEF();
					WFRT.setVal(s0.RightTrigger);WFRT.onEF();
					ctrls[0]=(s0.LeftTrigger>0.5)?1:0;
					ctrls[1]=(s0.RightTrigger>0.5)?1:0;
					ctrls[2]=s0.LB?1:0;
					ctrls[3]=s0.RB?1:0;
					//ctrlsA[0]=WFLT.val;
					//ctrlsA[1]=WFRT.val;
					//ctrlsA[2]=WFLB.val;
					//ctrlsA[3]=WFRB.val;
					
					//rotate
//					if(Math.abs(s0.LeftStick.x)>0.1) 
						cameraRotZ+=s0.LeftStick.x*ff;
					
					//lookX/lookY/
					switch(this.mode){
					case "path":
					WFRotX.setVal(s0.RightStick.x);
					WFRotY.setVal(s0.RightStick.y);
					break;
					case "roaming":
					cameraRotX+=s0.RightStick.x;//if(cameraRotX>360) cameraRotX-=360;if(cameraRotX<0) cameraRotX+=360;
					cameraRotY+=s0.RightStick.y;//if(cameraRotY>360) cameraRotY-=360;if(cameraRotY<0) cameraRotY+=360;
					var cameraX:Vector3D = look.transformVector(new Vector3D(1,0,0));
					var cameraY:Vector3D = look.transformVector(new Vector3D(0,1,0));
					var cameraZ:Vector3D = look.transformVector(new Vector3D(0,0,1));
					look.appendRotation(cameraRotX,cameraY);
					look.appendRotation(cameraRotY,cameraX);
					look.appendRotation(cameraRotZ,cameraZ);
					cameraRotX=0;cameraRotY=0;cameraRotZ=0;
					break;
					}
					
					//speed
					switch(this.mode){
						case "path":
						var val=s0.LeftStick.y;
						if(val>=0) sA=speedMin+val*(speedMax-speedMin);
						else sA=speedMin+val*speedMin;
						break;
						case "roaming":
						sA=0.5-s0.LeftStick.y*15;
						break;
					}
				}
				break;
				
				case "touch":
					if(dragOn){
						WFRotX.setVal((input.mouse.rX-dragX0)/2);
						WFRotY.setVal((input.mouse.rY-dragY0)/-2);
					}
				if(sA>speedMin) sA=speedMin+(sA-speedMin)*0.98;
				break;
				
				default:
				sA=1;
			}
			if(this.mode=="path"){
				WFRotX.onEF();WFRotY.onEF();
				cameraRotX=WFRotX.val*cameraRotXMax;
				cameraRotY=-WFRotY.val*cameraRotXMax;
			}
			//ns.sys.mstream.logSimple(Math.round(speed*100)/100);
			
			//adjust actual frame timing;
			speed=sA*ff;
			//speed=2*ff;
			//cameraRotZ=0;
			//cameraRotZ
		}
		
		function merge(o0,o1,n){
			o0[n]=o0[n]+o1[n];
			if(o0[n]>1) o0[n]=1;
			if(o0[n]<-1) o0[n]=-1;
			
		}
		function onZoom(e:TransformGestureEvent){
			sA*=e.scaleX;
			if(sA>speedMax) sA=speedMax;
		}
		function onRotate(e:TransformGestureEvent){
			cameraRotZ=(cameraRotZ+e.rotation+360)%360;
		}

		public function dispose(){

			switch(input.def){
				case "mkb":
				break;
				case "touch":
				//input.win.addEventListener(TransformGestureEvent.GESTURE_PAN,onPan,0,0,1);
				input.win.removeEventListener(TransformGestureEvent.GESTURE_ZOOM,onZoom);
				input.win.removeEventListener(TransformGestureEvent.GESTURE_ROTATE,onRotate);
				//input.win.addEventListener(TransformGestureEvent.GESTURE_SWIPE,onSwipe,0,0,1);
				input.stage.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
				input.stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
				
				break;
			}
		}
	}
}