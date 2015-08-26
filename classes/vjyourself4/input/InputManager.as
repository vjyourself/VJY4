package vjyourself4.input{
	
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	import flash.display.Stage;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	//import vjyourself2.src.GamePads.*;
	import vjyourself4.input.GameInputManager;
	import vjyourself4.sys.MetaStream;
	import vjyourself4.sys.ScreenManager;
	
	
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.events.TransformGestureEvent;
	import flash.events.TouchEvent;

	//import vjyourself2.src.GamepadNorthCode;
	
	public class InputManager{
		public var _debug:Object;
		public var _meta:Object={name:"Input"};
		public var debug4:Boolean=false;
		function log(level,msg){_debug.log(this,level,msg);}

		public var sys:Object;
		public var screen:ScreenManager;
		public var state="run...";
		public var wDimX=960;
		public var wDimY=540;
		public var wLimTop:Number=0;
		public var wLimBottom:Number=0;
		public var wLimLeft:Number=0;
		public var wLimRight:Number=0;
		
		public var active:Boolean = false;
		public var active_timeoutCC=0;
		public var active_timeout=24*15;
		
		public var touch:Boolean=false;
		public var touch_enabled:Boolean=false;
		public var cameraX:Number=0;
		public var cameraY:Number=0;
		var touchON:Boolean=false;
		var touchX0:Number=0;
		var touchY0:Number=0;
		var touchX1:Number=0;
		var touchY1:Number=0;
		var touchDX:Number=0;
		var touchDY:Number=0;
		
		public var mkb:Boolean=false;
		public var mkb_enabled:Boolean=false;
		public var mkb_active:Boolean=false;
		public var keys:Object;
		public var mouse={rX:0,rY:0,rR:0,x:0,y:0,x0:0,y0:0,dX:0,dY:0,butt:0,onstage:false};
		
		public var gamepad:Boolean=false;
		public var gamepad_enabled:Boolean=false;
		public var gamepad_active:Boolean=false;
		public var gamepad_type="" //depricated param
		public var gamepad_conn="XBoxServer";
		public var gamepad_calibration:Object;
		public var gamepad_merge=true;
		public var gamepadManager:Object;
		public var gamepadState:Object;
		
		public var auto:Boolean=false;
		public var auto_enabled:Boolean=true;
		
		public var def:String="auto";
		
		public var stage:Stage;
		public var win:DisplayObject;
		public var events = new EventDispatcher();
		
		function InputManager(){
			keys={Left:false,Right:false,Up:false,Down:false};
			for(var i=65;i<=90;i++) keys[String.fromCharCode(i)]=false;
			}
		
		public function init(p:Object=null){
			sys.screen.events.addEventListener(Event.RESIZE,onResize,0,0,1);
			if(p!=null){
				if(p.def!=null) def=p.def;
				if(p.active_timeout!=null) active_timeout=p.active_timeout;
				if(p.gamepad!=null){
					if(p.gamepad.enabled!=null) gamepad_enabled=Number(p.gamepad.enabled)==1;
					//if(p.gamepad.type!=null) gamepad_type=p.gamepad.type;
					if(p.gamepad.conn!=null) gamepad_conn=p.gamepad.conn;
					if(p.gamepad.calibration!=null){
						gamepad_calibration={};
						if(p.gamepad.calibration.square!=null) gamepad_calibration.square=Number(p.gamepad.calibration.square);
						if(p.gamepad.calibration.threshold!=null) gamepad_calibration.threshold=Number(p.gamepad.calibration.threshold);
					}
				}
				if(p.mkb!=null){
					if(p.mkb.enabled!=null) mkb_enabled=Number(p.mkb.enabled)==1;
				}
				if(p.touch!=null){
					if(p.touch.enabled!=null) touch_enabled=p.touch.enabled;
				}
				/*
				acc1= new Accelerometer();
				acc1.setRequestedUpdateInterval(50);
        		acc1.addEventListener(AccelerometerEvent.UPDATE, updateHandler);
				*/
				if(p.auto!=null){
					if(p.auto.enabled!=null) auto_enabled=Number(p.auto.enabled)==1;
					Multitouch.inputMode=MultitouchInputMode.GESTURE;
				}
			}
			if(debug4) log(4,"gamepad_enabled: "+gamepad_enabled);
			this[def]=true;
			if(gamepad_enabled){

					gamepadManager = new GameInputManager();
					gamepadManager.platform=sys.platform;
					gamepadManager.init();
					gamepadManager.events.addEventListener("CHANGE",gamepadOnChange,0,0,1);
				
				/*
				if(gamepad_conn=="XBoxServer"){
					
					gamepadManager = new XBOX360Manager();
					//gamepadManager.mergePads=gamepad_merge;
					gamepadManager.connect();
					//gamepadManager.events.addEventListener("Gamepad0_RB",screenShot,0,0,1);
					//trace("XXXXXXXXXXXX");
				}*/
				/*
				if(gamepad_conn=="NorthCode"){
					gamepadManager = new GamepadNorthCode();
					if(gamepad_calibration!=null) gamepadManager.calibration=gamepad_calibration;
					gamepadManager.connect();
					gamepadManager.events.addEventListener("CHANGE",gamepadOnChange,0,0,1);
				}*/
			}
			if(stage!=null) setStage(stage);
		}
		
		public function onResize(e){
			wDimX=sys.screen.wDimX;
			wDimY=sys.screen.wDimY;
				
		}
		public function setStage(s,w=null){
			if(w==null) w=s;
			stage=s;
			win=w;
			if((mkb_enabled)||(touch_enabled)){
				stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove,0,0,1);
				stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown,0,0,1);
				stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp,0,0,1);
				stage.addEventListener(Event.MOUSE_LEAVE,onMouseLeave,0,0,1);
				stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown,0,0,1);
				stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp,0,0,1);
			}
			/*
			if(touch_enabled){
					Multitouch.inputMode=MultitouchInputMode.TOUCH_POINT;
					stage.addEventListener(TouchEvent.TOUCH_BEGIN,onTouchBegin,0,0,1);
					stage.addEventListener(TouchEvent.TOUCH_MOVE,onTouchMove,0,0,1);
					stage.addEventListener(TouchEvent.TOUCH_END,onTouchEnd,0,0,1);
			}*/
		}
		/*
		function onTouchBegin(e:TouchEvent){
			if(e.isPrimaryTouchPoint){
				touchX0=e.stageX;
				touchY0=e.stageY;
				touchX1=e.stageX;
				touchY1=e.stageY;
				touchON=true;
			}
		}
		function onTouchMove(e:TouchEvent){
			if(e.isPrimaryTouchPoint){
				touchX1=e.stageX;
				touchY1=e.stageY;
			}
		}
		function onTouchEnd(e:TouchEvent){
			if(e.isPrimaryTouchPoint){
				touchON=false;
			}
		}*/
		public function onEF(e){
			if(state=="run..."){
				
				mkb=mkb_enabled && mkb_active;
				gamepad=gamepad_enabled && gamepad_active;
				//trace("mkb_active:"+mkb_active+" auto:"+auto);
				/*
				if(touch_enabled){
				if(touchON){
					touchDX=touchX1-touchX0;
					touchDY=touchY1-touchY0;
					touchX0=touchX1;touchY0=touchY1;
					cameraX+=touchDX/10;
					cameraY+=touchDY/10;
				}else{
					cameraX*=0.99;
					cameraY*=0.99;
				}
				}*/
			if(gamepad_enabled){
				gamepadManager.onEF();
				/*
				var s=getGamePadState();
				if(s._connected){
					gamepadState=s;
				}*/
			}
			active=mkb_active||gamepad_active;
			if((mkb_active)&&(mkb_enabled)){auto=false;def="mkb";};
			if((gamepad_active)&&(gamepad_enabled)){
				if(def!="gamepad") log(2,">> GAMEPAD <<");
				auto=false;
				def="gamepad";

			};
/*			if((gamepad_enabled)&&(gamepad_connected)){
			}*/
			if((!auto)){
				active_timeoutCC++;
				if(active_timeoutCC>=active_timeout){
					mkb_active=false;
					gamepad_active=false;
					if(auto_enabled){ 
						auto=true;
						def="auto";
						log(2,">> AUTO <<");
					}
				}
			}
			
				//mouse (mkb && touch)
				if((def=="mkb")||(def=="touch")){
					if((win!=null)&&(mouse.onstage)){
						mouse.x=win.mouseX;
						mouse.y=win.mouseY;
				
						mouse.dX=(mouse.x-mouse.x0)/screen.wDimX*2;
						mouse.dY=(mouse.y-mouse.y0)/screen.wDimY*2;
						//trace("mouse d:"+mouse.dX+","+mouse.dY);
						mouse.x0=mouse.x;
						mouse.y0=mouse.y;
				
						updateMouseR();
					}else{
						mouse.x=0;
						mouse.y=0;
						mouse.rX=0;
						mouse.rY=0;
						mouse.rR=0;
						mouse.dX=0;
						mouse.dY=0;
					}
				}
			}
		}
		function updateMouseR(){
			mouse.rX=win.mouseX/screen.wDimX*2-1;
						mouse.rY=win.mouseY/screen.wDimY*2-1;
						mouse.rR=Math.sqrt(mouse.rX*mouse.rX+mouse.rY*mouse.rY)

		}
		function onMouseMove(e){mkb_active=true;active_timeoutCC=0;if(!mouse.onstage){mouse.x0=win.mouseX;mouse.y0=win.mouseY;}mouse.onstage=true;}
		function onMouseLeave(e){active_timeoutCC=active_timeout;mouse.onstage=false;}
		function onMouseDown(e){
			//screen.saveScreenShot();
			if(def=="touch"){mouse.x0=win.mouseX;mouse.y0=win.mouseY;};mkb_active=true;active_timeoutCC=0;mouse.butt=1;events.dispatchEvent(new Event("CLICK"));
			}
		function onMouseUp(e){mkb_active=true;active_timeoutCC=0;mouse.butt=0;}
		function onKeyDown(e:KeyboardEvent){mkb_active=true;active_timeoutCC=0;
			switch(e.keyCode){
				case 37:keys["Left"]=true;break;
				case 38:keys["Up"]=true;break;
				case 39:keys["Right"]=true;break;
				case 40:keys["Down"]=true;break;
				default:
				keys[String.fromCharCode(e.charCode).toLowerCase()]=true;
				//trace(String.fromCharCode(e.charCode).toLowerCase()+" : true");
				break;
			}
		};
		function onKeyUp(e:KeyboardEvent){mkb_active=true;active_timeoutCC=0
			switch(e.keyCode){
				case 37:keys["Left"]=false;break;
				case 38:keys["Up"]=false;break;
				case 39:keys["Right"]=false;break;
				case 40:keys["Down"]=false;break;
				default:
				keys[String.fromCharCode(e.charCode).toLowerCase()]=false;
				break;
			}
		
		};
		
		function gamepadOnChange(e){
			//trace("GAMEPAD CHANGE");
			gamepad_active=true;active_timeoutCC=0;
		}
		
		/*
		public function getGamepadState(p=null):Object{
			return getGamePadState();
		}
		public function getGamePadState(p=null):Object{
			var s:Object;
			if((gamepad_enabled)){
				s=gamepadManager.getState(1);
				//s.connected=true;
			}else{
				s={};
				s._connected=false;
			}
			return s;
			};
		*/
	}
}
