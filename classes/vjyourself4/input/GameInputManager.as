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

		//to keep a device original ind, after previous devices get removed ...
		var deviceInd:Array=[{empty:false,merged:true},{empty:true},{empty:true},{empty:true},{empty:true}];
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
			
			for(var i=0;i<4;i++){
				states.push(new GamepadState());
				states[i].fireGlobal=i==0;
				states[i].events=events;
				states[i].ind=i;
			}	
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
			var ind=-1;
			for(var i=0;i<deviceInd.length;i++) if((ind==-1)&&(deviceInd[i].empty)) ind=i;
			if(ind==-1) {deviceInd.push({empty:true});ind=deviceInd.length-1;}

			var dd={empty:false}
			dd.ind=ind;
			dd.device=d;
			dd.device.enabled=true;
			dd.handler = new GameDeviceHandler();
			dd.handler.log = log;
			dd.handler.platform=platform;
			dd.handler.defGamepadType=defGamepadType;
			dd.handler.init(dd.device);
			devices.push(dd);
			deviceInd[ind]=dd;
		}

		function onRemoved(e:GameInputEvent){
			log("REMOVED");
			var d=e.device;
			var ind=-1;
			for(var i=0;i<devices.length;i++) if(d==devices[i].device) ind=i;
			log("IND "+ind);
			if(ind>-1){
				deviceInd[devices[ind].ind]={empty:true};
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
			
			//merge into 0 ind
			if(devices.length==1) states[0].setState(devices[0].handler.state);
			if(devices.length==2) states[0].setState(GamepadState.merge(devices[0].handler.state,devices[1].handler.state));
			
			//more inds 1-2-3-4
			for(var i=1;i<deviceInd.length;i++)if(!deviceInd[i].empty) states[i].setState(deviceInd[i].handler.state);
			
		}
		
		public function getState(ind){
			return states[ind].state;
		}

		
	}
	
}