package vjyourself4.ctrl{
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import vjyourself4.dson.Eval;
	import vjyourself4.DynamicEvent;
	
	public class GamepadCombo{
		public var _debug:Object;
		public var _meta:Object={name:"Scene"};
		public function setDLevels(l1,l2,l3,l4){dLevels=[l1,l2,l3,l4];}
		var dLevels:Array=[true,true,false,false];
		function log(level,msg){if(dLevels[level-1])_debug.log(this,level,msg);}

		public var ns:Object;
		public var params:Object;
		public var io;
	
		public var commButtons:Object;

		public var maps:Object;
		public var combos:Array;
		public var state:String="";
		public var comboInd:Number;
		public var modeInd:Number=0;
		public var modes:Array;
		
		public function GamepadCombo(){}
		
		public function init(){
			
			//commButtons=params.buttons;
			modes=params.modes;
			setMode(0);
			combos=params.combos;
			comboInd=-1;
			selectMap("std");
			io=ns._sys.io;
			if(io.gamepad.enabled) io.gamepadManager.events.addEventListener("GamepadButton",gamepadButton,0,0,1);
		}
		
		function setMode(i){
			modeInd=i;
			maps=params["maps_"+modes[modeInd]];
			selectMap("std");
		}
		function selectMap(name){
			state=name;
			commButtons=maps[name];
		}
		public function gamepadButton(e:DynamicEvent){
			var butt=e.data.button;
			trace("BUTT> "+butt);
			if(butt=="Start"){
				setMode((modeInd+1)%modes.length);
			}else{
				var comm;
				if(commButtons[butt]!=null) comm=commButtons[butt].command;
				else if(maps["std"][butt]!=null) comm=maps["std"][butt].command;
				if(comm!=null) execComm(comm);
			}
		}
		
		function execComm(comm){
			var tar=Eval.evalString(ns,comm[0]);
			tar[comm[1]].apply(tar,comm[2]);
		}

		public function onEF(e){
			//check combo hold
			if(io.gamepad.enabled){
				var ss=io.gamepad.manager.getState(0);
				if(state=="std") for(var i=0;i<combos.length;i++){if(ss[combos[i].key]){comboInd=i;selectMap(combos[i].map);break;}}
				else if(!ss[combos[comboInd].key]){comboInd=-1;selectMap("std");}
			}
		}

		public function dispose(){
			if(io.gamepad.enabled) io.gamepad.manager.events.removeEventListener("GamepadButton",gamepadButton);
			io=null;
		}
		
	}
}