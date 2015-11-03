package vjyourself4.ctrl{
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import vjyourself4.VJYBase;

	public class CtrlCameraMode extends VJYBase{
		public var ns:Object;
		public var params:Object;

		var ind:Number=0;
		
		var me:Object;
		var ctrlPath:Object;
		public function CtrlCameraMode(){}
		
		public function init(){
			me=ns.me;
			ctrlPath = ns.mid.cs.GP.ctrlPath;
		}
	
		
		public function setCameraMode(i){
			ind=(i+4)%4;
			switch(ind){
				case 0:ctrlPath.setCameraMode("beginning");me.setCameraMode("inside");break;
				case 1:ctrlPath.setCameraMode("beginning");me.setCameraMode("outside");break;
				case 2:ctrlPath.setCameraMode("end");me.setCameraMode("outside");break;	
				case 3:ctrlPath.setCameraMode("end");me.setCameraMode("inside");break;
			}
		};

		public function next(e=null){setCameraMode(ind+1);}
		
		public function prev(e=null){setCameraMode(ind-1);}

	}
}