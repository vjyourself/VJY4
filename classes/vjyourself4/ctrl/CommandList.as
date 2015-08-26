package vjyourself4.ctrl{
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import vjyourself4.dson.Eval;
	import vjyourself4.DynamicEvent;
	
	public class CommandList{
		public var _debug:Object;
		public var _meta:Object={name:"Scene"};
		public function setDLevels(l1,l2,l3,l4){dLevels=[l1,l2,l3,l4];}
		var dLevels:Array=[true,false,false,false];
		function log(level,msg){if(dLevels[level-1])_debug.log(this,level,msg);}

		public var ns:Object;
		public var params:Object;
		
		public var elems:Array;
		
		public function CommandList(){}
		
		public function init(){
			elems=params.elems;
		}
		
		public function trig(){
			for(var i=0;i<elems.length;i++) execComm(elems[i].command);
		}
		function execComm(comm){
			var tar=Eval.evalString(ns,comm[0]);
			tar[comm[1]].apply(tar,comm[2]);
		}

		//public function onEF(e){}

		public function dispose(){
			//input=null;
		}
		
	}
}