package vjyourself4.games{
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import vjyourself4.dson.Eval;
	import vjyourself4.DynamicEvent;
	import vjyourself4.patt.WaveFollow;
	
	public class CtrlRhythm{
		public var ns:Object;
		public var params:Object;
		public var input;
		var synthPath;
		public var ctrlsA:Array;
		var WFA0:WaveFollow= new WaveFollow({div:3,treshold:0.001});
		var WFA1:WaveFollow= new WaveFollow({div:3,treshold:0.001});
		var WFA2:WaveFollow= new WaveFollow({div:3,treshold:0.001});
		var WFA3:WaveFollow= new WaveFollow({div:3,treshold:0.001});
		
		public function CtrlRhythm(){}
		
		public function init(){
			ctrlsA=ns.inputVJY.ctrlsA;
			input=ns.input;
			synthPath=ns.GP.synthPath;
			//if(input.gamepad_enabled) input.gamepadManager.events.addEventListener("GamepadButton",gamepadButton,0,0,1);
		}
		
		
		public function gamepadButton(e:DynamicEvent){
			var butt=e.data.button;
				}
		public function hit(ind){
			//trace("********************");
			//trace(ind);
			//trace("*********************");
			if(synthPath.streams.list.length>ind)synthPath.streams.list[ind].cont.visible=!synthPath.streams.list[ind].cont.visible;
	
		}
		function execComm(comm){var tar=Eval.evalString(ns,comm[0]);tar[comm[1]].apply(tar,comm[2]);}

		public function onEF(e){
			//check combo hold
			if(input.gamepad_enabled){
				var s0=input.gamepadManager.getState(0);
				WFA0.setVal(s0.LeftTrigger);WFA0.onEF();
				WFA1.setVal(s0.RightTrigger);WFA1.onEF();
				WFA2.setVal(s0.LeftStick.x);WFA2.onEF();
				WFA3.setVal(s0.LeftStick.y);WFA3.onEF();
				ctrlsA[0]=WFA0.val;
				ctrlsA[1]=WFA1.val;
				ctrlsA[2]=WFA2.val;
				ctrlsA[3]=WFA3.val;
			}
		}
		
	}
}