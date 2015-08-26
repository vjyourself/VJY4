package vjyourself4.ctrl{
	import flash.events.Event;
	import flash.display.Sprite;
	import away3d.filters.*;
	import vjyourself4.dson.Eval;
	public class BindAnalPipes{
	
		public var tars:Array=[];
		public function BindAnalPipes(){}
		public function init(){
	
		}
		public function setBind(b){
			
		}
		public function unBind(){
			
		}
		public function setInput(ind,val){
			for(var i=0;i<tars.length;i++) tars[i].setInput(ind,val);
		}
	}
}