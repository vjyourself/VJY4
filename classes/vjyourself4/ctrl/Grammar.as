﻿package vjyourself4.ctrl{
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
		
		// GLOBALS
		public var ns:Object;
		public var params:Object;
		public var input;
	
		// COMP type
		var anal_path:String="scene.anal";
		var anal_obj:Object;
		var trig_path:String="sceneVary";
		var trig_obj:Object;

		public var commButtons:Object;
		var active:Object={anal:true,trig:true};

		public var map:Object;
		public var state:String="";

		var gamepad;
		public var mode:String="GamepadMulti";

		public function Grammar(){}
		
		public function init(){
			if(params.mode!=null) mode=params.mode;
			if(params.active!=null) active=params.active;
			if(params.bind!=null){
				if(params.bind.trig!=null) trig_path=params.bind.trig; 
				if(params.bind.anal!=null) anal_path=params.bind.anal;	
			}
			setBind("trig",trig_path);
			setBind("anal",anal_path);
			if(ns.sys.io.gamepad.enabled){
			switch(mode){
				case "SinglePlayer":
				gamepad = new GamepadSingle();
				gamepad.ns=ns;
				gamepad.events.addEventListener("Trig",onTrig);
				gamepad.params=params.gamepadSingle;
				gamepad.init();
				break;
				case "MultiPlayer":
				gamepad = new GamepadMulti();
				gamepad.ns=ns;
				gamepad.params=params.gamepadMulti;
				gamepad.events.addEventListener("Trig",onTrig);
				gamepad.init();
				break;
			}
			}else{
				mode="";
			}
		}
		public function setBind(prop,val){
			this[prop+"_path"]=val;
			this[prop+"_obj"]=Eval.evalPath(ns,val);
		}
		public function onTrig(e:DynamicEvent){
			if(active.trig) trig_obj.trig(e.data.ind);
			
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
			//trace("SDFSFSDFSDFSDF");
			//trace(mode);
			
			if(active.anal){
			switch(mode){
				case "SinglePlayer":
				gamepad.onEF(e);
				for(var i=0;i<gamepad.anal.length;i++) if(gamepad.anal[i]!=0) anal_obj.setInput(i,gamepad.anal[i]);
				break;

				case "MultiPlayer":
				gamepad.onEF(e);
				for(var i=0;i<gamepad.anal.length;i++) if(gamepad.anal[i]!=0) anal_obj.setInput(i,gamepad.anal[i]);
			
				break;
			}
		}
		}

		public function dispose(){
			//if(input.gamepad_enabled) input.gamepadManager.events.removeEventListener("GamepadButton",gamepadButton);
			//input=null;
		}
		
	}
}

/*
//gamepad 0
				ns.mid.cs.GP.synthPath.type.setInput(0,gamepad.anal[0][0]);
				ns.mid.cs.GP.synthPath.type.setInput(1,gamepad.anal[0][1]);
				ns.fore.cs.overlay.setInput(1,gamepad.anal[0][2]);
				//ns.fore.cs.overlay.setInput(3,gamepad.anal[0][3]);

				ns.back.cs.ctrlSky.setInput(0,gamepad.anal[0][4]);
				ns.mid.cs.GP.synthPath.type.setInput(5,gamepad.anal[0][5]);
				ns.mid.cs.GP.synthPath.type.setInput(7,gamepad.anal[0][6]);

				//gamepad 1				
				ns.mid.cs.GP.synthPath.type.setInput(2,gamepad.anal[1][0]);
				ns.fore.cs.overlay.setInput(0,gamepad.anal[1][1]);
				ns.fore.cs.overlay.setInput(2,gamepad.anal[1][2]);
				//ns.mid.cs.GP.synthPath.type.setInput(3,gamepad.anal[1][3]);

				//ns.back.cs.gridBox.setInput(0,gamepad.anal[1][4]);
				ns.mid.cs.GP.synthPath.type.setInput(4,gamepad.anal[1][5]);
				ns.mid.cs.GP.synthPath.type.setInput(6,gamepad.anal[1][6]);*/