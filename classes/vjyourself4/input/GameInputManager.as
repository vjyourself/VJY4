package vjyourself4.input
{
	import flash.events.EventDispatcher;
	import flash.ui.GameInput;
	import flash.events.GameInputEvent;
	import flash.ui.GameInputDevice;
	import flash.ui.GameInputControl;
	
	public class GameInputManager
	{
		public var events:EventDispatcher= new EventDispatcher();
		public var platform:String=""; //Mac
		public var defGamepadType:String="XBOX";
		var devices:Array;
		var states:Array;
		public var num:int=0;
		
		var gi:GameInput;
		public var log:Function;
		public var singleMerge:Boolean=false;
	
		public function GameInputManager():void
		{
		
		}
		
		public function init(){
			if(log==null) log=logTrace;
			devices=[];
			states=[];
			
			states.push(new GamepadState());
			states[0].events=events;
			states[0].ind=0;
			states.push(new GamepadState());
			states[1].events=events;
			states[1].ind=1;
			
			log(">>> GAME INPUT <<< "+GameInput.numDevices);
			
			for(var i=0;i<GameInput.numDevices;i++) addDevice(GameInput.getDeviceAt(i));
			gi = new GameInput();
			gi.addEventListener(GameInputEvent.DEVICE_ADDED,onAdded,0,0,1);
			gi.addEventListener(GameInputEvent.DEVICE_REMOVED,onRemoved,0,0,1);
			num=devices.length;
		}
		
		function logTrace(txt){

			//trace("GameInput> "+txt);
		}
		function onAdded(e:GameInputEvent){
			log("ADD gamepad");
			addDevice(e.device);
			log("- ind: "+(devices.length-1));
			log("- num: "+devices.length);
			num=devices.length;
		}
		
		function addDevice(d){
			var dd={};
			dd.device=d;
			dd.device.enabled=true;
			dd.handler = new GameDeviceHandler();
			dd.handler.log = log;
			dd.handler.platform=platform;
			dd.handler.defGamepadType=defGamepadType;
			dd.handler.init(dd.device);
			devices.push(dd);
		}

		function onRemoved(e:GameInputEvent){
			log("REMOVED");
			var d=e.device;
			var ind=-1;
			for(var i=0;i<devices.length;i++) if(d==devices[i].device) ind=i;
			log("IND "+ind);
			if(ind>-1){
				devices.splice(ind,1);
			}
			log("dev num:"+devices.length);
			num=devices.length;
		}
			
		
		public function onEF(e=null){
			//log(">>> GAME INPUT <<< "+GameInput.numDevices);
			//calculate devices
			for(var i=0;i<devices.length;i++) devices[i].handler.onEF();
			
			//feed in state OBJ
			if(devices.length==1) states[0].setState(devices[0].handler.state);
			if(devices.length==2){
				if(singleMerge) states[0].setState(GamepadState.merge(devices[0].handler.state,devices[1].handler.state));
				else{
					states[0].setState(devices[0].handler.state);
					states[1].setState(devices[1].handler.state);
				}
			}
		}
		
		public function getState(ind){
			return states[ind].state;
		}

		
	}
	
}