package vjyourself4.ctrl{
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import vjyourself4.VJYBase;

	public class CtrlCameraMode extends VJYBase{
		public var ns:Object;
		public var params:Object;

		var indInOut:int=0;
		var indFrontBack:int=0;
		
		var me:Object;
		var ctrlPath:Object;
		public function CtrlCameraMode(){}
		
		public function init(){
			me=ns.me;
			ctrlPath = ns.mid.cs.GP.ctrlPath;
		}
	
		// Front - Back
		public function setFrontBack(i){
			indFrontBack=(i+2)%2;
			indFrontBack==0?ctrlPath.setCameraMode("beginning"):ctrlPath.setCameraMode("end");
		}
		public function nextFrontBack(){ setFrontBack(indFrontBack+1);}
		public function prevFrontBack(){ setFrontBack(indFrontBack-1);}

		// In - Out
		public function setInOut(i){
			indInOut=(i+2)%2;
			indInOut==0?me.setCameraMode("inside"):me.setCameraMode("outside");
		}
		public function nextInOut(){ setInOut(indInOut+1);}
		public function prevInOut(){ setInOut(indInOut-1);}

		// In.Front - Out.Front - Out.Back - In.Back
		public function setFrontBackInOut(i){
			i=(i+4)%4;
			setFrontBack(Math.floor(i/2));
			setInOut(i%2);
		}
		public function nextFrontBackInOut(e=null){setFrontBackInOut(indFrontBack*2+indInOut+1);}
		public function prevFrontBackInOut(e=null){setFrontBackInOut(indFrontBack*2+indInOut-1);}

	}
}