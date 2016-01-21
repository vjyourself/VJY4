package vjyourself4.ctrl{
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import vjyourself4.dson.Eval;
	import vjyourself4.DynamicEvent;
	import vjyourself4.io.gamepad.GamepadState;
	
	public class GamepadMapper{
		public var _debug:Object;
		public var _meta:Object={name:"GamepadMapper"};
		public function setDLevels(l1,l2,l3,l4){dLevels=[l1,l2,l3,l4];}
		var dLevels:Array=[true,true,false,false];
		function log(level,msg){if(dLevels[level-1])_debug.log(this,level,msg);}

		public var ns:Object;
		public var params:Object;

		public var map:Object;
		
		public var state:Object={};
		public var stateNew:Object={};
		var statePerFrame:int=0;

		var analMap:Array;
		var trigMap:Array;

		public function GamepadMappper(){}
		
		public function init(){
			map=params.map;
			analMap=[];
			trigMap=[];
			for(var i=0;i<map.length;i++){
				switch(map[i].t){
					case "anal":
						analMap.push(map[i]);
						map[i].tar_ref=Eval.evalPath(ns,map[i].tar.obj);
					break;
					case "trigOn":
						trigMap.push(map[i]);
						map[i].val=true;
						map[i].command[0]=Eval.evalPath(ns,map[i].command[0]);
					break;
					case "trigOff":
						trigMap.push(map[i]);
						map[i].val=false;
						map[i].command[0]=Eval.evalPath(ns,map[i].command[0]);
					break;
				}
				map[i].isBool=GamepadState.isBool[map[i].n];
				
			}

			GamepadState.toDefault(state);
			GamepadState.toDefault(stateNew);
			statePerFrame=0;
			
		}
		
		
		public function setState(s:Object){
			GamepadState.mergeInto(stateNew,s);
			statePerFrame++;
		}

		function execComm(comm){
			var tar=comm[0];
			tar[comm[1]].apply(tar,comm[2]);
		}

		public function onEF(e){
			if(statePerFrame>0){
				trace(state["X"]+" -> "+stateNew["X"]);
				// Process Map
				//Anal
				var m:Object;
				for(var i=0;i<analMap.length;i++){
					m=analMap[i];
					m.tar_ref.setInput(m.tar.ch,m.isBool?(stateNew[m.n]?1:0):stateNew[m.n]);
				}
				//Trig
				for(var i=0;i<trigMap.length;i++){
					m=trigMap[i];
					if((state[m.n]!=stateNew[m.n])&&(stateNew[m.n]==m.val)) execComm(m.command);
				}

				//Move stateNew -> state & set stateNew to Default
				var tmp=state;
				state=stateNew;
				stateNew=tmp;
				GamepadState.toDefault(stateNew);
				statePerFrame=0;
			}
			
		}

		public function dispose(){
			
		}

	
	}
}