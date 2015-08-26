package vjyourself4.ctrl{
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import vjyourself4.dson.Eval;
	import vjyourself4.DynamicEvent;
	
	public class Gamepad{
		public var _debug:Object;
		public var _meta:Object={name:"CtrlGamepad"};
		public function setDLevels(l1,l2,l3,l4){dLevels=[l1,l2,l3,l4];}
		var dLevels:Array=[true,true,false,false];
		function log(level,msg){if(dLevels[level-1])_debug.log(this,level,msg);}
		
		public var ns:Object;
		public var params:Object;
		public var input;
	
		public var commButtons:Object;

		public var map:Object;
		public var state:String="";
		
		public function Gamepad(){}
		
		public function init(){
			map=params.map;
			input=ns._glob.input;
			if(input.gamepad_enabled) input.gamepadManager.events.addEventListener("GamepadButton",gamepadButton,0,0,1);
		}
		
		
		public function gamepadButton(e:DynamicEvent){
			var butt=e.data.button;
			trace(butt);
			trace(map[butt]);
			if(map[butt]!=null) execComm(map[butt].command);
		}
		
		function execComm(comm){
			trace(comm[0],comm[1]);
			var tar=Eval.evalString(ns,comm[0]);
			trace(tar);
			tar[comm[1]].apply(tar,comm[2]);
		}

		//public function onEF(e){}

		public function dispose(){
			if(input.gamepad_enabled) input.gamepadManager.events.removeEventListener("GamepadButton",gamepadButton);
			input=null;
		}
		
	}
}