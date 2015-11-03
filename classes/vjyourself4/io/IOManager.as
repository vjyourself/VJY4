package vjyourself4.io{
	
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	import flash.display.Stage;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	import vjyourself4.sys.MetaStream;
	import vjyourself4.sys.ScreenManager;
	
	
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.events.TransformGestureEvent;
	import flash.events.TouchEvent;
	import vjyourself4.VJYBase;
	import vjyourself4.io.gamepad.GamepadManager;
	
	public class IOManager extends VJYBase{
		
		public var sys:Object;
		public var params:Object;
		

		//Interfaces
		public var auto:Object={enabled:false};
		public var mkb:Object={enabled:false};
		public var touch:Object={enabled:false};
		public var gamepad:Object={enabled:false};
		public var midi:Object={enabled:false};
		public var arduino:Object={enabled:false};

		//screen for mouse / touch
		public var stage:Stage;
		public var win:DisplayObject;
		public var wDimX:Number=960;
		public var wDimY:Number=540;
		public var wLimTop:Number=0;
		public var wLimBottom:Number=0;
		public var wLimLeft:Number=0;
		public var wLimRight:Number=0;


		//last used base input: gamepad / mkb / touch ONLY (midi & arduino not affecting this)
		public var lastActiveBase:String="";

		public var events = new EventDispatcher();
		
		function IOManager(){
		}
		
		public function init(){
			log(1,"Init IO Managers");
			for(var i in params) this[i]=params[i];
			stage=sys.screen.stage;
			win=stage;
			sys.screen.events.addEventListener(Event.RESIZE,onResize,0,0,1);

			//auto
			if(auto.enabled){
				log(1,"Auto Enabled");
			}
			//mkb
			if(mkb.enabled){
				mkb.manager = new MkbManager();
				mkb.manager.io=this;
				mkb.manager._debug=_debug;
				mkb.manager.init();
				log(1,"Mkb Enabled");
			}
			//touch
			if(touch.enabled){
				touch.manager = new TouchManager();
				touch.manager.io=this;
				touch.manager._debug=_debug;
				touch.manager.init();
				log(1,"Touch Enabled");
			}
			//gamepad
			if(gamepad.enabled){
				gamepad.manager = new GamepadManager();
				gamepad.manager.io=this;
				gamepad.manager._debug=_debug;
				gamepad.manager.init();
				log(1,"Gamepad Enabled");
			}/*
			//midi
			if(midi.enabled){
				midi.manager = new MIDIManager();
				log(1,"MIDI Enabled");
			}
			//arduino
			if(arduino.enabled){
				arduino.manager = new ArduinoManager();
				log(1,"Arduino Enabled");
			}*/
			
		}
		
		public function onResize(e){
			wDimX=sys.screen.wDimX;
			wDimY=sys.screen.wDimY;
			//if(mkb.enabled) mkb.manager.onResize(e);
			//if(touch.enabled) touch.manager.onResize(e);
		}
		
		public function onEF(e){
			if(mkb.enabled){
				mkb.manager.onEF(e);
			}
			if(touch.enabled) touch.manager.onEF(e);
			/*
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
				}*/
			}
		
	}
}
