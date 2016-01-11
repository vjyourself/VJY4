package vjyourself4.ctrl{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import vjyourself4.dson.Eval;
	import vjyourself4.DynamicEvent;
	
	public class AnyRouter{
		public var _debug:Object;
		public var _meta:Object={name:"Scene"};
		public function setDLevels(l1,l2,l3,l4){dLevels=[l1,l2,l3,l4];}
		var dLevels:Array=[true,true,false,false];
		function log(level,msg){if(dLevels[level-1])_debug.log(this,level,msg);}

		public var ns:Object;
		public var params:Object;
		public var input;


		public var mapTrig:Array;
		public var mapAnal:Array;
	
		
		public function AnyRouter(){}
		
		public function init(){
			mapTrig=params.mapTrig;
			mapAnal=params.mapAnal;
			
		}
		
		
		
		public function trig(ind:Number){
			if(ind<mapTrig.length){
				var m=mapTrig[ind];
				switch (m.t){
					case "command": execComm(m.command);break;
					case "anal": break;
					case "trig": break;
				}
			}
		}
		
		public function setInput(ch,val){
			if(ch<mapAnal.length){
				var m=mapAnal[ch];
				switch (m.t){
					case "command": break;
					case "anal": 
						var tar=Eval.evalString(ns,m.tar.obj);
						tar.setInput(m.tar.ch,val);
						break;
					case "trig": break;
				}
			}
		}

		function execComm(comm){
			var tar=Eval.evalString(ns,comm[0]);
			tar[comm[1]].apply(tar,comm[2]);
		}

		public function onEF(e){
			
		}

		public function dispose(){
			input=null;
		}
		
	}
}