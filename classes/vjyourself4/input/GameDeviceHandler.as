package vjyourself4.input
{
	import flash.events.EventDispatcher;
	import flash.ui.GameInputDevice;
	
	public class GameDeviceHandler
	{
		public var platform:String="Mac";
		public var defGamepadType={
			Win:"XBOX",
			Mac:"XBOX",
			Linux:"NVIDIA"
		}
		public var type:String="";
	
		public var state:Object={};
		public var device:GameInputDevice;
		public var cs:Object={};
		public var map:Object;
		public var calibr:Object;
		public var active:Boolean=false;
		public var log:Function;

		public function GameDeviceHandler():void
		{
		
		}
		
		public function init(d:GameInputDevice){
			if(log==null) log=logTrace;
			device=d;
			log("-name: "+device.name);
			log("-id: "+device.id+" numCtrl: "+device.numControls);
			log("-platform: "+platform);
			var name=device.name.toLowerCase();
			//type=defGamepadType[platform];
			type="XBOX";
			if(name.indexOf("ouya")>=0) type="OUYA";
			if(name.indexOf("nvidia")>=0) type="NVIDIA";
			log("-type: "+type);
			//collect controllers
			map = GameDeviceHandler["map_"+platform+"_"+type];
			calibr = GameDeviceHandler["calibr_"+platform+"_"+type];
			for(var i=0;i<device.numControls;i++){
				var c=device.getControlAt(i);
				//log("C> "+c.id);
				for(var ii in map){
					//log(" ? "+map[ii]);
					if(c.id==map[ii]){
						cs[ii]=c;
						//log("Found "+ii+" : "+c);
					}
				}
				
			}
			//add zero value for unmapped
			for(var ii in map){
				if(cs[ii]==null) cs[ii]={value:0};
			}
			active=true;
		}
		function logTrace(txt){log("GameInputManager> "+txt);}
		public function onEF(e=null){
			if(active){

				state.LeftStick={x:noiseFilter(cs.LeftStick_X.value*calibr.LeftStick_X),y:noiseFilter(cs.LeftStick_Y.value*calibr.LeftStick_Y)};
				state.LeftTrigger=calibr.LeftTrigger.fullRange?cs.LeftTrigger.value/2+0.5:cs.LeftTrigger.value;
				state.RightStick={x:noiseFilter(cs.RightStick_X.value*calibr.RightStick_X),y:noiseFilter(cs.RightStick_Y.value*calibr.RightStick_Y)};
				state.RightTrigger=calibr.RightTrigger.fullRange?cs.RightTrigger.value/2+0.5:cs.RightTrigger.value;
				
				state.A=cs.A.value == 1;
				state.B=cs.B.value == 1;
				state.X=cs.X.value == 1;
				state.Y=cs.Y.value == 1;
				state.LB=cs.LB.value == 1;
				state.RB=cs.RB.value == 1;
				state.Start=cs.Start.value == 1;
				state.Back=cs.Back.value == 1;
				switch(calibr.DPad){
					case "BUTTON":
					state.Left=cs.Left.value == 1;
					state.Right=cs.Right.value == 1;
					state.Up=cs.Up.value == 1;
					state.Down=cs.Down.value == 1;
					break;
					case "AXIS":
					state.Left=cs.Left.value == -1;
					state.Right=cs.Right.value == 1;
					state.Up=cs.Up.value == 1;
					state.Down=cs.Down.value == -1;
					break;
				}
				
			}
		}
		function noiseFilter(v:Number):Number{
			var ret:Number=0;
			if(v>0.2) ret=(v-0.2)/0.8;
			if(v<-0.2) ret=(v+0.2)/0.8;
			
			return ret;
		}
		// **** Linux (Android) - NVIDIA ****************************************************************
		public static var map_Linux_NVIDIA = {
			LeftStick_X:"AXIS_0",
			LeftStick_Y:"AXIS_1",
			RightStick_X:"AXIS_11",
			RightStick_Y:"AXIS_14",
			LeftTrigger:"AXIS_17",
			RightTrigger:"AXIS_18",
			
			A:"BUTTON_96",
			B:"BUTTON_97",
			X:"BUTTON_99",
			Y:"BUTTON_100",
			LB:"BUTTON_102",
			RB:"BUTTON_103",
			//LS:"BUTTON_106",
			//RS:"BUTTON_107",
			Start:"",
			Back:"",
			/*
			Up:"BUTTON_19",
			Down:"BUTTON_20",
			Left:"BUTTON_21",
			Right:"BUTTON_22"
			*/
			Up:"AXIS_16",
			Down:"AXIS_16",
			Left:"AXIS_15",
			Right:"AXIS_15"
			
		}
		public static var calibr_Linux_NVIDIA ={
			LeftStick_X:1,
			LeftStick_Y:-1,
			RightStick_X:1,
			RightStick_Y:-1,
	
			LeftTrigger:{fullRange:false,a:true},
			RightTrigger:{fullRange:false,a:true},
			DPad:"AXIS"
			
		}
		// **** Linux (Android) - OUYA ****************************************************************
		public static var map_Linux_OUYA = {
			LeftStick_X:"AXIS_0",
			LeftStick_Y:"AXIS_1",
			RightStick_X:"AXIS_11",
			RightStick_Y:"AXIS_14",
			LeftTrigger:"AXIS_17",
			RightTrigger:"AXIS_18",
			
			A:"BUTTON_96",
			B:"BUTTON_97",
			X:"BUTTON_99",
			Y:"BUTTON_100",
			LB:"BUTTON_102",
			RB:"BUTTON_103",
			//LS:"BUTTON_106",
			//RS:"BUTTON_107",
			Start:"",
			Back:"",
			Up:"BUTTON_19",
			Down:"BUTTON_20",
			Left:"BUTTON_21",
			Right:"BUTTON_22"
		}
		
		public static var calibr_Linux_OUYA ={
			LeftStick_X:1,
			LeftStick_Y:1,
			RightStick_X:1,
			RightStick_Y:1,
	
			LeftTrigger:{fullRange:false,a:true},
			RightTrigger:{fullRange:false,a:true},
			DPad:"BUTTON"
			
		}
		// **** MAC - XBOX ****************************************************************
		public static var map_Mac_XBOX = {
			LeftStick_X:"AXIS_0",
			LeftStick_Y:"AXIS_1",
			RightStick_X:"AXIS_3",
			RightStick_Y:"AXIS_4",
			LeftTrigger:"AXIS_2",
			RightTrigger:"AXIS_5",
			
			A:"BUTTON_17",
			B:"BUTTON_18",
			X:"BUTTON_19",
			Y:"BUTTON_20",
			LB:"BUTTON_14",
			RB:"BUTTON_15",
			Start:"BUTTON_10",
			Back:"BUTTON_11",
			Up:"BUTTON_6",
			Down:"BUTTON_7",
			Left:"BUTTON_8",
			Right:"BUTTON_9"
		}
		
		public static var calibr_Mac_XBOX ={
			LeftStick_X:1,
			LeftStick_Y:-1,
			RightStick_X:1,
			RightStick_Y:-1,
	
			LeftTrigger:{fullRange:true,a:true},
			RightTrigger:{fullRange:true,a:true},
			DPad:"BUTTON"
			
		}
		
		// **** WIN - XBOX ****************************************************************
		public static var map_Win_XBOX = {
			LeftStick_X:"AXIS_0",
			LeftStick_Y:"AXIS_1",
			RightStick_X:"AXIS_2",
			RightStick_Y:"AXIS_3",			
			LeftTrigger:"BUTTON_10",
			RightTrigger:"BUTTON_11",

			A:"BUTTON_4",
			B:"BUTTON_5",
			X:"BUTTON_6",
			Y:"BUTTON_7",
			LB:"BUTTON_8",
			RB:"BUTTON_9",
			Start:"BUTTON_13",
			Back:"BUTTON_12",
			Up:"BUTTON_16",
			Down:"BUTTON_17",
			Left:"BUTTON_18",
			Right:"BUTTON_19"
		}
		
		public static var calibr_Win_XBOX ={
			//multiply axes (for inversion)
			LeftStick_X:1,
			LeftStick_Y:1,
			RightStick_X:1,
			RightStick_Y:1,
	
			//fullrange -1 - 1 ; normal 0 -1 --- a:analouge
			LeftTrigger:{fullRange:false,a:true},
			RightTrigger:{fullRange:false,a:true},
			DPad:"BUTTON"
			
		}
		
		
	}
	
}