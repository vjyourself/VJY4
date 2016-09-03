package vjyourself4.ctrl{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import vjyourself4.dson.Eval;
	import vjyourself4.DynamicEvent;
	
	public class CtrlKey{
		public var _debug:Object;
		public var _meta:Object={name:"Scene"};
		public function setDLevels(l1,l2,l3,l4){dLevels=[l1,l2,l3,l4];}
		var dLevels:Array=[true,true,false,false];
		function log(level,msg){if(dLevels[level-1])_debug.log(this,level,msg);}

		public var ns:Object;
		public var params:Object;
		public var input;


		public var map:Object;
	
		
		public function CtrlKey(){}
		
		public function init(){
			map=params.map;
			ns.sys.io.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKey,0,0,1);
		}
		
		
		public function onKey(e:KeyboardEvent){
			var ch=String.fromCharCode(e.charCode);
			for(var i in map) if(i==ch) execComm(map[i].command);
			/*
			var butt=e.data.button;
			trace("BUTT> "+butt);
			if(butt=="Start"){
				setMode((modeInd+1)%modes.length);
			}else{
				var comm;
				if(commButtons[butt]!=null) comm=commButtons[butt].command;
				else if(maps["std"][butt]!=null) comm=maps["std"][butt].command;
				if(comm!=null) execComm(comm);
			}*/

		}
		
		function execComm(comm){
			var tar=Eval.evalString(ns,comm[0]);
			tar[comm[1]].apply(tar,comm[2]);
			ns.scene.paramsChanged();
		}

		public function onEF(e){
			
		}

		public function dispose(){
			input=null;
		}
		
	}
}