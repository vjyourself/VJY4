package vjyourself4.ctrl{
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import vjyourself4.dson.Eval;
	import vjyourself4.DynamicEvent;
	
	public class Grammar{
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

		var gamepad;
		public var inputMode:String="GamepadMulti";
		public function Grammar(){}
		
		public function init(){
			switch(inputMode){
				case "GamepadSingle":
				gamepad = new GamepadSingle();
				gamepad.ns=ns;
				gamepad.init();
				gamepad.events.addEventListener("Trig",onTrig);
				break;
				case "GamepadMulti":
				gamepad = new GamepadMulti();
				gamepad.ns=ns;
				gamepad.init();
				gamepad.events.addEventListener("Trig",onTrig);
				break;
			}
		}
		public function onTrig(e:DynamicEvent){
			ns.sceneVary.next(e.data.ind);
			//switch(e.data.ind){
		//		case 0:
	//		}
		}
		/*
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
		*/
		public function onEF(e){
			switch(inputMode){
				case "GamepadSingle":
				gamepad.onEF(e);
			
				ns.mid.cs.GP.synthPath.bind.setInput(0,gamepad.anal[0][0]);
				ns.mid.cs.GP.synthPath.bind.setInput(1,gamepad.anal[0][1]);
				ns.mid.cs.GP.synthPath.bind.setInput(4,gamepad.anal[0][2]);
				ns.mid.cs.GP.synthPath.bind.setInput(5,gamepad.anal[0][3]);

				ns.mid.cs.GP.synthPath.bind.setInput(2,gamepad.anal[1][0]);
				ns.mid.cs.GP.synthPath.bind.setInput(3,gamepad.anal[1][1]);
				ns.mid.cs.GP.synthPath.bind.setInput(6,gamepad.anal[1][2]);
				ns.mid.cs.GP.synthPath.bind.setInput(7,gamepad.anal[1][3]);
		
				ns.fore.cs.overlay.setInput(0,gamepad.anal[2][0]);
				ns.fore.cs.overlay.setInput(1,gamepad.anal[2][1]);
				ns.fore.cs.overlay.setInput(2,gamepad.anal[2][2]);
				ns.fore.cs.overlay.setInput(3,gamepad.anal[2][3]);

				ns.back.cs.ctrlSky.setInput(0,gamepad.anal[3][0]);
				ns.back.cs.gridBox.setInput(0,gamepad.anal[3][1]);
				break;

				case "GamepadMulti":
				gamepad.onEF(e);
				
				//gamepad 0
				ns.mid.cs.GP.synthPath.bind.setInput(0,gamepad.anal[0][0]);
				ns.mid.cs.GP.synthPath.bind.setInput(1,gamepad.anal[0][1]);
				ns.fore.cs.overlay.setInput(1,gamepad.anal[0][2]);
				//ns.fore.cs.overlay.setInput(3,gamepad.anal[0][3]);

				ns.back.cs.ctrlSky.setInput(0,gamepad.anal[0][4]);
				ns.mid.cs.GP.synthPath.bind.setInput(5,gamepad.anal[0][5]);
				ns.mid.cs.GP.synthPath.bind.setInput(7,gamepad.anal[0][6]);

				//gamepad 1				
				ns.mid.cs.GP.synthPath.bind.setInput(2,gamepad.anal[1][0]);
				ns.fore.cs.overlay.setInput(0,gamepad.anal[1][1]);
				ns.fore.cs.overlay.setInput(2,gamepad.anal[1][2]);
				//ns.mid.cs.GP.synthPath.bind.setInput(3,gamepad.anal[1][3]);

				//ns.back.cs.gridBox.setInput(0,gamepad.anal[1][4]);
				ns.mid.cs.GP.synthPath.bind.setInput(4,gamepad.anal[1][5]);
				ns.mid.cs.GP.synthPath.bind.setInput(6,gamepad.anal[1][6]);

				break;
			}

		}

		public function dispose(){
			//if(input.gamepad_enabled) input.gamepadManager.events.removeEventListener("GamepadButton",gamepadButton);
			//input=null;
		}
		
	}
}