package vjyourself4.gui {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.events.EventDispatcher;
	public class ButtCombo extends Sprite{
		public var elems:Array;
		public var val:Object;
		public var ind:int=-1;
		
		public function ButtCombo() {
			butt.addEventListener(MouseEvent.CLICK,onClick,0,0,1);
		}
		public function onClick(e:MouseEvent){next();}

		public function next(){setInd(ind+1);}
		public function setInd(i){
			if(ind>=0) removeChild(elems[ind].icon);
			ind=(i+elems.length)%elems.length;
			addChild(elems[ind].icon);
			swapChildren(butt,elems[ind].icon);
			val=elems[ind];
			dispatchEvent(new Event(Event.CHANGE));
		}

		

	}
	
}
