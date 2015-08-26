package vjyourself4.gui {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.events.EventDispatcher;
	public class SelectList extends Sprite{
		public var events:EventDispatcher = new EventDispatcher();
		public var val:Number=0;
		public var num:Number=0;
		
		public function SelectList() {
			while(this["butt"+num]!=null){
				this["butt"+num].addEventListener(MouseEvent.CLICK,onClick,0,0,1);
				this["s"+num].visible=false;
				num++;
			}
		}
		public function onClick(e:MouseEvent){
			var ind:Number=Number(e.target.name.charAt(4));
			setVal(ind);
			events.dispatchEvent(new Event(Event.CHANGE));
		}
		public function setVal(v){
			if(val<num){
				this["s"+val].visible=false;
				val=v;
				this["s"+val].visible=true;
			}
		}

		

	}
	
}
