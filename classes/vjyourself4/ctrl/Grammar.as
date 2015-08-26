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
		
		// GLOBALS
		public var ns:Object;
		public var params:Object;
		public var input;
	
		// COMP type
		var anal_path:String="scene.anal";
		var anal_obj:Object;
		var vary_path:String="sceneVary";
		var vary_obj:Object;

		public var commButtons:Object;

		public var map:Object;
		public var state:String="";

		var gamepad;
		public var mode:String="GamepadMulti";
		public var type:String="Live";
		public function Grammar(){}
		
		public function init(){
			if(params.mode!=null) mode=params.mode;
			if(params.type!=null) type=params.type;
			if(params.bind!=null){
				if(params.bind.vary!=null) vary_path=params.bind.vary; 
				if(params.bind.anal!=null) anal_path=params.bind.anal;	
			}
			setBind("vary",vary_path);
			setBind("anal",anal_path);
			if(ns.sys.input.gamepad_enabled){
			switch(mode){
				case "GamepadSingle":
				gamepad = new GamepadSingle();
				gamepad.ns=ns;
				gamepad.events.addEventListener("Trig",onTrig);
				switch(type){
					
					case "Discovery":
					//DEF
					gamepad.analNum=6;
					gamepad.analPage_num=3;
					gamepad.analPage_mode="step";
					gamepad.analPage_butt="LB";
					
					gamepad.trigNum=8;
					gamepad.trigPage_num=1;
					gamepad.trigPage_mode="combo";
					gamepad.trigPage_butt="LB";
					gamepad.trigButtons=["Up","Right","Down","Left","X","Y","A","B"];
					if(params.gamepadParams!=null) for(var i in params.gamepadParams) gamepad[i]=params.gamepadParams[i];
					break;
				}
				gamepad.init();
				break;
				case "GamepadMulti":
				gamepad = new GamepadMulti();
				gamepad.ns=ns;
				gamepad.init();
				gamepad.events.addEventListener("Trig",onTrig);
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
			vary_obj.next(e.data.ind);
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
			switch(mode){
				case "GamepadSingle":
				gamepad.onEF(e);
				for(var i=0;i<gamepad.anal.length;i++) if(gamepad.anal[i]!=0) ns.scene.anal.setInput(i,gamepad.anal[i]);
			/*
				ns.mid.cs.GP.synthPath.type.setInput(0,gamepad.anal[0][0]);
				ns.mid.cs.GP.synthPath.type.setInput(1,gamepad.anal[0][1]);
				ns.mid.cs.GP.synthPath.type.setInput(4,gamepad.anal[0][2]);
				ns.mid.cs.GP.synthPath.type.setInput(5,gamepad.anal[0][3]);

				ns.mid.cs.GP.synthPath.type.setInput(2,gamepad.anal[1][0]);
				ns.mid.cs.GP.synthPath.type.setInput(3,gamepad.anal[1][1]);
				ns.mid.cs.GP.synthPath.type.setInput(6,gamepad.anal[1][2]);
				ns.mid.cs.GP.synthPath.type.setInput(7,gamepad.anal[1][3]);
		
				ns.fore.cs.overlay.setInput(0,gamepad.anal[2][0]);
				ns.fore.cs.overlay.setInput(1,gamepad.anal[2][1]);
				ns.fore.cs.overlay.setInput(2,gamepad.anal[2][2]);
				ns.fore.cs.overlay.setInput(3,gamepad.anal[2][3]);

				ns.back.cs.ctrlSky.setInput(0,gamepad.anal[3][0]);
				ns.back.cs.gridBox.setInput(0,gamepad.anal[3][1]);
			*/
				break;

				case "GamepadMulti":
				gamepad.onEF(e);
				
				if(gamepad.anal[0][0]!=0) ns.scene.anal.setInput(0,gamepad.anal[0][0]);
				if(gamepad.anal[0][1]!=0) ns.scene.anal.setInput(1,gamepad.anal[0][1]);
				if(gamepad.anal[1][0]!=0) ns.scene.anal.setInput(2,gamepad.anal[1][0]);
				if(gamepad.anal[1][1]!=0) ns.scene.anal.setInput(3,gamepad.anal[1][1]);

				ns.scene.anal.setInput(4,gamepad.anal[0][2]);
				ns.scene.anal.setInput(5,gamepad.anal[0][3]);
				ns.scene.anal.setInput(6,gamepad.anal[1][2]);
				ns.scene.anal.setInput(7,gamepad.anal[1][3]);

				
				break;
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