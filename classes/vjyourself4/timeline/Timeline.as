package vjyourself3.games{
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import vjyourself3.dson.Eval;
	
	public class CtrlTimeline{
		public var ns:Object;
		public var params:Object;
		public var input;
		
		var frames:Array;
		var framesInd:Number;
		
		public function CtrlTimeline(){}
		
		public function init(){
			
			input=ns.input;
			
			frames=params.frames;
			framesInd=-1;
			
			processCtrl(params,"next",doNext);
		
				
		}
		
		function doNext(e=null){
				framesInd=(framesInd+1)%frames.length;
				execFrame(frames[framesInd]);
		};

		/* Exec Frame */
		function execFrame(fr){
			var comm:Array;
			var tar:Object;
			for(var i=0;i<fr.length;i++){
				comm=fr[i];
				tar=Eval.evalString(ns,comm[0]);
				tar[comm[1]].apply(tar,comm[2]);
			}
		}
		public function processCtrl(p,name,func){
			if(p[name]){
				var ct=p[name];
				if((ct.gamepad)&&(ct.gamepad!="")&&input.gamepad_enabled) input.gamepadManager.events.addEventListener("Gamepad0_"+ct.gamepad,func,0,0,1);
				if((ct.click)&&input.mkb_enabled) input.stage.addEventListener(MouseEvent.CLICK,func,0,0,1);
			}
		}
	}
}