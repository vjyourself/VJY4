package vjyourself4.ctrl{
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import vjyourself4.dson.Eval;
	import vjyourself4.DynamicEvent;
	
	public class CtrlMIDI{
		public var _debug:Object;
		public var _meta:Object={name:"CtrlMIDI"};
		public function setDLevels(l1,l2,l3,l4){dLevels=[l1,l2,l3,l4];}
		var dLevels:Array=[true,true,false,false];
		function log(level,msg){if(dLevels[level-1])_debug.log(this,level,msg);}
		
		public var ns:Object;
		public var params:Object;
		public var input;
		var midi;
		var active:Boolean=false;
	
		
		public function CtrlMIDI(){}
		
		public function init(){
			active=ns.sys.midi.active;
			if(active){
				midi=ns.sys.midi;
			}
		}
		
		
		public function onEF(e=null){
			if(active){
			for(var i=0;i<4;i++) ns.scene.anal.setInput(i,midi.cc[params.anal[i]]);
			ns.game.lens_fov=0+midi.cc[24]*300;
			}
		}	
		
	
		
	}
}