package vjyourself4.gui {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.events.EventDispatcher;
	public class ButtToggle extends MovieClip{
		public var ind:int;
		
		public function ButtToggle() {
			butt.addEventListener(MouseEvent.CLICK,onClick,0,0,1);
		}
		public function onClick(e:MouseEvent){next();}

		public function next(){setInd(ind+1);}
		public function setInd(i){
			ind=(i+totalFrames)%totalFrames;
			gotoAndStop(ind+1);
			dispatchEvent(new Event(Event.CHANGE));
		}

		

	}
	
}
