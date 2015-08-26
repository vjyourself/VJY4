package vjyourself4.ctrl{
	import flash.events.Event;
	import flash.display.Sprite;
	import away3d.filters.*;
	import vjyourself4.dson.Eval;
	import vjyourself4.dson.TransJson;
	public class BindRouter{
			public var _debug:Object;
		public var _meta:Object={name:"CtrlGamepad"};
		public function setDLevels(l1,l2,l3,l4){dLevels=[l1,l2,l3,l4];}
		var dLevels:Array=[true,true,false,false];
		function log(level,msg){if(dLevels[level-1])_debug.log(this,level,msg);}
		
		
		public var ns:Object;
		public var params:Object;
		public var input;
	
		
		public var meta:Object={};
		public var list:Array;
		
		
		var channels:Object;
		

		public function BindRouter(){}
		public function init(){
			channels=TransJson.clone(params.channels);
		}
		public function next(chN:String){
			var ch=channels[chN];
			ch.ind=(ch.ind+1)%ch.states.length;
			var ss=ch.states[ch.ind];
			for(var i=0;i<ss.length;i++){
				var o=Eval.evalPath2(ns,ss[i][0]);
				o.obj.setBind(o.prop,ss[i][1]);
			}
		}
	
		
	}
}